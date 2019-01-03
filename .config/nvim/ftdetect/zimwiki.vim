" Language: ZimWiki
" Maintainer: Joan Rivera <joan.manuel.rivera+dev@gmail.com>
" URL: https://github.com/joanrivera/vim-zimwiki-syntax
" License: MIT

" My Vimscript is quite weak so excuse me.
" From he:
"                             *getline()*
" getline({lnum} [, {end}])
"         Without {end} the result is a String, which is line {lnum}
"         from the current buffer.  Example: >
"             getline(1)
" And if we run :echo getline(1) on a zim filetype, we get the top line.

" Yes
" Vim is not 0 indexed :(

if exists('b:current_syntax')
  finish
endif

function! s:DetectZimWiki()
    if getline(1) =~# 'Content-Type: text/x-zim-wiki'
        set filetype=zimwiki
        let b:current_syntax = 1
    endif
endfunction

augroup zimwiki
    autocmd BufRead,BufNewFile *.txt  call s:DetectZimWiki()
augroup end
