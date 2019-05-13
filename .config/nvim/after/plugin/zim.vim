" ============================================================================
  " File: zim.vim
  " Author: Faris Chugthai
  " Description: zim configuration
  " Last Modified: May 04, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'vim-zim')
  finish
endif

if exists('b:did_zim_after_plugin') || &compatible || v:version < 700
  finish
endif
let b:did_zim_after_plugin = 1

" Options: {{{1

if isdirectory(glob('~/projects/zim'))
  let g:zim_notebooks_dir = glob('~/projects/zim')

elseif isdirectory(glob('~/Notebooks/Notes'))
  let g:zim_notebooks_dir = glob('~/Notebooks/Notes')
endif
