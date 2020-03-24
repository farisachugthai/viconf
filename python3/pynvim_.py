#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Vim: set fdm=marker:
# {{{
"""Code shared between the API classes.

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

#) pynvim/util because that has no internal dependencies.

#) then compat

#) Then plugin/decorators.

#) api/nvim

#) plugin/scripthost

#) api/buffers

#) msgpack_rpc.__init__

#) api/common

Notes
-----

Remote got pushed way up out of API/common because it's invoked a handful of
times before then.

Decorators used by python host plugin system.

"""
import functools
import imp
import inspect
import io
import logging
import os
import sys
import threading
import warnings
from imp import find_module as original_find_module
from traceback import format_exception, format_stack

from msgpack import unpackb, ExtType
from pynvim.api import Window, Tabpage
from pynvim.msgpack_rpc.async_session import AsyncSession
from pynvim.msgpack_rpc.event_loop import EventLoop
from pynvim.msgpack_rpc.msgpack_stream import MsgpackStream
from pynvim.msgpack_rpc.session import ErrorResponse, Session

# }}}

# Globals: {{{
basestring = str

if sys.version_info >= (3, 4):
    from importlib.machinery import PathFinder

PYTHON_SUBDIR = "python3"

logger = logging.getLogger(__name__)
debug, info, warn = (
    logger.debug,
    logger.info,
    logger.warning,
)

long = int
unicode_errors_default = "surrogateescape"

NUM_TYPES = (int, long, float)

# }}}
# util: {{{
# There is no 'long' type in Python3 just int


def format_exc_skip(skip, limit=None):
    """Like traceback.format_exc but allow skipping the first frames."""
    etype, val, tb = sys.exc_info()
    for i in range(skip):
        tb = tb.tb_next
    return ("".join(format_exception(etype, val, tb, limit))).rstrip()


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
        """Check if version is same as other."""
        return self.__dict__ == other.__dict__


def get_client_info(kind, type_, method_spec):
    """Returns a tuple describing the client."""
    name = "python{}-{}".format(sys.version_info[0], kind)
    attributes = {
        "license": "Apache v2",
        "website": "github.com/neovim/pynvim"
    }
    return name, VERSION.__dict__, type_, method_spec, attributes


VERSION = Version(major=0, minor=4, patch=1, prerelease="")

# }}}

# compat: {{{


def find_module(fullname, path):
    """Compatibility wrapper for imp.find_module.

    Automatically decodes arguments of find_module, in Python3
    they must be Unicode
    """
    if isinstance(fullname, bytes):
        fullname = fullname.decode()
    if isinstance(path, bytes):
        path = path.decode()
    elif isinstance(path, list):
        newpath = []
        for element in path:
            if isinstance(element, bytes):
                newpath.append(element.decode())
            else:
                newpath.append(element)
        path = newpath
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
    f._nvim_shutdown_hook = True
    f._nvim_bind = True
    return f


def decode(mode=unicode_errors_default):
    """Configure automatic encoding/decoding of strings."""
    def dec(f):
        f._nvim_decode = mode
        return f

    return dec


def encoding(encoding=True):
    """DEPRECATED: use pynvim.decode()."""
    if isinstance(encoding, str):
        encoding = True

    def dec(f):
        f._nvim_decode = encoding
        return f

    return dec


# }}}

# api/common:Remote: {{{


class NvimError(Exception):
    pass


