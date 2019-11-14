" ============================================================================
    " File: css.vim
    " Author: Faris Chugthai
    " Description: css ftplugin
    " Last Modified: June 08, 2019
" ============================================================================

" Guard: {{{1
let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd=.html,.css
setlocal omnifunc=csscomplete#CompleteCSS

compiler csslint

if !empty('g:loaded_ale') && &filetype==#'css'
  call ftplugins#ALE_CSS_Conf()
endif

" Atexit: {{{1

let b:undo_ftplugin = 'setlocal et< sw< sts< sua< ofu< mp< efm< '
      \ . '|unlet! b:undo_ftplugin'

let &cpoptions = s:cpo_save
unlet s:cpo_save
