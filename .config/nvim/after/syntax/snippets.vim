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


" Syn match: {{{1
syn match snipComment '\_s*\_^#' contains=snipTODO display
