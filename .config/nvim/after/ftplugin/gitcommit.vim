" ============================================================================
    " File: gitcommit.vim
    " Author: Faris Chugthai
    " Description: Git commit buffer mods
    " Last Modified: May 19, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_git_commit_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_git_commit_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

setlocal textwidth=72
setlocal spell

" Keep the first line of a git commit 50 char long and everything after 72.
setlocal colorcolumn=50,73
setlocal linebreak

" More tpope. Official git commit ftplugin.
setlocal formatoptions-=t formatoptions+=croql
setlocal comments=:#,:; commentstring=;\ %s

" Atexit: {{{1

let b:undo_ftplugin = 'set tw< sp< cc< fo< com< cms<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
