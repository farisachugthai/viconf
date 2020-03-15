" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: Oct 27, 2019
" ============================================================================

" Global Options: {{{
let g:rst_style = 1

" May 13, 2019: Updated. Grabbed this directly from $VIMRUNTIME/syntax/rst.vim
"
" Use fewer code lists as it ends up accounting for 50% of
" startuptime when using rst docs
" It took me like 10 tries to get this right so here's a
" reminder of how dict syntax works.
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

" }}}

" Now that globals are set check for ....
if &filetype !=# 'rst' | finish | endif
" The right file type: {{{
if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/rst.vim

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
setlocal iskeyword-=_

" Dude some of the options in fo-table are MADE for rst
" n	When formatting text, recognize numbered lists.  This actually uses
" 	the 'formatlistpat' option, thus any kind of list can be used.  The
" 	indent of the text after the number is used for the next line.  The
" 	default is to find a number, optionally followed by '.', ':', ')',
" 	']' or '}'.  Note that 'autoindent' must be set too.  Doesn't work
" 	well together with "2".
" 	Example: >
" 		1. the first item
" 		   wraps
" 		2. the second item
setlocal formatoptions+=n

" Only because I want to follow module names the same way as python
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
" }}}

" Actually from the python ftplugin: {{{
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

" Isn't a func anymore. todo: this and maybe formatprg?
" command! -buffer Sphinx call pydoc_help#sphinx_build(<q-args>)

setlocal comments=fb:.. commentstring=..\ %s

let b:undo_ftplugin = 'setlocal tw< cms< com< cc< lbr< fdl< fdls< '
      \ . '|setlocal spell< wig< isk< kp< mp< efm< sua< sr< '
      \ . '|setlocal cin< cinw< path< '
      \ . '|setlocal include<'
      \ . '|setlocal indentkeys<'
      \ . '|setlocal cinkeys<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'

" reStructuredText standard recommends that tabs be expanded to 8 spaces
" The choice of 3-space indentation is to provide slightly better support for
" directives (..) and ordered lists (1.), although it can cause problems for
" many other cases.

" More sophisticated indentation rules should be revisited in the future.

if !exists('g:rst_style') || g:rst_style != 0
  setlocal expandtab shiftwidth=3 softtabstop=3 tabstop=8
  let b:undo_ftplugin .= 'setlocal ts< sw< sts<'
endif

setlocal foldmethod=expr
setlocal foldexpr=RstFold#GetRstFold()
setlocal foldtext=RstFold#GetRstFoldText()
" }}}

let b:undo_ftplugin .= 'setlocal fdm< foldexpr< foldtext<'
                  \ . '|unlet! b:RstFoldCache'
