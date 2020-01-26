" ============================================================================
    " File: pydoc_help.vim
    " Author: Faris Chugthai
    " Description: pydoc and man vim hooks
    " Last Modified: Nov 02, 2019
" ============================================================================

augroup UserHelpandPython
  au!
  autocmd FileType man,help setlocal number relativenumber
  autocmd FileType man,help  if winnr('$') > 1
        \| wincmd T
        \| endif

  autocmd FileType python let &l:path = py#PythonPath()
  autocmd FileType python call py#ALE_Python_Conf()
augroup END

if has('python3')
    command! -range -nargs=+ Pythonx <line1>,<line2>python3 <args>
    " FUCK YEA! Dec 27, 2019: Behaves as expected!
    command! -nargs=? Pd python3 print(dir(<args>))

elseif has('pythonx')
    command! -range -nargs=+ Pythonx <line1>,<line2>pythonx <args>
elseif has('python')
    command! -range -nargs=+ Pythonx <line1>,<line2>python <args>
endif

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
command! -nargs=1 -complete=help Help call pydoc_help#Helptab()
" Needs to accept args for bang
command! -bang -bar PydocThis call pydoc_help#PydocCword()

" This should be able to take the argument '-bang' and allow to open in a new
" separate window like fzf does.
command! -nargs=0 PydocSplit call pydoc_help#SplitPydocCword()
command! -nargs=? Pydoc call pydoc_help#Pydoc(<f-args>)
command! -nargs=0 PydocShow call pydoc_help#show()

" TODO: Work on the range then the bang
command! -complete=file -range BlackCurrent <line1>,<line2>call py#Black()

command! -nargs=* -complete=file -complete=file_in_path BlackThese call py#black_these(<f-args>)
