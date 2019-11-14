" ============================================================================
    " File: make.vim
    " Author: Faris Chugthai
    " Description: Set correct filetype settings for makefiles.
    " Last Modified: May 30, 2019
" ============================================================================

" Guard: {{{1
let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1
"
" Otherwise your make commands won't work.
setlocal noexpandtab
setlocal tabstop=8
setlocal softtabstop=8
setlocal shiftwidth=8

" Atexit: {{{1

let b:undo_ftplugin = 'setlocal et< ts< sts< sw<'
      \ . '|unlet! b:undo_ftplugin'

let &cpoptions = s:cpo_save
unlet s:cpo_save
