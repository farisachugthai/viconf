" Language: ZimWiki
" Maintainer: Joan Rivera <joan.manuel.rivera+dev@gmail.com>
" URL: https://github.com/joanrivera/vim-zimwiki-syntax
" License: MIT

" Huh so if this is our only metric for a zim file we have to make a
" skeleton.zim script then right?
"
" or maybe say all files that end with .txt in this dir tree are zim files.

if exists('b:current_syntax')
  finish
endif

function! s:DetectZimWiki()
    if getline(1) =~# 'Content-Type: text/x-zim-wiki'
        set filetype=zimwiki
    endif
endfunction

augroup zimwiki
    autocmd BufRead,BufNewFile *.txt  call s:DetectZimWiki()
augroup end

let b:current_syntax = 1
