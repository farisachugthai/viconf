" Markdown:
" Maintainer: Faris Chugthai

" Enable spellchecking.
setlocal spell!

" Automatically wrap at 80 characters after whitespace
setlocal textwidth=80
setlocal colorcolumn=80
" Then break lines if they're too long.
" setlocal linebreak

" Fix tabs so that we can have ordered lists render properly
setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

augroup filetype_markdown
    autocmd!
    autocmd FileType markdown noremap <buffer> <localleader>1 m`yypVr=``
    autocmd FileType markdown noremap <buffer> <localleader>2 m`yypVr-``
    autocmd FileType markdown noremap <buffer> <localleader>3 m`^i### <esc>``4l
    autocmd FileType markdown noremap <buffer> <localleader>4 m`^i#### <esc>``5l
    autocmd FileType markdown noremap <buffer> <localleader>5 m`^i##### <esc>``6l
augroup END
