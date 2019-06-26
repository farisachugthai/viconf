" ============================================================================
    " File: autoloads.vim
    " Author: Faris Chugthai
    " Description: Commands and functions defined in thw autoload dir
    " Last Modified: June 26, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_autoloads_vim') || &compatible || v:version < 700
    finish
endif
let g:did_autoloads_vim = 1

" Commands: {{{1
command! Todo call todo#Todo()

" Mappings: {{{1

inoremap <silent> <C-L> <C-R>=(ultisnips#ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

inoremap <expr> <CR> pumvisible() ? "<C-R>=ultisnips#ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"
