" ============================================================================
    " File: powershell.vim
    " Author: Faris Chugthai
    " Description: Powershell modifications
    " Last Modified: May 19, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_powershell_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_powershell_after_ftplugin = 1

" Options: {{{1
setlocal commentstring=#\ %s

let b:undo_ftplugin = 'set cms<'
