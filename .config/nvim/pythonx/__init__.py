#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Initialize pythonx in neovim."""
import logging
import os
import sys

import vim

logging.getLogger(__name__).addHandler(logging.NullHandler())

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
