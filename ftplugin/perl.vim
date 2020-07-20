" ============================================================================
    " File: perl.vim
    " Author: Faris Chugthai
    " Description: perl ftplugin
    " Last Modified: Jul 08, 2020
" ============================================================================

" Holy hell the original ftplugin actually does a ton right

if exists('b:did_ftplugin') | finish | endif

compiler perl
let perl_fold = 1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal makeprg<'
