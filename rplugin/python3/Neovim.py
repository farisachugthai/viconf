#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# import contextlib
import logging
import os
import sys
from pathlib import Path
# Fuck this module is deprecated but in here so many times.
import imp
import io
from importlib import import_module, invalidate_caches
from importlib.util import find_spec, module_from_spec

from pynvim import attach
from pynvim.api import Nvim, walk
from pynvim.msgpack_rpc import ErrorResponse
from pynvim.util import format_exc_skip
from pynvim.plugin.decorators import plugin, rpc_export


if sys.version_info >= (3, 4):
    from importlib.machinery import PathFinder
else:
    PathFinder = None

# Globals:


class App:
    """Instantiate an object and bind functions to it's ns as properties.

    We can bind the :func:`os.environ` to the namespace and maybe also
    :class:`pathlib.Path` so that we can simply have those abstracted
    away and add a ton of built-in methods for use with our class.

    """

    def __init__(self, _vim):
        """Instantiate the remote python process for neovim."""
        self.vim = _vim
        self.env = os.environ
        self.Path = Path


class Instance(App):
    """The namespace <3. rplugin.python3.neovim.App.Instance feels very right.

    In the future I'm gonna need to check how to decorate the
    :func:`Instance.listbuf` function correctly. Like are these 2 blocks
    of code different?::

        >>> @property
        >>> @pynvim.command('Foo')
        >>> def some_wrapped_func(self):
        ...     pass

    And this one.::

        >>> @pynvim.command('Foo')
        >>> @property
        >>> def some_wrapped_func(self):
        ...     pass

    List buf should go into this class but I'm making it a simple func for now.

    Since it doesn't really require self, do we call it a class method?
    Could it be a property?
    """

    # we'll need to do an env check for NVIM_LISTEN_ADDRESS, then attach and
    # that'll be our init method
    # def __init__(self):
    pass


def attach_nvim(how='path'):
    """Ensure you don't execute this from inside neovim or it'll emit an error.
    """
    path = os.environ.get("NVIM_LISTEN_ADDRESS")
    return attach(how, path=path)


def check_and_set_envvar(envvar, default=None):
    """Maintenance and housekeeping of the OS.

    Parameters
    ----------
    envvar : str
        Environment variable to check.
    default : str, optional
        If environment variable doesn't exist, set it to ``default``.

    """
    if not os.environ.get(envvar):
        logging.debug(envvar + " not set.")
        if default:
            os.environ.setdefault(str(envvar), default)
            logging.info(envvar + " set to: " + default)
    else:
        logging.debug(envvar + " already set to value of: " +
                      os.environ.get(envvar))


def setup_envvars():
    """Set logging, ensure the correct environment variables are set up.

    Returns
    -------
    TODO

    """
    home = Path.home()
    if sys.platform == "linux":
        xdg = home.joinpath(".local/share/")
    elif sys.platform.startswith("win"):
        xdg = home.joinpath("AppData/Local/")
    else:
        raise NotImplementedError("Windows, Android and Linux only.")

    xdg_data_default = str(xdg)
    check_and_set_envvar("XDG_DATA_HOME", default=xdg_data_default)

    nvim_log_file = xdg_data_default.joinpath("nvim/python.log")
    check_and_set_envvar("NVIM_PYTHON_LOG_FILE", default=str(nvim_log_file))

    nvim_log_level = "20"  # it actually fuckin throws if you feed it 20 not "20"
    check_and_set_envvar("NVIM_PYTHON_LOG_LEVEL", default=nvim_log_level)


@plugin
class ScriptHost:
    """Provides an environment for running python plugins created for Vim."""

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
                        nvim.current.buffer.api.set_lines(
                            sstart, end, True, newlines)
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
    """todo: Replace me with contextlib.redirect_stdout and redirect_stderr."""

    def __init__(self, redirect_handler):
        self.redirect_handler = redirect_handler

    def write(self, data):
        self.redirect_handler(data)

    def writelines(self, seq):
        self.redirect_handler("\n".join(seq))


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

def discover_runtime_directories(nvim):
    """How can we get rid of all these funcs that require nvim as a parameter?"""
    rv = []
    for rtp in nvim.list_runtime_paths():
        if not os.path.exists(rtp):
            continue
        for subdir in ["pythonx", PYTHON_SUBDIR]:
            path = os.path.join(rtp, subdir)
            if os.path.exists(path):
                rv.append(path)
    return rv


def path_hook(nvim):
    """todo: Flatten this more."""
    def _get_paths():
        if nvim._thread_invalid():
            return []
        return discover_runtime_directories(nvim)

    def hook(path):
        if path == nvim.VIM_SPECIAL_PATH:
            return VimPathFinder
        else:
            raise ImportError

    return hook


class VimModuleLoader:
    """Inexplicably this class and `VimPathFinder` were closures in `path_hook`."""

    def __init__(self, module, path=None):
        self.module = module
        self.path = path

    def load_module(self):
        """Check sys.modules, required for reload (see PEP302).

        Uh no. How about we just implement the loader protocol?
        """
        try:
            return sys.modules[fullname]
        except KeyError:
            pass
        return imp.load_module(fullname, *self.module)


class VimPathFinder:
    # TODO: We gotta define get_paths in this class but seriously every
    # function either implicitly uses `nvim` or requires it as a positional
    # parameter ughh

    def __init__(self, fullname, path=None):
        self.fullname = fullname
        self.path = path if path is not None else''
        # This is a clasmethod so the way you guys set this up was retarded
        self.spec = PathFinder.find_spec(fullname, path) if PathFinder is not None else None

    def find_module(self, fullname, oldtail, path):
        try:
            return self._find_module(fullname, oldtail, path)
        except ImportError:
            return None

    @staticmethod
    def _find_module(fullname, oldtail, path):
        """Method for Python 2.7 and 3.3."""
        # return VimModuleLoader._find_module(fullname, fullname, path or _get_paths())
        idx = oldtail.find(".")
        if idx > 0:
            name = oldtail[:idx]
            tail = oldtail[idx + 1:]
            fmr = imp.find_module(name, path)
            module = imp.find_module(fullname[: -len(oldtail)] + name, *fmr)
            return _find_module(fullname, tail, module.__path__)
        else:
            return imp.find_module(fullname, path)
