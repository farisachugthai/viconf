" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: Mar 25, 2019
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

" Which kinda raises the question of why both neovim and vim
" don't set an undo ftplugin for either rst or python files. Hm.
