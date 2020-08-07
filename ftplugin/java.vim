" ============================================================================
    " File: java.vim
    " Author: Faris Chugthai
    " Description: java ftplugin
    " Last Modified: Aug 04, 2020
" ============================================================================


if exists('b:did_ftplugin') | finish | endif

" Filetype Specific Options:

  setlocal expandtab
  setlocal tabstop=4 softtabstop=4 shiftwidth=4
  setlocal tagcase=smart
  compiler javac


let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal et< sts< ts< sw<'
      \. '|setlocal tagcase< mp< efm<'

