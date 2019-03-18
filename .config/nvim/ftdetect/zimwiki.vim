" Language: ZimWiki
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


" ####################
" #  " Mar 13, 2019  #
" ####################
" Got it. it detects text before zimwiki so we can't use the usual filetype guard. sweet!

function! s:DetectZimWiki()
    if getline(1) =~# 'Content-Type: text/x-zim-wiki'
        setlocal filetype=zimwiki
    endif
endfunction

augroup zimwikidetect
    autocmd!
    " autocmd BufRead,BufNewFile ~/Notebooks.git/*.txt call s:DetectZimWiki()
    " Honestly though if it's in that directory it IS a zimwiki note
    autocmd BufRead,BufNewFile ~/Notebooks/** setlocal filetype=zimwiki

    " Alternatively we can check all textfiles which oddly works better

    " autocmd BufRead,BufNewFile *.txt  call s:DetectZimWiki()
augroup end


let b:did_ftplugin = 1
