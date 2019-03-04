" man.vim
" Wanted to use this after file to add in a function to automatically
" open new help pages in a separate tab.
" TODO: Need to fix this. Have got it working before idk what I did.

" Just wanted to add this because it isn't set automatically
setlocal number

" Helptabs:

function! s:helptab()
  if &buftype ==# 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction

augroup mantabs
    autocmd!
    " Would this mean only call this part when we enter a new buffer but not
    " the first time we enter nvim?
    " Unfortunately no.
    " autocmd VimEnter finish
    autocmd BufEnter ft=man call s:helptab()
augroup END
