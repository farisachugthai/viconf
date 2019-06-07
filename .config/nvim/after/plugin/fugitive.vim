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
set cpoptions&vim

" Options: {{{1

let g:fugitive_git_executable = 'git'

" Mappings: {{{1

" TODO: should probably add that if !exists('no_plugin_maps') check

function! FugitiveMappings() abort

  noremap <silent> <Leader>gb   <Cmd>Gblame<CR>
  noremap <silent> <Leader>gc   <Cmd>Gcommit<CR>
  noremap <silent> <Leader>gd   <Cmd>Gdiff<CR>
  cabbrev Gd Gdiff
  noremap <silent> <Leader>gds  <Cmd>Gdiff --staged<CR>
  noremap <silent> <Leader>gds2 <Cmd>Git diff --stat --staged<CR>
  noremap <silent> <Leader>ge   <Cmd>Gedit<Space>
  noremap <silent> <Leader>gf   <Cmd>Gfetch<CR>
  noremap <silent> <Leader>gL   <Cmd>0Glog --pretty=oneline --graph --decorate --abbrev --all --branches<CR>
  noremap <silent> <Leader>gm   <Cmd>Gmerge<CR>
  " Make the mapping longer but clear as to whether gp would pull or push
  noremap <silent> <Leader>gpl  <Cmd>Gpull<CR>
  noremap <silent> <Leader>gps  <Cmd>Gpush<CR>
  noremap <silent> <Leader>gq   <Cmd>Gwq<CR>
  noremap <silent> <Leader>gQ   <Cmd>Gwq!<CR>
  noremap <silent> <Leader>gR   :Gread<Space>
  noremap <silent> <Leader>gs   <Cmd>Gstatus<CR>
  noremap <silent> <Leader>gst  <Cmd>Git diff --stat<CR>
  noremap <silent> <Leader>gw   <Cmd>Gwrite<CR>
  noremap <silent> <Leader>gW   <Cmd>Gwrite!<CR>

endfunction

if !exists('no_plugin_maps') && !exists('no_fugitive_vim_maps')
  call FugitiveMappings()
endif

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
