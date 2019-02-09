" IPython:

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

augroup ftpersonal
    autocmd!
    " IPython:
    autocmd BufRead,BufNewFile *.ipy setlocal filetype=python
    " I only want to set the current syntsx if we got the right file so can
    " that expression be conditional?
    let b:current_syntax = 1
augroup end
