" header
" It feels a little silly to do too much for this one line of code so let's not.

let g:python_space_error_highlight = 1

" Source it once per buffer
if exists('b:did_after_syntax_python') || &compatible || v:version < 700
  finish
endif
let b:did_after_syntax_python = 1

" Well i mean a specific kind
if &filetype !=# 'python'
  finish
endif

" Otherwise this probably got set
unlet! b:current_syntax
source $VIMRUNTIME/syntax/python.vim

" Personal Overrides: {{{
" They missed one! A python3.4 thing I think.
syn keyword pythonExceptions ModuleNotFoundError

" try/except is matched as a pythonException but else isn't and is recognized
" as a pythonConditional.
syn keyword pythonException else
" let's either group them together or highlight them the same.

" New func
syn keyword pythonBuiltinFunc breakpoint
