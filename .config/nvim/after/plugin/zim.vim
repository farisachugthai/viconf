" ============================================================================
  " File: zim.vim
  " Author: Faris Chugthai
  " Description: zim configuration
  " Last Modified: May 04, 2019
" ============================================================================

if isdirectory(glob('~/projects/zim'))
  let g:zim_notebooks_dir = glob('~/projects/zim')

elseif isdirectory(glob('~/Notebooks/Notes'))
  let g:zim_notebooks_dir = glob('~/Notebooks/Notes')
endif
