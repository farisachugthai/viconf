#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Utilize both the legacy and new nvim API to work with Neovim.

Let's initialize a :class:`jedi.Script()` object, and return whatever we
get by running a list comprehension over the completions data attribute of
our :class:`jedi.Script()` object.

"""
import functools
import importlib
from importlib.util import find_spec
import json
import logging
import pydoc
import site
import sys
from os.path import isdir
import time
import traceback
from pprint import pprint as print

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


logger = logging.getLogger(name=__name__)


def log(logrecord, level=30):
    """Simple way to wrap pythons usual logging features."""
    # Wait wouldnt it be easier if python thought sys.stdout/stderr were something
    # similar to this command?
    return vim.command("echomsg " + logger.log(logrecord, level))


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


# Jedi:

def py_import_completions():
    argl = vim.eval('a:argl')
    try:
        import jedi
    except ImportError:
        comps = []
    else:
        text = 'import %s' % argl
        script = jedi.Script(text, 1, len(text), '',
                             environment=get_environment())
        comps = ['%s%s' % (argl, c.complete) for c in script.completions()]
    vim.command("return '%s'" % '\n'.join(comps))


class PythonToVimStr:
    """ Vim has a different string implementation of single quotes """

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
        self.exc_info0, self.exc_info1, self.exc_info2 = *sys.exc_info()

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
    temp_cword = vim.eval('expand("<cWORD>")')
    logger.debug(f"{temp_cword}")
    try:
        helped_mod = importlib.import_module(temp_cword)
    except vim.error:
        vim.command("echoerr 'Error during import of %s'" % temp_cword)
    else:
        pydoc.help(helped_mod)


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


def import_into_vim(*args):
    if jedi is not None:
        text = f"import {args}"
        script = jedi.Script(text, 1, len(text), "",
                             environment=get_environment())

        partial_completions = (c.complete() for c in script.completions())

        completions = [f"{args}, {partial_completions}"]

    vim.command("return '%s'" % "\n".join(completions))
