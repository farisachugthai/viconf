#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Arguably this module is to show off how great the neovim API is.

There are enough new functions that deserve mention; however, I'm going to start
with the intersersed ones with minimal documentation or odd argument types.


I really need to practice writing classes more.

What were good reasons for writing a class that doesn't do anything?
Or only defines an init?? I think that was in MIT600.

Shit. This is probably gonna be hard really soon.
"""
import sys

try:
    import pynvim
except ImportError:  # Probably ModuleNotFound too but import is more backwards compatible
    sys.exit("Pynvim python library isn't installed. Exiting.")


@pynvim.plugin
class App:
    """Instantiate an object and bind functions to it's ns as properties."""

    def __init__(self, vim):
        self.vim = vim


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
    pass


@pynvim.command('ListBuf', nargs=0)
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
    bufnrs = vim.command('call nvim_list_bufs()')
    return bufnrs
