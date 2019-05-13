" ============================================================================
    " File: c.vim
    " Author: Faris Chugthai
    " Description: The C Programming Language
    " Last Modified: April 23, 2019

" ============================================================================

" Options: {{{1

setlocal suffixesadd='.c'
setlocal suffixesadd+='.h'

" Plugins: {{{1
let b:ale_fixers = [ 'clang-format' ]

" Should add a mapping

let g:clang_format_path =  expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'

noremap <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'

noremap! <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'

" With this integration you can press the bound key and clang-format will
" format the current line in NORMAL and INSERT mode or the selected region in
" VISUAL mode. The line or region is extended to the next bigger syntactic
" entity.
"
" You can also pass in the variable "l:lines" to choose the range for
" formatting. This variable can either contain "<start line>:<end line>" or
" "all" to format the full file. So, to format the full file, write a function
" like:
function! FormatFile()
  let l:lines='all'
  pyf expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
endfunction
"
" It operates on the current, potentially unsaved buffer and does not create
" or save any files. To revert a formatting, just undo.

setlocal makeprg=make\ %<.o
