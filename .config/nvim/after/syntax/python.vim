" It feels a little silly to do too much for this one line of code so let's
" not.

" Guard: {{{1
if exists('g:did_after_syntax_python') || &compatible || v:version < 700
  finish
endif
let g:did_after_syntax_python = 1

" Original: {{{1
runtime syntax/python.vim

" Personal Overrides: {{{1
" They missed one! A python3.4 thing I think.
syn keyword pythonExceptions ModuleNotFoundError

" try/except is matched as a pythonException but else isn't and is recognized
" as a pythonConditional.
syn keyword pythonException else
" let's either group them together or highlight them the same.
