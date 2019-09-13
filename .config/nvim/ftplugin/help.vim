" ============================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019 
" ============================================================================

" Guard: {{{1
if exists('g:did_help_vim') || &compatible || v:version < 700
  finish
endif
let g:did_help_vim = 1

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

let b:undo_ftplugin = "setl fo< tw< cole< cocu< keywordprg<"

" Options: {{{1

setlocal formatoptions+=tcroql textwidth=78
if has("conceal")
  setlocal cole=2 cocu=nc
endif

unlet! b:did_ftplugin

runtime ftplugin/man.vim

" Mappings: {{{1

" Oh shit i found duplicated code.
" nnoremap <silent><buffer> gO <Cmd>call pydoc_help#show_toc()<CR>

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
