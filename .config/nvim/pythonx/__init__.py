#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Initialize pythonx in neovim."""
import logging

try:
    import pynvim as vim
except ImportError:
    import vim

logging.getLogger(__name__).addHandler(logging.NullHandler())
