" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: Apr 14, 2019
" ============================================================================
" setlocal tabstop=4
" setlocal softtabstop=4
" setlocal shiftwidth=4
setlocal expandtab

setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=2
setlocal foldlevelstart=2
setlocal spell!

" This works beautifully!
setlocal keywordprg=:r!pydoc

" TODO: Set makeprg. sphinx-build or something. Do we set some defaults? Check if we have an exe?
