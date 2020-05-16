
" if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/nroff.vim
unlet! b:did_ftplugin

let s:curbuf = fnamemodify(expand('%'), ':t:r:')
exec 'Man ' . s:curbuf

" Automatically convert nroff to man pages

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                      \. '|unlet! b:undo_ftplugin'
                      \. '|unlet! b:did_ftplugin'
