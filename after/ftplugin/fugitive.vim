" ============================================================================
  " File: fugitive.vim
  " Author: Faris Chugthai
  " Description: A description of the file below
  " Last Modified: February 16, 2020
" ============================================================================

if exists('b:loaded_fugitive_ftplugin') | finish | endif
let b:loaded_fugitive_ftplugin = 1

if &filetype !=# 'fugitive'
  finish
endif

nnoremap q <Cmd>bd!<CR>
