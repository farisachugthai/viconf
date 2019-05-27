" ============================================================================
    " File: cheat40.vim
    " Author: Faris Chugthai
    " Description: Ftplugin mod for cheat40 window
    " Last Modified: May 26, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_cheat40_after_plugin') || &compatible || v:version < 700
  finish
endif
let b:did_cheat40_after_plugin = 1

" Options: {{{1

" Based on the plugin created by lifepillar/vim-cheat40
setlocal number
setlocal relativenumber
setlocal expandtab
setlocal nowrap

let b:undo_ftplugin = 'set nu< rnu< et< '
