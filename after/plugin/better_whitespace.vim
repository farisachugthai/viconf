" ============================================================================
  " File: better_whitespace.vim
  " Author: Faris Chugthai
  " Description: A description of the file below
  " Last Modified: October 26, 2019
" ============================================================================

" Guard: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=C

if !exists('g:better_whitespace_enabled')
  finish
endif

" Options: {{{1

let g:strip_whitespace_on_save = 1

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
