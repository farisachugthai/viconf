" ============================================================================
  " File: charblob.vim
  " Author: Faris Chugthai
  " Description: Load an autoloaded lua function.
  " Last Modified: May 30, 2019
" ============================================================================

" Guard: {{{1
if exists('g:charblob_loaded_plugin') || &compatible || v:version < 700
  finish
endif
let g:charblob_loaded_plugin = 1

command! MakeCharBlob :call charblob#encode_buffer()
