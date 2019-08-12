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

" Fun With Clipboards: {{{1

" Set Clipboard: {{{2
if has('unnamedplus')                   " Use the system clipboard.
    set clipboard+=unnamed,unnamedplus
else                                        " Accommodate Termux
    set clipboard+=unnamed
endif

set pastetoggle=<F7>

" Remote Hosts: {{{1

if has('unix')
  " This is still gonna be tough because exepath('python') on termux ==
  " python3 and on wsl == python2...
  if exists($ANDROID_DATA)
    let g:python3_host_prog = exepath('python')
    let g:loaded_python_provider = 1
  else
    let g:python3_host_prog = exepath('python3')
    let g:python_host_prog = exepath('python')
  endif

else  " windows not wsl
  if !empty($CONDA_PREFIX)
    let g:python3_host_prog = expand($CONDA_PREFIX) . '/python.exe'
  else
    let g:python3_host_prog = 'C:/tools/miniconda3/python.exe'
  endif
  let g:python_host_prog = 'C:/tools/miniconda3/envs/ansible/python.exe'
  let loaded_ruby_provider = 1
  let g:node_provider_host = 'C:/Users/faris/AppData/Local/Yarn/global/node_modules/neovim/bin/cli.js'

  let g:clipboard = {
        \   'name': 'winClip',
        \   'copy': {
        \      '+': 'win32yank.exe -i --crlf',
        \      '*': 'win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --lf',
        \      '*': 'win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 1,
        \ }
endif

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
