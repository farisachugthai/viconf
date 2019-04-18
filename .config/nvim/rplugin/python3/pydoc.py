#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Try to set up a pydoc remote plugin.

Apr 18, 2019
It works!

So currently it opens up a new tab with your info.

If we decide to make this a full plugin distribute it as it's own filetype
and distribute your own syntax highlighting.

In addition it'd be considerate if we added in:

A) options for vsplit, hsplit or open in a tab and
B) a mapping to ``<LocalLeader>`` or to :kbd:`K`.
C) Cmdline completion.

"""
import sys
try:
    import pynvim
except ModuleNotFoundError:
    sys.exit("Pynvim isn't installed. Exiting.")


@pynvim.plugin
class Pydoc(object):
    """Read output from :mod:`pydoc` into a buffer."""

    def __init__(self, vim):
        """Initialize the class."""
        self.vim = vim

    @pynvim.command('Pydoc', nargs=1)
    def command_handler(self, args):
        """Open a new tab with the pydoc output."""
        self.vim.command('tabe')
        self.vim.command('r!pydoc ' + args[0])
        self.vim.command('set ft=man')
