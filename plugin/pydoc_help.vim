" ============================================================================
    " File: pydoc_help.vim
    " Author: Faris Chugthai
    " Description: pydoc and man vim hooks
    " Last Modified: Nov 02, 2019
" ============================================================================

if exists('g:loaded_pydoc_help_vim') || &compatible || v:version < 700
    finish
endif
let g:loaded_pydoc_help_vim = 1

let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

augroup UserHelpandPython
  au!
  autocmd FileType man,help setlocal number relativenumber
  autocmd FileType man,help  if winnr('$') > 1
        \| wincmd T
        \| endif

  autocmd FileType python exec 'source ' . s:repo_root . '/ftplugin/python.vim'
  autocmd FileType python let &l:path = py#PythonPath()
  autocmd FileType python call py#ALE_Python_Conf()
augroup END

command! -bar -complete=expression -complete=function -range -nargs=+ Pythonx <line1>,<line2>python3 <args>
" FUCK YEA! Dec 27, 2019: Behaves as expected!
" You know whats nice? Both of these expressions work.
" :Pd(vim.vars)
" :Pd vim.vars
command! -range -bar -complete=expression -complete=function -nargs=? Pd <line1>,<line2>python3 from pprint import pprint; pprint(dir(<args>))

" Honestly i don't know what the <range> arg is providing to these commands
" and half the time it makes no sense but we may as well implement the whole
" interface
command! -range -bar -complete=expression -complete=function -nargs=? P <line1>,<line2>python3  print(<args>)

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
" Ah fzf is too good jesus christ. He provided all the arguments for you so
" all you have to do is ask "bang or not?"
" Unfortunately the ternary expression <bang> ? 1 : 0 doesn't work; however,
" junegunn's <bang>0 does!
command! -bar -bang -nargs=* -complete=help Help call fzf#vim#helptags(<bang>0)

command! -range -bang -bar PydocThis call pydoc_help#PydocCword(<bang>, <mods>>)

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

" TODO: I have no idea what's going wrong with this command the only error i'm
" getting is `list required`.
" command! -complete=expression -bang -bar -count=1 -addr=buffers PydocShow call pydoc_help#show(<count>)
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

command!  NvimCxn call py#Cnxn()

" It's so annoying that buffers need confirmation to kill. Let's dedicate a
" key but one that we know windows hasn't stolen yet.
tnoremap <D-z> <Cmd>bd!<CR>
