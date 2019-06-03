#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Didn't realize I hadn't made an __init__ for this directory yet.

Also wanted to leave a little inspiration/explanation for you.

In case you're wondering what that setup_logging import is::


    def setup_logging(name):
        # Setup logging according to environment variables.
        logger = logging.getLogger(__name__)
        if 'NVIM_PYTHON_LOG_FILE' in os.environ:
            prefix = os.environ['NVIM_PYTHON_LOG_FILE'].strip()
            major_version = sys.version_info[0]
            logfile = '{}_py{}_{}'.format(prefix, major_version, name)
            handler = logging.FileHandler(logfile, 'w', 'utf-8')
            handler.formatter = logging.Formatter(
                '%(asctime)s [%(levelname)s @ '
                '%(filename)s:%(funcName)s:%(lineno)s] %(process)s - %(message)s')
            logging.root.addHandler(handler)
            level = logging.INFO
            if 'NVIM_PYTHON_LOG_LEVEL' in os.environ:
                lvl = getattr(logging,
                              os.environ['NVIM_PYTHON_LOG_LEVEL'].strip(),
                              level)
                if isinstance(lvl, int):
                    level = lvl
            logger.setLevel(level)


    # Required for python 2.6
    class NullHandler(logging.Handler):
        def emit(self, record):
            pass


    if not logging.root.handlers:
        logging.root.addHandler(NullHandler())

noqa

Yeah I actually really don't like that code.

We should set up our own logging package. *sigh*.

.. admonition::

    Don't import vim! That works in the ../../pythonx/ directory but crashes the
    remote host if used here.


.. todo::

    Jun 03, 2019: As currently set up these files don't get registered as a
    remote plugin

"""
import logging
import os
import sys

try:
    import pynvim  # noqa F401
except ImportError:
    try:
        import neovim
    except ImportError:
        sys.exit('Pynvim not installed.')
else:
    from pynvim import setup_logging
