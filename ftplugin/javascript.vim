" ======================================================================
    " File: js.vim
    " Author: Faris Chugthai
    " Description: js ftplugin
    " Last Modified: June 09, 2019
" ======================================================================

let g:javaScript_fold = 1
if exists('b:did_ftplugin') | finish | endif

" Options: {{{
source $VIMRUNTIME/ftplugin/javascript.vim
source $VIMRUNTIME/indent/javascript.vim

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd+=.html,.css,.js
" see $VIMRUNTIME/syntax/javascript.vim for more
setlocal foldmethod=syntax

source $VIMRUNTIME/autoload/javascriptcomplete.vim
setlocal omnifunc=javascriptcomplete#CompleteJS

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
let &l:commentstring='// %s'

" From /r/vim
setlocal include=require(

" So here's the example from :he 'define'
let &l:define = '^\s*\ze\k\+\s*=\s*function('

" ALE:

  if !has('unix')
    let g:ale_windows_node_executable_path = fnameescape('C:/Program Files/nodejs/node.exe')
  endif

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  let b:ale_fixers += ['prettier']


" Atexit: {{{
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                \. '|setlocal et< sw< sts< sua< fdm< ofu< com< cms<'
                \. '|setlocal include< define< '
                \. '|unlet! b:undo_ftplugin'
                \. '|unlet! b:did_ftplugin'
                \. '|unlet! b:ale_fixers'


