#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Code shared between the API classes.  # {{{

The condensed pynvim API
=========================

Summary
-------

Combine the modules in the pynvim package into 1 file.
This runs almost entirely by itself. Run.::

    :py3f %

On the Vim ex line to verify. Still currently depends on pynvim.msgpack_rpc because it's a saturday
afternoon and I don't feel like it.

Extended Summary
----------------

#) Actually not in pynvim but a `get_documentation` function I always find useful.

#) __init__ : Can't believe I forgot this one

#) pynvim/util because that has no internal dependencies.

#) then compat

#) Then plugin/decorators.

#) api/nvim

#) plugin/scripthost

#) api/buffers

#) msgpack_rpc.__init__

#) api/common

#) msgpack_rpc.session

#) msgpack_rpc.async_session

#) msgpack_rpc.msgpack_stream

Notes
-----

Remote got pushed way up out of API/common because it's invoked a handful of
times before then.

Decorators used by python host plugin system.

"""
# import abc
import greenlet
from msgpack import unpackb, ExtType, Packer, Unpacker
import pkg_resources
import asyncio
import codecs
import cgitb
import functools
import gc
import imp
import importlib
import inspect
import io
import logging
import os
import platform
import pydoc
import reprlib
import signal

# import shlex
# import subprocess
import sys
import traceback
import threading
import warnings
from collections import namedtuple, UserList, deque
from imp import find_module as original_find_module
from io import StringIO

# from pathlib import Path
from pydoc import safeimport
from traceback import format_exception, format_stack, format_exc

if sys.version_info >= (3, 4):
    from importlib.machinery import PathFinder
else:
    PathFinder = None


try:
    import pyuv  # noqa
except ImportError:
    from pynvim.msgpack_rpc.event_loop import EventLoop
else:
    from pynvim.msgpack_rpc.event_loop.uv import UvEventLoop as EventLoop


# }}}

# Globals: {{{
global vim
basestring = str
# So on the low I don't think that logger or debug are used anywhere.
logger = logging.getLogger(__name__)
debug, info, warn, error = (
    logger.debug,
    logger.info,
    logger.warning,
    logger.error,
)

logger.setLevel(logging.WARNING)
handler = logging.StreamHandler()
handler.setLevel(logging.WARNING)
filterer = logging.Filter(name=__name__)
logger.addHandler(handler)
logger.addFilter(filterer)

# There is no 'long' type in Python3 just int
long = int
unicode_errors_default = "surrogateescape"
vers = namedtuple("vers", ("project", "release"))
mod_cache = {}

# so thats how you do this
distribution = pkg_resources.get_distribution("pynvim")
__version__ = distribution.version

os_chdir = os.chdir

lua_module = """
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

loop_cls = asyncio.SelectorEventLoop
if os.name == "nt":
    from asyncio.windows_utils import PipeHandle
    import msvcrt

    # On windows use ProactorEventLoop which support pipes and is backed by the
    # more powerful IOCP facility
    # NOTE: we override in the stdio case, because it doesn't work.
    loop_cls = asyncio.ProactorEventLoop


# }}}

# Pynvim __init__: {{{


