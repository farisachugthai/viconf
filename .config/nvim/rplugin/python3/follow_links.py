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
    """

    def __init__(self, vim, logger=None):
        """Initialize a file object."""
        self.vim = vim
        self.path_obj = vim.current.buffer.name
        self.logger = logger

    # i did this wrong somehow.
    # so do we implement this as a a function with an autocmd yeah actually
    # that's probably it
    # def follow_edit(self, fobj):
    #     self.fobj = fobj
    #     # self.Path = Path(fobj)
    #     path_obj = Path(self.fobj)

    def _path_file(self, linked_file):
        """Pathify a file."""
        return Path(linked_file)

    def _check_symlink(self, path_obj):
        """Check if `path_obj` is a symlink."""
        return path_obj.is_symlink()

    def _resolved_path(self, path_obj):
        return path_obj.resolve()

    @pynvim.command(name='Follow', nargs=1, complete='file')
    def true_file(self, path_obj):
        _link_file = self._path_file(path_obj)
        if self._check_symlink(_link_file):
            real_file = self._resolved_path(_link_file)
            dirname = Path.absolute(_link_file.parent)
            self.vim.chdir(dirname)
            self.vim.command('edit' + real_file)


def _setup_logging(level):
    logger = logging.getLogger(name=__name__)
    logger.setLevel(level)
    if os.environ.get('NVIM_PYTHON_LOG_FILE'):
        log_file = os.environ.get('NVIM_PYTHON_LOG_FILE')
    else:
        log_file = sys.stdout
    log_dir = realpath(join(__file__, pardir, 'log'))
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)
    log_file = os.path.join(log_dir, 'lint.log')
    hdlr = logging.FileHandler(log_file)
    logger.addHandler(hdlr)
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
    hdlr.setFormatter(formatter)
    return logger


@pynvim.autocmd(
    'BufEnter', 'BufNewFile', eval='getftype(expand("<afile>"))==#link')
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
        logger = _setup_logging(log_levels['warning'])

    FileLink(logger)


if __name__ == '__main__':
    main()
