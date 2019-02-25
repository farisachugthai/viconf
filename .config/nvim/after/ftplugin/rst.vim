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

" At first I saw that sphinx recommends 3 space tabstops, but it makes things
" really inconsistent with the source code. Python files will automatically
" create 4 space tabstops and the rst files documenting them use 3 and it gets
" messy very quickly.
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=0
setlocal foldlevelstart=0
setlocal spell!

" Assuming the rst is a python related file
" TODO: How do we modify so that `K` reads the help docs into a buffer?
" ...By mapping it so?
setlocal keywordprg=pydoc

" TODO: Need to set an undo ftplugin.
