#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Open a file, check if symlink, if so follow link and cd to dir.

.. module:: follow_links

.. highlight:: vim

Honestly don't know what to do to make this work.

Well now you can open up nvim and run::

    terminal
    ipython -i --pdb follow_links.py

And it'll execute without errors which is nice.

Nov 03, 2019:

    Holy shit I may have gotten this working.

"""
import logging
import os
from pathlib import Path
import pynvim

logger = logging.getLogger(name=__name__)


@pynvim.plugin
class FileLink:
    def __init__(self, nvim, logger=None):
        """Initialize a file object."""
        self.nvim = nvim
        # Damnit why isnt it recognizing this as a func? this is the missing link
        self.path_obj = nvim.call('nvim_get_current_buf()')
        if logger is not None:
            self.logger = logger

    def __repr__(self):
        return '{!r}'.format(self._path_file())

    def _path_file(self):
        """Pathify a file."""
        return Path(self.path_obj)

    @property
    def is_symlink(self):
        """Check if `path_obj` is a symlink."""
        return self._path_file().is_symlink()

    def _resolved_path(self):
        return self._path_file().resolve()

    @property
    def dirname(self):
        """Get the buffers directory."""
        real_file = self._resolved_path()
        if real_file:
            return real_file.parent

    @pynvim.command(name='Follow', nargs=1, complete='file')
    def true_file(self, path_obj):
        """Implement a command that opens and resolves a symlink."""
        if self._is_symlink:
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
    except Exception:
        pass
    else:
        logger.addHandler(hdlr)
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
    hdlr.setFormatter(formatter)
    return logger


@pynvim.autocmd('BufEnter')
def main():
    """Set everything up."""
    log_levels = {
        'debug': logging.DEBUG,
        'info': logging.INFO,
        'warning': logging.WARNING,
        'error': logging.ERROR,
        'critical': logging.CRITICAL,
    }
    LOGGER = _setup_logging(log_levels['warning'])
    # if os.environ.get('NVIM_LISTEN_ADDRESS'):
    #     nvim = pynvim.attach('socket', path=os.environ['NVIM_LISTEN_ADDRESS'])
    # else:
    #     nvim = None

    cur_file = FileLink(pynvim.Nvim, logger=LOGGER)

    if cur_file.is_symlink:
        cur_file.true_file()


if __name__ == '__main__':
    main()
