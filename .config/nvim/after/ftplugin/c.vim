" ============================================================================
    " File: c.vim
    " Author: Faris Chugthai
    " Description: The C Programming Language
    " Last Modified: Jul 17, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_c_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_c_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

setlocal suffixesadd='.c'
setlocal suffixesadd+='.h'
setlocal cindent
setlocal makeprg=make\ %<.o
setlocal omnifunc=ccomplete#Complete

" Atexit: {{{1

let b:undo_ftplugin = 'set sua< makeprg< cin<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
