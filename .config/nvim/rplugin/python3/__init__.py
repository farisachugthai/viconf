#!/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import os
import sys

# new neovim module and fallback
try:
    import pynvim
except ImportError:
    try:
        import neovim
    except ImportError:
        sys.exit('Neither pynvim or neovim installed.')

# legacy vim interface
# NOPE can't do this anymore
# import vim
import personal_rpc
