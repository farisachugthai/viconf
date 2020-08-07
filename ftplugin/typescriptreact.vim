" ============================================================================
  " File: typescriptreact.vim
  " Author: Faris Chugthai
  " Description: Typescript ftplugin - Because this is considered a different filetype?
  " Last Modified: August 3, 2020
" ============================================================================

" if exists('b:did_ftplugin') | finish | endif

setl syntax=typescript

let s:ftplugin_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h'))
exec 'source ' . s:ftplugin_root . '/typescript.vim'

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setl syntax<'
