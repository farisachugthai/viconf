" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Autoloaded funcs aren't showing up
    " Last Modified: April 21, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_syncom_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_syncom_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Commands: {{{1
command! HL call syncom#HL()
command! HiC call syncom#HiC()
command! HiQF call g:syncom#HiQF()

" Isn't working. But at least the error message is specific enough that you
" knew where to check.
command! SyntaxInfo call g:syncom#get_syn_info()

" Plug Mappings: {{{1

nnoremap <Plug>HL <Cmd>HL<CR>
nnoremap <Plug>HiC <Cmd>HiC<CR>
nnoremap <Plug>HiQF <Cmd>HiQF<CR>
nnoremap <Plug>SyntaxInfo <Cmd>SyntaxInfo<CR>

" atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
