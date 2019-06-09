" ============================================================================
    " File: sh.vim
    " Author: Faris Chugthai
    " Description: Bash ftplugin
    " Last Modified: June 09, 2019
" ============================================================================
"
" Guard: {{{1
if exists('g:did_sh_vim_after_ftplugin') || &compatible || v:version < 700
    finish
endif
let g:did_sh_vim_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heregoc folding)

" highlighting readline options
let readline_has_bash = 1


" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