class Remote(object):
    """Base class for Nvim objects(buffer/window/tabpage).

    Each type of object has it's own specialized class with API wrappers around
    the msgpack-rpc session. This implements equality which takes the remote
    object handle into consideration.
    """
    def __init__(self, session, code_data):
        """Initialize from session and code_data immutable object.

        The `code_data` contains serialization information required for
        msgpack-rpc calls. It must be immutable for Buffer equality to work.
        """
        self._session = session
        self.code_data = code_data
        self.handle = unpackb(code_data[1])
        self.api = RemoteApi(self, self._api_prefix)
        self.vars = RemoteMap(
            self,
            self._api_prefix + "get_var",
            self._api_prefix + "set_var",
            self._api_prefix + "del_var",
        )
        self.options = RemoteMap(self, self._api_prefix + "get_option",
                                 self._api_prefix + "set_option")

    def __repr__(self):
        """Get text representation of the object."""
        return "<%s(handle=%r)>" % (
            self.__class__.__name__,
            self.handle,
        )

    def __eq__(self, other):
        """Return True if `self` and `other` are the same object."""
        return hasattr(other,
                       "code_data") and other.code_data == self.code_data

    def __hash__(self):
        """Return hash based on remote object id."""
        return self.code_data.__hash__()

    def request(self, name, *args, **kwargs):
        """Wrapper for nvim.request."""
        return self._session.request(name, self, *args, **kwargs)


# }}}

# api/nvim: Needs to be above plugin/scripthost: {{{
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
    @classmethod
    def from_session(cls, session):
        """Create a new Nvim instance for a Session instance.

        This method must be called to create the first Nvim instance, since it
        queries Nvim metadata for type information and sets a SessionHook for
        creating specialized objects from Nvim remote handles.
        """
        session.error_wrapper = lambda e: NvimError(decode_if_bytes(e[1]))
        channel_id, metadata = session.request(b"nvim_get_api_info")

        metadata = walk(decode_if_bytes, metadata)

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

    def __init__(self,
                 session,
                 channel_id,
                 metadata,
                 types,
                 decode=False,
                 err_cb=None):
        """Initialize a new Nvim instance. This method is module-private."""
        self._session = session
        self.channel_id = channel_id
        self.metadata = metadata
        version = metadata.get("version", {"api_level": 0})
        self.version = Version(**version)
        self.types = types
        self.api = RemoteApi(self, "nvim_")
        self.vars = RemoteMap(self, "nvim_get_var", "nvim_set_var",
                              "nvim_del_var")
        self.vvars = RemoteMap(self, "nvim_get_vvar", None, None)
        self.options = RemoteMap(self, "nvim_get_option", "nvim_set_option")
        self.buffers = Buffers(self)
        self.windows = RemoteSequence(self, "nvim_list_wins")
        self.tabpages = RemoteSequence(self, "nvim_list_tabpages")
        self.current = Current(self)
        self.session = CompatibilitySession(self)
        self.funcs = Funcs(self)
        self.lua = LuaFuncs(self)
        self.error = NvimError
        self._decode = decode
        self._err_cb = err_cb

        # only on python3.4+ we expose asyncio
        self.loop = self._session.loop._loop

    def _from_nvim(self, obj, decode=None):
        if decode is None:
            decode = self._decode
        if type(obj) is ExtType:
            cls = self.types[obj.code]
            return cls(self, (obj.code, obj.data))
        if decode:
            obj = decode_if_bytes(obj, decode)
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
        if (self._session._loop_thread is not None
                and threading.current_thread() != self._session._loop_thread):
            msg = ("Request from non-main thread.\n"
                   "Requests from different threads should be wrapped "
                   "with nvim.async_call(cb, ...) \n{}\n".format("\n".join(
                       format_stack(None, 5)[:-1])))

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

    def run_loop(self,
                 request_cb,
                 notification_cb,
                 setup_cb=None,
                 err_cb=None):
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
                    name, args, format_exc_skip(1))
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
                    name, args, format_exc_skip(1))
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
        """Initialize a new Nvim instance."""
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

        There is a shorthand syntax to call lua functions with arguments:

            nvim.lua.func(1,2)
            nvim.lua.mymod.myfunction(data, async_=True)

        is equivalent to

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

    def replace_termcodes(self,
                          string,
                          from_part=False,
                          do_lt=True,
                          special=True):
        r"""Replace any terminal code strings by byte sequences.

        The returned sequences are Nvim's internal representation of keys,
        for example:

        <esc> -> '\x1b'
        <cr>  -> '\r'
        <c-l> -> '\x0c'
        <up>  -> '\x80ku'

        The returned sequences can be used as input to `feedkeys`.
        """
        return self.request("nvim_replace_termcodes", string, from_part, do_lt,
                            special)

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
        return (self._session._loop_thread is not None
                and threading.current_thread() != self._session._loop_thread)

    def quit(self, quit_command="qa!"):
        """Send a quit command to Nvim.

        By default, the quit command is 'qa!' which will make Nvim quit without
        saving anything.
        """
        try:
            self.command(quit_command)
        except IOError:
            # sending a quit command will raise an IOError because the
            # connection is closed before a response is received. Safe to
            # ignore it.
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
        call_point = "".join(format_stack(None, 5)[:-1])

        def handler():
            try:
                fn(*args, **kwargs)
            except Exception as err:
                msg = ("error caught while executing async callback:\n"
                       "{!r}\n{}\n \nthe call was requested at\n{}".format(
                           err, format_exc_skip(1), call_point))
                self._err_cb(msg)
                raise

        self._session.threadsafe_call(handler)