def start_host(session=None):
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
    """
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

    if not session:
        session = stdio_session()
    nvim = Nvim.from_session(session)

    if nvim.version.api_level < 1:
        sys.stderr.write("This version of pynvim " "requires nvim 0.1.6 or later")
        sys.exit(1)

    host = Host(nvim)
    host.start(plugins)


def attach(session_type, address=None, port=None, path=None, argv=None, decode=None):
    """Provide a nicer interface to create python api sessions.

    Previous machinery to create python api sessions is still there. This only
    creates a facade function to make things easier for the most usual cases.
    Thus, instead of:
        from pynvim import socket_session, Nvim
        session = tcp_session(address=<address>, port=<port>)
        nvim = Nvim.from_session(session)
    You can now do:
        from pynvim import attach
        nvim = attach('tcp', address=<address>, port=<port>)
    And also:
        nvim = attach('socket', path=<path>)
        nvim = attach('child', argv=<argv>)
        nvim = attach('stdio')

    When the session is not needed anymore, it is recommended to explicitly
    close it:
       nvim.close()
    It is also possible to use the session as a context mangager:
       with attach('socket', path=thepath) as nvim:
           print(nvim.funcs.getpid())
           print(nvim.current.line)
    This will automatically close the session when you're done with it, or
    when an error occured.


    """
    session = (
        tcp_session(address, port)
        if session_type == "tcp"
        else socket_session(path)
        if session_type == "socket"
        else stdio_session()
        if session_type == "stdio"
        else child_session(argv)
        if session_type == "child"
        else None
    )

    if not session:
        raise Exception('Unknown session type "%s"' % session_type)

    return Nvim.from_session(session).with_decode(decode)


def setup_logging(name):
    """Setup logging according to environment variables."""
    logger = logging.getLogger(__name__)
    if "NVIM_PYTHON_LOG_FILE" in os.environ:
        prefix = os.environ["NVIM_PYTHON_LOG_FILE"].strip()
        major_version = sys.version_info[0]
        logfile = "{}_py{}_{}".format(prefix, major_version, name)
        handler = logging.FileHandler(logfile, "w", "utf-8")
        handler.formatter = logging.Formatter(
            "%(asctime)s [%(levelname)s @ "
            "%(filename)s:%(funcName)s:%(lineno)s] %(process)s - %(message)s"
        )
        logging.root.addHandler(handler)
        level = logging.INFO
        env_log_level = os.environ.get("NVIM_PYTHON_LOG_LEVEL", None)
        if env_log_level is not None:
            lvl = getattr(logging, env_log_level.strip(), None)
            if isinstance(lvl, int):
                level = lvl
            else:
                logger.warning(
                    "Invalid NVIM_PYTHON_LOG_LEVEL: %r, using INFO.", env_log_level
                )
        logger.setLevel(level)


# Required for python 2.6
class NullHandler(logging.Handler):
    def emit(self, record):
        pass


if not logging.root.handlers:
    logging.root.addHandler(NullHandler())

# }}}

# util: {{{


def get_documentation(word):
    """Search documentation and append to current buffer."""
    # is sys.stdout needed at all below?
    sys.stdout, _ = StringIO(), sys.stdout
    try:
        pydoc.help("word")
    except AttributeError:  # maybe
        raise
    except NameError:
        try:  # this is actually how pydoc does it
            mod = safeimport(word, cache=mod_cache)
        except ImportError:
            return
        else:
            get_documentation(mod)
    sys.stdout, out = _, sys.stdout.getvalue()
    print(out)


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
    """Returns a tuple describing the client.

    But change kind to allow none because all we do is return it so whats the
    point?

    Where is this used? Im so confused by it.

    Parameters
    ----------
    type :
    method_spec :
    kind :
    """
    name = "python{}-{}".format(sys.version_info[0], kind)
    attributes = {"license": "Apache v2", "website": "github.com/neovim/pynvim"}
    return name, VERSION.__dict__, type_, method_spec, attributes


VERSION = Version(major=0, minor=4, patch=1, prerelease="")

# }}}

# compat: {{{


def get_decoded_string(encoded):
    """Decode encoded if it has the proper interface.

    Notes
    -----
    Any uses of shlex.split should also use  this function as shlex.split crashes
    when given bytes for input.

    """
    if hasattr(encoded, "decode"):
        # if this is a simple string then don't make this hard
        return codecs.decode(encoded, "utf-8")

    # But if it's a list we gotta try a little
    try:
        iter(encoded)
    except TypeError:
        return
    else:
        return [
            codecs.decode(element, "utf-8")
            for element in encoded
            if isinstance(element, bytes)
        ]


def find_module(fullname, path):
    """Compatibility wrapper for imp.find_module.

    Automatically decodes arguments of find_module, in Python3 they must be
    Unicode
    """
    if isinstance(fullname, bytes):
        fullname = get_decoded_string(fullname)
    if isinstance(path, bytes):
        path = get_decoded_string(path)
    return original_find_module(fullname, path)


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


# }}}

# plugin/decorators: {{{


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
    # @functools.wraps
    # adding wraps causes errors
    def predicate(fn):
        return hasattr(fn, "_nvim_bind")

    for _, fn in inspect.getmembers(cls, predicate):
        fn._nvim_bind = False
    return cls


def rpc_export(rpc_method_name, sync=False):
    """Export a function or plugin method as a msgpack-rpc request handler."""

    # should functools.wraps be going on top of all of these?
    @functools.wraps
    def dec(f):
        f._nvim_rpc_method_name = rpc_method_name
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = False
        return f

    return dec


def command(
    name,
    nargs=0,
    complete=None,
    range=None,
    count=None,
    bang=False,
    register=False,
    sync=False,
    allow_nested=False,
    eval=None,
):
    """Tag a function or plugin method as a Nvim command handler."""

    @functools.wraps
    def dec(f):
        f._nvim_rpc_method_name = "command:{}".format(name)
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = True

        opts = {}

        if range is not None:
            opts["range"] = "" if range is True else str(range)
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

        if eval:
            opts["eval"] = eval

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

    @functools.wraps
    def dec(f):
        f._nvim_rpc_method_name = "autocmd:{}:{}".format(name, pattern)
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = True

        opts = {"pattern": pattern}

        if eval:
            opts["eval"] = eval

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


def function(name, range=False, sync=False, allow_nested=False, eval=None):
    """Tag a function or plugin method as a Nvim function handler."""

    @functools.wraps
    def dec(f):
        f._nvim_rpc_method_name = "function:{}".format(name)
        f._nvim_rpc_sync = sync
        f._nvim_bind = True
        f._nvim_prefix_plugin_path = True

        opts = {}

        if range:
            opts["range"] = "" if range is True else str(range)

        if eval:
            opts["eval"] = eval

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

    @functools.wraps
    def _():
        f._nvim_shutdown_hook = True
        f._nvim_bind = True
        return f


def decode(mode=unicode_errors_default):
    """Configure automatic encoding/decoding of strings."""

    @functools.wraps
    def dec(f):
        f._nvim_decode = mode
        return f

    return dec


# }}}

# api/common:Remote: {{{


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


# }}}

# api/nvim: Needs to be above plugin/scripthost: {{{


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
    def from_session(cls, session):
        """Create a new Nvim instance for a Session instance.

        This method must be called to create the first Nvim instance, since it
        queries Nvim metadata for type information and sets a SessionHook for
        creating specialized objects from Nvim remote handles.
        """
        # wth is this?
        # session.error_wrapper = lambda e: NvimError(decode_if_bytes(e[1]))
        session.error_wrapper = cgitb.Hook(format="text")
        # okay so apparently we send errors  to the error wrapper incorrectly
        # because doing this raises a handful of errors
        channel_id, metadata = session.request(b"nvim_get_api_info")

        if isinstance(metadata, bytes):
            metadata = walk(codecs.decode(metadata, "utf-8"), metadata)

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

    def __init__(self, session, channel_id, metadata, types, decode=False, err_cb=None):
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
        self._err_cb = err_cb
        self._session = session
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

    @property
    def session(self):
        """The first of potentially many refactored properties."""
        return CompatibilitySession(self)

    def _from_nvim(self, obj, decode=None):
        if decode is None:
            decode = self._decode
        if type(obj) is ExtType:
            cls = self.types[obj.code]
            return cls(self, (obj.code, obj.data))
        return obj

    def _to_nvim(self, obj):
        if isinstance(obj, Remote):
            return ExtType(*obj.code_data)
        return obj

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

            vim.api.err_write('ERROR\n', async_=True)
            vim.current.buffer.api.get_mark('.')

        is equivalent to

            vim.request('nvim_err_write', 'ERROR\n', async_=True)
            vim.request('nvim_buf_get_mark', vim.current.buffer, '.')


        Normally a blocking request will be sent.  If the `async_` flag is
        present and True, a asynchronous notification is sent instead. This
        will never block, and the return value or error is ignored.
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
        if err_cb is None:
            err_cb = sys.stderr.write
        self._err_cb = err_cb

        def filter_request_cb(name, args):
            name = self._from_nvim(name)
            args = walk(self._from_nvim, args)
            try:
                result = request_cb(name, args)
            except Exception:
                msg = "error caught in request handler '{} {}'\n{}\n\n".format(
                    name, args, format_exc_skip(1)
                )
                self._err_cb(msg)
                raise
            return walk(self._to_nvim, result)

        def filter_notification_cb(name, args):
            name = self._from_nvim(name)
            args = walk(self._from_nvim, args)
            try:
                notification_cb(name, args)
            except Exception:
                msg = "error caught in notification handler '{} {}'\n{}\n\n".format(
                    name, args, format_exc_skip(1)
                )
                self._err_cb(msg)
                raise

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

    def with_decode(self, decode=True):
        """Initialize a new Nvim instance.

        Uhhhh this was definitely intended to be a classmethod right?
        """
        return Nvim(
            self._session,
            self.channel_id,
            self.metadata,
            self.types,
            decode,
            self._err_cb,
        )

    def ui_attach(self, width, height, rgb=None, **kwargs):
        """Register as a remote UI.

        After this method is called, the client will receive redraw
        notifications.
        """
        options = kwargs
        if rgb is not None:
            options["rgb"] = rgb
        return self.request("nvim_ui_attach", width, height, options)

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
        """
        return self.request("nvim_strwidth", string)

    def list_runtime_paths(self):
        """Return a list of paths contained in the 'runtimepath' option."""
        return self.request("nvim_list_runtime_paths")

    def foreach_rtp(self, cb):
        """Invoke `cb` for each path in 'runtimepath'.

        Call the given callable for each path in 'runtimepath' until either
        callable returns something but None, the exception is raised or there
        are no longer paths. If stopped in case callable returned non-None,
        vim.foreach_rtp function returns the value returned by callable.

        """
        for path in self.request("nvim_list_runtime_paths"):
            try:
                if cb(path) is not None:
                    break
            except Exception:
                break

    def chdir(self, dir_path):
        """Run os.chdir, then all appropriate vim stuff."""
        os_chdir(dir_path)
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

    def out_write(self, msg, **kwargs):
        r"""Print `msg` as a normal message.

        The message is buffered (won't display) until linefeed ("\n").
        """
        return self.request("nvim_out_write", msg, **kwargs)

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
                fn(*args, **kwargs)
            except Exception as err:
                msg = (
                    "error caught while executing async callback:\n"
                    "{!r}\n{}\n \nthe call was requested at\n{}".format(
                        err, format_exc_skip(1), call_point
                    )
                )
                self._err_cb(msg)
                raise

        self._session.threadsafe_call(handler)


