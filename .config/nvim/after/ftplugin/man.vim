" man.vim
" Wanted to use this after file to add in a function to automatically
" open new help pages in a separate tab.

" Just wanted to add this because it isn't set automatically
set number

" Helptabs:
function! s:helptab()
    if &buftype ==# 'help'
        wincmd T
        nnoremap <buffer> q :q<cr>
    " need to make an else for if ft isn't help then open a help page with the
    " first argument
    endif
endfunction

" Only reason this is in an augroup is because vint freaks out
augroup mantabs
    autocmd!
    autocmd BufEnter *.txt call s:helptab()
augroup END
