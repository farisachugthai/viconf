#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Utilize both the legacy and new nvim API to work with Neovim.

Let's initialize a :class:`jedi.Script()` object, and return whatever we
get by running a list comprehension over the completions data attribute of
our :class:`jedi.Script()` object.

"""
import functools
import importlib
import json
import logging
import os
import pydoc
import site
import sys
import time
import traceback
from importlib.util import find_spec
from os.path import isdir
from pathlib import Path
from pprint import pprint as print
from typing import Optional
from types import TracebackType

try:
    import vim  # noqa
except ImportError:
    vim = None  # remote process not in vim

try:
    import black
except:
    black = None

try:
    import jedi
except ImportError:
    jedi = None
else:
    from jedi.api import replstartup

logging.basicConfig()
logger = logging.getLogger(name=__name__)


def log(logrecord, level=30):
    """Simple way to wrap pythons usual logging features."""
    # Wait wouldnt it be easier if python thought sys.stdout/stderr were something
    # similar to this command? That's not a terrible idea.
    # we could make a class with the same interface as sys.stdout so subclass
    # io.TextIOWrapper and then sub it in.
    return vim.command("echomsg " + logger.log(logrecord, level))


def err(err, level=30, traceback=None):
    vim.command("echohl WarningMsg")
    vim.command("echomsg " + logger.log(err, level))
    vim.command("echohl None")
    # if isinstance(traceback, TracebackType):


def _set_return_error(err=None):
    """Standardize the flaky interface betweem vim and python.

    Exceptions don't really work across the vim-python boundary, so instead
    we catch the exception and set it into a global variable. The calling vim
    code will then manually check that value after the command completes.
    """
    # If we're not in a vim plugin, don't try to set the error
    if vim is None:
        return

    if err is None:
        vim.command("let g:py_err = {}")
    else:
        err_dict = {
            "code": getattr(err, "code", "ERROR"),
            "msg": str(err),
        }
        # Not the best way to serialize to vim types,
        # but it'll work for this specific case
        vim.command("let g:py_err_json = %s" % json.dumps(err_dict))


def print_call_chain(*args):
    """View individual frames in the stack."""
    print(" ".join(map(str, args)))
    f = sys._getframe(1)
    while f:
        name = f.f_code.co_name
        s = f.f_locals.get("self", None)
        if s:
            c = getattr(s, "__class__", None)
            if c:
                name = "%s.%s" % (c.__name__, name)
        print("Called from: %s %s" % (name, f.f_lineno))
        f = f.f_back
    print("-" * 70)


def vimcmd(fxn):
    """Decorator for functions that will be run from vim."""

    @functools.wraps(fxn)
    def wrapper(*args, **kwargs):
        try:
            ret = fxn(*args, **kwargs)
        except Exception as e:
            logger.exception("Error running python %s()", fxn.__name__)
            _set_return_error(e)
            return 0
        else:
            _set_return_error(None)
            return ret

    wrapper.is_cmd = True
    return wrapper


def py_import_completions():
    """Initialize jedi.Script and `eval` it."""
    argl = vim.eval("a:argl")
    text = "import %s" % argl
    script = jedi.Script(text, 1, len(text), "", environment=get_environment())
    comps = []
    comps = [f"{argl}, {c.complete for c in script.completions()}"]
    vim.command("return '%s'" % "\n".join(comps))


class PythonToVimStr:
    """Vim has a different string implementation of single quotes """

    __slots__ = []

    def __new__(cls, obj, encoding="UTF-8"):
        if not isinstance(obj, str):
            obj = str.__new__(cls, obj, encoding)

        # Vim cannot deal with zero bytes:
        obj = obj.replace("\0", "\\0")
        return str.__new__(cls, obj)

    def __repr__(self):
        # this is totally stupid and makes no sense but vim/python unicode
        # support is pretty bad. don't ask how I came up with this... It just
        # works...
        # It seems to be related to that bug: http://bugs.python.org/issue5876
        s = self.encode("UTF-8")
        return '"%s"' % s.replace("\\", "\\\\").replace('"', r"\"")


class VimError(Exception):
    def __init__(self, message, throwpoint, executing):
        super(type(self), self).__init__(message)
        self.message = message
        self.throwpoint = throwpoint
        self.executing = executing

    def __str__(self):
        return "{}; created by {!r} (in {})".format(
            self.message, self.executing, self.throwpoint
        )


class VimErr(VimError):
    """An error that's a bit gentler to handle."""

    def __init__(self, message=None):
        super().__init__(message)
        self.message = message
        self.exc_info0, self.exc_info1, self.exc_info2 = sys.exc_info()

    def __repr__(self):
        return (self.exc_info0, self.message)


