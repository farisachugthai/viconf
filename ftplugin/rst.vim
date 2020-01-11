" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: Oct 27, 2019
" ============================================================================

let g:rst_style = 1

" May 13, 2019: Updated. Grabbed this directly from $VIMRUNTIME/syntax/rst.vim
"
" Use fewer code lists it ends up accounting for 50% of startuptime when
" using rst docs
" It took me like 10 tries to get this right so here's a reminder of how dict
" syntax works.
" call extend(g:rst_syntax_code_list, {'javascript': ['js', 'javascript']})
" to add javascript highlighting to an rst doc
let g:rst_syntax_code_list = {
    \ 'python': ['python', 'python3', 'ipython'],
    \ 'sh': ['sh', 'bash'],
    \ }

  " just added rst
   " I kinda hope this does nothing
    " \ 'rst': ['rst'],
    " NOPE EVERYTHING BROKE
let g:rst_use_emphasis_colors = 1
let g:rst_fold_enabled = 1

" Now that globals are set check for b:did_ftplugin
if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

syntax sync fromstart
setlocal textwidth=80
setlocal expandtab
setlocal spell!
setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=1
setlocal foldlevelstart=1
setlocal wildignore+=*.html,*.css
setlocal iskeyword+=.

" Only because I want to follow module names the same way as python
setlocal include=^\\s*\\(from\\\|import\\)

setlocal includeexpr=substitute(v:fname,'\\.','/','g')

compiler rst

if executable('sphinx-build')
  let &l:makeprg = 'sphinx-build -b html'

  if filereadable('conf.py')
    let &l:makeprg .= ' . ./build/html '
  elseif glob('../conf.py')
    let &l:makeprg .= ' .. ../../build/html '
  endif

endif

" Actually from the python ftplugin: {{{2
setlocal cindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)
" This really fucks stuff up if you're indenting rst blocks as 3 spaces and
" python as 4
setlocal noshiftround
setlocal suffixesadd=.py,.rst,.rst.txt

let &l:path = py#PythonPath()

" Isn't a func anymore
" command! -buffer Sphinx call pydoc_help#sphinx_build(<q-args>)

setlocal comments=fb:.. commentstring=..\ %s

let b:undo_ftplugin = 'setlocal tw< cms< com< cc< lbr< fdl< fdls< '
      \ . '|setlocal spell< wig< isk< kp< mp< efm< sua< sr< '
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

setlocal foldmethod=expr
setlocal foldexpr=RstFold#GetRstFold()
setlocal foldtext=RstFold#GetRstFoldText()
let b:undo_ftplugin .= 'setlocal fdm< foldexpr< foldtext<'
                  \ . '|unlet! b:RstFoldCache'
