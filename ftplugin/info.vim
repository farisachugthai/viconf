" =======================================================================
  " File: info.vim
  " Author: Faris Chugthai
  " Description: info files
  " Last Modified: May 14, 2020
" =======================================================================

if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/help.vim


let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                      \. '|setlocal syntax<'
                      \. '|unlet! b:undo_ftplugin'
                      \. '|unlet! b:did_ftplugin'

