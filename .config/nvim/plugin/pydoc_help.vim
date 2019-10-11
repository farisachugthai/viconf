" ============================================================================
    " File: man.vim
    " Author: Faris Chugthai
    " Description: pydoc and man vim hooks
    " Last Modified: Jun 13, 2019
" ============================================================================

" Guards: {{{1
if exists('g:loaded_pydoc_plugin') || &compatible
    finish
endif
let g:loaded_pydoc_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

if !exists('g:pydoc_window')
  " Check in <../autoload/pydoc_help.vim> for function definitions
  let g:pydoc_window = 'split'  " should this be an int or str. hm.
endif

  if g:pydoc_window == 'split'
    let s:pydoc_action = 'split'
  elseif g:pydoc_window == 'vert'
    let s:pydoc_action = 'vert'
  elseif g:pydoc_window == 'tab'
    let s:pydoc_action = 'tab'
  else
    throw 'pydoc_help: plugin: Option not recognized.'
  endif

" Autocmds: {{{1
augroup mantabs
  au!
  autocmd Filetype man,help call pydoc_help#Helptab()
augroup END


" Maopings: {{{1

" Avoid accidental hits of <F1> while aiming for <Esc>
noremap! <F1> <Esc>


" Commands: {{{1
" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
command! -nargs=1 -complete=help Help call pydoc_help#Helptab()

if &filetype ==# 'python'
  runtime autoload/pydoc_help.vim
endif

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
