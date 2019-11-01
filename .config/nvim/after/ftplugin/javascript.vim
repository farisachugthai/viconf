" ============================================================================
    " File: js.vim
    " Author: Faris Chugthai
    " Description: js ftplugin
    " Last Modified: June 09, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_js_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_js_after_ftplugin = 1

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

if has_key(plugs, 'ale') && &filetype==#'javascript'
  call ftplugins#ALE_JS_Conf()
endif

" Atexit: {{{1
let b:undo_ftplugin = 'set et< sw< sts< sua< ofu< com< cms<'
let &cpoptions = s:cpo_save
unlet s:cpo_save