class Buffers(object):
    """Remote NVim buffers.

    Currently the interface for interacting with remote NVim buffers is the
    `nvim_list_bufs` msgpack-rpc function. Most methods fetch the list of
    buffers from NVim.

    Conforms to *python-buffers*.
    """
    def __init__(self, nvim):
        """Initialize a Buffers object with Nvim object `nvim`."""
        self._fetch_buffers = nvim.api.list_bufs

    def __len__(self):
        """Return the count of buffers."""
        return len(self._fetch_buffers())

    def __getitem__(self, number):
        """Return the Buffer object matching buffer number `number`."""
        for b in self._fetch_buffers():
            if b.number == number:
                return b
        raise KeyError(number)

    def __contains__(self, b):
        """Return whether Buffer `b` is a known valid buffer."""
        return isinstance(b, Buffer) and b.valid

    def __iter__(self):
        """Return an iterator over the list of buffers."""
        return iter(self._fetch_buffers())


class CompatibilitySession(object):
    """Helper class for API compatibility."""
    def __init__(self, nvim):
        self.threadsafe_call = nvim.async_call


class Current(object):
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


class Funcs(object):
    """Helper class for functional vimscript interface."""
    def __init__(self, nvim):
        self._nvim = nvim

    def __getattr__(self, name):
        return functools.partial(self._nvim.call, name)


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
            raise ValueError('"async" argument is not allowed. '
                             'Use "async_" instead.')
        async_ = kwargs.get("async_", False)
        pattern = "return {}(...)" if not async_ else "{}(...)"
        code = pattern.format(self.name)
        return self._nvim.exec_lua(code, *args, **kwargs)


# }}}

# plugin/scripthost: {{{


