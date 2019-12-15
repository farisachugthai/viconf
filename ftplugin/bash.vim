" ============================================================================
    " File: bash.vim
    " Author: Faris Chugthai
    " Description: The original ftplugin is so odd and it does nothing of value
    " Last Modified: Oct 22, 2019
" ============================================================================

" Just in case i didn't get them fro the sh plugin
let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heredoc folding)

" highlighting readline options
let g:readline_has_bash = 1

" Source things correctly damnit!
"
runtime $VIMRUNTIME/ftplugin/sh.vim
unlet! b:did_ftplugin
runtime $VIMRUNTIME/ftplugin/bash.vim
unlet! b:did_ftplugin
" runtime ftplugin/sh.vim
" unlet! b:did_ftplugin
runtime after/ftplugin/sh.vim
unlet! b:did_ftplugin

setlocal syntax=bash

let b:undo_ftplugin = 'setlocal syntax< '
      \ . '|unlet! b:undo_ftplugin'
