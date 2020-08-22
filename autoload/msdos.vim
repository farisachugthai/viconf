" ============================================================================
    " File: msdos.vim
    " Author: Faris Chugthai
    " Description: Windows specific modifications
    " Last Modified: Aug 18, 2019
" ============================================================================

function! msdos#set_shell_cmd() abort
  " All the defaults when running cmd as comspec on windows 10
  set shell=cmd.exe
  " yo this could be horrible but this might be amazing
  " Because this'll A) stop the horrific Terminate batch command? prompt
  " automatically along with a few other things
  " set shell=clink.cmd

  " i've noticed ALE needing shelltemp set
  setglobal shelltemp
  " set shellcmdflag=/s\ /c
  setglobal sessionoptions+=unix,slash viewoptions+=unix,slash

  " So this HAS to be a bad idea; however, all 3 DirChanged autocommands emit
  " errors and that's a little insane
  " Oct 22, 2019: Somehow I've observed literally 0 problems with this and the
  " error is still emitted when the dir changes soooo
  setglobal eventignore=DirChanged
  " XXX: might wanna change this:
  " let $FZF_DEFAULT_COMMAND = 'rg --hidden -M 200 -m 200 --smart-case --passthru --files . '
  " let $FZF_DEFAULT_COMMAND = 'fd --hidden --follow -d 6 -t f '
  unlet! $FZF_DEFAULT_OPTS
  unlet! $FZF_DEFAULT_COMMAND
  " TODO: Figure out if this wasn't a terrible idea. Maybe need to simply
  " modify our invocations of system commands.
	" Dude don't fucking turn /U ON
  " let &shellcmdflag = '/C /F:ON /E:ON '
						" *'shellpipe'* *'sp'*
	" For Windows the default is ">".  The output is directly saved in a file
	" and not echoed to the screen.
        " Let's double check that this shouldn't be set
  " Actually turning on of these on will really mess everything up. Huh
  " setglobal shellpipe=>%s\ 2>&1
  setglobal shellredir=>%s\ 2>&1
  " Is this necessary? Or should it be empty?
  " heres what this used to be set as. is this whats causing shell problems?
  " set shellxquote=(
  let &shellcmdflag = has('nvim') ? '/s /c' : '/c'
  let &shellxquote = has('nvim') ? '"' : '('
  setglobal shellxescape=^

  setglobal noshelltemp
  setglobal shellquote="
  " What about setting shellquote to "" so that cmd gets the args quoted?
  echomsg 'Using cmd as the system shell.'

  " Here's a handful of pretty unrelated things but we get to consolidate platform specific settings
  " in this way
  imap <C-x><C-f>       <Plug>(fzf-complete-file)
  imap <C-x><C-j>       <Plug>(fzf-complete-path)
  inoremap <C-f>        <C-x><C-f>
  inoremap <C-j>        <C-x><C-j>
endfunction

function! msdos#invoke_cmd(command) abort
  if !empty(a:command)
    let s:ret = systemlist(a:command)
  else
    call msdos#CmdTerm()
  endif

  if v:shell_error
    return v:shell_error
  else
    return s:ret
  endif
endfunction

function! msdos#CmdTerm(...) abort
  execute 'term cmd /U /F:ON /E:ON /K C:\Users\fac\init.cmd'
  if v:shell_error
    return v:shell_error
  else
    return s:ret
  endif
endfunction

function! msdos#PowerShell() abort
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

function! msdos#pwsh_help(helppage) abort
  echomsg 'Setting the shell to powershell.'
  call msdos#PowerShell()
  " It might not be a bad idea
  :r!pwsh -NoProfile -NoLogo -Command Get-Help a:helppage
  echomsg 'Note that shell was not restored'
endfunction

function! msdos#set_bash() abort
  " Uh this does not work.
  if has('Win32')
    setglobal runtimepath+=C:\Neovim\share\nvim-qt\runtime
   let &shell='bash.exe'
   let &shellcmdflag = '-c'
   let &shellredir = '>%s 2>&1'
   set shellquote= shellxescape=
   " set noshelltemp
   set shellxquote=
   let &shellpipe='2>&1| tee'
  endif
endfunction

function! msdos#SomethingWithShada() abort
  " Quite honestly this functions pretty pointless but I thought it was a neat example of the API.

  let fname = expand('~/.local/share/nvim-data/site/shada/main.shada')
  let mpack = readfile(fname, 'b')
  let shada_objects = msgpackparse(mpack)
  return shada#mpack_to_sd(shada_objects)
endfunction