class BufferBase(UserList):
    """I really feel like the Buffers class should fully implement the
    MutableSequence protocol."""

    def __init__(self, nvim):
        """Initialize a Buffers object with Nvim object `nvim`."""
        self._fetch_buffers = nvim.api.list_bufs
        self.nvim = nvim
        super().__init__(self._fetch_buffers())

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
        return reprlib.Repr().repr(self._fetch_buffers())


class CompatibilitySession(Remote):
    """Helper class for API compatibility. This should really subclass Remote
    though."""

    def __init__(self, nvim):
        self.threadsafe_call = nvim.async_call

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%r: (%r)>" % (self.__class__.__name__, self.threadsafe_call)

    def __call__(self, command):
        return self.threadsafe_call(command)


class Current(BufferBase):
    """Helper class for emulating vim.current from python-vim."""

    def __init__(self, session):
        self._session = session
        self.range = None

    @property
    def line(self):
        return self._session.request("nvim_get_current_line")

    @line.setter
    def line(self, line):
        return self._session.request("nvim_set_current_line", line)

    @line.deleter
    def line(self):
        return self._session.request("nvim_del_current_line")

    @property
    def buffer(self):
        return self._session.request("nvim_get_current_buf")

    @buffer.setter
    def buffer(self, buffer):
        return self._session.request("nvim_set_current_buf", buffer)

    @property
    def window(self):
        return self._session.request("nvim_get_current_win")

    @window.setter
    def window(self, window):
        return self._session.request("nvim_set_current_win", window)

    @property
    def tabpage(self):
        return self._session.request("nvim_get_current_tabpage")

    @tabpage.setter
    def tabpage(self, tabpage):
        return self._session.request("nvim_set_current_tabpage", tabpage)

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%r: (%r)>" % (self.__class__.__name__, self.buffer)


