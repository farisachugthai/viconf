" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Autoloaded funcs aren't showing up
    " Last Modified: April 21, 2019
" ============================================================================

if exists('g:did_syncom_vim') || &cp || v:version < 700
    finish
endif
let g:did_syncom_vim = 1

command! HL call syncom#HL()
command! HiC call syncom#HiC()
command! HiQF call g:syncom#HiQF()
command! SyntaxInfo call g:syncom#get_syn_info()
