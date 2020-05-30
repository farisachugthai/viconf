" ============================================================================
  " File: python.vim
  " Author: Faris Chugthai
  " Description: Syntax updates
  " Last Modified: March 22, 2020
" ============================================================================

let g:python_space_error_highlight = 1

" " Otherwise this probably got set
" unlet! b:current_syntax
" source $VIMRUNTIME/syntax/python.vim

" Personal Overrides: {{{
" They missed one! A python3.4 thing I think.
syn keyword pythonNewExceptions ModuleNotFoundError

" try/except is matched as a pythonException but else isn't and is recognized
" as a pythonConditional.
syn keyword pythonExceptionElse else
" let's either group them together or highlight them the same.

" New func
syn keyword pythonBuiltinFuncThreeSeven breakpoint

" Highlight the keys in keyword arguments correctly
syn region FCall start='[[:alpha:]_]\i*\s*(' end=')' contains=FCall,FCallKeyword
syn match FCallKeyword /\i*\ze\s*=[^=]/ contained

hi default link FCallKeyword Yellow
hi default link pythonBuiltinFuncThreeSeven pythonBuiltinFunc
hi default link pythonExceptionElse pythonException
hi default link pythonNewExceptions pythonException

" }}}