class Funcs(object):
    """Helper class for functional vimscript interface."""

    def __init__(self, nvim):
        self._nvim = nvim

    def __getattr__(self, name):
        return functools.partial(self._nvim.call, name)

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%r>" % (self.__class__.__name__)


class LuaFuncs(object):
    """Wrapper to allow lua functions to be called like python methods."""

    def __init__(self, nvim, name=""):
        self._nvim = nvim
        self.name = name

    def __getattr__(self, name):
        """Return wrapper to named api method."""
        prefix = self.name + "." if self.name else ""
        return LuaFuncs(self._nvim, prefix + name)

    def __call__(self, *args, **kwargs):
        # first new function after keyword rename, be a bit noisy
        if "async" in kwargs:
            raise ValueError(
                '"async" argument is not allowed. ' 'Use "async_" instead.'
            )
        async_ = kwargs.get("async_", False)
        pattern = "return {}(...)" if not async_ else "{}(...)"
        code = pattern.format(self.name)
        return self._nvim.exec_lua(code, *args, **kwargs)

    def __repr__(self):
        """Get the text representation of the object."""
        return "<%r>" % (self.__class__.__name__)


# }}}

# plugin/scripthost: {{{


@plugin
class ScriptHost:
    """Provides an environment for running python plugins created for Vim."""

    def __init__(self, nvim):
        """Initialize the legacy python-vim environment.

        Moved the self.nvim = nvim to the ``__init__`` so that :meth:`setup`
        doesn't require parameters anymore.
        """
        self.nvim = nvim

        self.setup()
        # context where all code will run
        self.module = imp.new_module("__main__")
        nvim.script_context = self.module
        # it seems some plugins assume 'sys' is already imported, so do it now
        exec("import sys", self.module.__dict__)
        self.legacy_vim = LegacyVim.from_nvim(nvim)
        sys.modules["vim"] = self.legacy_vim

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
        # os.chdir(nvim.eval('getcwd()', async_=False))
        nvim.command(
            'call rpcnotify({}, "python_chdir", getcwd())'.format(nvim.channel_id),
            async_=True,
        )

    def setup(self, nvim):
        """Set import hooks and global streams.

        This will add import hooks for importing modules from runtime
        directories and patch the sys module so 'print' calls will be
        forwarded to Nvim.
        """
        info("install import hook/path")
        self.hook = path_hook(nvim)
        sys.path_hooks.append(self.hook)
        # seriously why accept nvim as a parameter then define things on
        # it. were defining the class ourselves just fucking define
        # it here!
        # nvim.VIM_SPECIAL_PATH = "_vim_path_"
        sys.path.append(nvim.VIM_SPECIAL_PATH)
        # also we're gonna need to do something about all this horrific
        # sys.path hacking
        self.saved_stdout = sys.stdout
        self.saved_stderr = sys.stderr
        sys.stdout = RedirectStream(lambda data: nvim.out_write(data))
        sys.stderr = RedirectStream(lambda data: nvim.err_write(data))

    def teardown(self):
        """Restore state modified from the `setup` call."""
        nvim = self.nvim
        info("uninstall import hook/path")
        sys.path.remove(nvim.VIM_SPECIAL_PATH)
        sys.path_hooks.remove(self.hook)
        info("restore sys.stdout and sys.stderr")
        sys.stdout = self.saved_stdout
        sys.stderr = self.saved_stderr

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
            exec(script, self.module.__dict__)
        except Exception:
            raise ErrorResponse(format_exc_skip(1))

    @rpc_export("python_execute_file", sync=True)
    def python_execute_file(self, file_path, range_start, range_stop):
        """Handle the `pyfile` ex command."""
        self._set_current_range(range_start, range_stop)
        with open(file_path) as f:
            script = compile(f.read(), file_path, "exec")
            try:
                exec(script, self.module.__dict__)
            except Exception:
                raise ErrorResponse(format_exc_skip(1))

    @rpc_export("python_do_range", sync=True)
    def python_do_range(self, start, stop, code):
        """Handle the `pydo` ex command."""
        self._set_current_range(start, stop)
        nvim = self.nvim
        start -= 1
        fname = "_vim_pydo"

        # define the function
        function_def = "def %s(line, linenr):\n %s" % (fname, code,)
        exec(function_def, self.module.__dict__)
        # get the function
        function = self.module.__dict__[fname]
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
                result = function(line, linenr)
                if result is None:
                    # Update earlier lines, and skip to the next
                    if newlines:
                        end = sstart + len(newlines) - 1
                        nvim.current.buffer.api.set_lines(sstart, end, True, newlines)
                    sstart += len(newlines) + 1
                    newlines = []
                    pass
                elif isinstance(result, basestring):
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
        # delete the function
        del self.module.__dict__[fname]

    @rpc_export("python_eval", sync=True)
    def python_eval(self, expr):
        """Handle the `pyeval` vim function."""
        return eval(expr, self.module.__dict__)

    @rpc_export("python_chdir", sync=False)
    def python_chdir(self, cwd):
        """Handle working directory changes."""
        os.chdir(cwd)

    def _set_current_range(self, start, stop):
        current = self.legacy_vim.current
        current.range = current.buffer.range(start, stop)


