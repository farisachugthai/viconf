#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Try to set up a pydoc remote plugin.

Apr 18, 2019
It works!

Currently it opens up a new tab with your info.

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

06/02/2019:

The only thing that PythonJedi does is determine py2 or 3. So we can skip that.
jedi_vim is the pythonx file that jedi loads to call this function. 

py_import_completions()::

    @catch_and_print_exceptions
    def py_import_completions():
        argl = vim.eval('a:argl')
        try:
            import jedi
        except ImportError:
            print('Pyimport completion requires jedi module: https://github.com/davidhalter/jedi')
            comps = []
        else:
            text = 'import %s' % argl
            script = jedi.Script(text, 1, len(text), '', environment=get_environment())
            comps = ['%s%s' % (argl, c.complete) for c in script.completions()]
        vim.command("return '%s'" % '\n'.join(comps))

Let's initialize a :class:`jedi.Script()` object, and return whatever we get by running a
list comprehension over the completions data attribute of our :class:`jedi.Script()`
object.

*PHEW* we're getting closer.

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
class Pydoc:
    """Read output from :mod:`pydoc` into a buffer."""

    def __init__(self, vim, env=None):
        """Initialize the class."""
        self.vim = vim
        if env is not None:
            self.env = env
        else:
            self.env = os.environ.items()

    @pynvim.command('Pydoc', nargs=1)
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
    # should check for xdg data home existing too. probably should make this
    # its own function
    if not os.environ.get('NVIM_PYTHON_LOG_FILE'):
        os.environ.putenv(
            'NVIM_PYTHON_LOG_FILE',
            os.path.join(os.environ.get('XDG_DATA_HOME'), '', 'nvim',
                         'python.log'))
    setup_logging(name='rplugin/python3/pydoc')

    pydoc_plugin = Pydoc()
