" ============================================================================
    " File: xonsh.vim
    " Author: Faris Chugthai
    " Description: xonsh ftplugin
    " Last Modified: March 14, 2019
" ============================================================================

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" The syntax file specified it.
let g:xsh_highlight_all = 1

" Also the fact that this isn't enabled to begin with is a problem
runtime $VIMRUNTIME/ftplugin/python.vim

" Add in my python modifications
source $XDG_CONFIG_HOME/nvim/after/ftplugin/python.vim

setlocal commentstring=#\ %s
