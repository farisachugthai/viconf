" ============================================================================
    " File: gruvbox8_hard.vim
    " Author: Faris Chugthai
    " Description: Gruvbox8_hard mods
    " Last Modified: April 09, 2019
" ============================================================================

" Guard: {{{1
if g:colors_name !=# 'gruvbox8_hard'
    finish
else
    call s:gruvbox8_hard()
endif

function! s:gruvbox8_hard()
    set background=dark
    let g:gruvbox_plugin_hi_groups = 0
    let g:gruvbox_filetype_hi_groups = 0
    let g:gruvbox_italicize_strings = 1
    let g:gruvbox_italic = 1
    let g:gruvbox_transp_bg = 1
    let g:gruvbox_invert_tabline = 1
endfunction

command! -nargs=0 Gruvbox8 call s:gruvbox8_hard()
