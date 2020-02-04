" ============================================================================
  " File: gitconfig.vim
  " Author: Faris Chugthai
  " Description: git config files
  " Last Modified: December 24, 2019
" ============================================================================

setlocal et
setlocal softtabstop=4
setlocal tabstop=4
setlocal shiftwidth=4
setlocal cms=#\ %s

let b:undo_ftplugin = 'setlocal sw< et< sts< ts< '
      \ . '|unlet! b:undo_ftplugin'
