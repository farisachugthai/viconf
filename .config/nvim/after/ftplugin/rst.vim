" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: rst ftplugin
    " Last Modified: Feb 04, 2019
" ============================================================================
" The header snippet works phenomenally.

" Don't know if this is needed. From the help docs for ftdetect.
" if exists("did_load_filetypes")
"   finish
" endif
" augroup filetypedetect
"   au! BufRead,BufNewFile *.rst        setfiletype rst
" augroup END

if v:version < 600
    syntax clear
elseif exists('b:current_personal_syntax')
    finish
endif
let b:current_personal_syntax = 1

setlocal tabstop=3
setlocal softtabstop=3
setlocal shiftwidth=3  " and expandtab is already set so that should set that
setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=1
setlocal foldlevelstart=1
setlocal spell!

" TODO: Need to set an undo ftplugin.
