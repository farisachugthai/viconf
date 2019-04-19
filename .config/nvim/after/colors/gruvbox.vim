" ============================================================================
    " File: gruvbox.vim
    " Author: Faris Chugthai
    " Description: Gruvbox mods
    " Last Modified: April 09, 2019
" ============================================================================
" Figured there's no point in it taking up space in the init.vim
" POOP! None of my modifications had been applying because the function call
" was call s:gruvbox not <SID>

" Guard: {{{1
if exists('did_gruvbox_vim') || &cp || v:version < 700
    finish
endif
let did_gruvbox_vim = 1

if g:colors_name !=# 'gruvbox'
    finish
elseif g:colors_name ==# 'gruvbox'
    call <SID>gruvbox()
endif

" Functions: {{{1
function! <SID>gruvbox()
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
