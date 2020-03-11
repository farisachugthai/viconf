" ============================================================================
  " File: xonsh.vim
  " Author: Faris Chugthai
  " Description: Xonsh ftplugin
  " Last Modified: November 29, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" Sourcing Everything: {{{
source $VIMRUNTIME/ftplugin/python.vim
unlet! b:did_ftplugin

let s:this_dir = fnameescape(fnamemodify(expand('<sfile>'), ':p:h'))

exec 'source ' . s:this_dir . '/python.vim'
" }}}

" Options: {{{
if executable('black')
  setlocal formatprg=black
endif

setlocal keywordprg=:PydocShow
setlocal foldlevelstart=0
setlocal syntax=xonsh
syntax sync fromstart
setlocal suffixesadd+=,.xsh,.xonshrc,

setlocal formatoptions=jcroql
setlocal expandtab shiftwidth=4 sts=4 ts=4

" }}}

" Atexit: {{{
let b:undo_ftplugin = 'setlocal fdm< syntax< sua< '
            \ . '|unlet! b:undo_ftplugin'
            \ . '|unlet! b:did_ftplugin'
