" ============================================================================
    " File: pydoc.vim
    " Author: Faris Chugthai
    " Description: pydoc vim hooks
    " Last Modified: Jun 13, 2019
" ============================================================================

" Guards: {{{1
if exists('g:loaded_pydoc_plugin') || &compatible
    finish
endif
let g:loaded_pydoc_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

if !exists('g:pydoc_window')
  let g:pydoc_window = 1  " should this be an int or str. hm.
endif

" Functions: {{{1
function! g:PydocCword() abort
    enew
    exec ':r! pydoc <cword>'
endfunction

function! g:SplitPydocCword() abort
    split
    enew
    exec ':r! pydoc <cword>'
endfunction

" Commands: {{{1

" This should be able to take the argument '-bang' and allow to open in a new
" separate window like fzf does.
command! PydocSplit call g:SplitPydocCword()

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
