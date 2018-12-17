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
" And if we run :echo getline(1) on a zim filetype, we get the top line. Yes
" Vim is not 0 indexed :(

" And while that's frustrating, this is a very weak way to determine whether we
" have a zimwiki file or not.
function! s:DetectZimWiki()
    if getline(1) =~ 'Content-Type: text/x-zim-wiki'
        set filetype=zimwiki
    endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectZimWiki()
