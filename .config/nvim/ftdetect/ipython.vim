" IPython ftdetect. Needs a lot of work.

if exists('b:current_syntax')
  finish
endif

let b:current_syntax = 1

augroup ftpersonal
    autocmd!
    " IPython:
    autocmd BufRead,BufNewFile *.ipy setlocal filetype=python
augroup end
