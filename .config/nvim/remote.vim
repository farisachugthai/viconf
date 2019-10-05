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

" Clipboards: {{{1
if has('unnamedplus')                   " Use the system clipboard.
    set clipboard+=unnamed,unnamedplus
else                                        " Accommodate Termux
    set clipboard+=unnamed
endif

set pastetoggle=<F7>

" Remote Hosts: {{{1

if has('unix')

  " Termux
  if exists($ANDROID_DATA)
    call find_files#termux_remote()
  " Ubuntu like or WSL
  else
    call find_files#ubuntu_remote()
  endif

  if exists($TMUX)
    let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': 'tmux load-buffer -',
          \      '*': 'tmux load-buffer -',
          \    },
          \   'paste': {
          \      '+': 'tmux save-buffer -',
          \      '*': 'tmux save-buffer -',
          \   },
          \   'cache_enabled': 1,
          \ }
  endif

else  " windows not wsl
  call find_files#msdos_remote()
endif

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
