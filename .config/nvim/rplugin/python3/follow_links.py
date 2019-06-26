#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Open a file, check if symlink, if so follow link and cd to dir.

Honestly don't know what to do to make this work.
"""
import logging
import os
from os.path import join, realpath, pardir
from pathlib import Path
import sys

import pynvim

logger = logging.getLogger(name=__name__)


@pynvim.plugin
class FileLink():
    """FileLink because it may be an IPython class.

    Could we have files display with an embedded link?

    .. note::

        nvim.__init_subclass__() can not take any keyword arguments.

    """

    def __init__(self, nvim, logger=None):
        """Initialize a file object."""
        self.nvim = nvim
        self.path_obj = self.nvim.current.buffer.name

    def _path_file(self):
        """Pathify a file."""
        return Path(self.path_obj)

    def _check_symlink(self):
        """Check if `path_obj` is a symlink."""
        return self._path_file().is_symlink()

    def _resolved_path(self):
        return self._path_file().resolve()

    @pynvim.command(name='Follow', nargs=1, complete='file')
    def true_file(self, path_obj):
        """Implement a command that opens and resolves a symlink."""
        if self._check_symlink():
            real_file = self._resolved_path()
            dirname = real_file.parent
            self.nvim.chdir(str(dirname))
            self.nvim.command('edit' + str(real_file))


def _setup_logging(level):
    logger = logging.getLogger(name='rplugin/python3/follow_links')
    logger.setLevel(level)
    if os.environ.get('NVIM_PYTHON_LOG_FILE'):
        log_file = os.environ.get('NVIM_PYTHON_LOG_FILE')
    else:
        # log_file = sys.stdout
        # log_dir = realpath(join(__file__, pardir, 'log'))
        # if not os.path.exists(log_dir):
        # os.makedirs(log_dir)
        # log_file = os.path.join(log_dir, 'lint.log')
        pass
    try:
        hdlr = logging.FileHandler(log_file)
    except:
        pass
    else:
        logger.addHandler(hdlr)
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
    hdlr.setFormatter(formatter)
    return logger


@pynvim.autocmd('BufEnter')
def main():
    args = sys.argv[:]
    log_levels = {
        'debug': logging.DEBUG,
        'info': logging.INFO,
        'warning': logging.WARNING,
        'error': logging.ERROR,
        'critical': logging.CRITICAL,
    }
    if len(args) < 1:
        LOGGER = _setup_logging(log_levels['warning'])

    FileLink(LOGGER)


if __name__ == '__main__':
    main()