class RedirectStream(io.IOBase):
    def __init__(self, redirect_handler):
        self.redirect_handler = redirect_handler

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


def num_to_str(obj):
    """Converts int long and float to str."""
    num_types = (int, long, float)
    if isinstance(obj, num_types):
        return str(obj)
    else:
        return obj


class LegacyVim(Nvim):
    """Nvim subclass with new eval."""

    def eval(self, expr):
        obj = self.request("vim_eval", expr)
        return walk(num_to_str, obj)


def _find_module(fullname, oldtail, path):
    idx = oldtail.find(".")
    if idx > 0:
        name = oldtail[:idx]
        tail = oldtail[idx + 1:]
        fmr = imp.find_module(name, path)
        module = imp.find_module(fullname[: -len(oldtail)] + name, *fmr)
        return _find_module(fullname, tail, module.__path__)
    else:
        return imp.find_module(fullname, path)


def find_spec(fullname, target=None):
    """Method for Python 3.4+."""
    if PathFinder is not None:
        return PathFinder.find_spec(fullname, target)


def path_hook(nvim):
    return VimPath(nvim).hook(sys.path)


class VimPath(Nvim):
    def discover_runtime_directories(self):
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


# }}}

# API/buffer: {{{


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

    def __init__(self, session, code_data, valid=None, **kwargs):
        super().__init__(session, code_data, **kwargs)
        # Valid should NOT be a property! its explicitly tied to the instance
        # it doesnt seem like we have a 2 way channel for communication
        # so define it here.
        self.valid = valid if valid is not None else self.request("nvim_buf_is_valid")
        self.session = session
        self.code_data = code_data

    def __len__(self):
        """Return the number of lines contained in a Buffer."""
        return self.request("nvim_buf_line_count")

    def __bool__(self):
        """Adding a bool because its a waste of time to send a msgpack request."""
        return bool(self.valid)

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
        lines = self[:]
        for line in lines:
            yield line

    def __delitem__(self, idx):
        """Delete line or slice of lines from the buffer.

        This is the same as __setitem__(idx, [])
        """
        self.__setitem__(idx, None)

    def __ne__(self, other):
        """Test inequality of Buffers.

        Necessary for Python 2 compatibility.
        """
        return not self.__eq__(other)

    def __iadd__(self, lines, index=-1):
        return self.append(lines, index=index)

    def append(self, lines, index=-1):
        """Append a string or list of lines to the buffer. Now an alias for `__iadd__`."""
        if isinstance(lines, (basestring, bytes)):
            lines = [lines]
        return self.request("nvim_buf_set_lines", index, index, True, lines)

    def mark(self, name):
        """Return (row, col) tuple for a named mark."""
        return self.request("nvim_buf_get_mark", name)

    def range(self, start, end):
        """Return a `Range` object, which represents part of the Buffer."""
        return Range(self, start, end)

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

        By default existing highlights are preserved. Specify a line range with
        clear_start and clear_end to replace highlights in this range. As a
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

    # @property
    # def valid(self):
    #     """Return True if the buffer still exists."""
    #     return self.request("nvim_buf_is_valid")

    @property
    def number(self):
        """Get the buffer number."""
        return self.handle


class Range(object):
    def __init__(self, buffer, start, end):
        self._buffer = buffer
        self.start = start - 1
        self.end = end - 1

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
        self._buffer[start: end + 1] = lines

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


# }}}

# msgpack.__init__: {{{


def session(transport_type="stdio", *args, **kwargs):
    """Msgpack-rpc subpackage.

    This package implements a msgpack-rpc client. While it was designed for
    handling some Nvim particularities(server->client requests for example), the
    code here should work with other msgpack-rpc servers.
    """
    loop = EventLoop(transport_type, *args, **kwargs)
    msgpack_stream = MsgpackStream(loop)
    async_session = AsyncSession(msgpack_stream)
    session = Session(async_session)
    session.request(
        b"nvim_set_client_info", *get_client_info("client", "remote", {}), async_=True
    )
    return session


def tcp_session(address, port=7450):
    """Create a msgpack-rpc session from a tcp address/port."""
    return session("tcp", address, port)


def socket_session(path):
    """Create a msgpack-rpc session from a unix domain socket."""
    return session("socket", path)


def stdio_session():
    """Create a msgpack-rpc session from stdin/stdout."""
    return session("stdio")


def child_session(argv):
    """Create a msgpack-rpc session from a new Nvim instance."""
    return session("child", argv)


# }}}

# {{{ API/common


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


