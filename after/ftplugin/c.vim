" ============================================================================
    " File: c.vim
    " Author: Faris Chugthai
    " Description: The C Programming Language
    " Last Modified: Nov 06, 2019
" ============================================================================

" Guard: {{{1
let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1
" GCC					*quickfix-gcc*	*compiler-gcc*

" There's one variable you can set for the GCC compiler:

" 				Ignore lines that don't match any patterns
" 				defined for GCC.  Useful if output from
" 				commands run from make are generating false
				" positives.
let g:compiler_gcc_ignore_unmatched_lines = 1

setlocal suffixesadd=.c,.h,.cpp
setlocal cindent

if filereadable('Makefile')
  setlocal makeprg=make\ %<.o

elseif executable('gcc')  " Because of windows
  compiler gcc
  setlocal makeprg=gcc\ %<.o
  echomsg 'after/ftplugin/c.vim: Using gcc as the compiler'
endif

if exists(':Man') == 2
  setlocal keywordprg=:Man
endif

setlocal omnifunc=ccomplete#Complete

" Path: {{{2

" TODO: setlocal include
setlocal include=^\s*#\s*include
" setlocal define
" setlocal includexpr
" setlocal cinwords cinkeys etc etc
let &l:path=ftplugins#CPath()

let b:undo_ftplugin = 'setlocal sua< cin< mp< ofu< kp< include<'
      \ . '|unlet! &l:path'
      \ . '|unlet! b:undo_ftplugin'

" Mappings: {{{1
nnoremap <buffer> <F5> :call ftplugins#ClangCheck()<CR><CR>

let b:undo_ftplugin .= 'nunmap <buffer> <F5>'

" Idk why <CR> is  there twice and idk if it was a typo on the part of the
" Clang people but its in their official documentation..
"
" Cscope: {{{2
if has('cscope') && executable('cscope')
  " Reasonably good inspiration for other ftplugins

  nnoremap <buffer> <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <buffer> <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
  " TODO:
  let b:undo_ftplugin .= 'nunmap <buffer> <C-\>s'
        \ . '| nunmap <buffer> <C-\>g'
        \ . '| nunmap <buffer> <C-\>c'
        \ . '| nunmap <buffer> <C-\>t'
        \ . '| nunmap <buffer> <C-\>e'
        \ . '| nunmap <buffer> <C-\>f'
        \ . '| nunmap <buffer> <C-\>i'


  " Using 'CTRL-spacebar', the result is displayed in new horizontal window.
  " This simply prints Nul when you run `:map`???
  nnoremap <buffer> <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <buffer> <C-@>i :scs find i <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
  " Hitting CTRL-space *twice*, the result is displayed in new vertical window.
  nnoremap <buffer> <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <buffer> <C-@><C-@>i :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
  nnoremap <buffer> <2-LeftMouse> :cs find d <C-R>=expand("<cword>")<CR>:<C-R>=line('.')<CR>:%<CR>
  nnoremap <buffer> <C-LeftMouse> :cs find d <C-R>=expand("<cword>")<CR>:<C-R>=line('.')<CR>:%<CR>

  let b:undo_ftplugin .= 'nunmap <buffer> <C-@>s'
        \ . '| nunmap <buffer> <C-@>g'
        \ . '| nunmap <buffer> <C-@>c'
        \ . '| nunmap <buffer> <C-@>t'
        \ . '| nunmap <buffer> <C-@>e'
        \ . '| nunmap <buffer> <C-@>f'
        \ . '| nunmap <buffer> <C-@>i'
        \ . '| nunmap <buffer> <C-@><C-@>g'
        \ . '| nunmap <buffer> <C-@><C-@>c'
        \ . '| nunmap <buffer> <C-@><C-@>t'
        \ . '| nunmap <buffer> <C-@><C-@>e'
        \ . '| nunmap <buffer> <C-@><C-@>f'
        \ . '| nunmap <buffer> <C-@><C-@>i'
        \ . '| nunmap <buffer> <2-LeftMouse>'
        \ . '| nunmap <buffer> <C-LeftMouse'

endif

" Atexit: {{{1

" Oh shit the unmaps for this are gonna be annoying

let &cpoptions = s:cpo_save
unlet s:cpo_save
