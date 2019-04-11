" ============================================================================
    " File: gruvbox.vim
    " Author: Faris Chugthai
    " Description: Gruvbox mods
    " Last Modified: April 09, 2019
" ============================================================================

" Figured there's no point in it taking up space in the init.vim

" Guard: {{{1
if g:colors_name !=# 'gruvbox'
    finish
else
    call s:gruvbox()
endif

" Functions: {{{1
function! s:gruvbox()
    set background=dark
    let g:gruvbox_italic = 1
    let g:gruvbox_contrast_dark = 'hard'
    " let g:gruvbox_improved_strings=1 shockingly terrible
    let g:gruvbox_improved_warnings = 1
    let g:gruvbox_invert_tabline = 1
    let g:gruvbox_italicize_strings = 1
endfunction


" Commands: {{{1

command! -nargs=0 Gruvbox call s:gruvbox()
