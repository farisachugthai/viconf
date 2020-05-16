" =========================================================================
    " File: c.vim
    " Author: Faris Chugthai
    " Description: The C Programming Language
    " Last Modified: Nov 06, 2019
" =========================================================================

" Only do this when not done yet for this buffer
if exists('b:did_ftplugin') | finish | endif

" Options: {{{
" GCC					*quickfix-gcc*	*compiler-gcc*
" There's one variable you can set for the GCC compiler:
" Ignore lines that don't match any patterns
" defined for GCC.  Useful if output from
" commands run from make are generating false positives.
let g:compiler_gcc_ignore_unmatched_lines = 1

source $VIMRUNTIME/ftplugin/c.vim
" source $VIMRUNTIME/indent/c.vim
setlocal foldmethod=syntax
setlocal suffixesadd=.c,.h,.cpp
setlocal cindent

if filereadable('Makefile')
  setlocal makeprg=make\ %<.o

elseif executable('gcc')  " Because of windows
  compiler gcc
  setlocal makeprg=gcc\ %<.o
  echomsg 'ftplugin/c.vim: Using gcc as the compiler'
elseif executable('nmake')
  compiler msvc
endif

if exists(':Man') == 2
  setlocal keywordprg=:Man
endif
setlocal include=^\s*#\s*include
" setlocal define
" setlocal includexpr
" setlocal cinwords cinkeys etc etc
let &l:path=includes#CPath()
if getenv('MANPATH')
  let &l:path .= expand('$MANPATH')
endif


" ALE:
let l:lines='all'
let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
let b:ale_fixers += [ 'clang-format' ]

if filereadable('C:/tools/vs/2019/Community/VC/Tools/Llvm/bin/clang-format.exe')
  let g:clang_format_path = 'C:/tools/vs/2019/Community/VC/Tools/Llvm/bin/clang-format.exe'
endif

" Cleanup:
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal fdm< sua< cin< mp< efm< kp< include<'
      \. '|unlet! &l:path'
      \. '|unlet! b:undo_ftplugin'
      \. '|unlet! b:did_ftplugin'
      \. '|unlet! b:ale_fixers'
      \. '|unlet! b:undo_ftplugin'
      \. '|silent! nunmap <buffer> <F5>'
      \. '|silent! nunmap <buffer> <Leader>ef'

nnoremap <buffer> <F5> <Cmd>call ftplugins#ClangCheck()<CR>
" }}}

" Cscope: {{{
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
  let b:undo_ftplugin .= '|silent! nunmap <buffer> <C-\>s'
        \. '|silent! nunmap <buffer> <C-\>g'
        \. '|silent! nunmap <buffer> <C-\>c'
        \. '|silent! nunmap <buffer> <C-\>t'
        \. '|silent! nunmap <buffer> <C-\>e'
        \. '|silent! nunmap <buffer> <C-\>f'
        \. '|silent! nunmap <buffer> <C-\>i'


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

  let b:undo_ftplugin .= '|silent! nunmap <buffer> <C-@>s'
        \. '|silent! nunmap <buffer> <C-@>g'
        \. '|silent! nunmap <buffer> <C-@>c'
        \. '|silent! nunmap <buffer> <C-@>t'
        \. '|silent! nunmap <buffer> <C-@>e'
        \. '|silent! nunmap <buffer> <C-@>f'
        \. '|silent! nunmap <buffer> <C-@>i'
        \. '|silent! nunmap <buffer> <C-@><C-@>g'
        \. '|silent! nunmap <buffer> <C-@><C-@>c'
        \. '|silent! nunmap <buffer> <C-@><C-@>t'
        \. '|silent! nunmap <buffer> <C-@><C-@>e'
        \. '|silent! nunmap <buffer> <C-@><C-@>f'
        \. '|silent! nunmap <buffer> <C-@><C-@>i'
        \. '|silent! nunmap <buffer> <2-LeftMouse>'
        \. '|silent! nunmap <buffer> <C-LeftMouse'

endif
" }}}
