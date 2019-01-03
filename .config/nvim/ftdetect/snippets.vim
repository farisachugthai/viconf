" " ============================================================================
    " File: snippets.vim
    " Author: Faris Chugthai
    " Description: Snippets ftdetect
    " Last Modified: December 27, 2018
" ============================================================================

if exists('b:current_syntax')
  finish
endif

if has('autocmd')
    augroup snippetftd
        autocmd BufNewFile,BufRead *.snippets set filetype snippets
        let b:current_syntax = 1
    augroup end
endif
