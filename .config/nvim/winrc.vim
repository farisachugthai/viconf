" ============================================================================
    " File: winrc.vim
    " Author: Faris Chugthai
    " Description: Windows specific modifications
    " Last Modified: August 01, 2019
" ============================================================================

" Guard: {{{1
if exists('did_winrc') || &cp || version < 700
  finish
endif
" let did_winrc = 1

if has('unix') | finish | endif

let s:debug = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Font: {{{1
" ...shit this shouldn't be in a windows specific file...ubuntu has nvim-qt
" too....
if exists(':GuiFont') == 2
  execute 'GuiFont Source Code Pro:h12:cANSI'
endif

" Shellslash And Fileformats: {{{1

function! g:Cmd()

  " All the defaults when running cmd as comspec on windows 10
  set shell=cmd.exe
  set shellcmdflag=/s\ /c
  set shellpipe=>%s\ 2>&1
  set shellredir=>%s\ 2>&1
  set shellxquote="
endfunction

if exists('+shellslash')   " don't drop the +!
  set shellslash
endif

" In usr_41 it's mentioned that files formatted with dos formatting won't
" run vim scripts correctly so holy shit that might explain a hell of a lot
set fileformats=unix,dos

" Other: {{{1
" rewrite the s:InstallPlug() function so that win32 can handle it.

" I don't know why this has been necessary but if i don't source this
" UltiSnips doesn't work.
let g:UglyUltiSnipsHack = stdpath('data') . '/plugged/ultisnips/autoload/UltiSnips.vim'
execute 'source ' . g:UglyUltiSnipsHack

function! g:PowerShell() abort

  " 07/23/2019: Just found out that even when using powershell comspec is
  " supposed to be set to cmd. Explains a few things
  unlet! $SHELL
  let $SHELL = 'C:/pwsh/7-preview/pwsh.exe'
  set shell=pwsh.exe
  set shellpipe=\| shellredir=> shellxquote=
  let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned $* '

endfunction

command! PowerShell call g:Powershell()

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
