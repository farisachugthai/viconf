" ============================================================================
    " File: powershell.vim
    " Author: Faris Chugthai
    " Description: Powershell modifications
    " Last Modified: Oct 22, 2019
" ============================================================================

" Guard: {{{1
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

if exists('b:loaded_after_powershell') || &compatible || v:version < 700
  finish
endif
let b:loaded_after_powershell = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal commentstring=#\ %s
setlocal textwidth=0

" Recognize powershell's goofy ass hyphenated commands
" Actually it's easier to have this off. Maybe. Maybe make a buffer local
" mapping where you can toggle it?
setlocal iskeyword-=-

setlocal suffixesadd+=.ps1

" So this'll be tricky to do period and it's gonna {probably} be a bitch to
" implement in any sort of portable manner...but how can we set up keywordprg
setlocal foldmethod=syntax

let b:ale_fixers = ['powershell']

" Atexit: {{{1

let b:undo_ftplugin = 'set et< sw< sts< cms< tw< isk< sua<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
