" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

" Guards: {{{1
if exists('b:did_syncom_plugin') || &compatible || v:version < 700
    finish
endif
let b:did_syncom_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=c

" Options: {{{1

" Admittedly I kinda know why the screen looks so small
if &textwidth!=0
  setl colorcolumn=+1
else
  setl colorcolumn=80
endif

" Commands: {{{1
command! HL call syncom#HL()
command! HiC call syncom#HiC()
" command! HiD call <SID>syncom#HiD()
command! HiQF call syncom#HiQF()

" Isn't working. But at least the error message is specific enough that you
" knew where to check.
command! SyntaxInfo call g:syncom#get_syn_info()

command! HiTest call g:syncom#hitest()

" Plug Mappings: {{{1
" To attempt making this a little more modular.

nnoremap <Plug>HL <Cmd>HL<CR>
nnoremap <Plug>HiC <Cmd>HiC<CR>
nnoremap <Plug>HiQF <Cmd>HiQF<CR>
nnoremap <Plug>SyntaxInfo <Cmd>SyntaxInfo<CR>

" TODO: when i come up with some default mappings for this, remember to
" use this idiom:
" if !exists('no_plugin_maps') && !exists('no_windows_vim_maps') | call funcs
" | endif

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
