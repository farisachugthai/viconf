" IPython:

if exists('b:current_syntax')
  finish
endif

augroup ftpersonal
    autocmd!
    " IPython:
    autocmd BufRead,BufNewFile *.ipy setlocal filetype=python
    " I only want to set the current syntsx if we got the right file so can
    " that expression be conditional?
    let b:current_syntax = 1
augroup end
