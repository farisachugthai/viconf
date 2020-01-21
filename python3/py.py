import functools
import importlib
import logging
import pydoc
import time
import traceback
import vim

from pprint import pprint as print

try:
    import black
except:
    black = None

logger = logging.getLogger(name=__name__)


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


def black():
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


def BlackUpgrade():
    _initialize_black_env(upgrade=True)


def BlackVersion():
    print(f"Black, version {black.__version__} on Python {sys.version}.")
