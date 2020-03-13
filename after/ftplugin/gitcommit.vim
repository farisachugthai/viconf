" ============================================================================
    " File: gitcommit.vim
    " Author: Faris Chugthai
    " Description: Git commit buffer mods
    " Last Modified: Nov 14, 2019
" ============================================================================

setlocal textwidth=72
setlocal spell

" Keep the first line of a git commit 50 char long and everything after 72.
setlocal colorcolumn=50,73
setlocal linebreak

setlocal formatoptions-=t formatoptions+=croql
setlocal comments=:#,:; commentstring=;\ %s

let b:undo_ftplugin = 'setlocal tw< sp< cc< fo< com< cms<'
      \ . '|unlet! b:undo_ftplugin'
