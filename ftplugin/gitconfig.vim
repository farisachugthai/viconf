" ============================================================================
  " File: gitconfig.vim
  " Author: Faris Chugthai
  " Description: git config files
  " Last Modified: December 24, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" don't source the config from runtime it only does this anyway
setlocal formatoptions-=t formatoptions+=croql
setlocal comments=:#,:;
" commentstring=;\ %s

" source $VIMRUNTIME/ftplugin/gitconfig.vim
" This doesn't do anything else either *sigh*
" source $VIMRUNTIME/ftplugin/dosini.vim
setlocal et
setlocal softtabstop=4
setlocal tabstop=4
setlocal shiftwidth=4
setlocal cms=#\ %s

let b:undo_ftplugin = 'setlocal sw< et< sts< ts< fo< com< '
      \ . '|unlet! b:undo_ftplugin'
