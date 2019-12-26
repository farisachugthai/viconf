" ============================================================================
  " File: gitconfig.vim
  " Author: Faris Chugthai
  " Description: git config files
  " Last Modified: December 24, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

setlocal et
setlocal softtabstop=4
setlocal tabstop=4
setlocal shiftwidth=4

syntax sync fromstart
syntax include $VIMRUNTIME/syntax/dosini.vim

let b:undo_ftplugin = 'setlocal sw< et< sts< ts< '
      \ . '|unlet! b:undo_ftplugin'
