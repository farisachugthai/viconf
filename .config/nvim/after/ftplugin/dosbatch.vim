" ============================================================================
    " File: dosbatch.vim
    " Author: Faris Chugthai
    " Description: Dosbatch modifications
    " Last Modified: May 23, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_dosbatch_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_dosbatch_after_ftplugin = 1

" Options: {{{1
setlocal commentstring=::\ %s

let b:undo_ftplugin = 'set cms<'
