" ============================================================================
    " File: unix.vim
    " Author: Faris Chugthai
    " Description: Add unix commands in a general way so they work on all
    " platforms
    " Last Modified: April 17, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_unix_vim_autoloaded') || &compatible || v:version < 700
  finish
endif
let g:did_unix_vim_autoloaded = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Finger: {{{1
" Example from :he command-complete
" The following example lists user names to a Finger command
command! -complete=custom,ListUsers -nargs=1 Finger !finger <args>

function! g:ListUsers(A,L,P)
    return system('cut -d: -f1 /etc/passwd')
endfun

" Completes filenames from the directories specified in the 'path' option:
command! -nargs=1 -bang -complete=customlist,g:ListUsers EF edit<bang> <args>

" Modified implementation of :edit
function! EditFileComplete(A,L,P)
    return split(globpath(&path, a:A), '\n')
endfunction

" This example does not work for file names with spaces!
" so wait if that's true can't we just use shellescape...?
" Actually i have a great example right here.

" Chmod: {{{1
"	:S	Escape special characters for use with a shell command (see
"		|shellescape()|). Must be the last one. Examples:
"           :!dir <cfile>:S
"           :call system('chmod +w -- ' . expand('%:S'))
" From :he filename-modifiers in the cmdline page.
command! -nargs=1 -complete=file Chmod call system('chmod +x ' . expand('%:S'))

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
