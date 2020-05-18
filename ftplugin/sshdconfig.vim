" ============================================================================
  " File: sshdconfig.vim
  " Author: Faris Chugthai
  " Description: sshd ftplugin
  " Last Modified: March 10, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif
" It feels quite dumb to make a whole file just for this but
" sshdconfig is a distinct filetype from sshconfig and there's no sshdconfig
" file
source $VIMRUNTIME/ftplugin/sshconfig.vim

" It feels quite dumb to make a whole file just for this but
syntax sync fromstart

" They defined an undo ftplugin so we should have one already
" However they didn't add this part
let b:undo_ftplugin .= '|unlet! b:did_ftplugin'
      \ . '|unlet! b:undo_ftplugin'
