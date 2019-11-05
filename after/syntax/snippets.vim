" ============================================================================
  " File: snippets.vim
  " Author: Faris Chugthai
  " Description: Fix snippet syntax highlighting.
  " Last Modified: May 31, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_snippets_after_syntax') || &compatible || v:version < 700
  finish
endif
let g:did_snippets_after_syntax = 1

" Idk what i did that this is necessary
runtime syntax/snippets.vim

" Syn Match: {{{1

" We fixed snippet comments!
syn match snipComment '^\W*#.*$' contains=snipComment display

" Let's add a few keywords while we're here.
syntax keyword snipTODO contained todo hack xxx fixme notes note:
