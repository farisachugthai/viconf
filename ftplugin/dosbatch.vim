" ============================================================================
    " File: dosbatch.vim
    " Author: Faris Chugthai
    " Description: Dosbatch modifications
    " Last Modified: May 23, 2019
" ============================================================================

setlocal commentstring=::\ %s
setlocal suffixesadd=.cmd,.bat

let b:undo_ftplugin = 'setlocal cms< sua<'
      \ . '|unlet! b:undo_ftplugin'
