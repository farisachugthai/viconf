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


Setting up completions for pydoc
--------------------------------
Jedi can do it with the Pyimport command.


function! jedi#py_import_completions(argl, cmdl, pos) abort
    PythonJedi jedi_vim.py_import_completions()
endfun


Take apart this function (or call it as your completer) and use that.

"""
import os
import re
import sys
try:
    import pynvim
except ModuleNotFoundError:
    sys.exit("Pynvim isn't installed. Exiting.")
else:
    # forgot this was a thing!
    from pynvim import setup_logging


@pynvim.plugin
class Pydoc(object):
    """Read output from :mod:`pydoc` into a buffer."""

    def __init__(self, vim):
        """Initialize the class."""
        self.vim = vim

    @pynvim.command('Pydoc',
                    nargs=1,
                    complete='customlist,sys.modules().keys()')
    def command_handler(self, args):
        """Open a new tab with the pydoc output."""
        self.vim.command('tabe')
        self.vim.command('r!pydoc ' + args[0])
        self.vim.command('set ft=man')

    @pynvim.autocmd('BufEnter',
                    pattern='Filetype=man',
                    eval='expand("<afile>")')
    def check_buffer_output(self):
        """Make sure the first line isn't an error message."""
        line0 = self.vim.getline(1)  # yes we need to 0 index it!
        nodoc = re.compile('^[nN]o Python documentation.*$')
        matched = nodoc.search(line0)
        if matched:  # damn
            self.vim.command('%d')


if __name__ == "__main__":
    if not os.environ.get('NVIM_PYTHON_LOG_FILE'):
        os.environ.putenv(
            'NVIM_PYTHON_LOG_FILE',
            os.path.join(os.environ.get('XDG_DATA_HOME'), '', 'nvim',
                         'python.log'))
    setup_logging(name=__name__)
