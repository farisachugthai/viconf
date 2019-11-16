" ============================================================================
    " File: bash.vim
    " Author: Faris Chugthai
    " Description: The original ftplugin is so odd and it does nothing of value
    " Last Modified: Oct 22, 2019
" ============================================================================

" Guard: {{{1
" if exists("b:did_ftplugin")
"   finish
" endif
" let b:did_ftplugin = 1
" So I am apparently doing something very wrong because you lose sh syntax
" highlighting when you uncomment those. go figure

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

runtime ftplugin/sh.vim after/ftplugin/sh.vim

" Just in case i didn't get them fro the sh plugin
let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heredoc folding)

" highlighting readline options
let g:readline_has_bash = 1

setlocal syntax=sh

" Atexit: {{{1
let b:undo_ftplugin = 'setlocal syntax< '
      \ . '|unlet! b:undo_ftplugin'

let &cpoptions = s:cpo_save
unlet s:cpo_save
