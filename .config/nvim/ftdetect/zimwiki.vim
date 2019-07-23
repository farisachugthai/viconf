" Language: ZimWiki
" License: MIT

" My Vimscript is quite weak so excuse me.
" From he:
"                             *getline()*
" getline({lnum} [, {end}])
"         Without {end} the result is a String, which is line {lnum}
"         from the current buffer.  Example: >
"             getline(1)

" Yes
" Vim is not 0 indexed :(

" And if we run :echo getline(1) on a zim filetype, we get the top line.

" ####################
" #  " Mar 13, 2019  #
" ####################
" Got it. it detects text before zimwiki so we can't use the usual filetype guard. sweet!

function! s:DetectZimWiki()
    if getline(1) =~# 'Content-Type: text/x-zim-wiki'
        setlocal filetype=zimwiki
    endif
endfunction

augroup YourFtDetect
    autocmd!
    autocmd BufRead,BufNewFile *.txt  call s:DetectZimWiki()
augroup end
