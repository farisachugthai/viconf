" ============================================================================
    " File: remote.vim
    " Author: Faris Chugthai
    " Description: All the remote hosts that Neovim loads
    " Last Modified: Jul 03, 2019
" ============================================================================

" Preliminaries: {{{1
scriptencoding utf-8
let s:cpo_save = &cpoptions
set cpoptions-=C

" Remote Hosts: {{{1

function! Python3_Exe() abort
  " Only run if windows because otherwise it gets so excessively complex
  if !empty($CONDA_PREFIX)
    return expand($CONDA_PREFIX)
  endif

  " TODO: The rest
endfunction

" We may even be able to remove the 2 separate functions
" with a ternary operator and concatenating the results of:
" let b:bin_dir = has('win32') ? 'Scripts' : 'bin'

if has('unix')
  " let g:python3_host_prog = Get_Python3_Remote_Host()
  " If this works as a functional substitute I'm gonna lose it.1
  let g:python3_host_prog = exepath('python')
  let g:loaded_python_provider = 1
else
  let g:python3_host_prog = Python3_Exe() . '/python.exe'

endif


" Fun With Clipboards: {{{1

" I've been using vim for almost 3 years. I still don't have copy paste ironed out...
" Let's start simple

" Set Clipboard: {{{2
if has('unnamedplus')                   " Use the system clipboard.
    set clipboard+=unnamed,unnamedplus
else                                        " Accommodate Termux
    set clipboard+=unnamed
endif

set pastetoggle=<F7>

" Clipboard Provider: {{{2
" Now let's set up the clipboard provider

" As insane as this might be....it might not be necessary
runtime $VIMRUNTIME/autoload/provider/clipboard.vim

let g:clipboard = provider#clipboard#Executable()

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
