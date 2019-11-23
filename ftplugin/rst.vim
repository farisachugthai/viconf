" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: Oct 27, 2019
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions-=C

" Things that should get defined everywhere anyways so define them first.

" Yes we do the b:did_ftplugin later but define the global vars first

" Options: {{{1

let g:rst_style = 1

" See Also:
" RESTRUCTURED TEXT			*rst.vim* *ft-rst-syntax*
" he rst.vim or ft-rst-syntax or syntax 2600.

" Admonition:
" Don't put bash instead of sh.
" $VIMRUNTIME/syntax/rst.vim iterates over this var and if it can't find a
" bash.vim syntax file it will crash.

" May 13, 2019: Updated. Grabbed this directly from $VIMRUNTIME/syntax/rst.vim
"
" Use fewer code lists it ends up accounting for 50% of startuptime when
" using rst docs
let g:rst_syntax_code_list = {
    \ 'python': ['python', 'python3', 'ipython'],
    \ 'sh': ['sh', 'bash'],
    \ }

let g:rst_use_emphasis_colors = 1

let g:rst_fold_enabled = 1

" Rst specific: {{{1
setlocal expandtab
setlocal spell!
setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=1
setlocal foldlevelstart=1
setlocal iskeyword+=.

" Doesn't work
" if exists(':PydocThis')
"   setlocal keywordprg=:PydocThis
" else
" setlocal keywordprg=!pydoc
" endif

" let &l:keywordprg = pydoc_help#SplitPydocCword()

" don't do the executable(sphinx-build) check here its in ../compiler/rst.vim
compiler rst

if filereadable('conf.py')
  let &l:makeprg .= ' . ../build/html '
elseif glob('../conf.py')
  let &l:makeprg .= ' .. ../../build/html '
endif

" Actually from the python ftplugin: {{{2

setlocal cindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)
setlocal shiftround
setlocal suffixesadd=.py,.rst

let &l:path = py#PythonPath()

" Sphinx Command: {{{1
command! -buffer Sphinx call pydoc_help#sphinx_build(<q-args>)

" The Official Ftplugin: {{{1

setlocal comments=fb:.. commentstring=..\ %s

" Let's redo the undo ftplugin

let b:undo_ftplugin = 'setlocal cms< com< cc< lbr< fdl< fdls< '
      \ . '|setlocal spell< isk< kp< mp< efm< sua< sr< '
      \ . '|setlocal cin< cinw< path< '
      \ . '|setlocal include<'
      \ . '|setlocal indentkeys<'
      \ . '|setlocal cinkeys<'
      \ . '|unlet! b:undo_ftplugin'

" reStructuredText standard recommends that tabs be expanded to 8 spaces
" The choice of 3-space indentation is to provide slightly better support for
" directives (..) and ordered lists (1.), although it can cause problems for
" many other cases.

" More sophisticated indentation rules should be revisited in the future.

if !exists('g:rst_style') || g:rst_style != 0
  setlocal expandtab shiftwidth=3 softtabstop=3 tabstop=8
  let b:undo_ftplugin .= 'setlocal  ts< sw< sts<'
endif

if has('patch-7.3.867')  " Introduced the TextChanged event.
  setlocal foldmethod=expr
  setlocal foldexpr=RstFold#GetRstFold()
  setlocal foldtext=RstFold#GetRstFoldText()
  " augroup RstFold
  "   autocmd TextChanged,InsertLeave <buffer> unlet! b:RstFoldCache
  " augroup END
  let b:undo_ftplugin .= 'setlocal fdm< foldexpr< foldtext<'
                    \ . '|unlet! b:RstFoldCache'
endif


" Atexit: {{{1
" Can't use unlet! Or unlet in the same '' apparently

let &cpoptions = s:cpo_save
unlet s:cpo_save
