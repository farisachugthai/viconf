" ============================================================================
  " File: man.vim
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with help buffers
  " Last Modified: July 23, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=c

" Pydoc Cword: {{{1
function! pydoc_help#PydocCword() abort
    enew
    exec ':r! pydoc <cword>'
endfunction

" Pydoc Split Cword: {{{1
function! pydoc_help#SplitPydocCword() abort
    split
    enew
    exec ':r! pydoc <cword>'
endfunction

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
