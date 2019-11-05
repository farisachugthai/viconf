" ============================================================================
    " File: powershell.vim
    " Author: Faris Chugthai
    " Description: The original ftplugin is so odd and it does nothing of value
    " Last Modified: Oct 22, 2019
" ============================================================================

" Guard: {{{1
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

runtime ftplugin/sh.vim after/ftplugin/sh.vim

if executable('shellcheck') | compiler shellcheck | setlocal makeprg=shellcheck | endif

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
