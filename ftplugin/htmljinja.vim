" ============================================================================
    " File: htmljinja.vim
    " Author: Faris Chugthai
    " Description: htmljinja ftplugin
    " Last Modified: Oct 11, 2019
" ============================================================================

" Guards: {{{1
" if exists('b:did_ftplugin_htmljinja_vim') || &compatible || v:version < 700
"   finish
" endif
" let b:did_ftplugin_htmljinja_vim = 1

" Override any builtin ftplugin:
" There isn't one distributed for nvim or vim and Armin's is only the
" did_ftplugin check with a runtime! ftplugin/html.vim
" But runtime! takes too long.
" if exists("b:did_ftplugin")
"   finish
" endif

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

setlocal shiftwidth=2 expandtab softtabstop=2

runtime ftplugin/html.vim

" Atexit: {{{1

let b:undo_ftplugin = 'setlocal sw< et< sts< '
      \ . '|unlet! b:undo_ftplugin'

let &cpoptions = s:cpo_save
unlet s:cpo_save
