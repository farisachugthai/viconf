#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Initialize pythonx in neovim."""
from importlib.machinery import PathFinder
from io import StringIO
import logging
import os
import sys

try:
    import pynvim
    from pynvim import api, attach
except ImportError:
    pass

import vim  # noqa pylint:disable=import-error,unused-import


__docformat__ = "reStructuredText"

logger = logging.getLogger(__name__).addHandler(logging.StreamHandler())

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

if not getattr(vim, "find_module", None):
    vim.find_module = PathFinder.find_module


class Options:
    aggressive = 1
    diff = False
    experimental = True
    ignore = vim.eval("g:pymode_lint_ignore")
    in_place = True
    indent_size = int(vim.eval("&tabstop"))
    line_range = None
    hang_closing = False
    max_line_length = int(vim.eval("g:pymode_options_max_line_length"))
    pep8_passes = 100
    recursive = False
    select = vim.eval("g:pymode_lint_select")
    verbose = 0


def fix_file(buffer, options):
    # TODO
    pass


fix_file(vim.current.buffer.name, Options)


def get_documentation(vim):
    """Search documentation and append to current buffer."""
    # is sys.stdout needed at all below?
    sys.stdout, _ = StringIO(), sys.stdout
    help(vim.eval("a:word"))
    sys.stdout, out = _, sys.stdout.getvalue()
    vim.current.buffer.append(str(out).splitlines(), 0)
