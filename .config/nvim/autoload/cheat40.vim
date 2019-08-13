" Cheat40: Autoloaded Functions
" Author:              Lifepillar
" Maintainer:          Faris Chugthai
" Previous Maintainer: Lifepillar
" License:             Distributed under the same terms as Vim itself. See :help license.

if exists('g:did_cheat40_autoload_vim') || &compatible || v:version < 700
    finish
endif
let g:did_cheat40_autoload_vim = 1

let s:cheat40_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

" echomsg 'cheat40dir is' . s:cheat40_dir
" let s:cheat40_dir = expand('$XDG_CONFIG_HOME') . '/nvim'

function! s:slash() abort
  " Courtesy of Pathogen
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction


function! s:split(path) abort
  " Split a path into a list. Code from Pathogen.
  " Does this function still work with windows paths? Hm.

  if type(a:path) == type([]) 
    return a:path 
  endif

  if empty(a:path) 
    return [] 
  endif

  let split = split(a:path,'\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val,''\\\([\\,]\)'',''\1'',"g")')
endfunction

function! cheat40#open(newtab)
  " Wait why the \ like do we actually need those to separate options?
  if a:newtab
    tabnew +setlocal\ buftype=nofile\ bufhidden=hide\ nobuflisted\ noswapfile\ winfixwidth

  else
    " So many of these things should be configurable variables not hardcoded
    botright 40vnew +setlocal\ buftype=nofile\ bufhidden=hide\ nobuflisted\ noswapfile\ winfixwidth
  endif
  if get(g:, 'cheat40_use_default', 1)
    execute '$read' s:cheat40_dir.s:slash().'cheat40.txt'
  endif

  " This seems like an unnecessary for loop and rtps get really long.

  " We could and probably should break up the functionality but also check that we haven't set where that file is.
  " for glob in reverse(s:split(&runtimepath))
  "   for cs in filter(map(filter(split(glob(glob), "\n"), 'v:val !~ "cheat40"'), 'v:val.s:slash()."cheat40.txt"'), 'filereadable(v:val)')
  "     execute "$read" cs
  "   endfor
  " endfor
  norm ggd_
  setlocal foldlevel=1 foldmethod=marker foldtext=substitute(getline(v:foldstart),'\\s\\+{{{.*$','','')
  setlocal concealcursor=nc conceallevel=3
  setlocal expandtab  nospell nowrap
  " nonumber norelativenumber nomodifiable textwidth=40 here are the options i didn't want
  setlocal fileencoding=utf-8 filetype=cheat40
  setlocal iskeyword=@,48-57,-,/,.,192-255
  execute 'setlocal' 'tags='.s:cheat40_dir.s:slash().'tags'
  nnoremap <silent> <buffer> <tab> <c-w><c-p>

  " This mapping doesn't work when run as `:Cheat40!`
  nnoremap <silent> <buffer> q <c-w><c-p>@=winnr("#")<cr><c-w>c
endfunction
