" ============================================================================
  " File: lua.vim
  " Author: Faris Chugthai
  " Description: Lua ftplugin
  " Last Modified: May 09, 2019
" ============================================================================

" Options: {{{
setlocal shiftwidth=2
setlocal expandtab
setlocal softtabstop=2
setlocal commentstring=--\ %s
syntax sync fromstart

nnoremap <buffer> <F5> <Cmd>luafile %<CR>
" Apparently this is a problem. Echoes out an error message.
" setlocal comments=--\ %s
" }}}

let b:undo_ftplugin = 'setlocal sw< et< sts< cms<'
      \ . '|nunmap <F5>'
      \ . '|unlet! b:undo_ftplugin'
