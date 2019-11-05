" ============================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019 
" ============================================================================

" Guard: {{{1

let s:cpo_save = &cpoptions
set cpo-=C


" Vim Official Ftplugin: {{{1
" Set this globally
let g:ft_man_folding_enable = 1
let g:ft_man_open_mode = "tab"

if &filetype !=# 'man'
  finish  " why is the whole file wrapped in an if else?
endif

" Yours: {{{1
  " Kinda pointless in a man pagr
setlocal foldcolumn=0 signcolumn=
setlocal wrap linebreak

setlocal buftype=nofile
setlocal noswapfile
setlocal bufhidden=hide
setlocal nomodified
setlocal readonly
setlocal nomodifiable
setlocal noexpandtab
setlocal tabstop=8
setlocal softtabstop=8
setlocal shiftwidth=8
setlocal breakindent
setlocal number relativenumber

if !exists('g:no_plugin_maps') && !exists('g:no_man_maps')
  noremap <buffer> q <Cmd>bd<CR>
  " Check the rplugin/python3/pydoc.py file
  noremap <buffer> P <Cmd>call pydoc_help#PydocThis<CR>
endif

"Filetype  Nvim Official Ftplugin: {{{1
if !exists('g:no_plugin_maps') && !exists('g:no_man_maps')
  nnoremap <silent> <buffer> j          gj
  nnoremap <silent> <buffer> k          gk
  nnoremap <silent> <buffer> gO         :call man#show_toc()<CR>
  nnoremap <silent> <buffer> <C-]>      :Man<CR>
  nnoremap <silent> <buffer> K          :Man<CR>
  nnoremap <silent> <buffer> <C-T>      :call man#pop_tag()<CR>

  " allow dot and dash in manual page name.
  setlocal iskeyword+=\.,-
  let b:undo_ftplugin = 'setlocal isk< buftype< swf< bufhidden< mod< ro< ma< et< ts< sts< sw< wrap< breakindent< '

endif

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set sw=2 ts=8 noet:
