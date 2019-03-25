" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: rst ftplugin
    " Last Modified: Feb 04, 2019
" ============================================================================
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab

setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=2
setlocal foldlevelstart=2
setlocal spell!

setlocal keywordprg=pydoc
" TODO: Need to set an undo ftplugin.

" Which kinda raises the question of why neovim and vim both don't set an undo ftplugin for python files. Hm.