def _catch_exception(string, is_eval):
    """
    Interface between vim and python calls back to it.
    Necessary, because the exact error message is not given by `vim.error`.
    """
    result = vim.eval(
        "g:py_err ({0}, {1})".format(
            repr(PythonToVimStr(string, "UTF-8")), int(is_eval)
        )
    )
    if "exception" in result:
        raise VimError(result["exception"], result["throwpoint"], string)
    return result["result"]


def vim_command(string):
    _catch_exception(string, is_eval=False)


def vim_eval(string):
    return _catch_exception(string, is_eval=True)


def pykeywordprg():
    # wait does this work?
    temp_cword = vim.eval('expand("<cfile>")')
    logger.debug(f"{temp_cword}")
    # If this doesn't display anythin
    try:
        helped_mod = importlib.import_module(temp_cword)
    except vim.error:
        vim.command("echoerr 'Error during import of %s'" % temp_cword)
    else:
        pydoc.help(helped_mod)


def findsource(mod):
    for i in inspect.findsource(mod):
        vim.current.buffer.append(i)


def timer(func):
    """Print the runtime of the decorated function"""

    @functools.wraps(func)
    def wrapper_timer(*args, **kwargs):
        start_time = time.perf_counter()
        value = func(*args, **kwargs)
        end_time = time.perf_counter()
        run_time = end_time - start_time
        print(f"Finished {func.__name__!r} in {run_time:.4f} secs")
        return value

    return wrapper_timer


def _robust_black():
    if hasattr(black, "FileMode"):
        mode = get_mode()
    else:
        raise ModuleNotFoundError("Black wasn't installed.")
    buffer_str = "\n".join(vim.current.buffer) + "\n"
    try:
        return black.format_file_contents(buffer_str, fast=None, mode=mode)
    except black.NothingChanged:
        print("Already well formatted, good job.")
    except Exception as exc:
        traceback.print_exc(exc)


def get_mode():
    """The FileMode not the mode that Vim is in."""
    return black.FileMode(
        line_length=88, is_pyi=vim.current.buffer.name.endswith(".pyi"),
    )


def get_cursors():
    # Why is this a section of code that's called?
    current_buffer = vim.current.window.buffer
    cursors = []
    for i, tabpage in enumerate(vim.tabpages):
        if tabpage.valid:
            for j, window in enumerate(tabpage.windows):
                if window.valid and window.buffer == current_buffer:
                    cursors.append((i, j, window.cursor))
    for i, j, cursor in cursors:
        window = vim.tabpages[i].windows[j]
        try:
            window.cursor = cursor
        except vim.error:
            window.cursor = (len(window.buffer), 0)


def blackened_vim():
    """Currently the main entrypoint."""
    start = time.time()
    new_buffer_str = _robust_black()
    if new_buffer_str is None:
        return
    vim.current.buffer[:] = new_buffer_str.split("\n")[:-1]
    print(f"Reformatted in {time.time() - start:.4f}s.")


def black_version():
    print(f"Black, version {black.__version__} on Python {sys.version}.")


def setup_vim_path():
    vim_path = ".,**,,"
    vim_path += sys.prefix + ","
    for i in site.getsitepackages():
        vim_path += i + ","
        return vim_path


def pure_python_path():
    """Attempt 2."""
    for p in sys.path:
        # Add each directory in sys.path, if it exists.
        if isdir(p):
            # Command 'set' needs backslash before each space.
            vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))


def importer(mod):
    return find_spec(mod)


def get_environment(use_cache=True):
    if use_cache:
        return jedi.api.environment.get_cached_default_environment()
    else:
        try:
            return jedi.get_system_environment()
        except jedi.InvalidPythonEnvironment as exc:
            traceback.format_exc(exc)
            raise


def catch_and_print_exceptions(func):
    @functools.wraps
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except (Exception, vim.error):
            traceback.print_exc()

    return wrapper


