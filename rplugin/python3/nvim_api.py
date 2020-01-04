#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The help docs from the nvim remote help files.

Landed on it from $NVIM_RPLUGIN_MANIFEST I believe.

:date: Apr 18, 2019

.. highlight:: vim

Currently this module opens up a new tab with your info.

Roadmap
========

If we decide to make this a full plugin, distribute it as it's own filetype,
then we might wanna distribute your own syntax highlighting.

In addition it'd be considerate if we added in:

A) Options for ``vsplit``, ``hsplit`` or ``open`` in a tab and
B) A mapping to ``<LocalLeader>`` or to :kbd:`K`.
C) Cmdline completion.

Cmdline Completion
===================

Apr 19, 2019:

Figure out if this'll work for the completer.

.. code-block:: vim

    let l:old_path = &path
    set path=''
    let &path = sys.prefix + '**,'
    command -complete=file_in_path

I mean don't intermix langs like that but that general idea.


Setting up completions for pydoc
--------------------------------

Jedi can do it with the Pyimport command.::

    function! jedi#py_import_completions(argl, cmdl, pos) abort
        PythonJedi jedi_vim.py_import_completions()
    endfun

The only thing that PythonJedi does is determine py2 or 3. So we can skip that.
jedi_vim is the pythonx file that jedi loads to call this function.

py_import_completions()::

    @catch_and_print_exceptions
    def py_import_completions():
        argl = vim.eval('a:argl')
        try:
            import jedi
        except ImportError:
            print('Pyimport completion requires jedi module:'
            ' https://github.com/davidhalter/jedi')
            comps = []
        else:
            text = 'import %s' % argl
            script = jedi.Script(text, 1, len(text), '',
                                 environment=get_environment())
            comps = ['%s%s' % (argl, c.complete) for c in script.completions()]
        vim.command("return '%s'" % '\n'.join(comps))

Let's initialize a :class:`jedi.Script()` object, and return whatever we
get by running a list comprehension over the completions data attribute of
our :class:`jedi.Script()` object.

*PHEW* we're getting closer.

"""
import os
import sys

try:
    import pynvim
except ImportError:  # let's not use ModuleNotFoundError because that limit us to 3.7
    sys.exit("Pynvim isn't installed. Exiting.")
else:
    # forgot this was a thing!
    from pynvim import setup_logging


@pynvim.plugin
class Limit:
    """From `:he remote-plugin-host`."""
    def __init__(self, vim, calls=0):
        """Initialize the plugin.

        Parameters
        ----------
        vim : obj
            The Vim instance
        calls : int
            Number of calls to the instance.

        """
        self.vim = vim
        self.calls = 0

    @pynvim.command('Cmd', range='', nargs='*', sync=True)
    def command_handler(self, args, range):
        self._increment_calls()
        self.vim.current.line = (
            'Command: Called %d times, args: %s, range: %s' %
            (self.calls, args, range))


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


if __name__ == "__main__":
    # should check for xdg data home existing too. probably should make this
    # its own function
    if not os.environ.get('NVIM_PYTHON_LOG_FILE'):
        os.environ.putenv(
            'NVIM_PYTHON_LOG_FILE',
            os.path.join(os.environ.get('XDG_DATA_HOME'), '', 'nvim',
                         'python.log'))
    setup_logging(name='rplugin.python3.pydoc')

    pydoc_plugin = Pydoc()

    # Holy shit running `:py3f %` on this file echoes out the message!
    # vim.command('echo "did this work at all?"')
