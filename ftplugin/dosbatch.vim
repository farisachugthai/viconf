" ============================================================================
    " File: dosbatch.vim
    " Author: Faris Chugthai
    " Description: Dosbatch modifications
    " Last Modified: Mar 27, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

source $VIMRUNTIME/ftplugin/dosbatch.vim

" Kinda didn't expect this to exist
source $VIMRUNTIME/indent/dosbatch.vim

setlocal commentstring=::\ %s
setlocal suffixesadd=.cmd,.bat
" This is useful so that
" doskey /MACROFILE=file
" can utilize `gf` on the filename and behave as expected
setlocal isfname-==

setlocal fileformat=dos

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
                \ . '|setlocal cms< sua< isf<'
                \ . '|unlet! b:undo_ftplugin'
                \ . '|unlet! b:did_ftplugin'
