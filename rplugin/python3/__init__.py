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
import pkg_resources

pkg_resources.declare_namespace(__name__)
# new neovim module and fallback
try:
    import pynvim
except (ImportError, ModuleNotFoundError):
    try:
        import neovim
    except (ImportError, ModuleNotFoundError):
        sys.exit('Neither pynvim or neovim installed.')

# try:
#     from nvim_api import EmbeddedNvimShell
# except Exception as e:
#     print(e)

# So we haven't exited yet so let's go.

logging.basicConfig(level=logging.INFO)


def rplugin_attach():
    """Let's define a basic function to initialize everything."""
    global_nvim = pynvim.attach('socket',
                                path=os.environ['NVIM_LISTEN_ADDRESS'])
    return global_nvim


# Only run this if we don't have an open channel.
if not os.environ.get('NVIM_LISTEN_ADDRESS'):
    nvim = rplugin_attach()
