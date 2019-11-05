" ============================================================================
  " File: undotree.vim
  " Author: Faris Chugthai
  " Description: Undotree.
  " Last Modified: September 11, 2019 
" ============================================================================

" Guard: {{{1
if exists('g:did_undotree_vim') || &compatible || v:version < 700
  finish
endif
let g:did_undotree_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

let g:undotree_SetFocusWhenToggle = 1

" Mappings: {{{1

nnoremap U <Cmd>UndoTreeToggle<CR>


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
