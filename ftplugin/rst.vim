" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: Oct 27, 2019
" ============================================================================
-
" Global Options:
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

" The Right Filetype:
  " Now that globals are set check for ....
  if exists('b:did_ftplugin') | finish | endif
  let b:did_ftplugin = 1

  " So these are a massive source of start up time delay. Plus they get sourced in anyway.
  " source $VIMRUNTIME/ftplugin/rst.vim
  " source $VIMRUNTIME/indent/rst.vim
  setlocal textwidth=80
  setlocal colorcolumn=80,120
  setlocal linebreak
  setlocal foldlevel=1
  setlocal foldlevelstart=1
  setlocal spell!
  setlocal wildignore+=*.html,*.css
  setlocal iskeyword+=.
  setlocal iskeyword-=_
  setlocal keywordprg=:PydocShow
  setlocal wrap

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
  setlocal formatoptions=crq1jn

  " Only because I want to follow module names the same way as python
  setlocal include=^\\s*\\(from\\\|import\\)
  setlocal includeexpr=substitute(v:fname,'\\.','/','g')

" Actually From The Python Ftplugin:
  setlocal cindent
  setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
  setlocal cinkeys-=0#
  setlocal indentkeys-=0#
  " This fucks stuff up if you're indenting rst blocks as 3 spaces and python as 4
  setlocal noshiftround
  setlocal suffixesadd=.py,.rst,.rst.txt
  " TODO: XXX
  " Well somethings very fucking wrong because this adds 200ms to vim's startuptime.
  let &l:path = py#PythonPath()


  if !exists('b:undo_ftplugin') | let b:undo_ftplugin = '' | endif

  let b:undo_ftplugin .= '|setlocal tw< cc< lbr< fdl< fdls< '
        \ . '|setlocal spell< wig< isk< kp< wrap< fo<'
        \ . '|setlocal include<'
        \ . '|setlocal indentkeys<'
        \ . '|setlocal cin< cinw< cink< indk< sua< sr< path< '
        \ . '|unlet! b:undo_ftplugin'
        \ . '|unlet! b:did_ftplugin'

  " reStructuredText standard recommends that tabs be expanded to 8 spaces
  " The choice of 3-space indentation is to provide slightly better support for
  " directives (..) and ordered lists (1.), although it can cause problems for
  " many other cases.

  if !exists('g:rst_style') || g:rst_style != 0
    setlocal expandtab shiftwidth=3 softtabstop=3 tabstop=8
    let b:undo_ftplugin .= '|setlocal ts< sw< sts<'
  endif

  setlocal foldmethod=expr
  setlocal foldexpr=RstFold#GetRstFold()
  setlocal foldtext=RstFold#GetRstFoldText()
  setlocal comments=fb:.. commentstring=..\ %s expandtab

  compiler rst

  nnoremap <buffer> <F5> exe 'sphinx-build -b html ' . filereadable('Makefile') ==# 1 ? '. build/html' : ''

  let b:undo_ftplugin .= '|setlocal fdm< foldexpr< foldtext< cms< com< et< mp< efm< '
                    \ .  '|unlet! b:RstFoldCache'
                    \ .  '|silent! nunmap <buffer> <F5>'
                    \ .  '|unlet! b:undo_indent'
                    \ .  '|unlet! b:did_indent'

