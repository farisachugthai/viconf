" ============================================================================
  " File: lua.vim
  " Author: Faris Chugthai
  " Description: Lua ftplugin
  " Last Modified: May 09, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_lua_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_lua_after_ftplugin = 1

setlocal commentstring=--\ %s
setlocal comments=--\ %s

let b:undo_ftplugin = 'set cms< com<'
