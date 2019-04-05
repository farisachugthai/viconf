" ============================================================================
    " File: tmuxline.vim
    " Author: Faris Chugthai
    " Description: Tmuxline conf
    " Last Modified: April 02, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'tmuxline.vim')
    finish
endif

if exists('g:did_tmuxline_conf') || &compatible || v:version < 700
    finish
endif
let g:did_tmuxline_conf = 1

" Options: {{{1
let g:tmuxline_preset = 'zenburn'
