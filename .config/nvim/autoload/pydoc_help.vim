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

  " Holy shit it works!!!
  let s:temp_cword = expand('<cWORD>')
  enew
  exec ':r! pydoc ' . s:temp_cword
  setlocal relativenumber
  setlocal filetype=rst
  setlocal nomodified
  setlocal buflisted
  silent setlocal nomodifiable

  " If you wanna keep going we can change the status line. We can change how
  " we invoke python
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
