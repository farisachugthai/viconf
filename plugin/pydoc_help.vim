" ============================================================================
    " File: pydoc_help.vim
    " Author: Faris Chugthai
    " Description: pydoc and man vim hooks
    " Last Modified: Nov 02, 2019
" ============================================================================

" Guards: {{{
let s:cpo_save = &cpoptions
set cpoptions-=C

" Autocmds: {{{

augroup PydocHelp
  au!
  autocmd Filetype man,help setlocal number relativenumber
  autocmd Filetype man,help  if winnr('$') > 1
        \| wincmd T
        \| endif
  autocmd Filetype python call py#ALE_Python_Conf()
  autocmd Filetype python call py#PythonPath()
augroup END

" }}}
" Commands: {{{1

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
command! -nargs=1 -complete=help Help call pydoc_help#Helptab()
" if has('python') || has('python3')
command! -nargs=0 -range PydocThis call pydoc_help#PydocCword()
" This should be able to take the argument '-bang' and allow to open in a new
" separate window like fzf does.
command! -nargs=0 PydocSplit call pydoc_help#SplitPydocCword()
command! -nargs=? Pydoc call pydoc_help#Pydoc(<f-args>)

  " i just messed that function up pretty bad
  " command! -nargs=1 PydocMod call pydoc_help#ShowPyDoc('<args>', 1)
  " command! -nargs=* PydocModSearch call pydoc_help#ShowPyDoc('<args>', 0)
" endif

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
