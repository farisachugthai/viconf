#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Arguably this module is to show off how great the neovim API is.
"""
import logging
import os
import sys

# The directory is called python3 i thought this was implied
if sys.version_info < (3, 0):
    sys.exit()

from pathlib import Path

try:
    import pynvim
except (ImportError, ModuleNotFoundError) as e:
    sys.exit(e)


class UnsetEnvvarException(Exception):
    """Exception for trying to cal an unset envvar/one with no value."""

    def __init__(self, *args, **kwargs):
        super().__init__(self, *args, **kwargs)


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


def attach_nvim(how="socket", path=None):
    """Ensure you don't execute this from inside neovim or it'll emit an error."""
    from pynvim import attach

    return attach("socket", path=nvim_listen_address())


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
        logging.debug(envvar + " already set to value of: " + os.environ.get(envvar))


def main():
    """Set logging, ensure the correct environment variables are set up.

    Returns
    -------
    TODO

    """
    home = Path.home()
    if sys.platform == "linux":
        xdg_data_default = str(home.joinpath(".local/share/"))
    elif sys.platform.startswith("win"):
        xdg_data_default = str(home.joinpath("AppData/Local/"))
    else:
        raise NotImplementedError("Windows, Android and Linux only.")

    check_and_set_envvar("XDG_DATA_HOME", default=xdg_data_default)

    nvim_log_file = Path(xdg_data_default).joinpath("nvim/python.log")
    check_and_set_envvar("NVIM_PYTHON_LOG_FILE", default=nvim_log_file)

    nvim_log_level = 20
    check_and_set_envvar("NVIM_PYTHON_LOG_LEVEL", default=nvim_log_level)
