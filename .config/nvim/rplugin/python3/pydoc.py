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

Apr 19, 2019:

    We could try hacking the :class:`~IPython.core.completer.Completer` into
    this script but it'd take a LOT of extra imports.

    Actually we might get away with:

        .. code-block:: vim

            let l:old_path = &path
            set path=''
            let &path = sys.prefix + '**,'
            command -complete=file_in_path

    I mean don't intermix langs like that but that general idea.

"""
import sys
try:
    import pynvim
except ModuleNotFoundError:
    sys.exit("Pynvim isn't installed. Exiting.")


@pynvim.plugin
class Pydoc(object):
    """Read output from :mod:`pydoc` into a buffer."""

    def __init__(self, vim, initial_path):
        """Initialize the class."""
        self.vim = vim
        # Is this legal?
        # self.initial_path = initial_path

    @pynvim.command('Pydoc', nargs=1)
    def command_handler(self, args):
        """Open a new tab with the pydoc output."""
        self.vim.command('tabe')
        self.vim.command('r!pydoc ' + args[0])
        self.vim.command('set ft=man')
