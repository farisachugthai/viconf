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

" TPope To The Rescue: {{{1
" Dude I was just looking at the gitrebase.vim ftplugin. There's no way
" you knew these were commands
"
" command! -buffer -bar Pick   :call s:choose('pick')
" command! -buffer -bar Squash :call s:choose('squash')
" command! -buffer -bar Edit   :call s:choose('edit')
" command! -buffer -bar Reword :call s:choose('reword')
" command! -buffer -bar Fixup  :call s:choose('fixup')
" command! -buffer -bar Cycle  :call s:cycle()

" Options: {{{1
" Taken from:
" <https://github.com/thoughtbot/dotfiles/blob/master/vim/ftplugin/gitcommit.vim>

" Automatically wrap at 72 characters and spell check commit messages
setlocal textwidth=72
setlocal spell

" Keep the first line of a git commit 50 char long and everything after 72.
setlocal colorcolumn=50,73
setlocal linebreak

" atexit: {{{1

let b:undo_ftplugin = 'set tw< sp< cc<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
