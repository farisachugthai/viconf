" ============================================================================
  " File: tmux.vim
  " Author: Faris Chugthai
  " Description: Tmux ftplugin
  " Last Modified: March 10, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/tmux.vim

" It feels quite dumb to make a whole file just for this but
setlocal iskeyword+=-
setlocal iskeyword+=#
syntax sync fromstart

" TODO: the official ftplugin never defined an undo ftplugin.
" ...should probably do that.
"
let b:undo_ftplugin = 'setlocal isk< cms< '
      \ . '|unlet! b:did_ftplugin'
      \ . '|unlet! b:undo_ftplugin'
