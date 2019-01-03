" ============================================================================
    " File: i3.vim
    " Author: Faris Chugthai
    " Description: i3 ftdetect
    " Last Modified: December 21, 2018
" ============================================================================

if exists("b:current_syntax")
  finish
endif

augroup i3
    autocmd!
    autocmd BufNewFile,BufRead ~/.config/i3* set filetype=i3
    let b:current_syntax = 1
augroup end
