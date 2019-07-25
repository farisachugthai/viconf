" ============================================================================
    " File: c.vim
    " Author: Faris Chugthai
    " Description: The C Programming Language
    " Last Modified: Jul 17, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_c_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_c_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

setlocal suffixesadd='.c'
setlocal suffixesadd+='.h'
setlocal cindent

" Plugins: {{{1
" let b:ale_fixers = [ 'clang-format' ]

" " Should add a mapping

" let g:clang_format_path =  expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'

" noremap <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'

" noremap! <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'

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
" autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

" This is honestly really useful if you simply swap out the filetype
" function! ClangCheckImpl(cmd)
"   if &autowrite | wall | endif
"   echo "Running " . a:cmd . " ..."
"   let l:output = system(a:cmd)
"   cexpr l:output
"   cwindow
"   let w:quickfix_title = a:cmd
"   if v:shell_error != 0
"     cc
"   endif
"   let g:clang_check_last_cmd = a:cmd
" endfunction

" function! ClangCheck()
"   let l:filename = expand('%')
"   if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
"     call ClangCheckImpl("clang-check " . l:filename)
"   elseif exists("g:clang_check_last_cmd")
"     call ClangCheckImpl(g:clang_check_last_cmd)
"   else
"     echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
"   endif
" endfunction

" nmap <silent> <F5> :call ClangCheck()<CR><CR>

" Idk why <CR> is  there twice and idk if it was a typo on the part of the
" CLANG people but its in their official documentation..

setlocal makeprg=make\ %<.o

" Atexit: {{{1

let b:undo_ftplugin = 'set sua< makeprg< cin<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
