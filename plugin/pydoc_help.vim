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

command! -bar -complete=expression -complete=function -range -nargs=+ Pythonx <line1>,<line2>python3 <args>
" FUCK YEA! Dec 27, 2019: Behaves as expected!
" You know whats nice? Both of these expressions work.
" :Pd(vim.vars)
" :Pd vim.vars
command! -range -bar -complete=expression -complete=function -nargs=? Pd <line1>,<line2>python3 import(<args>);print(dir(<args>))

" Honestly i don't know what the <range> arg is providing to these commands
" and half the time it makes no sense but we may as well implement the whole
" interface
command! -range -bar -complete=expression -complete=function -nargs=? P <line1>,<line2>python3  print(<args>)

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
" Ah fzf is too good jesus christ. He provided all the arguments for you so
" all you have to do is ask "bang or not?"
command! -bar -bang -nargs=* -complete=help Help call fzf#vim#helptags(<bang> ? 1 : 0)

" Needs to accept args for bang
command! -bang -bar PydocThis call pydoc_help#PydocCword()

" This should be able to take the argument '-bang' and allow to open in a new
" separate window like fzf does.
" NOTE: See :he func-range to see how range can get passed automatically to
" functions without being specified in the command definition
command! -nargs=? -bar -range PydocSplit call pydoc_help#SplitPydocCword(<q-mods>)

" command! -bar -bang -range PydocSp
"       \ exec '<mods>split<bang>:python3 import pydoc'.expand('<cWORD>').'; pydoc.help('.expand('<cWORD>').')'
" holy fuck i just beefed this command up a lot. now takes a bang and should
" work more correctly.
" todo: i think i added a completefunc thatll work perfectly
" Man i really messed this one up. Look through the git log to see the older
" invocations
" command! -nargs=? -bang Pydoc :<mods>file<bang> exec 'call pydoc_help#Pydoc(<f-args>)'

command! PydocShow call pydoc_help#show()

" TODO: Work on the range then the bang
command! -complete=file -range BlackCurrent <line1>,<line2>call py#Black()

command! -nargs=* -complete=file -complete=file_in_path BlackThese call py#black_these(<f-args>)

function! s:IPythonOptions(...) abort
  let list = ['profile', 'history', 'kernel', 'locate']
  " Quote this with single quotes and it wont work correctly...WHAT THE FUCK
  return join(list, "\n")
endfunction

" So far works
command! -bar -bang -nargs=* -complete=dir -complete=custom,s:IPythonOptions IPy :<mods>term<bang> ipython <args>

