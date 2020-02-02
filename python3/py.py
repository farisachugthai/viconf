#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Utilize both the legacy and new nvim API to work with Neovim."""
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
    import vim  # pylint: disable=import-error
except ImportError:
    vim = None  # remote process not in vim

try:
    import black
except:
    black = None

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

    return wrapper


def pykeywordprg():
    temp_cword = vim.eval(expand("<cWORD>"))
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
    mode = get_mode()
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
        print(vim_path)
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
