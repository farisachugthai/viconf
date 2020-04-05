" ============================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019
" ============================================================================

" Set this globally: {{{
" Also this is checked in the ftplugin so ensure it's above the source
let g:ft_man_folding_enable = 1
let g:ft_man_open_mode = "tab"

if exists('b:did_ftplugin') | finish | endif
" }}}

" Yours: {{{
source $VIMRUNTIME/ftplugin/man.vim
" Speaking of which...here's the undo_ftplugin that the official ftplugin gives....
let b:undo_ftplugin = ''
" WHY!

" allow dot and dash in manual page name.
setlocal iskeyword+=\.,-

" Override the ftplugin
setlocal buftype=
setlocal bufhidden=
setlocal noreadonly
setlocal modifiable
setlocal number relativenumber
setlocal signcolumn=auto:4

" Like guys we have to define this correctly and fix things!
let b:undo_ftplugin  = 'setlocal isk< buftype< swf< bufhidden< mod< ro< '

if !exists('g:no_plugin_maps') && !exists('g:no_man_maps')
  nnoremap <buffer> q <Cmd>bd<CR>
  " Check the rplugin/python3/pydoc.py file
  nnoremap <buffer> P <Cmd>call pydoc_help#PydocThis<CR>

  let b:undo_ftplugin .= '|silent! nunmap <buffer> q'
	\ . '|silent! nunmap <buffer> P'
endif
" }}}

"Filetype  Nvim Official Ftplugin: {{{1
if !exists('g:no_plugin_maps') && !exists('g:no_man_maps')
  " I'm gonna use their check as well but only add to the undo_ftplugin
  let b:undo_ftplugin .= 'nunmap <buffer> j'
	\ . '|silent! nunmap <buffer> k'
	\ . '|silent! nunmap <buffer> gO'
	\ . '|silent! nunmap <buffer> <C-]>'
	\ . '|silent! nunmap <buffer> K'
	\ . '|silent! nunmap <buffer> <C-T>'
  " allow dot and dash in manual page name.
  setlocal iskeyword+=\.,-
  let b:undo_ftplugin .= '|setlocal isk<'
endif


let b:undo_ftplugin  .= '|setlocal ma< et< ts< sts< sw< wrap< breakindent< '
                    \ . '|unlet! b:undo_ftplugin'
                    \ . '|unlet! b:did_ftplugin'

" }}}
