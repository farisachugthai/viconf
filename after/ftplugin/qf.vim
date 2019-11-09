" ============================================================================
  " File: qf.vim
  " Author: Faris Chugthai
  " Description: Quickfix mods
  " Last Modified: October 26, 2019
" ============================================================================

" Guards: {{{1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

" set makeef=##  should set this to something i guess. and errorfile is dumb
" too. should have more qf settings i guess

" Mappings: {{{1
"
nnoremap <buffer> <Left> :colder<CR>
nnoremap <buffer> <Right> :cnewer<CR>

" Stl: {{{1
"
if !get(g:, 'qf_disable_statusline')
  let b:undo_ftplugin = "set stl<"

  " Display the command that produced the list in the quickfix window:
  setlocal stl=%t%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
endif

" Plugins: {{{1
if !exists('g:loaded_qf')
  finish
endif

let g:qf_mapping_ack_style = 1

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
