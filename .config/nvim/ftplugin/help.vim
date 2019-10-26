" ============================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_help_vim') || &compatible || v:version < 700
  finish
endif
let b:did_help_vim = 1

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C


" Options: {{{1
setlocal formatoptions+=tcroql textwidth=78

" Just saying... I have this set globally too. W/e.
if has("conceal")
  setlocal cole=2 cocu=nc
endif

" Helpfiles won't follow tags correctly without this one
" Now context-functions will probably go to the tag I want and not simply functions...
setlocal iskeyword+=-
let b:undo_ftplugin = "setl fo< tw< cole< cocu< keywordprg<"

unlet! b:did_ftplugin
" Source mine in
runtime ftplugin/man.vim


" Mappings: {{{1

" Oh shit i found duplicated code.
" NOTE: I mean code duplicated in the neovim source code.
" autoload/man.vim and ftplugin/man.vim have 1 function copy pasted
" nnoremap <silent><buffer> gO <Cmd>call pydoc_help#show_toc()<CR>

" Plugins: {{{1

" ALE as always
" I think this is probably the best way to define the buffer local fixers
" based on the global ones.
let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

let b:ale_fixers += ['align_help_tags'] " Align help tags to the right margin

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
