" ============================================================================
  " File: xml.vim
  " Author: Faris Chugthai
  " Description: xml ftplugin
  " Last Modified: May 08, 2020
" ============================================================================

let g:xml_syntax_folding = 1

if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/xml.vim
source $VIMRUNTIME/indent/xml.vim

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                      \. '|setlocal ofu<'
                      \. '|unlet! b:undo_ftplugin'
                      \. '|unlet! b:did_ftplugin'
