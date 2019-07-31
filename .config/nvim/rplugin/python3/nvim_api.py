#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Helper functions and commands for the nvim API."""
import atexit
from io import StringIO
import logging
import os
import tempfile

import IPython
from IPython.core.profiledir import ProfileDir
from IPython.core.interactiveshell import InteractiveShell
# from pynvim.api.nvim import NeovimError
from traitlets.config import Config
import pynvim
# import vim  # pylint:disable=import-error,unused-import

logging.getLogger(name=__name__)


@pynvim.plugin
class EmbeddedNvimShell:
    """Copy paste IPython.sphinxext.plugin.EmbeddedSphinxShell."""

    def __init__(self, nvim):
        self.nvim = nvim

    def init(self, exec_lines=None):
        """Do the real initialization here."""
        self.cout = StringIO()

        if exec_lines is None:
            exec_lines = []

        # Create config object for IPython
        config = Config()
        config.HistoryManager.hist_file = ':memory:'
        config.InteractiveShell.autocall = False
        config.InteractiveShell.autoindent = False
        config.InteractiveShell.colors = 'NoColor'

        # create a profile so instance history isn't saved
        tmp_profile_dir = tempfile.mkdtemp(prefix='profile_')
        profname = 'auto_profile_sphinx_build'
        pdir = os.path.join(tmp_profile_dir, profname)
        profile = ProfileDir.create_profile_dir(pdir)

        # Create and initialize global ipython, but don't start its mainloop.
        # This will persist across different EmbeddedSphinxShell instances.
        IP = InteractiveShell.instance(config=config, profile_dir=profile)
        atexit.register(self.cleanup)

        # Store a few parts of IPython we'll need.
        self.IP = IP
        self.user_ns = self.IP.user_ns
        self.user_global_ns = self.IP.user_global_ns

        self.input = ''
        self.output = ''
        self.tmp_profile_dir = tmp_profile_dir

        self.is_verbatim = False
        self.is_doctest = False
        self.is_suppress = False

        # Optionally, provide more detailed information to shell.
        # this is assigned by the SetUp method of IPythonDirective
        # to point at itself.
        #
        # So, you can access handy things at self.directive.state
        self.directive = None

        # on the first call to the savefig decorator, we'll import
        # pyplot as plt so we can make a call to the plt.gcf().savefig
        self._pyplot_imported = False

        # Prepopulate the namespace.
        for line in exec_lines:
            self.process_input_line(line, store_history=False)

    @pynvim.command('IPython', range='', nargs='*')
    def entry_point(self, rang, args):
        self.nvim.current.buffer = self.nvim.command('enew')
        return self.init()


def start_ipython():
    """Try embedding IPython in Neovim in a simpler manner."""
    return IPython.start_ipython(colors=None)
