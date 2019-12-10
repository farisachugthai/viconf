" ============================================================================
    " File: msdos.vim
    " Author: Faris Chugthai
    " Description: Windows specific modifications
    " Last Modified: Aug 18, 2019
" ============================================================================

function! msdos#Cmd() abort  " {{{1

  " All the defaults when running cmd as comspec on windows 10
  set shell=cmd.exe
  " set shellcmdflag=/s\ /c
  set shellpipe=>%s\ 2>&1
  set shellredir=>%s\ 2>&1
  " Is this necessary? Or should it be empty?
  set shellxquote=(
  set shellxescape=^
  " What about setting shellquote to "" so that cmd gets the args quoted?
  echomsg 'Using cmd as the system shell.'
  return
endfunction

function! msdos#PowerShell() abort  " {{{1

  " 07/23/2019: Just found out that even when using powershell comspec is
  " supposed to be set to cmd. Explains a few things
  if !empty($SHELL) | unlet! $SHELL | endif
  let $SHELL = 'C:/pwsh/7-preview/pwsh.exe'
  set shell=pwsh.exe
  set shellquote=
  set shellxquote=
  set shellpipe=\| shellredir=> shellxquote=
  let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command '
  set shellredir=\|\ Out-File\ -Encoding\ UTF8\ %s
  set shellpipe=\|\ Out-File\ -Encoding\ UTF8\ %s

  echomsg 'Using powershell as the system shell.'
  return
endfunction

function! msdos#pwsh_help(helppage) abort   " {{{1
  echomsg 'Setting the shell to powershell.'
  call msdos#PowerShell()
  r!pwsh -noprofile -nologo -command get-help a:helppage
  echomsg 'Note that shell was not restored'
endfunction
