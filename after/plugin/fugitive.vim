" ============================================================================
    " File: fugitive.vim
    " Author: Faris Chugthai
    " Description: Fugitive configuration
    " Last Modified: March 30, 2019
" ============================================================================

" Guards: {{{1
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
" Forgot an important one!
if exists('g:loaded_fugitive')
  call plugins#FugitiveMappings()
endif

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
