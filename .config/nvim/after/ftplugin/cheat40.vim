" ============================================================================
    " File: cheat40.vim
    " Author: Faris Chugthai
    " Description: Ftplugin mod for cheat40 window
    " Last Modified: May 26, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_cheat40_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_cheat40_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

" Based on the plugin created by lifepillar/vim-cheat40
setlocal number
setlocal relativenumber
setlocal expandtab
setlocal wrap

" Kinda works. Statusline doesn't revert correctly though.
let &statusline = ' %{&ft} '

" What is the abbreviation of nowrap? :set nowr<Tab> shows multiple choices.
let b:undo_ftplugin = 'set nu< rnu< et< wrap<
      \ unlet statusline'

let &cpoptions = s:cpo_save
unlet s:cpo_save
