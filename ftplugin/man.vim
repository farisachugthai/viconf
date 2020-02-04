" ============================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" Vim Official Ftplugin: {{{1
" Set this globally
let g:ft_man_folding_enable = 1
let g:ft_man_open_mode = "tab"

if &filetype !=# 'man'
  finish  " why is the whole file wrapped in an if else?
endif

" Yours: {{{1
  " Kinda pointless in a man page
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

let b:undo_ftplugin  = 'setlocal isk< buftype< swf< bufhidden< mod< ro< '

if !exists('g:no_plugin_maps') && !exists('g:no_man_maps')
  nnoremap <buffer> q <Cmd>bd<CR>
  " Check the rplugin/python3/pydoc.py file
  nnoremap <buffer> P <Cmd>call pydoc_help#PydocThis<CR>

  let b:undo_ftplugin .= '| nunmap <buffer> q'
	\ . '| nunmap <buffer> P'
endif

"Filetype  Nvim Official Ftplugin: {{{1
if !exists('g:no_plugin_maps') && !exists('g:no_man_maps')
  nnoremap <silent> <buffer> j          gj
  nnoremap <silent> <buffer> k          gk
  nnoremap <silent> <buffer> gO         :call man#show_toc()<CR>
  nnoremap <silent> <buffer> <C-]>      :Man<CR>
  nnoremap <silent> <buffer> K          :Man<CR>
  nnoremap <silent> <buffer> <C-T>      :call man#pop_tag()<CR>

  let b:undo_ftplugin .= 'nunmap <buffer> j'
	\ . '|nunmap <buffer> k'
	\ . '|nunmap <buffer> gO'
	\ . '|nunmap <buffer> <C-]>'
	\ . '|nunmap <buffer> K'
	\ . '|nunmap <buffer> <C-T>'
  " allow dot and dash in manual page name.
  setlocal iskeyword+=\.,-
  let b:undo_ftplugin .= '|setlocal isk<'
endif


let b:undo_ftplugin  .= '|setlocal ma< et< ts< sts< sw< wrap< breakindent< '
                    \ . '|unlet! b:undo_ftplugin'
                    \ . '|unlet! b:did_ftplugin'
