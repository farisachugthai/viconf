#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Setting up completions thanks to Jedi.

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


# @pynvim.plugin
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

    # @pynvim.command("Cmd", range="", nargs="*", sync=True)
    def command_handler(self, args, range):
        self._increment_calls()
        self.vim.current.line = "Command: Called %d times, args: %s, range: %s" % (
            self.calls,
            args,
            range,
        )


# @pynvim.plugin
class PydocButUnfortunatelyBroken:
    """Read output from :mod:`pydoc` into a buffer."""

    def __init__(self, vim, env=None):
        """Initialize the class."""
        self.vim = vim
        if env is not None:
            self.env = env
        else:
            self.env = os.environ.items()

    # @pynvim.command("Pydoc", nargs=1)
    def command_handler(self, args):
        """Open a new tab with the pydoc output."""
        self.vim.command("tabe")
        self.vim.command("r!pydoc " + args[0])
        self.vim.command("set ft=man")

