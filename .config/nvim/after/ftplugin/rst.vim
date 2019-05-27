" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: May 19, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_rst_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_rst_after_ftplugin = 1

" Options: {{{1
" setlocal tabstop=4
" setlocal softtabstop=4
" setlocal shiftwidth=4
setlocal expandtab

setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=2
setlocal foldlevelstart=2
setlocal spell!

" This works beautifully!
setlocal keywordprg=:r!pydoc

" TODO: Need to set an undo ftplugin.
compiler rst

" Syntax Highlighting: {{{1
" he rst.vim or ft-rst-syntax or syntax 2600. Don't put bash instead of sh.
" $VIMRUNTIME/syntax/rst.vim iterates over this var and if it can't find a
" bash.vim syntax file it will crash.

" May 13, 2019: Updated. Grabbed this directly from $VIMRUNTIME/syntax/rst.vim
let g:rst_syntax_code_list = {
    \ 'vim': ['vim'],
    \ 'java': ['java'],
    \ 'cpp': ['cpp', 'c++'],
    \ 'lisp': ['lisp'],
    \ 'php': ['php'],
    \ 'python': ['python', 'python3', 'ipython'],
    \ 'perl': ['perl'],
    \ 'sh': ['sh'],
    \ }

let b:undo_ftplugin = 'set et< cc< fdl< fdls< spell<'
