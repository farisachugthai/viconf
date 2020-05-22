" ==========================================================================
  " File: lua.vim
  " Author: Faris Chugthai
  " Description: Lua ftplugin
  " Last Modified: May 09, 2019
" ==========================================================================

if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/lua.vim

setlocal shiftwidth=2
setlocal expandtab
setlocal softtabstop=2
syntax sync fromstart

let s:path = luaeval('package.cpath')
let &l:path = s:path

" Idk if this is right
setlocal include=require\(\s*['".]

" IMO: lua plugins loading from &rtp is retarded because now look what i have to do

setlocal foldmethod=marker foldlevelstart=0 foldignore= foldminlines=0

nnoremap <buffer> <F5> <Cmd>luafile %<CR>

command! -range -addr=lines -buffer -bar LuaDir lua print(vim.inspect(vim))

" Eh maybe dont make this buffer specific
command! -range -addr=lines -bang -bar -nargs=* Lua lua print(vim.inspect(<args>))

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                \. '|setlocal sw< et< sts< path< inc< rtp<'
                \. '|setlocal fdm< fdls< foldignore< foldminlines<'
                \. '|nunmap <buffer> <F5>'
                \. '|unlet! b:undo_ftplugin'
                \. '|unlet! b:did_ftplugin'
