#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Todo. Open a file, check if symlink, if so follow link and cd to dir.

"""
from pathlib import Path
import pynvim


@pynvim.plugin
class FileLink():
    """FileLink because it may be an IPython class.

    Could we have files display with an embedded link?
    """

    def __init__(self, vim):
        """Initialize a file object."""
        self.vim = vim

    # i did this wrong somehow.
    # so do we implement this as a a function with an autocmd yeah actually
    # that's probably it
    # def follow_edit(self, fobj):
    #     self.fobj = fobj
    #     # self.Path = Path(fobj)
    #     path_obj = Path(self.fobj)

    def _check_symlink(self, path_obj):
        """Check if `path_obj` is a symlink."""
        return path_obj.is_symlink()

    def _resolved_path(self, path_obj):
        return path_obj.resolve()

    @pynvim.autocmd('BufEnter', 'BufNewFile', eval='expand("<afile>")')
    def true_file(self, path_obj):
        if self._check_symlink():
            real_file = self._resolved_path()
            self.vim.command('edit' + real_file)