class RemoteMap:
    """Represents a string->object map stored in Nvim.

    This is the dict counterpart to the `RemoteSequence` class, but it is used
    as a generic way of retrieving values from the various map-like data
    structures present in Nvim.

    It is used to provide a dict-like API to vim variables and options.

    Would it make more sense to subclass collections.UserDict here?

    No because then it would require that the main Nvim class be iterable.
    Which can happen later but not now.
    """

    _set = None
    _del = None

    def __init__(self, obj, get_method, set_method=None, del_method=None):
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


class RemoteSequence(UserList):
    """Represents a sequence of objects stored in Nvim.

    This class is used to wrap msgapck-rpc functions that work on Nvim
    sequences(of lines, buffers, windows and tabpages) with an API that
    is similar to the one provided by the python-vim interface.

    For example, the 'windows' property of the `Nvim` class is a RemoteSequence
    sequence instance, and the expression `nvim.windows[0]` is translated to
    session.request('nvim_list_wins')[0].

    One important detail about this class is that all methods will fetch the
    sequence into a list and perform the necessary manipulation
    locally(iteration, indexing, counting, etc).
    """

    def __init__(self, session, method):
        """Initialize a RemoteSequence with session, method.

        Parameters
        ----------
        session :
            Something that has a request attr?
        method
        """
        self._fetch = functools.partial(session.request, method)
        self.session = session
        self.method = method
        super().__init__()

    def __len__(self):
        """Return the length of the remote sequence."""
        return len(self._fetch())

    def __getitem__(self, idx):
        """Return a sequence item by index."""
        if not isinstance(idx, slice):
            return self._fetch()[idx]
        return self._fetch()[idx.start: idx.stop]

    def __iter__(self):
        """Return an iterator for the sequence."""
        items = self._fetch()
        for item in items:
            yield item

    def __contains__(self, item):
        """Check if an item is present in the sequence."""
        return item in self._fetch()


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


# }}}

# msgpack_rpc.session: {{{


