#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The help docs from the nvim remote help files.

Landed on it from $NVIM_RPLUGIN_MANIFEST I believe.
"""
import sys

try:
    import pynvim
except ImportError:  # let's not use ModuleNotFoundError because that limit us to 3.7
    sys.exit("Pynvim isn't installed. Exiting.")
else:
    # forgot this was a thing!
    from pynvim import setup_logging


@pynvim.plugin
class Limit(object):
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
            'Command: Called %d times, args: %s, range: %s' % (self.calls, args, range))


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
