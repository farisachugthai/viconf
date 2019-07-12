#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Didn't realize I hadn't made an __init__ for this directory yet.

.. admonition::

    Don't import vim! That works in the ../../pythonx/ directory but crashes the
    remote host if used here.

"""
import logging
import os
import sys

# new neovim module and fallback
try:
    import pynvim
except (ImportError,ModuleNotFoundError):
    try:
        import neovim
    except (ImportError,ModuleNotFoundError):
        sys.exit('Neither pynvim or neovim installed.')

try:
    from nvim_api import EmbeddedNvimShell
except Exception as e:
    print(e)
