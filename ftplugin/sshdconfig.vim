" ============================================================================
  " File: sshdconfig.vim
  " Author: Faris Chugthai
  " Description: sshd ftplugin
  " Last Modified: March 10, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

source $VIMRUNTIME/ftplugin/sshconfig.vim

" They defined an undo ftplugin so we should have one already
" However they didn't add this part
let b:undo_ftplugin .= '|unlet! b:did_ftplugin'
                    \. '|unlet! b:undo_ftplugin'
