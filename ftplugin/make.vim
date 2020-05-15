" ============================================================================
    " File: make.vim
    " Author: Faris Chugthai
    " Description: Set correct filetype settings for makefiles.
    " Last Modified: May 30, 2019
" ============================================================================

" Otherwise your make commands won't work.
setlocal noexpandtab
setlocal tabstop=8
setlocal softtabstop=8
setlocal shiftwidth=8

let b:undo_ftplugin = 'setlocal et< ts< sts< sw<'
      \ . '|unlet! b:undo_ftplugin'
