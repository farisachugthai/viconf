" Language: ZimWiki
" Maintainer: Joan Rivera <joan.manuel.rivera+dev@gmail.com>
" URL: https://github.com/joanrivera/vim-zimwiki-syntax
" License: MIT

" Huh so if this is our only metric for a zim file we have to make a
" skeleton.zim script then right?
"
" or maybe say all files that end with .txt in this dir tree are zim files.

function! s:DetectZimWiki()
    if getline(1) =~ 'Content-Type: text/x-zim-wiki'
        set filetype=zimwiki
    endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectZimWiki()
