" ============================================================================
    " File: fugitive.vim
    " Author: Faris Chugthai
    " Description: Fugitive configuration
    " Last Modified: March 30, 2019
" ============================================================================

" Guards: {{{1

if !has_key(plugs, 'vim-fugitive')
    finish
endif

if exists('g:did_fugitive_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_fugitive_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

" Surprisingly git.exe didn't work
" if !has('unix')
"   let g:fugitive_git_executable = 'git.exe'
" else
"   let g:fugitive_git_executable = 'git'
" endif

" Mappings: {{{1

if !exists('no_plugin_maps') && !exists('no_fugitive_vim_maps')
  " Forgot an important one!
  if g:loaded_fugitive == 1  " lol make sure fugitive was loaded!!!
    call plugins#FugitiveMappings()
  endif
endif

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
