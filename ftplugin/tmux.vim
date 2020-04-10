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
syntax enable
setlocal path+=$HOME/.tmux,$_ROOT/share/byobu
setlocal include=^\s*\%(so\%[urce-file]\)\ *\zs*
setlocal suffixesadd=.tmux,.conf

" TODO: the official ftplugin never defined an undo ftplugin.
" ...should probably do that.

let b:undo_ftplugin = 'setlocal isk< cms< path< include< sua<'
      \ . '|unlet! b:did_ftplugin'
      \ . '|unlet! b:undo_ftplugin'
