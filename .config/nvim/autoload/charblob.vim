" File: charblob.vim
" Author: Faris Chugthai
" Description:
" Last Modified: July 15, 2019

" Guard: {{{1

if exists('g:did_charblob_vim') || &compatible || v:version < 700
  finish
endif
let g:did_charblob_vim = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Functions: {{{1 From lua-require-example

function! s:charblob#encode_buffer() abort

  call setline(1, luaeval(
  \    'require("charblob").encode(unpack(_A))',
  \    [getline(1, '$'), &textwidth, '  ']))

endfunction

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
