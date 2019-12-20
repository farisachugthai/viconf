" ============================================================================
    " File: pydoc_help.vim
    " Author: Faris Chugthai
    " Description: pydoc and man vim hooks
    " Last Modified: Nov 02, 2019
" ============================================================================

" Autocmds:
"
augroup PydocHelp
  au!
  autocmd Filetype man,help setlocal number relativenumber
  autocmd Filetype man,help  if winnr('$') > 1
        \| wincmd T
        \| endif
  autocmd Filetype python let &l:path = py#PythonPath()
  autocmd Filetype python call py#ALE_Python_Conf()
augroup END

" Commands:

if has('python3')
    command! -range -nargs=+ Pythonx <line1>,<line2>python3 <args>
    command! -nargs=? Pd python3 print(dir(<q-args>))

elseif has('pythonx')
    command! -range -nargs=+ Pythonx <line1>,<line2>pythonx <args>
elseif has('python')
    command! -range -nargs=+ Pythonx <line1>,<line2>python <args>
endif

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
