" ============================================================================
  " File: xonsh.vim
  " Author: Faris Chugthai
  " Description: Xonsh ftplugin
  " Last Modified: November 29, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" Sourcing Everything: {{{1
source $VIMRUNTIME/ftplugin/python.vim
unlet! b:did_ftplugin

let s:this_dir = fnameescape(fnamemodify(expand('<sfile>'), ':p:h'))

exec 'source ' . s:this_dir . '/python.vim'

" Options: {{{1
setlocal syntax=xonsh

syntax sync fromstart

setlocal foldmethod=indent
setlocal suffixesadd+=,.xsh,.xonshrc,

" Atexit: {{{1
let b:undo_ftplugin = 'setlocal fdm< syntax< sua< '
            \ . '|unlet! b:undo_ftplugin'
            \ . '|unlet! b:did_ftplugin'
