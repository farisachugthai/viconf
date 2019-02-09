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

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

function! s:DetectZimWiki()
    if getline(1) =~# 'Content-Type: text/x-zim-wiki'
        setlocal filetype=zimwiki
        let b:current_syntax = 1
    endif
endfunction

augroup zimwikidetect
    autocmd!
    " autocmd BufRead,BufNewFile ~/Notebooks.git/*.txt call s:DetectZimWiki()
    " Honestly though if it's in that directory it IS a zimwiki note
    autocmd BufRead, BufNewFile ~/Notebooks* set ft=zimwiki
augroup end
