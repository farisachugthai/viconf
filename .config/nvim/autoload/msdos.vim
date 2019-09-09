" ============================================================================
    " File: msdos.vim
    " Author: Faris Chugthai
    " Description: Windows specific modifications
    " Last Modified: Aug 18, 2019
" ============================================================================

" Guards: {{{1
if has('unix') | finish | endif

let s:debug = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1
" ...shit this shouldn't be in a windows specific file...ubuntu has nvim-qt
" too....
if exists(':GuiFont') == 2
  execute 'GuiFont Source Code Pro:h12:cANSI'
endif

if exists('+shellslash')   " don't drop the +!
  set shellslash
endif

" In usr_41 it's mentioned that files formatted with dos formatting won't
" run vim scripts correctly so holy shit that might explain a hell of a lot
set fileformats=unix,dos

" So this HAS to be a bad idea; however, all 3 DirChanged autocommands emit
" errors and that's a little insane
set eventignore=DirChanged

function! msdos#Cmd() abort  " {{{1

  " All the defaults when running cmd as comspec on windows 10
  set shell=cmd.exe
  set shellcmdflag=/s\ /c
  set shellpipe=>%s\ 2>&1
  set shellredir=>%s\ 2>&1
  set shellxquote="
endfunction

command! Cmd call msdos#Cmd()

function! msdos#PowerShell() abort  " {{{1

  " 07/23/2019: Just found out that even when using powershell comspec is
  " supposed to be set to cmd. Explains a few things
  if !empty($SHELL) | unlet! $SHELL | endif
  let $SHELL = 'C:/pwsh/7-preview/pwsh.exe'
  set shell=pwsh.exe
  set shellquote=(
  set shellpipe=\| shellredir=> shellxquote=
  let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command '
  set shellredir=\|\ Out-File\ -Encoding\ UTF8

   echomsg 'Using powershell as the system shell.'
   return
endfunction

command! PowerShell call msdos#Powershell()

" Holy hell is this annoying don't do this!!
" cabbrev pwsh PowerShell

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
