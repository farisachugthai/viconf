" ============================================================================
  " File: tmux.vim
  " Author: Faris Chugthai
  " Description: Tmux ftplugin
  " Last Modified: March 10, 2020
" ============================================================================

" The Entire Builtin Ftplugin:
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=#\ %s

" Options:
  setlocal iskeyword+=-
  setlocal iskeyword+=#
  setlocal path+=$HOME/.tmux,$_ROOT/share/byobu
  setlocal include=^\s*\%(so\%[urce-file]\)\ *\zs*
  setlocal suffixesadd=.tmux,.conf
  setlocal foldmethod=marker foldlevelstart=0 foldignore= foldminlines=0


let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal isk< cms< path< include< sua<'
      \. '|setlocal fdm< fdls< foldignore< foldminlines<'
      \. '|unlet! b:did_ftplugin'
      \. '|unlet! b:undo_ftplugin'
