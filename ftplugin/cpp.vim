" Vim filetype plugin file
" Language:	C++
" Maintainer: Faris Chugthai
" Previous Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change: Nov 06, 2019

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Behaves just like C
" But don't use the exclamation mark
runtime ftplugin/c.vim ftplugin/c_*.vim ftplugin/c/*.vim

" Also account for my mods
runtime after/ftplugin/c.vim
