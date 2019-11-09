" ============================================================================
    " File: c.vim
    " Author: Faris Chugthai
    " Description: The C Programming Language
    " Last Modified: Nov 06, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_c_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_c_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

setlocal suffixesadd=.c,.h,.cpp
setlocal cindent
if filereadable('Makefile')
  setlocal makeprg=make\ %<.o
endif

if executable('gcc')  " Because of windows
  compiler gcc
  echomsg 'ftplugin/cpp.vim: Using gcc as the compiler'
endif

if exists(':Man') == 2
  setlocal keywordprg=:Man
endif

setlocal omnifunc=ccomplete#Complete

" Path: {{{2

" TODO:
" setlocal include
" setlocal define
" setlocal includexpr
" setlocal cinwords cinkeys etc etc

let &l:path=ftplugins#CPath()

" Cscope Mappings: {{{1
if has('cscope') && executable('cscope')
  " Reasonably good inspiration for other ftplugins

  nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

  " Using 'CTRL-spacebar', the result is displayed in new horizontal window.
  nnoremap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <C-@>i :scs find i <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
  " Hitting CTRL-space *twice*, the result is displayed in new vertical window.
  nnoremap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <C-@><C-@>i :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
  nnoremap <2-LeftMouse> :cs find d <C-R>=expand("<cword>")<CR>:<C-R>=line('.')<CR>:%<CR>
  nnoremap <C-LeftMouse> :cs find d <C-R>=expand("<cword>")<CR>:<C-R>=line('.')<CR>:%<CR>
endif


" Atexit: {{{1

" Oh shit the unmaps for this are gonna be annoying
let b:undo_ftplugin = 'set sua< cin< makeprg< ofu< kp< '
      \ . '|unlet! l&:path'
      \ . '|unlet! b:undo_ftplugin'


let &cpoptions = s:cpo_save
unlet s:cpo_save
