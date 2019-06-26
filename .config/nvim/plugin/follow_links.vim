" ============================================================================
    " File: follow_links.vim
    " Author: Faris Chugthai
    " Description: Follow links
    " Last Modified: Jun 26, 2019
" ============================================================================

" Guards: {{{1
if exists('g:loaded_follow_links') || &compatible
    finish
endif
let g:loaded_pydoc_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Commands: {{{1
" test:
" command! Follow

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
