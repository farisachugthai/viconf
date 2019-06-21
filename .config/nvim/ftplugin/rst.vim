" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: May 19, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_rst_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_rst_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" So I officially took the entire ftplugin so at this point disable it
if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" Options: {{{1
setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=2
setlocal foldlevelstart=2
setlocal spell!

" This works beautifully!
setlocal keywordprg=pydoc

compiler rst

let &makeprg='sphinx-build -b html '

" The Official Ftplugin: {{{1

setlocal comments=fb:.. commentstring=..\ %s expandtab
setlocal formatoptions+=tcroql

" reStructuredText standard recommends that tabs be expanded to 8 spaces
" The choice of 3-space indentation is to provide slightly better support for
" directives (..) and ordered lists (1.), although it can cause problems for
" many other cases.
"
" More sophisticated indentation rules should be revisted in the future.

" if !exists("g:rst_style") || g:rst_style != 0
    setlocal expandtab shiftwidth=3 softtabstop=3 tabstop=8
" endif

" if has('patch-7.3.867')  " Introduced the TextChanged event.
  setlocal foldmethod=expr
  setlocal foldexpr=RstFold#GetRstFold()
  setlocal foldtext=RstFold#GetRstFoldText()
  augroup RstFold
    autocmd TextChanged,InsertLeave <buffer> unlet! b:RstFoldCache
  augroup END
" endif

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

" Atexit: {{{1

let b:undo_ftplugin = 'set cc< lbr< fdl< fdls< spell< kp< et< ts< sw< sts<'
" can't use unlet! or unlet in the same '' apparently

let &cpoptions = s:cpo_save
unlet s:cpo_save
