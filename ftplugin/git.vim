" ============================================================================
  " File: git.vim
  " Author: Faris Chugthai
  " Description: Git commit ftplugin
  " Last Modified: February 23, 2020
" ============================================================================

" Filetype for generic git output. Don't load this too heavy because it's sourced
" by gitconfig and a handful of others.

if exists('b:did_ftplugin') | finish | endif

if exists('*stdpath')
  let s:stddata = stdpath("data")
else
  let s:stddata = resolve(expand('~/.local/share/nvim'))
endif

let s:stdconfig = exists('*stdpath') ? stdpath('config') : resolve(expand('~/.config/nvim'))

if !exists('g:loaded_fugitive')
  " return
  exec 'source ' . s:stddata . '/plugged/vim-fugitive/plugin/fugitive.vim'
endif

if !exists('b:git_dir')
  call ftplugins#get_git_dir()
endif

source $VIMRUNTIME/ftplugin/git.vim

setlocal tabstop=4
setlocal comments=:# commentstring=#\ %s
setlocal spell

" So now you have his version to append to
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal tw< cuc< cc< ts< com< cms< spell< '
      \. '|unlet! b:undo_ftplugin'
      \. '|unlet! b:did_ftplugin'
      \. '|silent! <buffer> nunmap q'

