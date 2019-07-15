" ============================================================================
    " File: winrc.vim
    " Author: Faris Chugthai
    " Description: Windows specific modifications
    " Last Modified: June 29, 2019
" ============================================================================

" Guard: {{{1
let s:debug = 1

if exists('g:loaded_winrc') || &compatible || v:version < 700
	finish
endif

if s:debug
  " if were debugging don't define it I'll probably source this file
  " repeatedly
else
  let g:loaded_winrc = 1
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" Font: {{{1
" Should note in the future the pros and cons of checking the existence of the
" command in this way
"
" Or largely what the pros and cons are of checking if the GUI is running this
" way. I mean it makes sense to check GuiFont because we need to call it but
" ...shit this shouldn't be in a windows specific file...nvim has nvim-qt
" too....
if exists(':GuiFont') == 2
  " warning: font hack reports bad fixed pitch metrics.
  execute 'GuiFont Hack:h12'
endif

" Shellslash And Fileformats: {{{1
"
function! g:Cmd()

  " Moved out of the init.
  " How do i check if I'm on cmd or powershell?
  " might need to individually set the envvar SHELL in a startup script for each
  set shell=cmd.exe

endfunction

if exists('+shellslash')   " don't drop the +!
  set shellslash
endif

set fileformats=dos,unix

" Other: {{{1
" rewrite the s:InstallPlug() function so that win32 can handle it.

" I don't know why this has been necessary but if i don't source this
" UltiSnips doesn't work.
let g:UglyUltiSnipsHack = stdpath('data') . '/plugged/ultisnips/autoload/UltiSnips.vim'
execute 'source ' . g:UglyUltiSnipsHack

function! g:PowerShell() abort

  " Here goes...
  unlet! $COMSPEC
  let $COMSPEC = 'C:/Program Files/PowerShell/6/pwsh.exe'
  unlet! $SHELL
  let $SHELL = 'C:/Program Files/PowerShell/6/pwsh.exe'
  set shell=pwsh.exe
  let &shellcmdflag = '-Command $* '

  " The below is from the nvim help docs.
  " set shell=powershell shellpipe=\| shellredir=> shellxquote=
  " let &shellcmdflag='-NoLogo  -ExecutionPolicy RemoteSigned -Command $* '
  " Should I -NoExit this?

endfunction

" I want this to work so badly but it usually doesn't soooo
" try
"   call g:PowerShell()
" catch
"   call g:Cmd()
" endtry

command! PowerShell call g:Powershell()

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
