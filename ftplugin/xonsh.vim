" ============================================================================
  " File: xonsh.vim
  " Author: Faris Chugthai
  " Description: Xonsh ftplugin
  " Last Modified: November 29, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" Sourcing Everything: {{{1
runtime $VIMRUNTIME/ftplugin/python.vim
unlet! b:did_ftplugin

runtime ftplugin/python.vim
unlet! b:did_ftplugin

runtime ftplugin/python/*.vim
unlet! b:did_ftplugin

runtime after/ftplugin/python.vim
unlet! b:did_ftplugin

runtime after/ftplugin/python/*.vim
unlet! b:did_ftplugin

runtime $VIMRUNTIME/syntax/python.vim

" Options: {{{1
setlocal syntax=xonsh

syntax sync fromstart

setlocal foldmethod=indent
setlocal suffixesadd+=,.xsh,.xonshrc,

" Atexit: {{{1
let b:undo_ftplugin = 'setlocal foldmethod< syntax< sua< '
            \ . '|unlet! b:undo_ftplugin'
