" ============================================================================
    " File: coc.vim
    " Author: Faris Chugthai
    " Description: Coc plugin mods
    " Last Modified: March 22, 2019
" ============================================================================

" Options are in coc_settings.json

" Guard: {{{1
if !has_key(plugs, 'coc.nvim')
    finish
endif

if exists('did_coc_nvim_conf') || &cp || v:version < 700
    finish
endif
let did_coc_nvim_conf = 1
" Mappings: {{{1
inoremap <silent><expr> <c-space> coc#refresh()

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
