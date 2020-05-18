" ============================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019
" ============================================================================

" Set This Globally:
" Also this is checked in the ftplugin so ensure it's above the source
let g:ft_man_folding_enable = 1
let g:ft_man_open_mode = 'tab'

if exists('b:did_ftplugin') | finish | endif

" Yours:
  source $VIMRUNTIME/ftplugin/man.vim
  " Speaking of which...here's the undo_ftplugin that the official ftplugin gives....
  let b:undo_ftplugin = ''
  " WHY!

  " Override the ftplugin
  " hate this mapping.
  silent! nunmap <buffer> q
  setlocal buftype=
  " setlocal bufhidden=
  " setlocal noreadonly
  setlocal modifiable
  setlocal number relativenumber
  " setlocal signcolumn=auto:4
  setlocal wrap
  " allow dot and dash in manual page name.
  setlocal iskeyword+=\.,-

  " also literally how is this not defined in the ftplugin??? its notably defined
  " EVERYWHERE else.
  if exists(':Man') == 2
    setlocal keywordprg=:Man
  endif

  " *******
  " BUG:
  " *******
  " MANPATH is set but getenv(anythibg) returns v:null
  " if getenv('$MANPATH')
  if exists('$MANPATH')
    let &l:path = expand('$MANPATH')
  elseif exepath('manpath')
    let &l:path = exepath('manpath')
  endif

  nnoremap <silent> <buffer> <nowait> q :lclose<CR>:bd<CR>
  nnoremap <expr> <buffer> gO         man#show_toc()

  " Like guys we have to define this correctly and fix things!
  let b:undo_ftplugin  = 'setlocal buftype< bufhidden< ro< mod< nu< rnu< signcolumn< wrap<'
                      \. '|setlocal swf< isk< kp< path<'
                      \. '|setlocal ma< et< ts< sts< sw< wrap< breakindent< swf<'
                      \. '|unlet! b:undo_ftplugin'
                      \. '|unlet! b:did_ftplugin'

" Nvim Official Ftplugin:

if !exists('g:no_plugin_maps') && !exists('g:no_man_maps')
  nnoremap <buffer> q <Cmd>bd<CR>
  " Check the rplugin/python3/pydoc.py file
  nnoremap <buffer> P <Cmd>call pydoc_help#PydocThis<CR>

  let b:undo_ftplugin .='|silent! nunmap <buffer> q'
	             \. '|silent! nunmap <buffer> P'
                     \. '|silent! nunmap <buffer> j'
                     \. '|silent! nunmap <buffer> k'
                     \. '|silent! nunmap <buffer> gO'
                     \. '|silent! nunmap <buffer> <C-]>'
                     \. '|silent! nunmap <buffer> K'
                     \. '|silent! nunmap <buffer> <C-T>'
endif