@plugin
class ScriptHost(object):
    """Provides an environment for running python plugins created for Vim."""
    def __init__(self, nvim):
        """Initialize the legacy python-vim environment."""
        self.setup(nvim)
        # context where all code will run
        self.module = imp.new_module("__main__")
        nvim.script_context = self.module
        # it seems some plugins assume 'sys' is already imported, so do it now
        exec("import sys", self.module.__dict__)
        self.legacy_vim = LegacyVim.from_nvim(nvim)
        sys.modules["vim"] = self.legacy_vim

        # Handle DirChanged. #296
        nvim.command(
            'au DirChanged * call rpcnotify({}, "python_chdir", v:event.cwd)'.
            format(nvim.channel_id),
            async_=True,
        )
        # XXX: Avoid race condition.
        # https://github.com/neovim/pynvim/pull/296#issuecomment-358970531
        # TODO(bfredl): when host initialization has been refactored,
        # to make __init__ safe again, the following should work:
        # os.chdir(nvim.eval('getcwd()', async_=False))
        nvim.command(
            'call rpcnotify({}, "python_chdir", getcwd())'.format(
                nvim.channel_id),
            async_=True,
        )

    def setup(self, nvim):
        """Setup import hooks and global streams.

        This will add import hooks for importing modules from runtime
        directories and patch the sys module so 'print' calls will be
        forwarded to Nvim.
        """
        self.nvim = nvim
        pass  # replaces next logging statement
        # info('install import hook/path')
        self.hook = path_hook(nvim)
        sys.path_hooks.append(self.hook)
        nvim.VIM_SPECIAL_PATH = "_vim_path_"
        sys.path.append(nvim.VIM_SPECIAL_PATH)
        pass  # replaces next logging statement
        # info('redirect sys.stdout and sys.stderr')
        self.saved_stdout = sys.stdout
        self.saved_stderr = sys.stderr
        sys.stdout = RedirectStream(lambda data: nvim.out_write(data))
        sys.stderr = RedirectStream(lambda data: nvim.err_write(data))

    def teardown(self):
        """Restore state modified from the `setup` call."""
        nvim = self.nvim
        pass  # replaces next logging statement
        # info('uninstall import hook/path')
        sys.path.remove(nvim.VIM_SPECIAL_PATH)
        sys.path_hooks.remove(self.hook)
        pass  # replaces next logging statement
        # info('restore sys.stdout and sys.stderr')
        sys.stdout = self.saved_stdout
        sys.stderr = self.saved_stderr

    @rpc_export("python_execute", sync=True)
    def python_execute(self, script, range_start, range_stop):
        """Handle the `python` ex command."""
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
        function_def = "def %s(line, linenr):\n %s" % (
            fname,
            code,
        )
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
                        nvim.current.buffer.api.set_lines(
                            sstart, end, True, newlines)
                    sstart += len(newlines) + 1
                    newlines = []
                    pass
                elif isinstance(result, basestring):
                    newlines.append(result)
                else:
                    exception = TypeError("pydo should return a string " +
                                          "or None, found %s instead" %
                                          result.__class__.__name__)
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


num_types = (int, float)


def num_to_str(obj):
    if isinstance(obj, num_types):
        return str(obj)
    else:
        return obj


class LegacyVim(Nvim):
    def eval(self, expr):
        obj = self.request("vim_eval", expr)
        return walk(num_to_str, obj)


# Copied/adapted from :help if_pyth.
def path_hook(nvim):
    def _get_paths():
        if nvim._thread_invalid():
            return []
        return discover_runtime_directories(nvim)

    def _find_module(fullname, oldtail, path):
        idx = oldtail.find(".")
        if idx > 0:
            name = oldtail[:idx]
            tail = oldtail[idx + 1:]
            fmr = imp.find_module(name, path)
            module = imp.find_module(fullname[:-len(oldtail)] + name, *fmr)
            return _find_module(fullname, tail, module.__path__)
        else:
            return imp.find_module(fullname, path)

    class VimModuleLoader(object):
        def __init__(self, module):
            """

            Parameters
            ----------
            module :
            """
            self.module = module

        def load_module(self, fullname, path=None):
            # Check sys.modules, required for reload (see PEP302).
            try:
                return sys.modules[fullname]
            except KeyError:
                pass
            return imp.load_module(fullname, *self.module)

    class VimPathFinder(object):
        @staticmethod
        def find_module(fullname, path=None):
            """Method for Python 2.7 and 3.3."""
            try:
                return VimModuleLoader(
                    _find_module(fullname, fullname, path or _get_paths()))
            except ImportError:
                return None

        @staticmethod
        def find_spec(fullname, target=None):
            """Method for Python 3.4+."""
            return PathFinder.find_spec(fullname, _get_paths(), target)

    def hook(path):
        if path == nvim.VIM_SPECIAL_PATH:
            return VimPathFinder
        else:
            raise ImportError

    return hook