@catch_and_print_exceptions
def get_script(source=None, column=None):
    jedi.settings.additional_dynamic_modules = [
        b.name
        for b in vim.buffers
        if (b.name is not None and b.name.endswith(".py") and b.options["buflisted"])
    ]
    if source is None:
        source = "\n".join(vim.current.buffer)
    row = vim.current.window.cursor[0]
    if column is None:
        column = vim.current.window.cursor[1]
    buf_path = vim.current.buffer.name

    return jedi.Script(
        source,
        row,
        column,
        buf_path,
        encoding=vim_eval("&encoding") or "latin1",
        environment=get_environment(),
    )


def import_into_vim(*args):
    if jedi is not None:
        text = f"import {args}"
        script = jedi.Script(text, 1, len(text), "", environment=get_environment())

        partial_completions = (c.complete() for c in script.completions())

        completions = [f"{args}, {partial_completions}"]

    vim.command("return '%s'" % "\n".join(completions))


def Black():
    start = time.time()
    fast = bool(int(vim.eval("g:black_fast")))
    mode = black.FileMode(
        line_length=int(vim.eval("g:black_linelength")),
        string_normalization=not bool(
            int(vim.eval("g:black_skip_string_normalization"))
        ),
        is_pyi=vim.current.buffer.name.endswith(".pyi"),
    )
    buffer_str = "\n".join(vim.current.buffer) + "\n"
    try:
        new_buffer_str = black.format_file_contents(buffer_str, fast=fast, mode=mode)
    except black.NothingChanged:
        print(f"Already well formatted, good job. (took {time.time() - start:.4f}s)")
    except Exception as exc:
        print(exc)
    else:
        current_buffer = vim.current.window.buffer
        cursors = []
        for i, tabpage in enumerate(vim.tabpages):
            if tabpage.valid:
                for j, window in enumerate(tabpage.windows):
                    if window.valid and window.buffer == current_buffer:
                        cursors.append((i, j, window.cursor))
        vim.current.buffer[:] = new_buffer_str.split("\n")[:-1]
        for i, j, cursor in cursors:
            window = vim.tabpages[i].windows[j]
            try:
                window.cursor = cursor
            except vim.error:
                window.cursor = (len(window.buffer), 0)
        print(f"Reformatted in {time.time() - start:.4f}s.")


def BlackVersion():
    """Print the installed version of black."""
    print(f"Black, version {black.__version__} on Python {sys.version}.")


def list_buf():
    """Return the Vimscript function :func:`nvim_list_bufs()`.

    Returns
    --------
    bufnrs : list of ints
        Currently loaded buffers

    Examples
    --------
    .. code-block:: vim

        :ListBuf
        " With one open buffer the output will be [1]
        " Note that this could be any list of integers

    """
    bufnrs = vim.eval("call nvim_list_bufs()")
    return bufnrs


class FileLink:
    def __init__(self, logger=None, buf=None):
        """Initialize a file object."""
        # Damnit why isnt it recognizing this as a func? this is the missing link
        if logger is not None:
            self.logger = logger
        self.buf = Path(buf.name) if buf is not None else self._path_file()

    def __repr__(self):
        return "{!r} --- {!r}".format(self.__class__.__name__, self.buf)

    def _path_file(self):
        """Pathify a file."""
        return Path(vim.eval("nvim_get_current_buf()"))

    @property
    def is_symlink(self):
        """Check if `path_obj` is a symlink."""
        return self.buf.is_symlink()

    def _resolved_path(self):
        return self._path_file().resolve()

    def dirname(self):
        """Get the buffers directory."""
        real_file = self._resolved_path()
        if real_file:
            return real_file.parent

    def open_true_file(self):
        """Implement a command that opens and resolves a symlink."""
        if self.is_symlink:
            real_file = self._resolved_path()
            dirname = real_file.parent
            vim.chdir(str(dirname))
            vim.command("edit" + str(real_file))


def main():
    """Set everything up."""
    cur_file = FileLink()

    if cur_file.is_symlink:
        cur_file.true_file()


if __name__ == "__main__":
    log_levels = {
        "debug": logging.DEBUG,
        "info": logging.INFO,
        "warning": logging.WARNING,
        "error": logging.ERROR,
        "critical": logging.CRITICAL,
    }
    if vim is not None:
        file_link = FileLink(logger, vim.current.buffer)
