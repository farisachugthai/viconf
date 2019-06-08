#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The remote plugin example from nvim.

Thanks guys!

In remote_plugin.txt

==============================================================================
3. Example                          *remote-plugin-example*

The best way to learn about remote plugins is with an example, so let's see
what a Python plugin looks like. This plugin exports a command, a function, and
an autocmd. The plugin is called 'Limit', and all it does is limit the number
of requests made to it. Here's the plugin source code:


Apr 15, 2019

This module does in fact work and confused the hell out of me when it started firing.
"""
import sys
try:
    import pynvim
except ModuleNotFoundError:
    sys.exit("Pynvim isn't installed. Exiting.")


@pynvim.plugin
class Count(object):
    """Cross your fingers."""

    def __init__(self, vim):
        """Initialize the class."""
        self.vim = vim
        self.calls = 0

    @pynvim.command('Cmd', range='', nargs='*', sync=True)
    def command_handler(self, args, range):
        self._increment_calls()
        self.vim.current.line = (
            'Command: Called %d times, args: %s, range: %s' %
            (self.calls, args, range))

    # @pynvim.autocmd(
    #     'BufEnter', pattern='*.py', eval='expand("<afile>")', sync=True)
    # def autocmd_handler(self, filename):
    #     self._increment_calls()
    #     self.vim.current.line = (
    #         'Autocmd: Called %s times, file: %s' % (self.calls, filename))

    @pynvim.function('Func')
    def function_handler(self, args):
        self._increment_calls()
        self.vim.current.line = ('Function: Called %d times, args: %s' %
                                 (self.calls, args))

    def _increment_calls(self):
        if self.calls == 5:
            raise Exception('Too many calls!')
        self.calls += 1
