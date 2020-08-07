" ======================================================================
    " File: js.vim
    " Author: Faris Chugthai
    " Description: js ftplugin
    " Last Modified: June 09, 2019
" ======================================================================

let g:javaScript_fold = 1

if !has('unix')
  let g:ale_windows_node_executable_path = fnameescape('C:/Program Files/nodejs/node.exe')
endif

if exists('b:did_ftplugin') | finish | endif

" Options:
  source $VIMRUNTIME/ftplugin/javascript.vim
  if &filetype ==# 'javascript'  " typescript
    source $VIMRUNTIME/indent/javascript.vim
    source $VIMRUNTIME/autoload/javascriptcomplete.vim
    setlocal omnifunc=javascriptcomplete#CompleteJS
  endif

  setlocal expandtab
  setlocal shiftwidth=2
  setlocal softtabstop=2
  setlocal suffixesadd+=.html,.css,.js
  " see $VIMRUNTIME/syntax/javascript.vim for more
  setlocal foldmethod=syntax

  " Set 'comments' to format dashed lists in comments.
  setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
  let &l:commentstring='// %s'

  " From /r/vim
  " setlocal include=require(
  let &l:include = '\<require(\(["'']\)\zs[^\1]\+\ze\1'

  " So here's the example from :he 'define'
  let &l:define = '^\s*\ze\k\+\s*=\s*function('

  setlocal tagcase=smart
  setlocal isfname+=@-@

" ALE:

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  let b:ale_fixers += ['prettier']
  let b:ale_fixers += ['eslint']
  let b:ale_fixers += ['tsserver']
  let b:ale_linters = get(g:, 'ale_linters["*"]', ['tsserver', 'eslint', 'prettier',])
  let b:ale_linters_explicit = 1

" Atexit:
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                \. '|setlocal et< sw< sts< sua< fdm< ofu< com< cms<'
                \. '|setlocal include< define< tagcase< isf<'
                \. '|unlet! b:undo_ftplugin'
                \. '|unlet! b:did_ftplugin'
                \. '|unlet! b:ale_fixers'
                \. '|unlet! b:ale_linters'
                \. '|unlet! b:ale_linters_explicit'

