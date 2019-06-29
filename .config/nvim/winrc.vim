" ============================================================================
    " File: winrc.vim
    " Author: Faris Chugthai
    " Description: Windows specific modifications
    " Last Modified: June 29, 2019
" ============================================================================

" Guard: {{{1
if exists('g:loaded_winrc') || &compatible || v:version < 700
	finish
endif
" let g:loaded_winrc = 1

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

" Shellslash / fileformats: {{{1
" Moved out of the init.
" How do i check if I'm on cmd or powershell?
" might need to individually set the envvar SHELL in a startup script for each
" set shell=powershell shellpipe=\| shellredir=> shellxquote=
" let &shellcmdflag='-NoLogo  -ExecutionPolicy RemoteSigned -Command $* '  " Should I -NoExit this?
"
function! g:Cmd() abort
  set shell=cmd.exe
endfunction

if exists('+shellslash')   " don't drop the +!
  set shellslash
endif

set fileformats=dos,unix

" Other: {{{1
" TODO:
" well the usual guards.
" rewrite the s:InstallPlug() function so that win32 can handle it.

" I don't know why this has been necessary
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
endfunction

" I want this to work so badly but it usually doesn't soooo
" try
"   call g:PowerShell()
" catch
"   call g:Cmd()
" endtry

command! PowerShell call g:Powershell()
