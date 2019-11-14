" ============================================================================
    " File: js.vim
    " Author: Faris Chugthai
    " Description: js ftplugin
    " Last Modified: June 09, 2019
" ============================================================================

" Guard: {{{1
let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd+=.html,.css,.js

setlocal omnifunc=javascriptcomplete#CompleteJS

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
let &l:commentstring='// %s'

" From /r/vim
setlocal include=require(

" So here's the example from :he 'define'
let &l:define = '^\s*\ze\k\+\s*=\s*function('

if !has('unix')
  let &l:path = ',.,**,,C:\\tools\\nodejs\\node_modules\\**,'
" else TODO
endif

if exists('g:loaded_ale') && &filetype==#'javascript'
  call ftplugins#ALE_JS_Conf()
endif

" Atexit: {{{1
let b:undo_ftplugin = 'setlocal et< sw< sts< sua< com< cms< ofu< '
      \ . '|setlocal define< '
      \ . '|setlocal path< '
      \ . '|setlocal include< '
      \ . '|unlet! b:undo_ftplugin'

let &cpoptions = s:cpo_save
unlet s:cpo_save