def discover_runtime_directories(nvim):
    rv = []
    for rtp in nvim.list_runtime_paths():
        if not os.path.exists(rtp):
            continue
        for subdir in ["pythonx", PYTHON_SUBDIR]:
            path = os.path.join(rtp, subdir)
            if os.path.exists(path):
                rv.append(path)
    return rv


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

    def __len__(self):
        """Return the number of lines contained in a Buffer."""
        return self.request("nvim_buf_line_count")

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

    def add_highlight(self,
                      hl_group,
                      line,
                      col_start=0,
                      col_end=-1,
                      src_id=-1,
                      async_=None,
                      **kwargs):
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

    def clear_highlight(self,
                        src_id,
                        line_start=0,
                        line_end=-1,
                        async_=None,
                        **kwargs):
        """Clear highlights from the buffer."""
        async_ = check_async(async_, kwargs, True)
        self.request("nvim_buf_clear_highlight",
                     src_id,
                     line_start,
                     line_end,
                     async_=async_)

    def update_highlights(self,
                          src_id,
                          hls,
                          clear_start=0,
                          clear_end=-1,
                          clear=False,
                          async_=True):
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
        lua.update_highlights(self,
                              src_id,
                              hls,
                              clear_start,
                              clear_end,
                              async_=async_)

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
        self._buffer[start:end + 1] = lines

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
"""Msgpack-rpc subpackage.

This package implements a msgpack-rpc client. While it was designed for
handling some Nvim particularities(server->client requests for example), the
code here should work with other msgpack-rpc servers.
"""


def session(transport_type="stdio", *args, **kwargs):
    loop = EventLoop(transport_type, *args, **kwargs)
    msgpack_stream = MsgpackStream(loop)
    async_session = AsyncSession(msgpack_stream)
    session = Session(async_session)
    session.request(b"nvim_set_client_info",
                    *get_client_info("client", "remote", {}),
                    async_=True)
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
    """Wrapper to allow api methods to be called like python methods."""
    def __init__(self, obj, api_prefix):
        """Initialize a RemoteApi with object and api prefix."""
        self._obj = obj
        self._api_prefix = api_prefix

    def __getattr__(self, name):
        """Return wrapper to named api method."""
        return functools.partial(self._obj.request, self._api_prefix + name)


def transform_keyerror(exc):
    if isinstance(exc, NvimError):
        if exc.args[0].startswith("Key not found:"):
            return KeyError(exc.args[0])
        if exc.args[0].startswith("Invalid option name:"):
            return KeyError(exc.args[0])
    return exc


class RemoteMap(object):
    """Represents a string->object map stored in Nvim.

    This is the dict counterpart to the `RemoteSequence` class, but it is used
    as a generic way of retrieving values from the various map-like data
    structures present in Nvim.

    It is used to provide a dict-like API to vim variables and options.
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


class RemoteSequence(object):
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
        """
        self._fetch = functools.partial(session.request, method)

    def __len__(self):
        """Return the length of the remote sequence."""
        return len(self._fetch())

    def __getitem__(self, idx):
        """Return a sequence item by index."""
        if not isinstance(idx, slice):
            return self._fetch()[idx]
        return self._fetch()[idx.start:idx.stop]

    def __iter__(self):
        """Return an iterator for the sequence."""
        items = self._fetch()
        for item in items:
            yield item

    def __contains__(self, item):
        """Check if an item is present in the sequence."""
        return item in self._fetch()


def _identity(obj, session, method, kind):
    return obj


def decode_if_bytes(obj, mode=True):
    """Decode obj if it is bytes."""
    if mode is True:
        mode = unicode_errors_default
    if isinstance(obj, bytes):
        return obj.decode("utf-8", errors=mode)
    return obj


def walk(fn, obj, *args, **kwargs):
    """Recursively walk an object graph applying `fn`/`args` to objects."""
    if type(obj) in [list, tuple]:
        return list(walk(fn, o, *args) for o in obj)
    if type(obj) is dict:
        return dict(
            (walk(fn, k, *args), walk(fn, v, *args)) for k, v in obj.items())
    return fn(obj, *args, **kwargs)


# }}}