class ErrorResponse(BaseException):
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
    a LOT.
    """

    def __init__(self, async_session):
        """Wrap `async_session` on a synchronous msgpack-rpc interface."""
        self._async_session = async_session
        self._request_cb = self._notification_cb = None
        self._pending_messages = deque()
        self._is_running = False
        self._setup_exception = None
        self.loop = async_session.loop
        self._loop_thread = None

    def threadsafe_call(self, fn, *args, **kwargs):
        """Wrap :meth:`AsyncSession.threadsafe_call`."""

        @functools.wraps
        def handler():
            try:
                fn(*args, **kwargs)
            except Exception:
                warn("error caught while excecuting async callback\n%s\n", format_exc())

        @functools.wraps
        def greenlet_wrapper():
            gr = greenlet.greenlet(handler)
            gr.switch()

        self._async_session.threadsafe_call(greenlet_wrapper)

    def next_message(self):
        """Block until a message(request or notification) is available.

        If any messages were previously enqueued, return the first in queue.
        If not, run the event loop until one is received.

        Raises
        ------
        """
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
        async_ = check_async(kwargs.pop("async_", None), kwargs, False)
        if async_:
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
            raise OSError("EOF")
        err, rv = v
        if err:
            info("'Received error: %s", err)
            raise self.error_wrapper(*err, sys.last_traceback)
        return rv

    def run(self, request_cb, notification_cb, setup_cb=None):
        """Run the event loop to receive requests and notifications from Nvim.

        Like `AsyncSession.run()`, but `request_cb` and `notification_cb` are
        inside greenlets.
        """
        self._request_cb = request_cb
        self._notification_cb = notification_cb
        self._is_running = True
        self._setup_exception = None
        self._loop_thread = threading.current_thread()

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

        if self._setup_exception:
            error("Setup error: {}".format(self._setup_exception))
            raise self._setup_exception

        # Process all pending requests and notifications
        while self._pending_messages:
            msg = self._pending_messages.popleft()
            getattr(self, "_on_{}".format(msg[0]))(*msg[1:])
        self._async_session.run(self._on_request, self._on_notification)
        self._is_running = False
        self._request_cb = None
        self._notification_cb = None
        self._loop_thread = None

        if self._setup_exception:
            raise self._setup_exception

    def stop(self):
        """Stop the event loop."""
        self._async_session.stop()

    def close(self):
        """Close the event loop."""
        self._async_session.close()

    def _yielding_request(self, method, args):
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

    def _enqueue_request_and_stop(self, name, args, response):
        self._enqueue_request(name, args, response)
        self.stop()

    def _enqueue_notification_and_stop(self, name, args):
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
                debug(
                    "greenlet %s finished executing, " + "sending %s as response",
                    gr,
                    rv,
                )
                response.send(rv)
            except ErrorResponse as err:
                warn(
                    "error response from request '%s %s': %s", name, args, format_exc()
                )
                response.send(err.args[0], error=True)
            except Exception as err:
                warn(
                    "error caught while processing request '%s %s': %s",
                    name,
                    args,
                    format_exc(),
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


# }}}

# msgpack_rpc.async_session: {{{


class AsyncSession(object):

    """Asynchronous msgpack-rpc layer that wraps a msgpack stream.

    This wraps the msgpack stream interface for reading/writing msgpack
    documents and exposes an interface for sending and receiving msgpack-rpc
    requests and notifications.
    """

    def __init__(self, msgpack_stream):
        """Wrap `msgpack_stream` on a msgpack-rpc interface."""
        self._msgpack_stream = msgpack_stream
        self._next_request_id = 1
        self._pending_requests = {}
        self._request_cb = self._notification_cb = None
        self._handlers = {
            0: self._on_request,
            1: self._on_response,
            2: self._on_notification,
        }
        self.loop = msgpack_stream.loop

    def threadsafe_call(self, fn):
        """Wrapper around `MsgpackStream.threadsafe_call`."""
        self._msgpack_stream.threadsafe_call(fn)

    def request(self, method, args, response_cb):
        """Send a msgpack-rpc request to Nvim.

        A msgpack-rpc with method `method` and argument `args` is sent to
        Nvim. The `response_cb` function is called with when the response
        is available.
        """
        request_id = self._next_request_id
        self._next_request_id = request_id + 1
        self._msgpack_stream.send([0, request_id, method, args])
        self._pending_requests[request_id] = response_cb

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

    def stop(self):
        """Stop the event loop."""
        self._msgpack_stream.stop()

    def close(self):
        """Close the event loop."""
        self._msgpack_stream.close()

    def _on_message(self, msg):
        try:
            self._handlers.get(msg[0], self._on_invalid_message)(msg)
        except Exception:
            err_str = format_exc(5)
            pass  # replaces next logging statement
            # warn(err_str)
            self._msgpack_stream.send([1, 0, err_str, None])

    def _on_request(self, msg):
        # request
        #   - msg[1]: id
        #   - msg[2]: method name
        #   - msg[3]: arguments
        pass  # replaces next logging statement
        # debug('received request: %s, %s', msg[2], msg[3])
        self._request_cb(msg[2], msg[3], Response(self._msgpack_stream, msg[1]))

    def _on_response(self, msg):
        # response to a previous request:
        #   - msg[1]: the id
        #   - msg[2]: error(if any)
        #   - msg[3]: result(if not errored)
        pass  # replaces next logging statement
        # debug('received response: %s, %s', msg[2], msg[3])
        self._pending_requests.pop(msg[1])(msg[2], msg[3])

    def _on_notification(self, msg):
        # notification/event
        #   - msg[1]: event name
        #   - msg[2]: arguments
        pass  # replaces next logging statement
        # debug('received notification: %s, %s', msg[1], msg[2])
        self._notification_cb(msg[1], msg[2])

    def _on_invalid_message(self, msg):
        error = "Received invalid message %s" % msg
        pass  # replaces next logging statement
        # warn(error)
        self._msgpack_stream.send([1, 0, error, None])


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
        pass  # replaces next logging statement
        # debug('sending response to request %d: %s', self._request_id, resp)
        self._msgpack_stream.send(resp)


# }}}

# msgpack_rpc.msgpack_stream: {{{


class MsgpackStream(object):

    """Two-way msgpack stream that wraps a event loop byte stream.

    This wraps the event loop interface for reading/writing bytes and
    exposes an interface for reading/writing msgpack documents.
    """

    def __init__(self, event_loop):
        """Wrap `event_loop` on a msgpack-aware interface."""
        self.loop = event_loop
        self._packer = Packer(unicode_errors=unicode_errors_default)
        self._unpacker = Unpacker()
        self._message_cb = None

    def threadsafe_call(self, fn):
        """Wrapper around `BaseEventLoop.threadsafe_call`."""
        self.loop.threadsafe_call(fn)

    def send(self, msg):
        """Queue `msg` for sending to Nvim."""
        pass  # replaces next logging statement
        # debug('sent %s', msg)
        self.loop.send(self._packer.pack(msg))

    def run(self, message_cb):
        """Run the event loop to receive messages from Nvim.

        While the event loop is running, `message_cb` will be called whenever
        a message has been successfully parsed from the input stream.
        """
        self._message_cb = message_cb
        self.loop.run(self._on_data)
        self._message_cb = None

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
                pass  # replaces next logging statement
                # debug('waiting for message...')
                msg = next(self._unpacker)
                pass  # replaces next logging statement
                # debug('received message: %s', msg)
                self._message_cb(msg)
            except StopIteration:
                pass  # replaces next logging statement
                # debug('unpacker needs more data...')
                break


# }}}

# msgpack_rpc.event_loop.base: {{{

# When signals are restored, the event loop library may reset SIGINT to SIG_DFL
# which exits the program. To be able to restore the python interpreter to it's
# default state, we keep a reference to the default handler
default_int_handler = signal.getsignal(signal.SIGINT)
main_thread = threading.current_thread()


class BaseEventLoop(object):

    """Abstract base class for all event loops.

    Event loops act as the bottom layer for Nvim sessions created by this
    library. They hide system/transport details behind a simple interface for
    reading/writing bytes to the connected Nvim instance.

    This class exposes public methods for interacting with the underlying
    event loop and delegates implementation-specific work to the following
    methods, which subclasses are expected to implement:

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
    """

    def __init__(self, transport_type, *args):
        """Initialize and connect the event loop instance.

        The only arguments are the transport type and transport-specific
        configuration, like this:

        >>> BaseEventLoop('tcp', '127.0.0.1', 7450)
        Traceback (most recent call last):
            ...
        AttributeError: 'BaseEventLoop' object has no attribute '_init'
        >>> BaseEventLoop('socket', '/tmp/nvim-socket')
        Traceback (most recent call last):
            ...
        AttributeError: 'BaseEventLoop' object has no attribute '_init'
        >>> BaseEventLoop('stdio')
        Traceback (most recent call last):
            ...
        AttributeError: 'BaseEventLoop' object has no attribute '_init'
        >>> BaseEventLoop('child',
                ['nvim', '--embed', '--headless', '-u', 'NONE'])
        Traceback (most recent call last):
            ...
        AttributeError: 'BaseEventLoop' object has no attribute '_init'

        This calls the implementation-specific initialization
        `_init`, one of the `_connect_*` methods(based on `transport_type`)
        and `_start_reading()`
        """
        self._transport_type = transport_type
        self._signames = dict(
            (k, v) for v, k in signal.__dict__.items() if v.startswith("SIG")
        )
        self._on_data = None
        self._error = None
        self._init()
        try:
            getattr(self, "_connect_{}".format(transport_type))(*args)
        except Exception as e:
            self.close()
            raise e
        self._start_reading()

    def connect_tcp(self, address, port):
        """Connect to tcp/ip `address`:`port`. Delegated to `_connect_tcp`."""
        pass  # replaces next logging statement
        # info('Connecting to TCP address: %s:%d', address, port)
        self._connect_tcp(address, port)

    def connect_socket(self, path):
        """Connect to socket at `path`. Delegated to `_connect_socket`."""
        pass  # replaces next logging statement
        # info('Connecting to %s', path)
        self._connect_socket(path)

    def connect_stdio(self):
        """Connect using stdin/stdout. Delegated to `_connect_stdio`."""
        pass  # replaces next logging statement
        # info('Preparing stdin/stdout for streaming data')
        self._connect_stdio()

    def connect_child(self, argv):
        """Connect a new Nvim instance. Delegated to `_connect_child`."""
        pass  # replaces next logging statement
        # info('Spawning a new nvim instance')
        self._connect_child(argv)

    def send(self, data):
        """Queue `data` for sending to Nvim."""
        pass  # replaces next logging statement
        # debug("Sending '%s'", data)
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
        pass  # replaces next logging statement
        # debug('Entering event loop')
        self._run()
        pass  # replaces next logging statement
        # debug('Exited event loop')
        if threading.current_thread() == main_thread:
            self._teardown_signals()
            signal.signal(signal.SIGINT, default_int_handler)
        self._on_data = None

    def stop(self):
        """Stop the event loop."""
        self._stop()
        pass  # replaces next logging statement
        # debug('Stopped event loop')

    def close(self):
        """Stop the event loop."""
        self._close()
        pass  # replaces next logging statement
        # debug('Closed event loop')

    def _on_signal(self, signum):
        msg = "Received {}".format(self._signames[signum])
        pass  # replaces next logging statement
        # debug(msg)
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

    def _on_error(self, error):
        pass  # replaces next logging statement
        # debug(error)
        self._error = OSError(error)
        self.stop()

    def _on_interrupt(self):
        self.stop()


# }}}

# mspack_rpc.event_loop.asyncio: {{{


class AsyncioEventLoop(BaseEventLoop, asyncio.Protocol, asyncio.SubprocessProtocol):

    """`BaseEventLoop` subclass that uses `asyncio` as a backend."""

    def connection_made(self, transport):
        """Used to signal `asyncio.Protocol` of a successful connection."""
        self._transport = transport
        self._raw_transport = transport
        if isinstance(transport, asyncio.SubprocessTransport):
            self._transport = transport.get_pipe_transport(0)

    def connection_lost(self, exc):
        """Used to signal `asyncio.Protocol` of a lost connection."""
        self._on_error(exc.args[0] if exc else "EOF")

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
        """Used to signal `asyncio.SubprocessProtocol` when the child exits."""
        self._on_error("EOF")

    def _init(self):
        self._loop = loop_cls()
        self._queued_data = deque()
        self._fact = lambda: self
        self._raw_transport = None

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
            pipe = PipeHandle(msvcrt.get_osfhandle(sys.stdin.fileno()))
        else:
            pipe = sys.stdin
        coroutine = self._loop.connect_read_pipe(self._fact, pipe)
        self._loop.run_until_complete(coroutine)
        pass  # replaces next logging statement
        # debug("native stdin connection successful")

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
        pass  # replaces next logging statement
        # debug("native stdout connection successful")

    def _connect_child(self, argv):
        if os.name != "nt":
            self._child_watcher = asyncio.get_child_watcher()
            self._child_watcher.attach_loop(self._loop)
        coroutine = self._loop.subprocess_exec(self._fact, *argv)
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


# }}}

# api.window: {{{


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
        """Set the (row, col) tuple as the new cursor position."""
        return self.request("nvim_win_set_cursor", pos)

    @property
    def height(self):
        """Get the window height in rows."""
        return self.request("nvim_win_get_height")

    @height.setter
    def height(self, height):
        """Set the window height in rows."""
        return self.request("nvim_win_set_height", height)

    @property
    def width(self):
        """Get the window width in rows."""
        return self.request("nvim_win_get_width")

    @width.setter
    def width(self, width):
        """Set the window height in rows."""
        return self.request("nvim_win_set_width", width)

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


# }}}

# api.tabpage: {{{
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


# }}}

gc.collect()

# Vim: set fdm=marker fdls=0:
