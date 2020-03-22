#!/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import os
from pathlib import Path
import vim

logger = logging.getLogger(name=__name__)


class FileLink:
    def __init__(self, logger=None):
        """Initialize a file object."""
        # Damnit why isnt it recognizing this as a func? this is the missing link
        self.path_obj = vim.eval("nvim_get_current_buf()")
        if logger is not None:
            self.logger = logger

    def __repr__(self):
        return "{!r}".format(self._path_file())

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

    def true_file(self, path_obj):
        """Implement a command that opens and resolves a symlink."""
        if self._is_symlink:
            real_file = self._resolved_path()
            dirname = real_file.parent
            vim.chdir(str(dirname))
            vim.command("edit" + str(real_file))


def _setup_logging(level):
    logger = logging.getLogger(name="rplugin/python3/follow_links")
    logger.setLevel(level)
    if os.environ.get("NVIM_PYTHON_LOG_FILE"):
        log_file = os.environ.get("NVIM_PYTHON_LOG_FILE")
    else:
        pass
    try:
        hdlr = logging.FileHandler(log_file)
    except Exception:
        pass
    else:
        logger.addHandler(hdlr)
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
    hdlr.setFormatter(formatter)
    return logger


def list_buf():
    """Return the Vimscript function :func:`nvim_list_bufs()`.

    Returns
    --------
    bufnrs : list of ints
        Currently loaded buffers

    Examples
    --------
    .. code-block:: vim

        :ListBuf
        " With one open buffer the output will be [1]
        " Note that this could be any list of integers

    """
    bufnrs = vim.command("call nvim_list_bufs()")
    return bufnrs


def main():
    """Set everything up."""
    cur_file = FileLink()

    if cur_file.is_symlink:
        cur_file.true_file()


if __name__ == "__main__":
    log_levels = {
        "debug": logging.DEBUG,
        "info": logging.INFO,
        "warning": logging.WARNING,
        "error": logging.ERROR,
        "critical": logging.CRITICAL,
    }
    LOGGER = _setup_logging(log_levels["warning"])
    main()
