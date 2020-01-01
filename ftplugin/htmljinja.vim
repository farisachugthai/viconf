" ============================================================================
    " File: htmljinja.vim
    " Author: Faris Chugthai
    " Description: htmljinja ftplugin
    " Last Modified: Dec 24, 2019
" ============================================================================

setlocal shiftwidth=2 expandtab softtabstop=2

runtime ftplugin/html.vim

syntax sync fromstart
syntax include $VIMRUNTIME/syntax/django.vim

let b:undo_ftplugin = 'setlocal sw< et< sts< '
      \ . '|unlet! b:undo_ftplugin'
