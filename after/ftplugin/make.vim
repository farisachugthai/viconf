" ============================================================================
    " File: make.vim
    " Author: Faris Chugthai
    " Description: Set correct filetype settings for makefiles.
    " Last Modified: May 30, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_make_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_make_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1
"
" Otherwise your make commands won't work.
setlocal noexpandtab
setlocal tabstop=8
setlocal softtabstop=8
setlocal shiftwidth=8

" atexit: {{{1

let b:undo_ftplugin = 'set et< ts< sts< sw<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
