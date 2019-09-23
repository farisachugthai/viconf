#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The help docs from the nvim remote help files.

Landed on it from $NVIM_RPLUGIN_MANIFEST I believe.
"""
import sys
import pynvim


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
            'Command: Called %d times, args: %s, range: %s' % (self.calls,
                                                                args,
                                                                range))


if __name__ == "__main__":
    # Holy shit running `:py3f %` on this file echoes out the message!
    vim.command('echo "did this work at all?"')
