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

"""
import logging
import os
from pathlib import Path
import sys

try:
    import pynvim  # noqa F401
except ImportError:
    import vim
else:
    from pynvim import setup_logging

from .Neovim import *
from .pydoc import *


def check_and_set_envvar(envvar, default=None):
    """Maintenance and housekeeping of the OS.

    Parameters
    ----------
    envvar : str
        Environment variable to check.
    default : str, optional
        If environment variable doesn't exist, set it to ``default``.
    """
    if not os.environ.get(envvar):
        logging.debug(envvar + " not set.")
        if default:
            os.environ.setdefault(envvar, default)
            logging.info(envvar + " set to: " + default)
    else:
        logging.debug(envvar + " already set to value of: " + os.environ.get(envvar))


def main():
    """Setup logging, ensure the correct environment variables are set up.

    Returns
    -------
    TODO

    """
    home = Path.home()
    if sys.platform == 'linux':
        xdg_data_default = str(home.joinpath('.local/share/'))
    elif sys.platform.startswith('win'):
        xdg_data_default = str(home.joinpath('AppData/Local/'))
    check_and_set_envvar('XDG_DATA_HOME', default=xdg_data_default)

    nvim_log_file = Path(xdg_data_default).joinpath('nvim/python.log')
    check_and_set_envvar('NVIM_PYTHON_LOG_FILE', default=nvim_log_file)

    nvim_log_level = 20
    check_and_set_envvar('NVIM_PYTHON_LOG_LEVEL', default=nvim_log_level)


if __name__ == "__main__":
    main()
