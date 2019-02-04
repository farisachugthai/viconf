" ============================================================================
	" File: rst.vim
	" Author: Faris Chugthai
	" Description: rst ftplugin
	" Last Modified: Jan 05, 2019
" ============================================================================
" The header snippet works phenomenally.

setlocal tabstop=3
setlocal softtabstop=3
setlocal shiftwidth=3  " and expandtab is already set so that should set that
setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=1
setlocal foldlevelstart=1
setlocal spell!

" TODO: Need to set an undo ftplugin.

" I want Sphinx to work inside of Vim. Use the compiler file.
" setlocal makeprg=make\ html
