#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Initialize pythonx in neovim."""
import logging
import os
import sys
from collections import namedtuple
from importlib.machinery import PathFinder
from io import StringIO

try:
    import pynvim
except ImportError:
    pass
else:
    from pynvim import attach, LegacyVim, stdio_session


# try:
#     import vim  # noqa pylint:disable=import-error,unused-import
# except ImportError:
#     session = stdio_session()
#     vim = LegacyVim.from_session(session)

__docformat__ = "reStructuredText"

logger = logging.getLogger(__name__).addHandler(logging.StreamHandler())

# file not defined? fuck
# sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


class Options:
    aggressive = 1
    diff = False
    experimental = True
    in_place = True
    # indent_size = int(vim.eval("&tabstop"))
    line_range = None
    hang_closing = False
    pep8_passes = 100
    recursive = False
    verbose = 0


alt_options = namedtuple(
    "alt_options",
    field_names=(
        "aggressive",
        "diff",
        "experimental",
        "in_place",
        "ignore",
        "pep8_passes",
        "line_range",
    ),
)

# so thats how you do this
# moved here because importing pkg_resources is expensive
# import pkg_resources
# distribution = pkg_resources.get_distribution("pynvim")
# __version__ = distribution.version

