" " ============================================================================
    " File: snippets.vim
    " Author: Faris Chugthai
    " Description: Snippets ftdetect
    " Last Modified: December 27, 2018
" ============================================================================
" recognize .snippet files

if exists('b:current_syntax')
  finish
endif

let b:current_syntax = 1

if has('autocmd')
    augroup snippetftd
        autocmd BufNewFile,BufRead *.snippets set filetype snippets
    augroup end
endif
