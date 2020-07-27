" ============================================================================
    " File: rust.vim
    " Author: Faris Chugthai
    " Description: rust ftplugin
    " Last Modified: Jul 26, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

let g:cargo_makeprg_params = 1
let g:rust_fold = 1

" So cargo sources $VIMRUNTIME/compiler/rustc.vim
compiler cargo

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal makeprg<'
      \. '|setlocal efm<'
