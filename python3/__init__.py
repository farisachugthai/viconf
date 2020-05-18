#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Initialize pythonx in neovim."""
__docformat__ = "reStructuredText"

import logging
import os
import sys
from collections import namedtuple
from importlib.machinery import PathFinder
from io import StringIO
from pathlib import Path

logger = logging.getLogger(__name__).addHandler(logging.StreamHandler())

# root = Path.cwd().parent
# sys.path.insert(0, root.joinpath("python3").__fspath__())


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
