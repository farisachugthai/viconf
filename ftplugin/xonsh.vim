" ============================================================================
  " File: xonsh.vim
  " Author: Faris Chugthai
  " Description: Xonsh ftplugin
  " Last Modified: November 29, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1


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
" Is this a thing?
" unlet b:did_syntax
setlocal syntax=xonsh

syntax sync fromstart

setlocal foldmethod=indent

let b:undo_ftplugin = 'setlocal foldmethod< '
      \ . '|unlet! b:undo_ftplugin'
