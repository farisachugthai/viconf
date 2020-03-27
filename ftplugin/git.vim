" ============================================================================
  " File: git.vim
  " Author: Faris Chugthai
  " Description: Git commit ftplugin
  " Last Modified: February 23, 2020
" ============================================================================

" Tpope does a `runtime! ftplugin/git.vim` in the neovim
" $VIMRUNTIME/ftplugin/gitcommit.vim` so let's call this a clever way of
" handling that
" Wait how did my dumbass not source his???
if exists('b:did_ftplugin') | finish | endif

source $VIMRUNTIME/ftplugin/git.vim

setlocal textwidth=70
setlocal cursorcolumn
setlocal colorcolumn=50,70
setlocal tabstop=4
setlocal comments=:# commentstring=#\ %s
setlocal spell

nnoremap <buffer> q <Cmd>bd!<CR>

" So now you have his version to append to
let b:undo_ftplugin .= '|setlocal tw< cuc< cc< ts< com< cms< spell< '
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
      \ . '|silent! nunmap q'
