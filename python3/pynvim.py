#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Code shared between the API classes.

Neovim allows Python 3 plugins to be defined by placing python files
or packages in rplugin/python3/ (in a runtimepath folder). Python 2 rplugins
are also supported and placed in rplugin/python/, but are considered
deprecated. Further added library features will only be available on Python
3. Rplugins follow the structure of this example:

If sync=True is supplied Neovim will wait for the handler to finish (this is
required for function return values), but by default handlers are executed
asynchronously.

Normally async handlers (sync=False, the default) are blocked while a
synchronous handler is running. This ensures that async handlers can call
requests without Neovim confusing these requests with requests from a
synchronous handler. To execute an asynchronous handler even when other
handlers are running, add allow_nested=True to the decorator. This handler must
then not make synchronous Neovim requests, but it can make asynchronous
requests, i.e. passing async_=True.

"""
__package__ = "pynvim"
# __path__ = [__file__]
__docformat__ = "reStructuredText"
__authors__ = "Neovim"

# Imports:
import abc
import asyncio
import contextlib
import enum
import functools
import inspect
import io
import itertools
import locale
import logging
import multiprocessing
import os
import pathlib
import re
import signal
import sys
import threading
import traceback
import warnings

from asyncio.events import get_event_loop_policy
from asyncio.futures import Future
from asyncio.streams import StreamReader, StreamWriter
from collections import namedtuple, UserList, deque
from collections.abc import MutableMapping
from functools import partial
from pathlib import Path
from traceback import format_exception, format_stack, format_exc
from typing import Dict, Any, AnyStr, Union, List, Optional, Callable

import msgpack

try:
    from msgpack._cmsgpack import Packer, unpackb, Unpacker
except ImportError:
    from msgpack.fallback import Packer, unpackb, Unpacker

if sys.version_info >= (3, 4):
    from importlib.machinery import PathFinder
else:
    PathFinder = None

if sys.version_info <= (3, 7):

    class ModuleNotFoundError(ImportError):
        """New exception for Python3.7."""

        pass  # i have a better implementation somewhere...


global vim
try:
    import vim  # noqa
except ImportError:
    pass

try:
    from os import PathLike, fspath, fsencode, fsdecode
except ImportError:

    class PathLike(abc.ABC):
        """Abstract base class for implementing the file system path protocol."""

        @abc.abstractmethod
        def __fspath__(self):
            """Return the file system path representation of the object."""
            raise NotImplementedError

        @classmethod
        def register(self, Path):
            pass

    PathLike.register(pathlib.Path)

    def fspath(path):
        """Return the string representation of the path.

        If str or bytes is passed in, it is returned unchanged. If __fspath__()
        returns something other than str or bytes then TypeError is raised. If
        this function is given something that is not str, bytes, or os.PathLike
        then TypeError is raised.
        """
        if isinstance(path, (str, bytes)):
            return path

        if isinstance(path, pathlib.Path):
            return str(path)

        # Work from the object's type to match method resolution of other magic
        # methods.
        path_type = type(path)
        try:
            path = path_type.__fspath__(path)
        except AttributeError:
            if hasattr(path_type, "__fspath__"):
                raise
        else:
            if isinstance(path, (str, bytes)):
                return path
            else:
                raise TypeError(
                    "expected __fspath__() to return str or bytes, "
                    "not " + type(path).__name__
                )

        raise TypeError(
            "expected str, bytes or os.PathLike object, not " + path_type.__name__
        )

    def _fscodec(filename):
        encoding = sys.getfilesystemencoding()
        if encoding == "mbcs":
            errors = "strict"
        else:
            errors = "surrogateescape"

        def fsencode():
            """Encode filename (an os.PathLike, bytes, or str) to the filesystem
            encoding with 'surrogateescape' error handler, return bytes unchanged.
            On Windows, use 'strict' error handler if the file system encoding is
            'mbcs' (which is the default encoding).
            """
            filename = fspath(filename)  # Does type-checking of `filename`.
            if isinstance(filename, str):
                return filename.encode(encoding, errors)
            else:
                return filename

        def fsdecode():
            """Decode filename (an os.PathLike, bytes, or str) from the filesystem
            encoding with 'surrogateescape' error handler, return str unchanged. On
            Windows, use 'strict' error handler if the file system encoding is
            'mbcs' (which is the default encoding).
            """
            filename = fspath(filename)  # Does type-checking of `filename`.
            if isinstance(filename, bytes):
                return filename.decode(encoding, errors)
            else:
                return filename

        return fsencode, fsdecode

    fsencode, fsdecode = _fscodec()


# Globals:
# ***
# BUG: don't hardcode this its an actual function we can check
unicode_errors_default = sys.getfilesystemencodeerrors()

default_int_handler = signal.getsignal(signal.SIGINT)
mp_logger = multiprocessing.get_logger()
multiprocessing.log_to_stderr(logging.WARNING)

# When signals are restored, the event loop library may reset SIGINT to SIG_DFL
# which exits the program. To be able to restore the python interpreter to it's
# default state, we keep a reference to the default handler
main_thread = threading.current_thread()
locale.setlocale(locale.LC_ALL, "")
host_method_spec = {"poll": {}, "specs": {"nargs": 1}, "shutdown": {}}

# Pynvim __init__:


def _goofy_way_of_loading_plugins():
    plugins = []
    for arg in sys.argv:
        _, ext = os.path.splitext(arg)
        if ext == ".py":
            plugins.append(arg)
        elif os.path.isdir(arg):
            init = os.path.join(arg, "__init__.py")
            if os.path.isfile(init):
                plugins.append(arg)

    # This is a special case to support the old workaround of
    # adding an empty .py file to make a package directory
    # visible, and it should be removed soon.
    for path in list(plugins):
        dup = path + ".py"
        if os.path.isdir(path) and dup in plugins:
            plugins.remove(dup)

    # Special case: the legacy scripthost receives a single relative filename
    # while the rplugin host will receive absolute paths.
    if plugins == ["script_host.py"]:
        name = "script"
    else:
        name = "rplugin"
    setup_logging(name)
    return plugins


def start_host(session=None, load_plugins=True, plugins=None):
    """Promote the current process into python plugin host for Nvim.

    Start msgpack-rpc event loop for `session`, listening for Nvim requests
    and notifications. It registers Nvim commands for loading/unloading
    python plugins.

    The sys.stdout and sys.stderr streams are redirected to Nvim through
    `session`. That means print statements probably won't work as expected
    while this function doesn't return.

    This function is normally called at program startup and could have been
    defined as a separate executable. It is exposed as a library function for
    testing purposes only.

    I never noticed until now but it also initializes a logger? Wth?
    """
    if load_plugins:
        plugins = _goofy_way_of_loading_plugins()

    if not session:
        session = socket_session()
    else:
        if isinstance(session, str):
            session = _convert_str_to_session(session)

    nvim = Nvim.from_session(session)
    # nvim = Nvim.from_session(session).with_decode(decode)

    if nvim.version.api_level < 1:
        sys.stderr.write("This version of pynvim requires nvim 0.1.6 or later")
        sys.exit(1)

    host = Host(nvim)
    if plugins is not None:
        host.start(plugins)
    return host


def _convert_str_to_session(
    session_type, address=None, port=None, path=None, argv=None, decode=None
):
    if session_type not in ["socket", "tcp", "stdio", "child"]:
        raise NvimError(
            '%s given. Must be one of "socket", "tcp", "stdio", "child"' % session_type
        )
    if session_type == "socket":
        session = socket_session(path)
    elif session_type == "tcp":
        session = tcp_session(address, port)
    elif session_type == "stdio":
        session = stdio_session()
    elif session_type == "child":
        session = child_session(argv)
    return session


def attach(session_type, address=None, port=None, path=None, argv=None, decode=None):
    """Provide a nicer interface to create python api sessions.

    Previous machinery to create python api sessions is still there. This only
    creates a facade function to make things easier for the most usual cases.
    Thus, instead of::

        >>> from pynvim import socket_session, Nvim
        >>> session = socket_session(path=None)
        >>> nvim = Nvim.from_session(session)

    You can now do::

        >>> from pynvim import attach
        >>> nvim = attach('tcp', address=<address>, port=<port>)

    And also::

        >>> nvim = attach('socket', path=os.environ.get('NVIM_LISTEN_ADDRESS'))
        >>> nvim = attach('child', argv=[])
        >>> nvim = attach('stdio')

    When the session is not needed anymore, it is recommended to explicitly
    close it::

       nvim.close()

    It is also possible to use the session as a context mangager::

       with attach('socket', path=thepath) as nvim:
           print(nvim.funcs.getpid())
           print(nvim.current.line)

    This will automatically close the session when you're done with it, or
    when an error occured.

    Raises
    ------
    NvimError
        On any connection issues. Subclass of Exception so that you can catch
        the error we raise but if you do something wrong, it doesn't fail
        silently.
    AttributeError
        if session_type not in ["socket", "tcp", "stdio", "child"]

    """
    return Nvim.from_session(
        _convert_str_to_session(
            session_type, address=None, port=None, path=None, argv=None, decode=None
        )
    ).with_decode(decode)


def setup_logging(name: AnyStr = None, level: int = None, disable_asyncio_logging=True):
    """Setup logging according to environment variables.

    So I just figured out why the nvim_python_log_file never sets.
    This is set up so wrong.

    Parameters
    ----------
    name : str, optional
    level : int, optional
        Now level can be specified at the time of function call, or used as
        an environment variable and we won't arbitrarily overwrite it halfway
        through the function.

    Returns
    -------
    logger : :class:`logging.Logger`
        Returns something now. Because for all that work we never returned the
        logger!!!!

    """
    if name is None:
        name = __name__
    if level is None:
        level = os.environ.get("NVIM_PYTHON_LOG_LEVEL", logging.WARNING)
    if level in ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]:
        level = "logging." + level

    try:
        level = int(level)
    except ValueError:  # apparently this gets raised if you do int(logging.DEBUG)
        pass
    except TypeError:
        raise

    logger = logging.getLogger(name=name)
    logger.setLevel(level)

    stream = logging.StreamHandler(sys.stderr)
    stream.setLevel(level)
    logger.addHandler(stream)
    filterer = logging.Filter(name=__name__)
    logger.addFilter(filterer)

    if "NVIM_PYTHON_LOG_FILE" not in os.environ.copy():
        return logger

    # Set up the logfile handler
    prefix = os.environ["NVIM_PYTHON_LOG_FILE"].strip()
    major_version = sys.version_info[0]
    logfile = "{}_py{}_{}".format(prefix, major_version, name)
    handler = logging.FileHandler(logfile, "w", "utf-8")
    handler.setLevel(level)

    # Set up the logfile formatter
    log_datefmt = "%Y-%m-%d %H:%M:%S"
    default_log_format = "[ %(name)s : %(relativeCreated)d :] %(levelname)s : %(module)s : --- %(message)s "
    formatter = logging.Formatter(fmt=default_log_format, datefmt=log_datefmt)
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.root.addHandler(handler)
    if not disable_asyncio_logging:
        return logger
    if len(asyncio.log.logger.root.handlers) > 0:
        asyncio.log.logger.root.handlers.pop()
    if len(asyncio.log.logger.handlers) > 0:
        asyncio.log.logger.handlers.pop()

    asyncio.log.logger.setLevel(99)
    asyncio.log.logger.root.setLevel(99)
    if len(logging.root.handlers) > 0:
        logging.root.handlers.pop()
    logging.root.setLevel(99)
    asyncio.log.logger.disabled = True
    asyncio.log.logger.root.disabled = True
    return logger


logging.basicConfig(level=logging.WARNING, format=logging.BASIC_FORMAT)
logger = logging.getLogger(name=__name__)
# logger = setup_logging()
debug, info, warn, error = (
    logger.debug,
    logger.info,
    logger.warning,
    logger.error,
)


def multiprocess_setup_logging(level=30):
    """Simply a convenience function."""
    logger = setup_logging(name=multiprocessing.get_logger(), level=level)
    return logger


# util:


def get_documentation(word):
    """Search documentation and append to current buffer."""
    # is sys.stdout needed at all below?
    # sys.stdout, _=StringIO(), sys.stdout
    try:
        import pydoc

        with contextlib.redirect_stderr(sys.stderr):
            pydoc.help(str(word))
    except AttributeError:  # maybe
        raise
    except NameError:
        try:  # this is actually how pydoc does it
            from pydoc import safeimport

            mod = safeimport(word)
        except ImportError:
            return
        else:
            get_documentation(mod)


def format_exc_skip(skip=1, limit=None, exception=None):
    """Like traceback.format_exc but allow skipping the first frames.

    Parameters
    ----------
    skip : int
        Frames to skip
    limit : int
        Limit of formatted frames.
    exception : tuple
        Because why did we not allow THAT to be specified?

    """
    if exception is None:
        etype, val, tb = sys.exc_info()
    else:
        etype, val, tb = exception

    for i in range(skip):
        tb = tb.tb_next
    return "".join(format_exception(etype, val, tb, limit)).rstrip()


def catch_and_print_exceptions(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except (Exception, vim.error):
            traceback.print_exc()

    return wrapper


# Taken from SimpleNamespace in python 3
class Version:
    """Helper class for version info."""

    def __init__(self, **kwargs):
        """Create the Version object."""
        self.__dict__.update(kwargs)

    def __repr__(self):
        """Return str representation of the Version."""
        keys = sorted(self.__dict__)
        items = ("{}={!r}".format(k, self.__dict__[k]) for k in keys)
        return "{}({})".format(type(self).__name__, ", ".join(items))

    def __eq__(self, other):
        """Check if version is same as other.

        Might be worth noting this from the lang ref.

        A class that overrides __eq__() and does not define __hash__() will have
        its __hash__() implicitly set to None. When the __hash__() method of
        a class is None, instances of the class will raise an appropriate
        TypeError when a program attempts to retrieve their hash value.
        """
        return self.__dict__ == other.__dict__


def get_client_info(type_, method_spec, kind=None):
    """Returns a dict describing the client.

    But change kind to allow none because all we do is return it so whats the
    point?

    Where is this used? Im so confused by it.

    Parameters
    ----------
    type_ :
    method_spec :
    kind :

    Returns
    -------
    dict
    """
    name = "python{}-{}".format(sys.version_info[0], kind)
    attributes = {"license": "Apache v2", "website": "github.com/neovim/pynvim"}
    return name, VERSION.__dict__, type_, method_spec, attributes


VERSION = Version(major=0, minor=4, patch=1, prerelease="")


# compat:


def get_decoded_string(encoded):
    """Decode encoded if it has the proper interface.

    Notes
    -----
    Any uses of shlex.split should also use  this function as shlex.split crashes
    when given bytes for input.

    """
    if hasattr(encoded, "decode"):
        import codecs

        # if this is a simple string then don't make this hard
        return codecs.decode(encoded, "utf-8")

    # But if it's a list we gotta try a little
    try:
        iter(encoded)
    except TypeError:
        return encoded
    else:
        return [
            codecs.decode(element, "utf-8")
            for element in encoded
            if isinstance(element, bytes)
        ]


def check_async(async_, kwargs, default):
    """Return a value of 'async' in kwargs or default when async_ is None.

    This helper function exists for backward compatibility (See #274).
    It shows a warning message when 'async' in kwargs is used to note users.
    """
    if async_ is not None:
        return async_
    elif "async" in kwargs:
        warnings.warn(
            '"async" attribute is deprecated. Use "async_" instead.',
            DeprecationWarning,
        )
        return kwargs.pop("async")
    else:
        return default


# plugin/decorators:


def plugin(cls):
    """Tag a class as a plugin.

    This decorator is required to make the class methods discoverable by the
    plugin_load method of the host.
    """
    cls._nvim_plugin = True

    # the _nvim_bind attribute is set to True by default, meaning that
    # decorated functions have a bound Nvim instance as first argument.
    # For methods in a plugin-decorated class this is not required, because
    # the class initializer will already receive the nvim object.
    def predicate(fn):
        return hasattr(fn, "_nvim_bind")

    for _, fn in inspect.getmembers(cls, predicate):
        fn._nvim_bind = False
    return cls


def rpc_export(rpc_method_name, sync=False):
    """Export a function or plugin method as a msgpack-rpc request handler."""

    def dec(f):
        f._nvim_rpc_method_name = rpc_method_name
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = False
        return f

    return dec


def command(
    name,
    nargs=0,  # type Optional[Union[int, List]
    complete=None,
    _range=False,
    count=None,
    bang=False,
    register=False,
    sync=False,
    allow_nested=False,
    _eval=None,
):
    """Tag a function or plugin method as a Nvim command handler.

    Set :param:`sync` to False and 'allow_nested' to True to allow async
    funcs or plugins.
    """

    def dec(f):
        f._nvim_rpc_method_name = "command:{}".format(name)
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = True

        opts = {}

        if _range is not None:
            opts["_range"] = "" if _range is True else str(_range)
        elif count is not None:
            opts["count"] = count

        if bang:
            opts["bang"] = ""

        if register:
            opts["register"] = ""

        if nargs:
            opts["nargs"] = nargs

        if complete:
            opts["complete"] = complete

        if _eval:
            opts["_eval"] = _eval

        if not sync and allow_nested:
            rpc_sync = "urgent"
        else:
            rpc_sync = sync

        f._nvim_rpc_spec = {
            "type": "command",
            "name": name,
            "sync": rpc_sync,
            "opts": opts,
        }
        return f

    return dec


def autocmd(name, pattern="*", sync=False, allow_nested=False, eval=None):
    """Tag a function or plugin method as a Nvim autocommand handler."""

    def dec(f):
        f._nvim_rpc_method_name = "autocmd:{}:{}".format(name, pattern)
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = True

        opts = {"pattern": pattern}

        if eval:
            opts["_eval"] = eval

        if not sync and allow_nested:
            rpc_sync = "urgent"
        else:
            rpc_sync = sync

        f._nvim_rpc_spec = {
            "type": "autocmd",
            "name": name,
            "sync": rpc_sync,
            "opts": opts,
        }
        return f

    return dec


def function(name, _range=False, sync=False, allow_nested=False, _eval=None):
    """Tag a function or plugin method as a Nvim function handler."""

    def dec(f):
        f._nvim_rpc_method_name = "function:{}".format(name)
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = True

        opts = {}

        if _range:
            opts["_range"] = "" if _range is True else str(_range)

        if _eval:
            opts["_eval"] = _eval

        if not sync and allow_nested:
            rpc_sync = "urgent"
        else:
            rpc_sync = sync

        f._nvim_rpc_spec = {
            "type": "function",
            "name": name,
            "sync": rpc_sync,
            "opts": opts,
        }
        return f

    return dec


def shutdown_hook(f):
    """Tag a function or method as a shutdown hook."""

    def _():
        f._nvim_shutdown_hook = True
        f._nvim_bind = True
        return f


def decode(mode=unicode_errors_default):
    """Configure automatic encoding/decoding of strings."""

    def dec(f):
        f._nvim_decode = mode
        return f

    return dec


# api/common:Remote:


class NvimError(Exception):
    # TODO: This should probably be expanded on and initialize with some
    # sort of message
    pass


class Remote(object):
    """Base class for Nvim objects(buffer/window/tabpage).

    Each type of object has it's own specialized class with API wrappers around
    the msgpack-rpc session. This implements equality which takes the remote
    object handle into consideration.

    So unless I'm mistaken this looks like an abstract class as it doesn't
    actually define the _api_prefix attribute it requires in it's init.
    So maybe add `abc.abstract_property` to that?
    """

    def __init__(self, session, code_data):
        """Initialize from session and code_data immutable object.

        The `code_data` contains serialization information required for
        msgpack-rpc calls. It must be immutable for Buffer equality to work.
        """
        self._session = session
        self.code_data = code_data
        self.handle = unpackb(code_data[1])
        if not hasattr(self, "_api_prefix"):
            raise AttributeError("All subclasses must implement attribute _api_prefix.")
        self.__api_prefix = "nvim_"
        # Wait where the hell did self._api_prefix come from??
        self.api = RemoteApi(self, self._api_prefix)
        self.vars = RemoteMap(
            self,
            self._api_prefix + "get_var",
            self._api_prefix + "set_var",
            self._api_prefix + "del_var",
        )
        self.options = RemoteMap(
            self, self._api_prefix + "get_option", self._api_prefix + "set_option"
        )

    @property
    def _api_prefix(self) -> AnyStr:
        return self.__api_prefix

    @_api_prefix.setter
    def _set_api_prefix(self, value: AnyStr):
        self.__api_prefix = value

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%s(handle=%r)>" % (self.__class__.__name__, self.handle,)

    def __eq__(self, other):
        """Return True if `self` and `other` are the same object."""
        return hasattr(other, "code_data") and other.code_data == self.code_data

    def __hash__(self):
        """Return hash based on remote object id."""
        return self.code_data.__hash__()

    def request(self, name, *args, **kwargs):
        """Wrap nvim.request method from the Session object."""
        return self._session.request(name, self, *args, **kwargs)


# msgpack_rpc.session:


class ErrorResponse(NvimError):
    """Raise this in a request handler to respond with a given error message.

    Unlike when other exceptions are caught, this gives full control off the
    error response sent. When "ErrorResponse(msg)" is caught "msg" will be
    sent verbatim as the error response.No traceback will be appended.
    """

    pass


class NvimRuntimeError(NvimError):
    """Created so we don't raise RuntimeErrors but still generate exceptions as
    needed."""


class Session(object):
    """Msgpack-rpc session layer that uses coroutines for a synchronous API.

    This class provides the public msgpack-rpc API required by this library.
    It uses the greenlet module to handle requests and notifications coming
    from Nvim with a synchronous API.

    Ahhhh the Session object! Probably gonna end up subclassing this bitch
    a LOT. Oddly not really yet. This class should probably subclass AsyncSession
    though.

    """

    def __init__(self, async_session, cb=None, error_wrapper=None):
        """Wrap `async_session` on a synchronous msgpack-rpc interface.

        Parameters
        ----------
        async_session : AsyncSession

        Returns
        -------
        Session
        """
        self._async_session = async_session
        self._request_cb = self._notification_cb = cb if cb is not None else None
        self._pending_messages = deque()
        self._is_running = False
        self._setup_exception = sys.exc_info()[2]
        # JUST USE THE STANDARD INTERFACE FOR TRACEBACKS WHAT THE HELL
        self.loop = async_session.loop
        self.current_thread = threading.current_thread()
        # so ALLLL this bullshit used to be in the nvim class but GUYS WHY
        if error_wrapper is None:
            # wth is this? session.error_wrapper = lambda e:
            # NvimError(decode_if_bytes(e[1]))0
            import cgitb

            self.error_wrapper = cgitb.Hook(format="text")
        # okay so apparently we send errors  to the error wrapper incorrectly
        # because doing this raises a handful of errors

    @property
    def _loop_thread(self):
        """Used extensively in `Nvim`."""
        return self.current_thread

    @_loop_thread.setter
    def _set_loop_thread(self, thread):
        raise NotImplementedError

        # i get the whole composition over inheritence thing but
        # most of this class is simply wrapping pre-existing shit.
        # this is where you want inheritence

    def threadsafe_call(self, fn, *args, **kwargs):
        """Wrap :meth:`AsyncSession.threadsafe_call`."""

        def handler():
            try:
                return fn(*args, **kwargs)
            except Exception:
                warn("error caught while excecuting async callback\n%s\n", format_exc())

        def greenlet_wrapper():
            gr = greenlet.greenlet(handler)
            gr.switch()

        return self._async_session.threadsafe_call(greenlet_wrapper)

    def next_message(self):
        """Block until a message(request or notification) is available.

        If any messages were previously enqueued, return the first in queue.
        If not, run the event loop until one is received.

        Raises
        ------
        NvimError
            '_is_running' returns False.
        """
        # so i think this is literally what the magic method __next__ does but
        # its probably senseless to define that with no __iter__
        if self._is_running:
            raise NvimError("Event loop already running")
        if self._pending_messages:
            return self._pending_messages.popleft()
        self._async_session.run(
            self._enqueue_request_and_stop, self._enqueue_notification_and_stop
        )
        if self._pending_messages:
            return self._pending_messages.popleft()

    def request(self, method, *args, **kwargs):
        """Send a msgpack-rpc request and block until as response is received.

        If the event loop is running, this method must have been called by a
        request or notification handler running on a greenlet. In that case,
        send the quest and yield to the parent greenlet until a response is
        available.

        When the event loop is not running, it will perform a blocking request
        like this:
        - Send the request
        - Run the loop until the response is available
        - Put requests/notifications received while waiting into a queue

        If the `async_` flag is present and True, a asynchronous notification
        is sent instead. This will never block, and the return value or error
        is ignored.
        """
        if kwargs.pop("async_", None):
            self._async_session.notify(method, args)
            return
        # if kwargs:
        #     raise ValueError("request got unsupported keyword argument(s): {}"
        #                      .format(', '.join(kwargs.keys())))

        if self._is_running:
            v = self._yielding_request(method, args)
        else:
            v = self._blocking_request(method, args)
        if not v:
            return
            # raise OSError("EOF")
        err, rv = v
        if err:
            info("'Received error: %s", err)
            if getattr(sys, "last_traceback", None):
                raise self.error_wrapper(*err, sys.last_traceback)
        return rv

    def run(self, request_cb=None, notification_cb=None, setup_cb=None):
        """Run the event loop to receive requests and notifications from Nvim.

        Like `AsyncSession.run()`, but `request_cb` and `notification_cb` are
        inside greenlets.
        """
        import greenlet

        self._request_cb = request_cb
        self._notification_cb = notification_cb
        self._is_running = True

        def on_setup():
            try:
                setup_cb()
            except Exception as e:
                self._setup_exception = e
                self.stop()

        if setup_cb:
            # Create a new greenlet to handle the setup function
            gr = greenlet.greenlet(on_setup)
            gr.switch()

        # Process all pending requests and notifications
        while self._pending_messages:
            msg = self._pending_messages.popleft()
            getattr(self, "_on_{}".format(msg[0]))(*msg[1:])
        self._async_session.run(self._on_request, self._on_notification)

    def stop(self):
        """Stop the event loop."""
        self._async_session.stop()

    def close(self):
        """Close the event loop."""
        self._async_session.close()

    def _yielding_request(self, method, args):
        import greenlet

        gr = greenlet.getcurrent()
        parent = gr.parent

        def response_cb(err, rv):
            debug("response is available for greenlet %s, switching back", gr)
            gr.switch(err, rv)

        self._async_session.request(method, args, response_cb)
        debug("yielding from greenlet %s to wait for response", gr)
        return parent.switch()

    def _blocking_request(self, method, args):
        result = []

        def response_cb(err, rv):
            result.extend([err, rv])
            self.stop()

        self._async_session.request(method, args, response_cb)
        self._async_session.run(self._enqueue_request, self._enqueue_notification)
        return result

    def _non_blocking_request(self, method, args):
        yield from self._blocking_request(method, args)

    def _enqueue_request_and_stop(self, name, args, response):
        """

        Parameters
        ----------
        name :
        args :
        response :
        """
        self._enqueue_request(name, args, response)
        self.stop()

    def _enqueue_notification_and_stop(self, name, args):
        """

        Parameters
        ----------
        name :
        args :
        """
        self._enqueue_notification(name, args)
        self.stop()

    def _enqueue_request(self, name, args, response):
        self._pending_messages.append(("request", name, args, response,))

    def _enqueue_notification(self, name, args):
        self._pending_messages.append(("notification", name, args,))

    def _on_request(self, name, args, response):
        def handler():
            try:
                rv = self._request_cb(name, args)
                debug(f"greenlet {gr} finished executing sending {rv} as response")
                response.send(rv)
            except ErrorResponse as err:
                warn(
                    "error response from request '%s %s': %s", name, args, format_exc()
                )
                response.send(err.args[0], error=True)
            except Exception as err:
                warn(
                    "error caught while processing request '%s %s': %s".format(
                        name, args, format_exc(),
                    )
                )
                response.send(repr(err) + "\n" + format_exc(5), error=True)
            debug("greenlet %s is now dying...", gr)

        # Create a new greenlet to handle the request
        gr = greenlet.greenlet(handler)
        debug("received rpc request, greenlet %s will handle it", gr)
        gr.switch()

    def _on_notification(self, name, args):
        def handler():
            try:
                self._notification_cb(name, args)
                debug("greenlet %s finished executing", gr)
            except Exception:
                warn(
                    "error caught while processing notification '%s %s': %s",
                    name,
                    args,
                    format_exc(),
                )

            debug("greenlet %s is now dying...", gr)

        gr = greenlet.greenlet(handler)
        debug("received rpc notification, greenlet %s will handle it", gr)
        gr.switch()

    def __call__(self, fn, *args, **kwargs):
        return self.threadsafe_call(fn, *args, **kwargs)

    def __repr__(self):
        return f"{self.__class__.__name__}"

    def _error_wrapper(self, *exc_info):
        # Idk what to do here.
        pass


# api/nvim: Needs to be above plugin/scripthost:


class Nvim(object):
    """Class that represents a remote Nvim instance.

    This class is main entry point to Nvim remote API, it is a wrapper
    around Session instances.

    The constructor of this class must not be called directly. Instead, the
    `from_session` class method should be used to create the first instance
    from a raw `Session` instance.

    Subsequent instances for the same session can be created by calling the
    `with_decode` instance method to change the decoding behavior or
    `SubClass.from_nvim(nvim)` where `SubClass` is a subclass of `Nvim`, which
    is useful for having multiple `Nvim` objects that behave differently
    without one affecting the other.

    When this library is used on python3.4+, asyncio event loop is guaranteed
    to be used. It is available as the "loop" attribute of this class. Note
    that asyncio callbacks cannot make blocking requests, which includes
    accessing state-dependent attributes. They should instead schedule another
    callback using nvim.async_call, which will not have this restriction.
    """

    # idk where the fuck this was implemented but im gonna define
    # this explicitly
    VIM_SPECIAL_PATH = "_vim_path"

    @classmethod
    def from_session(cls, session: Session):
        """Create a new Nvim instance for a Session instance.

        This method must be called to create the first Nvim instance, since it
        queries Nvim metadata for type information and sets a SessionHook for
        creating specialized objects from Nvim remote handles.
        """
        if isinstance(session, str):
            session = _convert_str_to_session(session)
        try:
            response = session.request(b"nvim_get_api_info")
        except OSError:  # why is thi raising?
            raise

        channel_id, metadata = response

        if isinstance(metadata, bytes):
            import codecs

            metadata = codecs.decode(metadata, "utf-8")

        types = {
            metadata["types"]["Buffer"]["id"]: Buffer,
            metadata["types"]["Window"]["id"]: Window,
            metadata["types"]["Tabpage"]["id"]: Tabpage,
        }

        return cls(session, channel_id, metadata, types)

    @classmethod
    def from_nvim(cls, nvim):
        """Create a new Nvim instance from an existing instance."""
        return cls(
            nvim._session,
            nvim.channel_id,
            nvim.metadata,
            nvim.types,
            nvim._decode,
            nvim._err_cb,
        )

    def __init__(
        self,
        session: Session,
        channel_id: int,
        metadata,
        types,
        decode: Optional[bool] = False,
        err_cb=None,
    ):
        """Initialize a new Nvim instance. This method is module-private.

        Also worth pointing out that as insane as this __init__ is, we still
        never defined the script context that any plugins would potentially
        need.

        Parameters
        ----------
        metadata :
            Required to have a get attr.

        """
        self.error = NvimError
        self._err_cb = sys.stderr.write if err_cb is None else err_cb
        self.session = session
        if self.session is None:
            self.session = CompatibilitySession(self)
        self.channel_id = channel_id
        self.metadata = metadata
        version = metadata.get("version", {"api_level": 0})
        self.version = Version(**version)
        self.types = types
        self._decode = decode
        # arguably all **FIFTEEN** of this instance attributes should probably
        # be properties
        self.api = RemoteApi(self, "nvim_")
        self.vars = RemoteMap(self, "nvim_get_var", "nvim_set_var", "nvim_del_var")
        self.vvars = RemoteMap(self, "nvim_get_vvar", None, None)
        self.options = RemoteMap(self, "nvim_get_option", "nvim_set_option")
        self.buffers = Buffers(self)
        self.windows = RemoteSequence(self, "nvim_list_wins")
        self.tabpages = RemoteSequence(self, "nvim_list_tabpages")
        self.current = Current(self)
        self.funcs = Funcs(self)
        self.lua = LuaFuncs(self)

        # only on python3.4+ we expose asyncio
        self.loop = self._session.loop._loop

    def __repr__(self):
        return f"{self.__class__.__name__}"

    def get_nvim(self):
        # get_ipython throwback
        return self

    @property
    def _session(self) -> Session:
        """The first of potentially many refactored properties."""
        return self.session

    def _from_nvim(self, obj: msgpack.ExtType):
        from msgpack import ExtType

    def _from_nvim(self, obj, decode=None):
        warnings.warn(DeprecationWarning("decode is ignored"))
        if isinstance(obj, ExtType):
            cls = self.types[obj.code]
            return cls(self, (obj.code, obj.data))
        else:
            raise TypeError("Obj not `Remote`.")

    def _to_nvim(self, obj):
        if isinstance(obj, Remote):
            from msgpack import ExtType

            return ExtType(*obj.code_data)
        else:
            raise TypeError("Obj not `Remote`.")

    def _get_lua_private(self):
        if not getattr(self._session, "_has_lua", False):
            self.exec_lua(lua_module, self.channel_id)
            self._session._has_lua = True
        return getattr(self.lua, "_pynvim_{}".format(self.channel_id))

    def request(self, name, *args, **kwargs):
        r"""Send an API request or notification to nvim.

        It is rarely needed to call this function directly, as most API
        functions have python wrapper functions. The `api` object can
        be also be used to call API functions as methods:

            _vim.api.err_write('ERROR\n', async_=True)
            _vim.current.buffer.api.get_mark('.')

        is equivalent to

            _vim.request('nvim_err_write', 'ERROR\n', async_=True)
            _vim.request('nvim_buf_get_mark', _vim.current.buffer, '.')


        Normally a blocking request will be sent.  If the `async_` flag is
        present and True, a asynchronous notification is sent instead. This
        will never block, and the return value or error is ignored.

        Parameters
        ----------

        """
        if (
            self._session._loop_thread is not None
            and threading.current_thread() != self._session._loop_thread
        ):
            msg = (
                "Request from non-main thread.\n"
                "Requests from different threads should be wrapped "
                "with nvim.async_call(cb, ...) \n{}\n".format(
                    "\n".join(format_stack(None, 5)[:-1])
                )
            )

            self.async_call(self._err_cb, msg)
            raise NvimError("request from non-main thread")

        decode = kwargs.pop("decode", self._decode)
        args = walk(self._to_nvim, args)
        res = self._session.request(name, *args, **kwargs)
        return walk(self._from_nvim, res, decode=decode)

    def next_message(self):
        """Block until a message(request or notification) is available.

        If any messages were previously enqueued, return the first in queue.
        If not, run the event loop until one is received.
        """
        msg = self._session.next_message()
        if msg:
            return walk(self._from_nvim, msg)

    def run_loop(self, request_cb, notification_cb, setup_cb=None, err_cb=None):
        """Run the event loop to receive requests and notifications from Nvim.

        This should not be called from a plugin running in the host, which
        already runs the loop and dispatches events to plugins.
        """
        self._session.run(filter_request_cb, filter_notification_cb, setup_cb)

    def stop_loop(self):
        """Stop the event loop being started with `run_loop`."""
        self._session.stop()

    def close(self):
        """Close the nvim session and release its resources."""
        self._session.close()

    def __enter__(self):
        """Enter nvim session as a context manager."""
        return self

    def __exit__(self, *exc_info):
        """Exit nvim session as a context manager.

        Closes the event loop.
        """
        self.close()

    def filter_request_cb(self, name, *args):
        name = self._from_nvim(name)
        args = walk(self._from_nvim, args)
        try:
            # TODO: define request_cb
            result = request_cb(name, args)
        except Exception:
            msg = "error caught in request handler '{} {}'\n{}\n\n".format(
                name, args, format_exc_skip(1)
            )
            self._err_cb(msg)
            raise
        return walk(self._to_nvim, result)

    def filter_notification_cb(self, name, *args):
        name = self._from_nvim(name)
        args = walk(self._from_nvim, args)
        try:
            # TODO: define notification_cb
            notification_cb(name, args)
        except Exception:
            msg = "error caught in notification handler '{} {}'\n{}\n\n".format(
                name, args, format_exc_skip(1)
            )
            self._err_cb(msg)
            raise

    def with_decode(self, decode=True, _err_cb=None):
        """Initialize a new Nvim instance.

        Uhhhh this was definitely intended to be a classmethod right?
        """
        _err_cb = self._err_cb if _err_cb is None else _err_cb
        return Nvim(
            self._session, self.channel_id, self.metadata, self.types, decode, _err_cb,
        )

    def ui_attach(self, width, height, rgb=None, **kwargs):
        """Register as a remote UI.

        After this method is called, the client will receive redraw
        notifications.
        """
        # refactored but i still doubt this does anything.
        rgb = kwargs.pop("rgb", None) if rgb is None else rgb
        return self.request("nvim_ui_attach", width, height, kwargs)

    def ui_detach(self):
        """Unregister as a remote UI."""
        return self.request("nvim_ui_detach")

    def ui_try_resize(self, width, height):
        """Notify nvim that the client window has resized.

        If possible, nvim will send a redraw request to resize.
        """
        return self.request("ui_try_resize", width, height)

    def subscribe(self, event):
        """Subscribe to a Nvim event."""
        return self.request("nvim_subscribe", event)

    def unsubscribe(self, event):
        """Unsubscribe to a Nvim event."""
        return self.request("nvim_unsubscribe", event)

    def command(self, string, **kwargs):
        """Execute a single ex command."""
        return self.request("nvim_command", string, **kwargs)

    def command_output(self, string):
        """Execute a single ex command and return the output."""
        return self.request("nvim_command_output", string)

    def eval(self, string, **kwargs):
        """Evaluate a vimscript expression."""
        return self.request("nvim_eval", string, **kwargs)

    def call(self, name, *args, **kwargs):
        """Call a vimscript function."""
        return self.request("nvim_call_function", name, args, **kwargs)

    def exec_lua(self, code, *args, **kwargs):
        """Execute lua code.

        Additional parameters are available as `...` inside the lua chunk.
        Only statements are executed.  To evaluate an expression, prefix it
        with `return`: `return my_function(...)`

        There is a shorthand syntax to call lua functions with arguments::

            nvim.lua.func(1,2)
            nvim.lua.mymod.myfunction(data, async_=True)

        is equivalent to.::

            nvim.exec_lua("return func(...)", 1, 2)
            nvim.exec_lua("mymod.myfunction(...)", data, async_=True)

        Note that with `async_=True` there is no return value.
        """
        return self.request("nvim_execute_lua", code, args, **kwargs)

    def strwidth(self, string):
        """Return the number of display cells `string` occupies.

        Tab is counted as one cell.

        .. todo::
            How to make the string parameter = nvim_get_current_line if None?

        """
        return self.request("nvim_strwidth", string)

    def list_runtime_paths(self):
        """Return a list of paths contained in the 'runtimepath' option."""
        return self.request("nvim_list_runtime_paths")

    def foreach_rtp(self, cb: Callable):
        """Invoke `cb` for each path in 'runtimepath'.

        Call the given callable for each path in 'runtimepath' until either
        callable returns something but None, the exception is raised or there
        are no longer paths. If stopped in case callable returned non-None,
        _vim.foreach_rtp function returns the value returned by callable.

        """
        for path in self.request("nvim_list_runtime_paths"):
            try:
                if cb(path) is not None:
                    break
            except Exception:
                break

    def chdir(self, dir_path):
        """Run os.chdir, then all appropriate _vim stuff."""
        os.chdir(dir_path)
        return self.request("nvim_set_current_dir", dir_path)

    def feedkeys(self, keys, options="", escape_csi=True):
        """Push `keys` to Nvim user input buffer.

        Options can be a string with the following character flags:

        - 'm': Remap keys. This is default.
        - 'n': Do not remap keys.
        - 't': Handle keys as if typed; otherwise they are handled as if coming
               from a mapping. This matters for undo, opening folds, etc.

        """
        return self.request("nvim_feedkeys", keys, options, escape_csi)

    def input(self, bytes):
        """Push `bytes` to Nvim low level input buffer.

        Unlike `feedkeys()`, this uses the lowest level input buffer and the
        call is not deferred. It returns the number of bytes actually
        written(which can be less than what was requested if the buffer is
        full).
        """
        return self.request("nvim_input", bytes)

    def replace_termcodes(self, string, from_part=False, do_lt=True, special=True):
        r"""Replace any terminal code strings by byte sequences.

        The returned sequences are Nvim's internal representation of keys,
        for example:

        <esc> -> '\x1b'
        <cr>  -> '\r'
        <c-l> -> '\x0c'
        <up>  -> '\x80ku'

        The returned sequences can be used as input to `feedkeys`.
        """
        return self.request("nvim_replace_termcodes", string, from_part, do_lt, special)

    # why doesnt the api have a out_writeln func?
    def out_write(self, msg, **kwargs):
        r"""Print `msg` as a normal message.

        The message is buffered (won't display) until linefeed ("\n").
        Js thats a terrible idea but whatever.
        Can we add a few parameters so that this matches the parameters
        print takes?::

            print(value, ..., sep=' ', end='\n', file=sys.stdout, flush=False)

        """

    # how is there no err_writeln?
    def err_write(self, msg, **kwargs):
        r"""Print `msg` as an error message.

        The message is buffered (won't display) until linefeed ("\n").
        """
        if self._thread_invalid():
            # special case: if a non-main thread writes to stderr
            # i.e. due to an uncaught exception, pass it through
            # without raising an additional exception.
            self.async_call(self.err_write, msg, **kwargs)
            return
        return self.request("nvim_err_write", msg, **kwargs)

    def _thread_invalid(self):
        return (
            self._session._loop_thread is not None
            and threading.current_thread() != self._session._loop_thread
        )

    def quit(self, quit_command="qa!"):
        """Send a quit command to Nvim.

        By default, the quit command is 'qa!' which will make Nvim quit without
        saving anything.
        """
        try:
            self.command(quit_command)
        except OSError:
            # sending a quit command will raise an IOError because the
            # connection is closed before a response is received. Safe to
            # ignore it.
            # you mean oserror.
            pass

    def new_highlight_source(self):
        """Return new src_id for use with Buffer.add_highlight."""
        return self.current.buffer.add_highlight("", 0, src_id=0)

    def async_call(self, fn, *args, **kwargs):
        """Schedule `fn` to be called by the event loop soon.

        This function is thread-safe, and is the only way code not
        on the main thread could interact with nvim api objects.

        This function can also be called in a synchronous
        event handler, just before it returns, to defer execution
        that shouldn't block neovim.
        """
        call_point = "".join(traceback.format_stack(None, 5)[:-1])

        def handler():
            try:
                return fn(*args, **kwargs)
            except Exception as err:
                msg = (
                    "error caught while executing async callback:\n"
                    "{!r}\n{}\n \nthe call was requested at\n{}".format(
                        err, format_exc_skip(1), call_point
                    )
                )
                self._err_cb(msg)
                raise

        self._session.threadsafe_call(handler())


class BufferBase(UserList):
    """The Buffers class should fully implement the MutableSequence protocol.

    Actually this might be a better idea.

    .. seealso::
        `Python's Buffer Objects
        <https://docs.python.org/3/c-api/buffer.html#bufferobjects>`_

    """

    def __init__(self, nvim, session=None):
        """Initialize a Buffers object with Nvim object `nvim`."""
        self.nvim = Nvim.from_session(session) if nvim is None else nvim
        self._fetch_buffers = nvim.api.list_bufs

    def __len__(self):
        """Return the count of buffers."""
        return len(self._fetch_buffers())

    def __iter__(self):
        """Return an iterator over the list of buffers."""
        return iter(self._fetch_buffers())

    def __getitem__(self, number):
        """Return the Buffer object matching buffer number `number`."""
        for b in self._fetch_buffers():
            if b.number == number:
                return b
        raise KeyError(number)

    def __contains__(self, b):
        """Return whether Buffer `b` is a known valid buffer."""
        return isinstance(b, Buffer) and b.valid

    def __repr__(self):
        return f"{self.__class__.__name__}"


class BufferNvimBase(Nvim):
    """Subclass Nvim to create Buffers.

    In order to avoid writing more classes that require the Nvim instance
    to instantiate properly, let's utilize the tools of inheritence made
    available to us.

    Actually the nvim class has such a big constructor that its gonna
    be easier to do this with the Remote class.

    *sigh*
    """

    session: Session
    channel_id: int

    def __init__(
        self,
        session: Session,
        channel_id: int = None,
        metadata=None,
        types=None,
        decode: Optional[bool] = False,
        err_cb=None,
        **kwargs,
    ):
        # fuck. TODO: we only need either the session or other stuff. not both.
        self.session = session
        self.channel_id = channel_id
        self.metadata = metadata
        self.types = types
        self.decode = decode
        self.err_cb = err_cb
        if session is not None:
            super().from_session(session, **kwargs)
        else:
            super().__init__(
                channel_id, metadata, types, decode=decode, err_cb=err_cb, **kwargs
            )


class Buffers(BufferBase):
    """Remote NVim buffers.

    Currently the interface for interacting with remote NVim buffers is the
    `nvim_list_bufs` msgpack-rpc function. Most methods fetch the list of
    buffers from NVim.

    Conforms to *python-buffers*.
    """

    def all(self):
        return self._fetch_buffers()

    def __repr__(self):
        from reprlib import Repr

        return Repr().repr(self._fetch_buffers())


class CompatibilitySession(Remote):
    """Helper class for API compatibility. This should really subclass Remote
    though."""

    def __init__(self, nvim, session, code_data):
        super().__init__(session, code_data)
        self.threadsafe_call = nvim.async_call

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%r: (%r)>" % (self.__class__.__name__, self.threadsafe_call)

    def __call__(self, command):
        return self.threadsafe_call(command)


class Current(BufferBase):
    """Helper class for emulating _vim.current from python-_vim."""

    def __init__(self, session, nvim):
        super().__init__(nvim)
        self._session = session
        self.range = None

    @property
    def line(self):
        return self._session.request("nvim_get_current_line")

    @line.setter
    def line(self, line):
        self._session.request("nvim_set_current_line", line)

    @line.deleter
    def line(self):
        self._session.request("nvim_del_current_line")

    @property
    def buffer(self):
        return self._session.request("nvim_get_current_buf")

    @buffer.setter
    def buffer(self, buffer):
        self._session.request("nvim_set_current_buf", buffer)

    @property
    def window(self):
        return self._session.request("nvim_get_current_win")

    @window.setter
    def window(self, window):
        self._session.request("nvim_set_current_win", window)

    @property
    def tabpage(self):
        return self._session.request("nvim_get_current_tabpage")

    @tabpage.setter
    def tabpage(self, tabpage):
        self._session.request("nvim_set_current_tabpage", tabpage)

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%r: (%r)>" % (self.__class__.__name__, self.buffer)


class Funcs(object):
    """Helper class for functional vimscript interface."""

    def __init__(self, nvim):
        self._nvim = nvim

    def __getattr__(self, name):
        return functools.partial(self._nvim.call, name)

    def __call__(self, *args, **kwargs):
        # first new function after keyword rename, be a bit noisy
        if "async" in kwargs:
            raise DeprecationWarning(
                '"async" argument is not allowed. ' 'Use "async_" instead.'
            )
        async_ = kwargs.get("async_", False)
        pattern = "return {}(...)" if not async_ else "{}(...)"
        code = pattern.format(self.name)
        return self._nvim.exec(code, *args, **kwargs)

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%r>" % (self.__class__.__name__)


class LuaFuncs(Funcs):
    """Wrapper to allow lua functions to be called like python methods."""

    def __init__(self, nvim, name=""):
        self.name = name
        super().__init__(nvim)

    def __getattr__(self, name):
        """Return wrapper to named api method."""
        prefix = self.name + "." if self.name else ""
        return LuaFuncs(self._nvim, prefix + name)

    def __call__(self, *args, **kwargs):
        # BREAKING CHANGE. You wanted to raise DeprecationWarning
        if "async" in kwargs:
            raise DeprecationWarning(
                '"async" argument is not allowed. ' 'Use "async_" instead.'
            )
        async_ = kwargs.get("async_", False)
        pattern = "return {}(...)" if not async_ else "{}(...)"
        code = pattern.format(self.name)
        return self._nvim.exec_lua(code, *args, **kwargs)


class LuaModule:
    """Moved into a class so that users can override it if they want."""

    def __init__(self):
        import textwrap

        self.lua_module = textwrap.dedent(
            """
    local a = vim.api
    local function update_highlights(buf, src_id, hls, clear_first, clear_end)
    if clear_first ~= nil then
        a.nvim_buf_clear_highlight(buf, src_id, clear_first, clear_end)
    end
    for _,hl in pairs(hls) do
        local group, line, col_start, col_end = unpack(hl)
        if col_start == nil then
        col_start = 0
        end
        if col_end == nil then
        col_end = -1
        end
        a.nvim_buf_add_highlight(buf, src_id, group, line, col_start, col_end)
    end
    end

    local chid = ...
    local mod = {update_highlights=update_highlights}
    _G["_pynvim_"..chid] = mod
    """
        )


lua_module = LuaModule().lua_module

# plugin/scripthost:


def path_hook(_vim):
    """Query the `VimPath` for additional directories."""
    return VimPath.from_nvim(_vim).hook(sys.path)


class VimPath(Nvim):
    """A class that fixes neovim's odd sys.path hacks."""

    def __init__(self):
        # simply to make using our classes a lil easier like jesus christ are
        # these painful to work with
        super().from_nvim(vim)

    def __repr__(self):
        import reprlib

        return reprlib.Repr().repr(self.list_runtime_paths())

    def __iter__(self):
        # Note that this isnt defined in the superclass either.
        for i in self.list_runtime_paths():
            return i

    def discover_runtime_directories(self):
        """Find directories that Vim is aware of that python won't be."""
        # Alright so we should make a class that we can utilize to hack on Vim's
        # sys.path. This is definitely gonna be a method. It should probably
        # subclass Nvim
        PYTHON_SUBDIR = "python3"
        rv = []
        for rtp in self.list_runtime_paths():
            if not os.path.exists(rtp):
                continue
            for subdir in ["pythonx", PYTHON_SUBDIR]:
                path = os.path.join(rtp, subdir)
                if os.path.exists(path):
                    rv.append(path)
        return rv

    def hook(self, path):
        if path == self.VIM_SPECIAL_PATH:
            return self


def out_stream(data, **kwargs):
    """In an attempt to avoid ever using RedirectStream again."""
    with contextlib.redirect_stdout(sys.stdout):
        vim.request("nvim_out_write", data, **kwargs)
    return (data, kwargs)


def err_stream(data, **kwargs):
    with contextlib.redirect_stdout(sys.stdout):
        vim.request("nvim_err_write", data, **kwargs)
    return (data, kwargs)


@contextlib.contextmanager
def hide_stdio():
    """Swallow stdout and stderr. Don't use RedirectStream."""
    ignored = IgnoredIO()
    sys.stdout = ignored
    sys.stderr = ignored
    try:
        yield
    finally:
        sys.stdout = sys.__stdout__
        sys.stderr = sys.__stderr__


@plugin
class ScriptHost:
    """Provides an environment for running python plugins created for Vim."""

    def __init__(self, nvim=None):
        """Initialize the legacy python-_vim environment.

        Moved the self.nvim = nvim to the ``__init__`` so that :meth:`setup`
        doesn't require parameters anymore.
        Set import hooks and global streams.

        This will add import hooks for importing modules from runtime
        directories and patch the sys module so 'print' calls will be
        forwarded to Nvim.
        """
        self.nvim = nvim if nvim is not None else Nvim.from_session(self)
        info("install import hook/path")
        sys.path_hooks.append(self.hook)
        sys.path.append(nvim.VIM_SPECIAL_PATH)
        # also we're gonna need to do something about all this horrific
        # sys.path hacking
        self.hook = path_hook(nvim)

        # context where all code will run
        import types

        # it seems some plugins assume 'sys' is already imported, so do it now
        exec("import sys", globals(), locals())
        exec("import re", globals(), locals())
        self.legacy_vim = LegacyVim.from_nvim(nvim)
        exec("import vim", globals(), locals())
        sys.modules["vim"] = self.legacy_vim
        exec("import vim", self.module.__dict__)
        import platform

        if not platform.platform().startswith("Win"):
            self.handle_dirchanged(self.nvim)

    def handle_dirchanged(self, nvim):
        # Handle DirChanged. #296
        nvim.command(
            "au DirChanged *"
            'call rpcnotify({}, "python_chdir", v:event.cwd)'.format(nvim.channel_id),
            async_=True,
        )

        # XXX: Avoid race condition.
        # https://github.com/neovim/pynvim/pull/296#issuecomment-358970531
        # TODO(bfredl): when host initialization has been refactored,
        # to make __init__ safe again, the following should work:
        # os.chdir(nvim._eval('getcwd()', async_=False))
        nvim.command(
            'call rpcnotify({}, "python_chdir", getcwd())'.format(nvim.channel_id),
            async_=True,
        )

    # def teardown(self):
    #     """Restore state modified from the `setup` call."""
    #     nvim = self.nvim
    #     info("uninstall import hook/path")
    #     sys.path.remove(nvim.VIM_SPECIAL_PATH)
    #     sys.path_hooks.remove(self.hook)
    #     info("restore sys.stdout and sys.stderr")
    #     sys.stdout = self.saved_stdout
    #     sys.stderr = self.saved_stderr

    @rpc_export("python_execute", sync=True)
    def python_execute(self, script, range_start, range_stop):
        """Handle the `python` ex command.

        Might wanna consider adding their test suite in here as well.
        I don't wanna introduce any regressions but if we could add a lot
        more default values to everything it'd be so much easier to use this
        API in addition to speed things up by making all of the lookups local.
        """
        self._set_current_range(range_start, range_stop)
        try:
            exec(script, globals(), locals())
        except Exception:
            raise ErrorResponse(format_exc_skip(1))

    @rpc_export("python_execute_file", sync=True)
    def python_execute_file(self, file_path, range_start, range_stop):
        """Handle the `pyfile` ex command."""
        self._set_current_range(range_start, range_stop)
        with open(file_path) as f:
            script = compile(f.read(), file_path, "exec")
            try:
                exec(script, globals(), locals())
            except Exception:
                raise ErrorResponse(format_exc_skip(1))

    @rpc_export("python_do_range", sync=True)
    def python_do_range(self, start, stop, code):
        """Handle the `pydo` ex command."""
        self._set_current_range(start, stop)
        nvim = self.nvim
        start -= 1
        fname = "_vim_pydo"

        # define the func
        function_def = "def %s(line, linenr):\n %s" % (fname, code,)
        exec(script, globals(), locals())
        # get the func
        exec(function_def, self.module.__dict__)
        while start < stop:
            # Process batches of 5000 to avoid the overhead of making multiple
            # API calls for every line. Assuming an average line length of 100
            # bytes, approximately 488 kilobytes will be transferred per batch,
            # which can be done very quickly in a single API call.
            sstart = start
            sstop = min(start + 5000, stop)
            lines = nvim.current.buffer.api.get_lines(sstart, sstop, True)

            exception = None
            newlines = []
            linenr = sstart + 1
            for i, line in enumerate(lines):
                result = func(line, linenr)
                if result is None:
                    # Update earlier lines, and skip to the next
                    if newlines:
                        end = sstart + len(newlines) - 1
                        nvim.current.buffer.api.set_lines(sstart, end, True, newlines)
                    sstart += len(newlines) + 1
                    newlines = []
                    pass
                elif isinstance(result, str):
                    newlines.append(result)
                else:
                    exception = TypeError(
                        "pydo should return a string "
                        + "or None, found %s instead" % result.__class__.__name__
                    )
                    break
                linenr += 1

            start = sstop
            if newlines:
                end = sstart + len(newlines)
                nvim.current.buffer.api.set_lines(sstart, end, True, newlines)
            if exception:
                raise exception

    @rpc_export("python_eval", sync=True)
    def python_eval(self, expr):
        """Handle the `pyeval` _vim function."""
        return eval(expr, self.module.__dict__)

    @rpc_export("python_chdir", sync=False)
    def python_chdir(self, cwd):
        """Handle working directory changes."""
        os.chdir(cwd)

    def _set_current_range(self, start, stop):
        current = self.legacy_vim.current
        current.range = current.buffer.range(start, stop)


class RedirectStream(io.TextIOWrapper):
    """The streams that our Nvim and Session objects are writing to.

    .. versionchanged:: 0.4.mytakeover

        Implements the context manager protocol.
        In addition no longer subclasses io.IOBase as that abstract class
        requires the subclass to implement more than 2 methods.
        Using io.TextIOWrapper as it's the standard IO interface one works
        with in the REPL.

    """

    def __init__(self, redirect_handler, **kwargs):
        r"""Initialize with a redirect handler. Must accept arbitrary data.

        In addition must be able to write to python streams.:

            io.TextIOWrapper(
                buffer, encoding=None, errors=None, newline=None,
                line_buffering=False, write_through=False
            )

        Character and line based layer over a BufferedIOBase object, buffer.

        encoding gives the name of the encoding that the stream will be
        decoded or encoded with. It defaults to locale.getpreferredencoding(False).

        errors determines the strictness of encoding and decoding (see
        help(codecs.Codec) or the documentation for codecs.register) and
        defaults to "strict".

        newline controls how line endings are handled. It can be None, '',
        '\n', '\r', and '\r\n'.  It works as follows:

        * On input, if newline is None, universal newlines mode is
          enabled. Lines in the input can end in '\n', '\r', or '\r\n', and
          these are translated into '\n' before being returned to the
          caller. If it is '', universal newline mode is enabled, but line
          endings are returned to the caller untranslated. If it has any of
          the other legal values, input lines are only terminated by the given
          string, and the line ending is returned to the caller untranslated.

        * On output, if newline is None, any '\n' characters written are
          translated to the system default line separator, os.linesep. If
          newline is '' or '\n', no translation takes place. If newline is any
          of the other legal values, any '\n' characters written are translated
          to the given string.

        If line_buffering is True, a call to flush is implied when a call to
        write contains a newline character.

        """
        self.redirect_handler = redirect_handler
        raise DeprecationWarning
        super().__init__(**kwargs)

    @property
    def encoding(self):
        return sys.getfilesystemencoding()

    def write(self, data):
        self.redirect_handler(data)

    def writelines(self, seq):
        self.redirect_handler("\n".join(seq))

    def __enter__(self):
        # TODO:
        print("Did this work at all?")

    def __exit__(self, *exc_info):
        # dude can we please update v:shell_err or ANYTHING here??
        pass
        # let v:shell_err or some shit

    # def fileno(self):
    # TODO
    def open(file, *pargs, **kwargs):
        if isinstance(file, PathLike):
            file = fspath(file)
        return io.open(file, *pargs, **kwargs)

    read = open


def num_to_str(obj):
    """Converts int long and float to str."""
    num_types = (int, float)
    if isinstance(obj, num_types):
        return str(obj)
    else:
        return obj


class LegacyVim(Nvim):
    """Nvim subclass with new _eval."""

    __ISLEGACY__ = True

    def eval(self, expr, **kwargs):
        return self.request("vim_eval", expr)
        # return walk(num_to_str, obj)


def _find_module(fullname, oldtail):
    warnings.warn(DeprecationWarning, "Use find_module")
    idx = oldtail.find(".")
    if idx > 0:
        return _find_module(fullname, oldtail)


def find_module(mod, path=None, target=None):
    """A more sensible manner for finding a module."""
    if isinstance(mod, bytes):
        mod = get_decoded_string(mod)
    if isinstance(path, bytes):
        path = get_decoded_string(path)
    from importlib.util import module_from_spec

    try:
        return module_from_spec(find_spec(mod, path, target=target))
    except ModuleNotFoundError:
        # TODO: update v:shell_err
        sys.stderr.write(str(mod) + " not found!")


class VimPathFinder:
    # TODO: We gotta define get_paths in this class but seriously every
    # function either implicitly uses `nvim` or requires it as a positional
    # parameter ughh

    def __init__(self, fullname, path=None):
        self.fullname = fullname
        self.path = path if path is not None else ""

    @classmethod
    def find_module(cls, fullname, oldtail, path):
        try:
            return find_module(fullname, oldtail, path)
        except ImportError:
            return None


def find_spec(fullname, path=None, target=None):
    """Find the `ModuleSpec` for a given module.

    Method for Python 3.4+.

    .. versionchanged:: 0.4.2

        Now accepts path keyword argument.

    """
    if PathFinder is not None:
        return PathFinder.find_spec(fullname, path=path, target=target)
    # else VimPathFinder().find_module()


# API/buffer:


def adjust_index(idx, default=None):
    """Convert from python indexing convention to nvim indexing convention."""
    if idx is None:
        return default
    elif idx < 0:
        return idx - 1
    else:
        return idx


class Buffer(Remote):
    """A remote Nvim buffer."""

    _api_prefix = "nvim_buf_"

    def __init__(self, session, code_data, **kwargs):
        super().__init__(session, code_data, **kwargs)
        self.session = session
        self.code_data = code_data

    def __len__(self):
        """Return the number of lines contained in a Buffer."""
        return self.request("nvim_buf_line_count")

    def __bool__(self):
        """Adding a bool because its a waste of time to send a msgpack request."""
        return self.valid

    def __getitem__(self, idx):
        """Get a buffer line or slice by integer index.

        Indexes may be negative to specify positions from the end of the
        buffer. For example, -1 is the last line, -2 is the line before that
        and so on.

        When retrieving slices, omiting indexes(eg: `buffer[:]`) will bring
        the whole buffer.
        """
        if not isinstance(idx, slice):
            i = adjust_index(idx)
            return self.request("nvim_buf_get_lines", i, i + 1, True)[0]
        start = adjust_index(idx.start, 0)
        end = adjust_index(idx.stop, -1)
        return self.request("nvim_buf_get_lines", start, end, False)

    def __setitem__(self, idx, item):
        """Replace a buffer line or slice by integer index.

        Like with `__getitem__`, indexes may be negative.

        When replacing slices, omiting indexes(eg: `buffer[:]`) will replace
        the whole buffer.
        """
        if not isinstance(idx, slice):
            i = adjust_index(idx)
            lines = [item] if item is not None else []
            return self.request("nvim_buf_set_lines", i, i + 1, True, lines)
        lines = item if item is not None else []
        start = adjust_index(idx.start, 0)
        end = adjust_index(idx.stop, -1)
        return self.request("nvim_buf_set_lines", start, end, False, lines)

    def __iter__(self):
        """Iterate lines of a buffer.

        This will retrieve all lines locally before iteration starts. This
        approach is used because for most cases, the gain is much greater by
        minimizing the number of API calls by transfering all data needed to
        work.
        """
        for line in self:
            yield line

    def __delitem__(self, idx):
        """Delete line or slice of lines from the buffer.

        This is the same as __setitem__(idx, [])
        """
        self.__setitem__(idx, None)

    def __ne__(self, other):
        """Test inequality of Buffers.

        Necessary for Python 2 compatibility. We never defined eq?
        If I define eq, I'll need to define hash. Otherwise hash returns
        nothing. Oh shit we should add reduce so we can pickle these things.
        Awh shit this is gonna get complicated.
        """
        return not self.__eq__(other)

    def append(self, lines, index=-1):
        """Append a string or list of lines to the buffer."""
        if isinstance(lines, (str, bytes)):
            # BUG: dont just add [] around it split on newlines too!
            lines = lines.split("\n")
        return self.request("nvim_buf_set_lines", index, index, True, lines)

    def __iadd__(self, lines, index=-1):
        self.append(lines, index)

    def mark(self, name):
        """Return (row, col) tuple for a named mark."""
        return self.request("nvim_buf_get_mark", name)

    # def _range(self, start, end):
    def range(self, start=None, end=None):
        """Return a `Range` object, which represents part of the Buffer."""
        if start is None:
            start = 0
        if end is None:
            end = len(self)
        return Range(self, start, end)
        # return Range(self, start, end)

    def add_highlight(
        self, hl_group, line, col_start=0, col_end=-1, src_id=-1, async_=None, **kwargs
    ):
        """Add a highlight to the buffer."""
        async_ = check_async(async_, kwargs, src_id != 0)
        return self.request(
            "nvim_buf_add_highlight",
            src_id,
            hl_group,
            line,
            col_start,
            col_end,
            async_=async_,
        )

    def clear_highlight(self, src_id, line_start=0, line_end=-1, async_=None, **kwargs):
        """Clear highlights from the buffer."""
        async_ = check_async(async_, kwargs, True)
        self.request(
            "nvim_buf_clear_highlight", src_id, line_start, line_end, async_=async_
        )

    def update_highlights(
        self, src_id, hls, clear_start=0, clear_end=-1, clear=False, async_=True
    ):
        """Add or update highlights in batch to avoid unnecessary redraws.

        A `src_id` must have been allocated prior to use of this function. Use
        for instance `nvim.new_highlight_source()` to get a src_id for your
        plugin.

        `hls` should be a list of highlight items. Each item should be a list
        or tuple on the form `("GroupName", linenr, col_start, col_end)` or
        `("GroupName", linenr)` to highlight an entire line.

        By default existing highlights are preserved. Specify a line _range with
        clear_start and clear_end to replace highlights in this _range. As a
        shorthand, use clear=True to clear the entire buffer before adding the
        new highlights.
        """
        if clear and clear_start is None:
            clear_start = 0
        lua = self._session._get_lua_private()
        lua.update_highlights(self, src_id, hls, clear_start, clear_end, async_=async_)

    @property
    def name(self):
        """Get the buffer name."""
        return self.request("nvim_buf_get_name")

    @name.setter
    def name(self, value):
        """Set the buffer name. BufFilePre/BufFilePost are triggered."""
        return self.request("nvim_buf_set_name", value)

    @property
    def valid(self):
        """Return True if the buffer still exists."""
        return self.request("nvim_buf_is_valid")

    @property
    def number(self):
        """Get the buffer number."""
        return self.handle


class Range(object):
    def __init__(self, buffer=None, start=1, end=None):
        """Give all required parameters default arguments to match Vims.

        Parameters
        ----------
        start : int
        end : int
        """
        self._buffer = buffer if buffer is not None else vim.current.buffer
        self.start = start - 1
        if end is not None:
            self.end = end - 1
        else:
            self.end = len(self._buffer)

    def __len__(self):
        return self.end - self.start + 1

    def __getitem__(self, idx):
        if not isinstance(idx, slice):
            return self._buffer[self._normalize_index(idx)]
        start = self._normalize_index(idx.start)
        end = self._normalize_index(idx.stop)
        if start is None:
            start = self.start
        if end is None:
            end = self.end + 1
        return self._buffer[start:end]

    def __setitem__(self, idx, lines):
        if not isinstance(idx, slice):
            self._buffer[self._normalize_index(idx)] = lines
            return
        start = self._normalize_index(idx.start)
        end = self._normalize_index(idx.stop)
        if start is None:
            start = self.start
        if end is None:
            end = self.end
        self._buffer[start : end + 1] = lines

    def __iter__(self):
        for i in range(self.start, self.end + 1):
            yield self._buffer[i]

    def append(self, lines, i=None):
        i = self._normalize_index(i)
        if i is None:
            i = self.end + 1
        self._buffer.append(lines, i)

    def _normalize_index(self, index):
        if index is None:
            return None
        if index < 0:
            index = self.end
        else:
            index += self.start
            if index > self.end:
                index = self.end
        return index


# API/common:


class RemoteApi(object):
    """Wrapper to allow api methods to be called like python methods.

    Currently only defines getattr. Could easily expand or subclass something and possibly get much ore
    fine controlled access to everything. Bound to the Neovim class at `api` so definitely important.
    """

    def __init__(self, obj, api_prefix="nvim_"):
        """Initialize a RemoteApi with object and api prefix.

        Parameters
        ----------
        api_prefix : str
            Now has a default so we don't have to type as much.

        """
        self._obj = obj
        self._api_prefix = api_prefix

    def __getattr__(self, name):
        """Return wrapper to named api method."""
        return functools.partial(self._obj.request, self._api_prefix + name)

    def __repr__(self):
        # Let's add a useful repr shall we?
        return f"<{self.__class__.__name__}:> - Bound to {self._obj}"


def transform_keyerror(exc):
    # Im very confident that this is not how you do this
    if isinstance(exc, NvimError):
        if exc.args[0].startswith("Key not found:"):
            raise AttributeError
        #     return KeyError(exc.args[0])
        if exc.args[0].startswith("Invalid option name:"):
            raise KeyError
        #     return KeyError(exc.args[0])
    # return exc


class RemoteMap(MutableMapping):
    """Represents a string->object map stored in Nvim.

    This is the dict counterpart to the `RemoteSequence` class, but it is used
    as a generic way of retrieving values from the various map-like data
    structures present in Nvim.

    It is used to provide a dict-like API to _vim variables and options.

    Examples
    --------
    ::

        >>> import pprint
        >>> pprint.pprint(vim.vars)

    No because then it would require that the main Nvim class be iterable.
    Which can happen later but not now.
    """

    _set = None
    _del = None

    def __init__(self, obj: AnyStr, get_method, set_method=None, del_method=None):
        """Initialize a RemoteMap with session, getter/setter."""
        self._get = functools.partial(obj.request, get_method)
        if set_method:
            self._set = functools.partial(obj.request, set_method)
        if del_method:
            self._del = functools.partial(obj.request, del_method)
        self.obj = obj

    def __getitem__(self, key):
        """Return a map value by key."""
        try:
            return self._get(key)
        except NvimError as exc:
            raise transform_keyerror(exc)

    def __setitem__(self, key, value):
        """Set a map value by key(if the setter was provided)."""
        if not self._set:
            raise TypeError("This dict is read-only")
        self._set(key, value)

    def __delitem__(self, key):
        """Delete a map value by associating None with the key."""
        if not self._del:
            raise TypeError("This dict is read-only")
        try:
            return self._del(key)
        except NvimError as exc:
            raise transform_keyerror(exc)

    def __contains__(self, key):
        """Check if key is present in the map."""
        try:
            self._get(key)
            return True
        except Exception:
            return False

    def get(self, key, default=None):
        """Return value for key if present, else a default value."""
        try:
            return self.__getitem__(key)
        except KeyError:
            return default

    def __repr__(self):
        return "<%s: %s>" % (self.__class__.__name__, self.obj)


class RemoteSequence(UserList):
    """Represents a sequence of objects stored in Nvim.

    This class is used to wrap msgpack-rpc functions that work on Nvim
    sequences(of lines, buffers, windows and tabpages) with an API that
    is similar to the one provided by the python-_vim interface.

    For example, the 'windows' property of the `Nvim` class is a RemoteSequence
    sequence instance, and the expression `nvim.windows[0]` is translated to
    session.request('nvim_list_wins')[0].

    One important detail about this class is that all methods will fetch the
    sequence into a list and perform the necessary manipulation
    locally(iteration, indexing, counting, etc).

    Attributes
    ----------
    `_fetch` : functools.Partial
        Literally the only one so this could become a function very easily.

    """

    def __init__(self, session, method):
        """Initialize a RemoteSequence with session, method.

        Parameters
        ----------
        session :
            Something that has a request attr?
        method :
            Idk.

        """
        self._fetch = functools.partial(session.request, method)

    def __len__(self):
        """Return the length of the remote sequence."""
        return len(self._fetch())

    def __getitem__(self, idx):
        """Return a sequence item by index."""
        if not isinstance(idx, slice):
            return self._fetch()[idx]
        return self._fetch()[idx.start : idx.stop]

    def __iter__(self):
        """Return an iterator for the sequence."""
        items = self._fetch()
        for item in items:
            yield item

    def __contains__(self, item):
        """Check if an item is present in the sequence."""
        return item in self._fetch()


def _walk(f, obj=None, *args, **kwargs):
    # TODO: test
    if obj is None:
        return
    if not hasattr(obj, "__iter__"):
        raise TypeError
    return f(itertools.chain.from_iterable(obj), *args, **kwargs)


# why is this set up this way?
def _identity(obj, session, method, kind):
    return obj


def walk(fn, obj, *args, **kwargs):
    """Recursively walk an object graph applying `fn`/`args` to objects."""
    if type(obj) in [list, tuple]:
        return list(walk(fn, o, *args) for o in obj)
    if type(obj) is dict:
        return dict((walk(fn, k, *args), walk(fn, v, *args)) for k, v in obj.items())
    return fn(obj, *args, **kwargs)


# msgpack_rpc.msgpack_stream:


class MsgpackStream(object):
    """Two-way msgpack stream that wraps a event loop byte stream.

    This wraps the event loop interface for reading/writing bytes and
    exposes an interface for reading/writing msgpack documents.
    """

    def __init__(self, event_loop=None, _message_cb=None, autoreset=True, **kwargs):
        """Wrap `event_loop` on a msgpack-aware interface.

        Parameters
        ----------
        :param callable default:
            Convert user type to builtin type that Packer supports.
            See also simplejson's document.

        :param bool use_single_float:
            Use single precision float type for float. (default: False)

        :param bool autoreset:
            Reset buffer after each pack and return its content as `bytes`. (default: True).
            If set this to false, use `bytes()` to get content and `.reset()` to clear buffer.

        :param bool use_bin_type:
            Use bin type introduced in msgpack spec 2.0 for bytes.
            It also enables str8 type for unicode. (default: True)

        :param bool strict_types:
            If set to true, types will be checked to be exact. Derived classes
            from serializeable types will not be serialized and will be
            treated as unsupported type and forwarded to default.
            Additionally tuples will not be serialized as lists.
            This is useful when trying to implement accurate serialization
            for python types.

        :param str unicode_errors:
            The error handler for encoding unicode. (default: 'strict')
            DO NOT USE THIS!!  This option is kept for very specific usage.

        Unpacker's Parameters
        ---------------------
        :param file_like:
            File-like object having `.read(n)` method.
            If specified, unpacker reads serialized data from it and :meth:`feed()` is not usable.

        :param int read_size:
            Used as `file_like.read(read_size)`. (default: `min(1024**2, max_buffer_size)`)

        :param bool use_list:
            If true, unpack msgpack array to Python list.
            Otherwise, unpack to Python tuple. (default: True)

        :param bool raw:
            If true, unpack msgpack raw to Python bytes.
            Otherwise, unpack to Python str by decoding with UTF-8 encoding (default).

        :param bool strict_map_key:
            If true (default), only str or bytes are accepted for map (dict) keys.

        :param callable object_hook:
            When specified, it should be callable.
            Unpacker calls it with a dict argument after unpacking msgpack map.
            (See also simplejson)

        :param callable object_pairs_hook:
            When specified, it should be callable.
            Unpacker calls it with a list of key-value pairs after unpacking msgpack map.
            (See also simplejson)

        :param int max_buffer_size:
            Limits size of data waiting unpacked.  0 means system's INT_MAX.
            The default value is 100*1024*1024 (100MiB).
            Raises `BufferFull` exception when it is insufficient.
            You should set this parameter when unpacking data from untrusted source.

        :param int max_str_len:
            Deprecated, use *max_buffer_size* instead.
            Limits max length of str. (default: max_buffer_size)

        :param int max_bin_len:
            Deprecated, use *max_buffer_size* instead.
            Limits max length of bin. (default: max_buffer_size)

        :param int max_array_len:
            Limits max length of array. (default: max_buffer_size)

        :param int max_map_len:
            Limits max length of map. (default: max_buffer_size//2)

        :param int max_ext_len:
            Deprecated, use *max_buffer_size* instead.
            Limits max size of ext type. (default: max_buffer_size)

        :param str unicode_errors:
            Error handler used for decoding str type.  (default: `'strict'`)

        """
        self._loop = (
            event_loop if event_loop is not None else AsyncioEventLoop()
        )  # todo: args

        # OR:
        # try:
        #     self.loop = get_running_loop() if event_loop is None else event_loop
        # except RunTimeError:
        #     loop_policy = get_event_loop_policy()
        #     self.loop = loop_policy.get_event_loop()

        self._packer = Packer(autoreset=autoreset)
        self._unpacker = Unpacker(**kwargs)
        self._message_cb = _message_cb

    @property
    def loop(self):
        if isinstance(self._loop, asyncio.BaseEventLoop):
            try:
                asyncio.get_event_loop()
            except RuntimeError:  # not running
                ml_logger.warn("Event loop isn't running.")
        # else:
        #     raise NotImplementedError
        return self._loop

    @loop.setter
    def _set_loop(self, value):
        if isinstance(self._loop, asyncio.BaseEventLoop):
            asyncio.set_event_loop(value)
        else:
            # todo:
            self._loop = value

    def threadsafe_call(self, fn):
        """Wrapper around `BaseEventLoop.threadsafe_call`."""
        if isinstance(self.loop, asyncio.BaseEventLoop):
            self.loop.call_soon_threadsafe(fn)
        else:
            self.loop.threadsafe_call(fn)

    def send(self, msg):
        """Queue `msg` for sending to Nvim."""
        debug("msgpack_stream: sent %s", msg)
        packed = self._packer.pack(msg)
        debug(packed)

    def run(self, coroutine=None):
        """Run the event loop to receive messages from Nvim.

        While the event loop is running, `message_cb` will be called whenever
        a message has been successfully parsed from the input stream.
        """
        # self._message_cb = message_cb
        # self._message_cb = None
        if isinstance(self.loop, asyncio.BaseEventLoop):
            # gotta start awaiting
            self.loop.run_until_complete(coroutine)
        else:
            self.loop.run(self._on_data)

    def stop(self):
        """Stop the event loop."""
        self.loop.stop()

    def close(self):
        """Close the event loop."""
        self.loop.close()

    def _on_data(self, data):
        self._unpacker.feed(data)
        while True:
            try:
                debug("waiting for message...")
                msg = next(self._unpacker)
                debug("received message: %s", msg)
                self._message_cb(msg)
            except StopIteration:
                debug("unpacker needs more data...")
                break

    def __repr__(self):
        return f"{self.__class__.__name__}"


# msgpack_rpc.async_session:


class SessionHandlers(enum.Enum):
    _on_request = 1
    _on_response = 2
    _on_notification = 3

    def __str__(self):
        return self.name


class AsyncSession(MsgpackStream):
    """Asynchronous msgpack-rpc layer that wraps a msgpack stream.

    This wraps the msgpack stream interface for reading/writing msgpack
    documents and exposes an interface for sending and receiving msgpack-rpc
    requests and notifications.

    """

    # TODO: integrate this in correctly
    # self.loop = loop if loop is not None else get_event_loop_policy().new_event_loop()
    # also it should be a class attribute as every instance should
    # probably be accessing the same loop.

    def __init__(self, event_loop=None, _message_cb=None, msgpack_stream=None):
        """Wrap `msgpack_stream` on a msgpack-rpc interface."""
        # self._msgpack_stream = msgpack_stream
        warnings.warn(DeprecationWarning("msgpack_stream is deprecated"))
        self._next_request_id = 1
        self._pending_requests = {}
        self._request_cb = self._notification_cb = None
        self._handlers = {
            0: self._on_request,
            1: self._on_response,
            2: self._on_notification,
        }
        # self._enum_handlers = SessionHandlers()
        # self.loop = msgpack_stream.loop
        super().__init__(event_loop, _message_cb)

    @property
    def _msgpack_stream(self):
        return self.loop

    @_msgpack_stream.setter
    def _set_msgpack_stream(self, value):
        if isinstance(self.loop, asyncio.BaseEventLoop):
            asyncio.set_event_loop(value)
        else:
            # todo:
            self.loop = value

    def request(self, method, args, response_cb):
        """Send a msgpack-rpc request to Nvim.

        A msgpack-rpc with method `method` and argument `args` is sent to
        Nvim. The `response_cb` function is called with when the response
        is available.
        """
        request_id = self._next_request_id
        self._msgpack_stream.send([0, request_id, method, args])
        self._pending_requests[request_id] = response_cb
        self._next_request_id += 1

    def notify(self, method, args):
        """Send a msgpack-rpc notification to Nvim.

        A msgpack-rpc with method `method` and argument `args` is sent to
        Nvim. This will have the same effect as a request, but no response
        will be recieved
        """
        self._msgpack_stream.send([2, method, args])

    def run(self, request_cb, notification_cb):
        """Run the event loop to receive requests and notifications from Nvim.

        While the event loop is running, `request_cb` and `notification_cb`
        will be called whenever requests or notifications are respectively
        available.
        """
        self._request_cb = request_cb
        self._notification_cb = notification_cb
        self._msgpack_stream.run(self._on_message)
        self._request_cb = None
        self._notification_cb = None

    def _on_message(self, msg):
        try:
            self._handlers.get(msg[0], self._on_invalid_message)(msg)
        except Exception:
            err_str = format_exc(5)
            warn(err_str)
            # self._msgpack_stream.send([1, 0, err_str, None])
            self.send([1, 0, err_str, None])

    def _on_request(self, msg):
        """Request.

        - msg[1]: id
        - msg[2]: method name
        - msg[3]: arguments
        """
        debug("received request: %s, %s", msg[2], msg[3])
        # self._request_cb(msg[2], msg[3], Response(
        #     self._msgpack_stream, msg[1]))
        self._request_cb(msg[2], msg[3], Response(self, msg[1]))

    def _on_response(self, msg):
        """Callback upon receiving a notification.

        response to a previous request:

          - msg[1]: the id
          - msg[2]: error(if any)
          - msg[3]: result(if not errored)

        """
        debug("received response: %s, %s", msg[2], msg[3])
        self._pending_requests.pop(msg[1])(msg[2], msg[3])

    def _on_notification(self, msg):
        """Callback upon receiving a notification.

        notification/events follow the form.:

            - msg[1]: event name
            - msg[2]: arguments

        """
        debug("received notification: %s, %s", msg[1], msg[2])
        self._notification_cb(msg[1], msg[2])

    def _on_invalid_message(self, msg):
        error = "Received invalid message %s" % msg
        warn(error)
        self._msgpack_stream.send([1, 0, error, None])
        self.send([1, 0, error, None])


class Response(object):
    """Response to a msgpack-rpc request that came from Nvim.

    When Nvim sends a msgpack-rpc request, an instance of this class is
    created for remembering state required to send a response.
    """

    def __init__(self, msgpack_stream, request_id):
        """Initialize the Response instance."""
        self._msgpack_stream = msgpack_stream
        self._request_id = request_id

    def send(self, value, error=False):
        """Send the response.

        If `error` is True, it will be sent as an error.
        """
        if error:
            resp = [1, self._request_id, value, None]
        else:
            resp = [1, self._request_id, None, value]
        debug("sending response to request %d: %s", self._request_id, resp)
        self._msgpack_stream.send(resp)

    def __repr__(self):
        return f"{self.__class__.__name__}"


# msgpack_rpc.event_loop.base:

if os.name.startswith("Win"):

    class _PlatformSpecificLoop(asyncio.ProactorEventLoop, asyncio.SubprocessProtocol):
        pass


else:

    class _PlatformSpecificLoop(asyncio.SelectorEventLoop, asyncio.SubprocessProtocol):
        pass


class BaseEventLoop(_PlatformSpecificLoop):
    """Abstract base class for all event loops.

    Event loops act as the bottom layer for Nvim sessions created by this
    library. They hide system/transport details behind a simple interface for
    reading/writing bytes to the connected Nvim instance.

    This class exposes public methods for interacting with the underlying
    event loop and delegates implementation-specific work to the following
    methods, which subclasses are expected to implement. Note that there
    is no mechanism to enforce this is suggestion; however.:

    - `_init()`: Implementation-specific initialization

    - `_connect_tcp(address, port)`: connect to Nvim using tcp/ip
    - `_connect_socket(path)`: Same as tcp, but use a UNIX domain socket or
      named pipe.

    - `_connect_stdio()`: Use stdin/stdout as the connection to Nvim
    - `_connect_child(argv)`: Use the argument vector `argv` to spawn an
      embedded Nvim that has its stdin/stdout connected to the event loop.

    - `_start_reading()`: Called after any of _connect_* methods. Can be used
      to perform any post-connection setup or validation.

    - `_send(data)`: Send `data`(byte array) to Nvim. The data is only
    - `_run()`: Runs the event loop until stopped or the connection is closed.
      calling the following methods when some event happens:
      actually sent when the event loop is running.

    - `_on_data(data)`: When Nvim sends some data.
    - `_on_signal(signum)`: When a signal is received.
    - `_on_error(message)`: When a non-recoverable error occurs(eg:
       connection lost)

    - `_stop()`: Stop the event loop
    - `_interrupt(data)`: Like `stop()`, but may be called from other threads
      this.

    - `_setup_signals(signals)`: Add implementation-specific listeners for
      for `signals`, which is a list of OS-specific signal numbers.
    - `_teardown_signals()`: Removes signal listeners set by `_setup_signals`


    .. versionchanged:: Now officially subclasses asyncio.base_events.

    """

    def __init__(self, transport_type, *args):
        """Initialize and connect the event loop instance.

        The only arguments are the transport type and transport-specific
        configuration, like this:

        >>> BaseEventLoop('tcp', '127.0.0.1', 7450)
        BaseEventLoop

        >>> BaseEventLoop('socket', '/tmp/nvim-socket')
        BaseEventLoop

        >>> BaseEventLoop('stdio')
        BaseEventLoop

        >>> BaseEventLoop('child', ['nvim', '--embed', '--headless', '-u', 'NONE'])
        BaseEventLoop

        This calls the implementation-specific initialization
        `_init`, one of the `_connect_*` methods(based on `transport_type`)
        and `_start_reading()`
        """
        # super().__init__()
        if transport_type is None:
            transport_type = "socket"
        self._transport_type = transport_type
        self._signames = dict(
            (k, v) for v, k in signal.__dict__.items() if v.startswith("SIG")
        )
        self._on_data = None
        self._error = None
        self._closed = True
        try:
            getattr(self, "_connect_{}".format(transport_type))(*args)
        except Exception as e:
            self.close()
            raise e
        self._start_reading()

    @abc.abstractmethod
    def _init(self):
        raise NotImplementedError

    def connect_tcp(self, address, port):
        """Connect to tcp/ip `address`:`port`. Delegated to `_connect_tcp`."""
        info("Connecting to TCP address: %s:%d", address, port)
        self._connect_tcp(address, port)

    def connect_socket(self, path):
        """Connect to socket at `path`. Delegated to `_connect_socket`."""
        info("Connecting to %s", path)
        self._connect_socket(path)

    def connect_stdio(self):
        """Connect using stdin/stdout. Delegated to `_connect_stdio`."""
        info("Preparing stdin/stdout for streaming data")
        self._connect_stdio()

    def connect_child(self, argv):
        """Connect a new Nvim instance. Delegated to `_connect_child`."""
        info("Spawning a new nvim instance")
        self._connect_child(argv)

    def send(self, data):
        """Queue `data` for sending to Nvim."""
        debug("Sending '%s'", data)
        self._send(data)

    def threadsafe_call(self, fn):
        """Call a function in the event loop thread.

        This is the only safe way to interact with a session from other
        threads.
        """
        self._threadsafe_call(fn)

    def run(self, data_cb):
        """Run the event loop."""
        if self._error:
            err = self._error
            if isinstance(self._error, KeyboardInterrupt):
                # KeyboardInterrupt is not destructive(it may be used in
                # the REPL).
                # After throwing KeyboardInterrupt, cleanup the _error field
                # so the loop may be started again
                self._error = None
            raise err
        self._on_data = data_cb
        if threading.current_thread() == main_thread:
            self._setup_signals([signal.SIGINT, signal.SIGTERM])
        debug("Entering event loop")
        self._run()
        debug("Exited event loop")
        if threading.current_thread() == main_thread:
            self._teardown_signals()
            signal.signal(signal.SIGINT, signal.getsignal(signal.SIGINT))
        self._on_data = None

    def stop(self):
        """Stop the event loop."""
        self._stop()
        debug("Stopped event loop")

    def close(self):
        """Stop the event loop."""
        self._close()
        debug("Closed event loop")

    def _on_signal(self, signum):
        msg = "Received {}".format(self._signames[signum])
        debug(msg)
        if signum == signal.SIGINT and self._transport_type == "stdio":
            # When the transport is stdio, we are probably running as a Nvim
            # child process. In that case, we don't want to be killed by
            # ctrl+C
            return
        cls = Exception
        if signum == signal.SIGINT:
            cls = KeyboardInterrupt
        self._error = cls(msg)
        self.stop()

    def _on_error(self, *exc_info):
        """Handle errors raised by the host Neovim process.

        Notes
        -----
        Exception handlers are supposed to accept a tuple of 3 elements as per sys.exc_info.

        Parameters
        ----------
        exc_info : tuple, optional
            Exception info of the form (exception_type, exception_value, types.Traceback)

        """
        debug(*exc_info)
        self._error = OSError(*exc_info)
        self.stop()

    def _on_interrupt(self):
        self.stop()

    def __repr__(self):
        return f"{self.__class__.__name__}"

    @abc.abstractmethod
    def _start_reading(self):
        pass

    def _close(self):
        pass

    def _teardown_signals(self):
        pass

    def _setup_signals(self, param):
        pass

    def _stop(self):
        pass

    def _run(self):
        pass

    def _threadsafe_call(self, fn):
        pass

    def _connect_child(self, argv):
        pass

    def _connect_tcp(self, address, port):
        pass

    def _connect_socket(self, path):
        pass

    def _connect_stdio(self):
        pass

    def _send(self, data):
        pass

    @classmethod
    def register(self, other):
        pass


# mspack_rpc.event_loop.asyncio:

# Triple subclassed?


class AsyncioEventLoop(BaseEventLoop, asyncio.SubprocessProtocol, asyncio.Protocol):
    """`BaseEventLoopABC` subclass that uses `asyncio` as a backend.

    On Windows use ProactorEventLoop which support pipes and is backed by the
    more powerful IOCP facility

    .. note::
        We override in the stdio case, because it doesn't work.

    Attributes
    ----------
    _fact : asyncio.Protocol factory.
        Review the `asyncio.events.EventLoop.subprocess_exec`.

    """

    _closed = False

    _fact = None  # TODO

    if os.name == "nt":
        # On windows use ProactorEventLoop which support pipes and is backed by the
        # more powerful IOCP facility
        # NOTE: we override in the stdio case, because it doesn't work.
        loop_cls = asyncio.ProactorEventLoop
    else:
        loop_cls = asyncio.SelectorEventLoop


class AsyncioBaseEventLoop(BaseEventLoop, asyncio.Protocol):
    pass


class AsyncioEventLoop(AsyncioBaseEventLoop):
    """`BaseEventLoop` subclass that uses `asyncio` as a backend.

    On our use of Transports.

    Transport(extra=None)

    Interface representing a bidirectional transport.

    There may be several implementations, but typically, the user does
    not implement new transports; rather, the platform provides some
    useful transports that are implemented using the platform's best
    practices.

    The user never instantiates a transport directly; they call a
    utility function, passing it a protocol factory and other
    information necessary to create the transport and protocol.  (E.g.
    EventLoop.create_connection() or EventLoop.create_server().)

    The utility function will asynchronously create a transport and a
    protocol and hook them up by calling the protocol's
    connection_made() method, passing it the transport.

    """

    _queued_data = deque()
    _raw_transport = None
    _local = threading.local
    _closed = False

    def __init__(
        self, path=None, argv=None, stdio=False, transport_type=None, **kwargs
    ):
        """Used to signal `asyncio.Protocol` of a successful connection.

        .. attention::
            **Breaking Change!**
            No longer takes transport_type as an arg.
            Now simply proxies the functions that generate transports I.E.

        Examples
        --------
        >>> import os
        >>> loop = AsyncioEventLoop(path=os.environ.get('NVIM_LISTEN_ADDRESS'))
        >>> loop = AsyncioEventLoop(argv=[])
        >>> loop = AsyncioEventLoop(stdio=True)

        """
        self.loop_policy = get_event_loop_policy()
        self._local = self.loop_policy._local
        self._watcher = self.loop_policy._watcher
        try:
            self._loop = self.loop_policy.get_event_loop()
        except RuntimeError:
            self._loop = self.loop_policy.new_event_loop()
        self._raw_transport = transport_type
        if isinstance(transport_type, asyncio.SubprocessTransport):
            self._transport = transport_type.get_pipe_transport(0)
        # elif isinstance(transport_type, str):
        # So this really needs to stop happening
        # raise ⁿiipTypeError
        else:
            # TODO: this is wrong.
            self._transport = transport_type
        self._fact = lambda: self
        # have this initialized for teardown
        self._signals = []  # type: List[signal.signal]
        super().__init__(transport_type)

    # @property
    def _fact(self):
        return self

    # literally where in the code base did these get used?
    # @property
    # def reader(self):
    #     return StreamReader(loop=self._loop)

    # @property
    # def writer(self):
    #     return StreamWriter  # todo

    def connection_lost(self, exc, *args):
        """Signals to `asyncio.Protocol` of a lost connection."""
        self._on_error(exc.args[0] if exc else "EOF")
        super().connection_lost(exc)
        try:
            return sys._last_frame
        except AttributeError:
            pass

    pipe_connection_lost = connection_lost

    def data_received(self, data):
        """Used to signal `asyncio.Protocol` of incoming data."""
        if self._on_data:
            self._on_data(data)
            return
        self._queued_data.append(data)

    def pipe_connection_lost(self, fd, exc):
        """Used to signal `asyncio.SubprocessProtocol` of a lost connection."""
        self._on_error(exc.args[0] if exc else "EOF")

    def pipe_data_received(self, fd, data):
        """Used to signal `asyncio.SubprocessProtocol` of incoming data."""
        if fd == 2:  # stderr fd number
            self._on_stderr(data)
        elif self._on_data:
            self._on_data(data)
        else:
            self._queued_data.append(data)

    def process_exited(self):
        """Used to signal `asyncio.SubprocessProtocol` when the child exits.

        Typically represents an `EOFError`.
        Analagous to the :meth:`asyncio.Transport.eof_received`
        """
        self._on_error("EOF")

    eof_received = process_exited

    def _init(self):
        pass

    def _connect_tcp(self, address, port):
        coroutine = self._loop.create_connection(self._fact, address, port)
        self._loop.run_until_complete(coroutine)

    def _connect_socket(self, path):
        if os.name == "nt":
            coroutine = self._loop.create_pipe_connection(self._fact, path)
        else:
            coroutine = self._loop.create_unix_connection(self._fact, path)
        self._loop.run_until_complete(coroutine)

    def _connect_stdio(self):
        if os.name == "nt":
            from asyncio.windows_utils import PipeHandle
            import msvcrt

            pipe = PipeHandle(msvcrt.get_osfhandle(sys.stdin.fileno()))
        else:
            pipe = sys.stdin
        coroutine = self._loop.connect_read_pipe(self._fact, pipe)
        self._loop.run_until_complete(coroutine)
        debug("native stdin connection successful")

        # Make sure subprocesses don't clobber stdout,
        # send the output to stderr instead.
        rename_stdout = os.dup(sys.stdout.fileno())
        os.dup2(sys.stderr.fileno(), sys.stdout.fileno())

        if os.name == "nt":
            pipe = PipeHandle(msvcrt.get_osfhandle(rename_stdout))
        else:
            pipe = os.fdopen(rename_stdout, "wb")
        coroutine = self._loop.connect_write_pipe(self._fact, pipe)
        self._loop.run_until_complete(coroutine)
        debug("native stdout connection successful")

    def _connect_child(self, argv):
        """Connect to Nvim using the 'child' method of attach.

        Internally, uses asyncio subprocesses. At this time, the default
        Windows default EventLoop does **NOT** support shelling out.

        :param argv: Args to pass to the loop's :meth:`subprocess_exec`.
        """
        # TODO: is this still unsupported on NT?
        if os.name != "nt":
            self._child_watcher = asyncio.get_child_watcher()
            self._child_watcher.attach_loop(self._loop)
        coroutine = self._loop.subprocess_exec(self._fact, *argv)
        # so lookin at this stack traces we should have DEFINITEly started
        # using the await keyword. this function starts calling async def funcs
        self._loop.run_until_complete(coroutine)

    def _start_reading(self):
        pass

    def _send(self, data):
        self._transport.write(data)

    def _run(self):
        while self._queued_data:
            self._on_data(self._queued_data.popleft())
        self._loop.run_forever()

    def _stop(self):
        self._loop.stop()

    def _close(self):
        if self._raw_transport is not None:
            self._raw_transport.close()
        self._loop.close()

    def _threadsafe_call(self, fn):
        self._loop.call_soon_threadsafe(fn)

    def _setup_signals(self, signals):
        if os.name == "nt":
            # add_signal_handler is not supported in win32
            self._signals = []
            return

        self._signals = list(signals)
        for signum in self._signals:
            self._loop.add_signal_handler(signum, self._on_signal, signum)

    def _teardown_signals(self):
        for signum in self._signals:
            self._loop.remove_signal_handler(signum)

    def __repr__(self):
        return f"{self.__class__.__name__}"

    def _on_stderr(self, data):
        pass


# msgpack.__init__:
# Keep below asyncio mod


def session(transport_type="stdio", *args, **kwargs) -> Session:
    """Msgpack-rpc subpackage.

    This package implements a msgpack-rpc client. While it was designed for
    handling some Nvim particularities(server->client requests for example), the
    code here should work with other msgpack-rpc servers.
    """
    try:
        loop = asyncio.get_event_loop()
    except RuntimeError:
        loop_policy = get_event_loop_policy()
        loop = loop_policy.get_event_loop()
    msgpack_stream = MsgpackStream(loop, *args, **kwargs)
    async_session = AsyncSession(msgpack_stream)
    _session = Session(async_session)
    _session.request(
        b"nvim_set_client_info", *get_client_info("client", "remote", {}), async_=True
    )
    return _session


def tcp_session(address, port=7450):
    """Create a msgpack-rpc session from a tcp address/port."""
    return session("tcp", address, port)


def socket_session(path: Optional[Union[os.PathLike, pathlib.Path, AnyStr]] = None):
    """Create a msgpack-rpc session from a unix domain socket."""
    if path is None:
        try:
            path = os.environ.get("NVIM_LISTEN_ADDRESS")
        except OSError:
            raise
    return session("socket", path)


def stdio_session(*args: list, **kwargs: dict) -> Session:
    """Create a msgpack-rpc session from stdin/stdout."""
    return session("stdio", *args, **kwargs)


def child_session(argv=None):
    """Create a msgpack-rpc session from a new Nvim instance."""
    return session("child", argv)


# api.window:


class Window(Remote):
    """A remote Nvim window."""

    _api_prefix = "nvim_win_"

    @property
    def buffer(self):
        """Get the `Buffer` currently being displayed by the window."""
        return self.request("nvim_win_get_buf")

    @property
    def cursor(self):
        """Get the (row, col) tuple with the current cursor position."""
        return self.request("nvim_win_get_cursor")

    @cursor.setter
    def cursor(self, pos):
        """Set the (row, col) tuple as the new cursor position.

        Parameters
        ----------
        pos :
        """
        self.request("nvim_win_set_cursor", pos)

    @property
    def height(self):
        """Get the window height in rows."""
        return self.request("nvim_win_get_height")

    @height.setter
    def height(self, height):
        """Set the window height in rows."""
        self.request("nvim_win_set_height", height)

    @property
    def width(self):
        """Get the window width in rows."""
        return self.request("nvim_win_get_width")

    @width.setter
    def width(self, width: object) -> object:
        """Set the window height in rows."""
        self.request("nvim_win_set_width", width)

    @property
    def row(self):
        """0-indexed, on-screen window position(row) in display cells."""
        return self.request("nvim_win_get_position")[0]

    @property
    def col(self):
        """0-indexed, on-screen window position(col) in display cells."""
        return self.request("nvim_win_get_position")[1]

    @property
    def tabpage(self):
        """Get the `Tabpage` that contains the window."""
        return self.request("nvim_win_get_tabpage")

    @property
    def valid(self):
        """Return True if the window still exists."""
        return self.request("nvim_win_is_valid")

    @property
    def number(self):
        """Get the window number."""
        return self.request("nvim_win_get_number")

    def __repr__(self):
        return f"{self.__class__.__name__}"


# api.tabpage:
class Tabpage(Remote):
    """A remote Nvim tabpage."""

    _api_prefix = "nvim_tabpage_"

    def __init__(self, *args):
        """Initialize from session and code_data immutable object.

        The `code_data` contains serialization information required for
        msgpack-rpc calls. It must be immutable for Buffer equality to work.
        """
        super(Tabpage, self).__init__(*args)
        self.windows = RemoteSequence(self, "nvim_tabpage_list_wins")

    @property
    def window(self):
        """Get the `Window` currently focused on the tabpage."""
        return self.request("nvim_tabpage_get_win")

    @property
    def valid(self):
        """Return True if the tabpage still exists."""
        return self.request("nvim_tabpage_is_valid")

    @property
    def number(self):
        """Get the tabpage number."""
        return self.request("nvim_tabpage_get_number")

    def __repr__(self):
        return f"{self.__class__.__name__}"


# plugin/host:


class Host:
    """Nvim host for python plugins.

    Takes care of loading/unloading plugins and routing msgpack-rpc
    requests/notifications to the appropriate handlers.
    """

    _specs: Optional[Dict[Any, Any]]
    _loaded: Optional[Dict[Any, Any]]

    def __init__(self, nvim, **kwargs):
        """Set handlers for plugin_load/plugin_unload.

        Parameters
        ----------
        _specs: dict
            No idea what the dict should be.

        """
        self.nvim = nvim
        if kwargs.pop("_specs"):
            self._specs = kwargs.pop("_specs")
        else:
            self._specs = {}
        self._loaded = {}
        self._load_errors = {}
        self._notification_handlers = {"nvim_error_event": self._on_error_event}
        self._request_handlers = {
            "poll": lambda: "ok",
            "specs": self._on_specs_request,
            "shutdown": self.shutdown,
        }
        self.handler = self._notification_handlers.get(name, None)

        # Decode per default for Python3
        # self._decode_default = IS_PYTHON3
        self._decode_default = True

    def _on_async_err(self, msg):
        # uncaught python exception
        self.nvim.err_write(msg, async_=True)

    def _on_error_event(self, kind, msg):
        """Error from nvim due to async request."""
        # like nvim.command(..., async_=True)
        errmsg = (
            f"{self.name}: Async request caused an error:\nKind: {kind}\nMsg: {msg}\n"
        )
        self.nvim.err_write(errmsg, async_=True)
        return errmsg

    def start(self, plugins):
        """Start listening for msgpack-rpc requests and notifications."""
        self.nvim.run_loop(
            self._on_request,
            self._on_notification,
            lambda: self._load(plugins),
            err_cb=self._on_async_err,
        )

    def shutdown(self):
        """Shutdown the host."""
        self._unload()
        self.nvim.stop_loop()

    def _wrap_delayed_function(
        self, cls, delayed_handlers, name, sync, module_handlers, path, *args
    ):
        # delete the delayed handlers to be sure
        for handler in delayed_handlers:
            method_name = handler._nvim_registered_name
            if handler._nvim_rpc_sync:
                del self._request_handlers[method_name]
            else:
                del self._notification_handlers[method_name]
        # create an instance of the plugin and pass the nvim object
        plugin = cls(self._configure_nvim_for(cls))

        # discover handlers in the plugin instance
        self._discover_functions(plugin, module_handlers, path, False)

        if sync:
            self._request_handlers[name](*args)
        else:
            self._notification_handlers[name](*args)

    def _wrap_function(self, fn, sync, name, *args, nvim_bind=None):
        # if decode:
        #     args = walk(decode_if_bytes, args, decode)
        if nvim_bind is not None:
            args.insert(0, nvim_bind)
        try:
            return fn(*args)
        except Exception:
            if sync:
                msg = "error caught in request handler '{} {}':\n{}".format(
                    name, args, format_exc_skip(1)
                )
                raise ErrorResponse(msg)
            else:
                msg = "error caught in async handler '{} {}'\n{}\n".format(
                    name, args, format_exc_skip(1)
                )
                self._on_async_err(msg + "\n")

    def _on_request(self, name, args):
        """Handle a msgpack-rpc request."""
        # if IS_PYTHON3:
        #     name = decode_if_bytes(name)
        handler = self._request_handlers.get(name, None)
        if not handler:
            msg = self._missing_handler_error(name, "request")
            error(msg)
            raise ErrorResponse(msg)
        debug('calling request handler for "%s", args: "%s"', name, args)
        rv = handler(*args)
        debug("request handler for '%s %s' returns: %s", name, args, rv)
        return rv

    def _on_notification(self, name, args):
        """Handle a msgpack-rpc notification."""
        # if IS_PYTHON3:
        #     name = decode_if_bytes(name)
        if not handler:
            msg = self._missing_handler_error(name, "notification")
            error(msg)
            self._on_async_err(msg + "\n")
            return

        debug('calling notification handler for "%s", args: "%s"', name, args)
        handler(*args)

    def _missing_handler_error(self, name, kind):
        msg = 'no {} handler registered for "{}"'.format(kind, name)
        pathmatch = re.match(r"(.+):[^:]+:[^:]+", name)
        if pathmatch:
            loader_error = self._load_errors.get(pathmatch.group(1))
            if loader_error is not None:
                msg = msg + "\n" + loader_error
        return msg

    def _load_plugin(self, plugin):
        if plugin == "script_host.py":
            from pynvim.plugin import script_host

            module = script_host
            has_script = True
        else:
            import importlib

            directory, name = os.path.split(os.path.splitext(path)[0])
            file, pathname, descr = find_module(name, [directory])
            try:
                module = importlib.import_module(name, file, pathname, descr)
            except ImportError:
                return
        handlers = []
        self._discover_classes(module, handlers, path)
        self._discover_functions(module, handlers, path, False)
        if not handlers:
            error("{} exports no handlers".format(path))
        self._loaded[path] = {"handlers": handlers, "module": module}

    def _load(self, plugins: List):
        has_script = False
        for path in plugins:
            err = None
            if path in self._loaded:
                error("{} is already loaded".format(path))
                continue
            try:
                loaded = self.load_plugin(path)
            except Exception as e:
                err = "Encountered {} loading plugin at {}: {}\n{}".format(
                    type(e).__name__, path, e, format_exc(5)
                )
                error(err)
                self._load_errors[path] = err

        kind = "script-host" if len(plugins) == 1 and has_script else "rplugin-host"
        info = get_client_info(kind, "host", host_method_spec)
        self.name = info[0]
        self.nvim.api.set_client_info(*info, async_=True)

    def _unload(self):
        for path, plugin in self._loaded.items():
            handlers = plugin["handlers"]
            for handler in handlers:
                method_name = handler._nvim_registered_name
                if hasattr(handler, "_nvim_shutdown_hook"):
                    handler()
                elif handler._nvim_rpc_sync:
                    del self._request_handlers[method_name]
                else:
                    del self._notification_handlers[method_name]
        self._specs = {}
        self._loaded = {}

    def _discover_classes(self, module, handlers, plugin_path):
        for _, cls in inspect.getmembers(module, inspect.isclass):
            if getattr(cls, "_nvim_plugin", False):
                # discover handlers in the plugin instance
                self._discover_functions(cls, handlers, plugin_path, True)

    def _discover_functions(self, obj, handlers, plugin_path, delay):
        def predicate(o):
            return hasattr(o, "_nvim_rpc_method_name")

        cls_handlers = []
        specs = []
        objdecode = getattr(obj, "_nvim_decode", self._decode_default)
        for _, fn in inspect.getmembers(obj, predicate):
            method = fn._nvim_rpc_method_name
            if fn._nvim_prefix_plugin_path:
                method = "{}:{}".format(plugin_path, method)
            sync = fn._nvim_rpc_sync
            if delay:
                fn_wrapped = partial(
                    self._wrap_delayed_function,
                    obj,
                    cls_handlers,
                    method,
                    sync,
                    handlers,
                    plugin_path,
                )
            else:
                decode = getattr(fn, "_nvim_decode", objdecode)
                nvim_bind = None
                if fn._nvim_bind:
                    nvim_bind = self._configure_nvim_for(fn)

                fn_wrapped = partial(
                    self._wrap_function, fn, sync, decode, nvim_bind, method
                )
            self._copy_attributes(fn, fn_wrapped)
            fn_wrapped._nvim_registered_name = method
            # register in the rpc handler dict
            if sync:
                if method in self._request_handlers:
                    raise Exception(
                        ('Request handler for "{}" is ' + "already registered").format(
                            method
                        )
                    )
                self._request_handlers[method] = fn_wrapped
            else:
                if method in self._notification_handlers:
                    raise Exception(
                        f'Notification handler for "{method}" is already registered'
                    )
                self._notification_handlers[method] = fn_wrapped
            if hasattr(fn, "_nvim_rpc_spec"):
                specs.append(fn._nvim_rpc_spec)
            handlers.append(fn_wrapped)
            cls_handlers.append(fn_wrapped)
        if specs:
            self._specs[plugin_path] = specs

    def _copy_attributes(self, fn, fn2):
        # Copy _nvim_* attributes from the original function
        for attr in dir(fn):
            if attr.startswith("_nvim_"):
                setattr(fn2, attr, getattr(fn, attr))

    def _on_specs_request(self, path):
        # if IS_PYTHON3:
        #     path = decode_if_bytes(path)
        if path in self._load_errors:
            self.nvim.out_write(self._load_errors[path] + "\n")
        return self._specs.get(path, 0)

    def _configure_nvim_for(self, obj):
        """Configure a nvim instance for obj (checks encoding configuration)."""
        nvim = self.nvim
        decode = getattr(obj, "_nvim_decode", self._decode_default)
        if decode:
            nvim = nvim.with_decode(decode)
        return nvim


# msgpack_rpc.event_loop.pyuv:


class UvEventLoop(BaseEventLoop):
    """`BaseEventLoop` subclass that uses `pvuv` as a backend.

    Concrete implementation of the abstract EventLoop class.
    Also wanted to note. Should we make the connect_tcp,
    connect_stdio, and connect_child methods classmethods?

    Attributes
    ----------
    transport_type : str

    """

    try:
        import pyuv  # noqa
    except ImportError:
        # warnings.warn("pyuv not installed!")
        pyuv = None

    _connection_error = None
    _callbacks = deque()
    _error_stream = None
    _closed = False

    def _init(self, transport_type=None, *args, **kwargs):
        self._loop = pyuv.Loop.default_loop()
        sys.excepthook = self._loop.eventhook
        self._async = pyuv.Async(self._loop, self._on_async)
        self._connection_error = None
        self._error_stream = None
        self._callbacks = deque()
        # kinda cant call this for the time being. whats the transport
        # type to pass to super?
        # super().__init__(*args)

    def __repr__(self):
        return f"{self.__class__.__name__}"

    def _on_connect(self, stream, error):
        self.stop()
        if error:
            msg = "Cannot connect to {}: {}".format(
                self._connect_address, pyuv.errno.strerror(error)
            )
            self._connection_error = OSError(msg)
            return
        self._read_stream = self._write_stream = stream

    def _on_read(self, handle, data, error):
        if error or not data:
            msg = pyuv.errno.strerror(error) if error else "EOF"
            self._on_error(msg)
            return
        if handle == self._error_stream:
            return
        self._on_data(data)

    def _on_write(self, handle, error):
        if error:
            msg = pyuv.errno.strerror(error)
            self._on_error(msg)

    def _on_exit(self, handle, exit_status, term_signal):
        self._on_error("EOF")

    def _disconnected(self, *args):
        raise OSError("Not connected to Nvim")

    def _connect_tcp(self, address, port):
        stream = pyuv.TCP(self._loop)
        self._connect_address = "{}:{}".format(address, port)
        stream.connect((address, port), self._on_connect)

    def _connect_socket(self, path):
        stream = pyuv.Pipe(self._loop)
        self._connect_address = path
        stream.connect(path, self._on_connect)

    def _connect_stdio(self):
        self._read_stream = pyuv.Pipe(self._loop)
        self._read_stream.open(sys.stdin.fileno())
        self._write_stream = pyuv.Pipe(self._loop)
        self._write_stream.open(sys.stdout.fileno())

    def _connect_child(self, argv):
        self._write_stream = pyuv.Pipe(self._loop)
        self._read_stream = pyuv.Pipe(self._loop)
        self._error_stream = pyuv.Pipe(self._loop)
        stdin = pyuv.StdIO(
            self._write_stream, flags=pyuv.UV_CREATE_PIPE + pyuv.UV_READABLE_PIPE
        )
        stdout = pyuv.StdIO(
            self._read_stream, flags=pyuv.UV_CREATE_PIPE + pyuv.UV_WRITABLE_PIPE
        )
        stderr = pyuv.StdIO(
            self._error_stream, flags=pyuv.UV_CREATE_PIPE + pyuv.UV_WRITABLE_PIPE
        )
        pyuv.Process.spawn(
            self._loop,
            args=argv,
            exit_callback=self._on_exit,
            flags=pyuv.UV_PROCESS_WINDOWS_HIDE,
            stdio=(stdin, stdout, stderr,),
        )
        self._error_stream.start_read(self._on_read)

    def _start_reading(self):
        # where else is transport  type defined in this class?
        if self._transport_type in ["tcp", "socket"]:
            self._loop.run()
            if self._connection_error:
                self.run = self.send = self._disconnected
                raise self._connection_error
        self._read_stream.start_read(self._on_read)

    def _send(self, data):
        self._write_stream.write(data, self._on_write)

    def _run(self):
        self._loop.run(pyuv.UV_RUN_DEFAULT)

    def _stop(self):
        self._loop.stop()

    def _close(self):
        pass

    def _threadsafe_call(self, fn):
        self._callbacks.append(fn)
        self._async.send()

    def _on_async(self, handle):
        while self._callbacks:
            self._callbacks.popleft()()

    def _setup_signals(self, signals):
        self._signal_handles = []

        def handler(h, signum):
            self._on_signal(signum)

        for signum in signals:
            handle = pyuv.Signal(self._loop)
            handle.start(handler, signum)
            self._signal_handles.append(handle)

    def _teardown_signals(self):
        for handle in self._signal_handles:
            handle.stop()


EventLoop = UvEventLoop


import gc  # noqa

gc.collect()

if __name__ == "__main__":
    from py._path.local import LocalPath

    # f = LocalPath(os.path.abspath(__file__))
    # f.pyimport()

# Vim: set fdm=indent fdls=0:
