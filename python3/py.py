import functools
import importlib
import json
import logging
import pydoc
import time
import traceback
try:
    import vim  # pylint: disable=import-error
    _has_vim = True
except ImportError:
    _has_vim = False

from pprint import pprint as print

try:
    import black
except:
    black = None

logger = logging.getLogger(name=__name__)


def _set_return_error(err):
    # If we're not in a vim plugin, don't try to set the error
    if not _has_vim:
        return

    # Exceptions don't really work across the vim-python boundary, so instead
    # we catch the exception and set it into a global variable. The calling vim
    # code will then manually check that value after the command completes.
    if err is None:
        vim.command('let g:py_err = {}')
    else:
        err_dict = {
            "code": getattr(err, 'code', 'ERROR'),
            "msg": str(err),
        }
        # Not the best way to serialize to vim types,
        # but it'll work for this specific case
        vim.command("let g:py_err_json = %s" % json.dumps(err_dict))

def vimcmd(fxn):
    """ Decorator for functions that will be run from vim """

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


def import_mod_under_cursor():
    temp_cword = vim.eval(expand("<cWORD>"))
    logger.debug(f"{temp_cword}")
    try:
        helped_mod = importlib.import_module(temp_cword)
    except:
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
    # TODO
    return black.FileMode(
        # line_length=int(vim.eval("g:black_linelength")),
        line_length=88,
        # string_normalization=not bool(
        #     int(vim.eval("g:black_skip_string_normalization"))
        # ),
        is_pyi=vim.current.buffer.name.endswith(".pyi"),
    )


def _black():
    try:
        return _robust_black()
    except:
        raise


def get_cursors():
    # Why is this a section of code that's called?
    current_buffer = vim.current.window.buffer
    cursors = []
    for i, tabpage in enumerate(vim.tabpages):
        if tabpage.valid:
            for j, window in enumerate(tabpage.windows):
                if window.valid and window.buffer == current_buffer:
                    cursors.append((i, j, window.cursor))


def blackened_vim():
    start = time.time()
    new_buffer_str = _black()
    if new_buffer_str is None:
        return
    list_of_cursors = get_cursors()
    vim.current.buffer[:] = new_buffer_str.split("\n")[:-1]
    for i, j, cursor in cursors:
        window = vim.tabpages[i].windows[j]
        try:
            window.cursor = cursor
        except vim.error:
            window.cursor = (len(window.buffer), 0)
    print(f"Reformatted in {time.time() - start:.4f}s.")


def black_version():
    print(f"Black, version {black.__version__} on Python {sys.version}.")
