" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: Oct 18, 2019
" ============================================================================

" Guards: {{{1
if exists('b:did_python_vim') || &compatible || v:version < 700
  finish
endif
let b:did_python_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

" Globals
let g:python_highlight_all = 1
let g:python_space_error_highlight = 1

" Oddly I don't have an ftplugin guard setup. But rst sourced this in so...
if &filetype != 'python'
  finish
endif

setlocal linebreak
setlocal textwidth=120

setlocal comments=b:#,fb:-
setlocal commentstring=#\ %s
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4

" I guess i should set cindent if both of these are set right?
setlocal cindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal cinkeys-=0#

setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)

setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
setlocal foldmethod=indent

" runtime autoload/pydoc_help.vim

" setlocal keywordprg=pydoc
" let &l:keywordprg = ':PydocThis' . expand('<cWORD>')
" let &l:keywordprg = pydoc_help#SplitPydocCword()

" Use xnoremap because I wouldn't want this in select mode
" xnoremap K <Cmd>'<,'>PydocThis<CR>

setlocal suffixesadd+=.py
setlocal omnifunc=python3complete#Complete
setlocal iskeyword+=.

let &l:path = ftplugins#PythonPath()

" *'shiftround'* *'sr'* *'noshiftround'* *'nosr'*
" 'shiftround' 'sr'	boolean	(default off) global
	" Round indent to multiple of 'shiftwidth'.  Applies to > and <
	" commands.  CTRL-T and CTRL-D in Insert mode always round the indent to
	" a multiple of 'shiftwidth' (this is Vi compatible).
setlocal shiftround
" Possibly chalk this up to one of the many tab related and necessary option
" python requires you set

" Compiler: {{{1

" Well this is neat!
if executable('pytest')
  compiler pytest
  echomsg 'Using pytest as a compiler!'
else
  compiler pylint
  echomsg 'Using pylint as a compiler!'
endif

" Mappings: {{{1

" Don't know how I haven't done this yet.
noremap <buffer> <F5> <Cmd>py3f %<CR>
noremap! <buffer> <F5> <Cmd>py3f %<CR>

" Formatters: {{{1

if executable('yapf')
  setlocal equalprg=yapf
  setlocal formatprg=yapf

  command! -buffer -complete=buffer -nargs=0 YAPF call ftplugins#YAPF()
  command! -buffer -complete=buffer -nargs=0 YAPFI exec '!yapf -i %'
  command! -buffer -complete=buffer -nargs=0 YAPFD cexpr! exec '!yapf -d %'

else
    if executable('autopep8')
        setlocal equalprg=autopep8
        setlocal formatprg=autopep8

        command! -nargs=0 -complete=buffer -buffer Autopep8 cexpr! exec '!autopep8 -i ' . shellescape(<q-args>) . expand('%')
        " command! -nargs=0 Autopep8 exec '!autopep8 -i %'
        " command! -nargs=0 Autopep8 cexpr! exec '!autopep8 -d %'
    endif
endif

" ALE: {{{1

if !empty('g:loaded_ale')
  call ftplugins#ALE_Python_Conf()
endif

" Coc: {{{1
"
" Just tried this and it worked! So keep checking :CocCommand output
if !empty('g:did_coc_loaded')
  command! -nargs=? CocPython call CocActionAsync('runCommand', 'python.startREPL', shellescape(<q-args>))|
endif


" Atexit: {{{1
" For a reference go to $VIMRUNTIME/ftplugin/python.vim
let b:undo_ftplugin = 'setlocal lbr< tw< cms< et< sts< ts< sw< cc< fdm< kp<'
      \ . '|setlocal sr< sua< isk< ep< fp< path< cinw<'
      \ . '|setlocal comments<'
      \ . '|setlocal include<'
      \ . '|setlocal indentkeys<'
      \ . '|setlocal omnifunc<'
      \ . '|setlocal cinkeys<'
      \ . '|unlet! b:undo_ftplugin'

let &cpoptions = s:cpo_save
unlet s:cpo_save
