<<<<<<< HEAD
" IPython:

augroup ftpersonal
    autocmd!
    autocmd BufRead,BufNewFile *.ipy setlocal filetype=python
augroup end
||||||| merged common ancestors
=======
" IPython ftdetect. Needs a lot of work.

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
>>>>>>> master
