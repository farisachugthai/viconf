" ============================================================================
    " File: dosbatch.vim
    " Author: Faris Chugthai
    " Description: Dosbatch modifications
    " Last Modified: Mar 27, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

source $VIMRUNTIME/ftplugin/dosbatch.vim

setlocal commentstring=::\ %s
setlocal suffixesadd=.cmd,.bat

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe') .
                \ . '|setlocal cms< sua<'
                \ . '|unlet! b:undo_ftplugin'
                \ . '|unlet! b:did_ftplugin'
