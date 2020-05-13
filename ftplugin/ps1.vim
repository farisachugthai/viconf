" ============================================================================
    " File: powershell.vim
    " Author: Faris Chugthai
    " Description: Powershell modifications
    " Last Modified: May 12, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif
" doesn't exist at all wow. and amazingly i actually like my ftplugin more
" than PProvost's
" source $VIMRUNTIME/ftplugin/powershell.vim

" Options: {{{
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal commentstring=#\ %s
setlocal textwidth=120
setlocal foldignore=
if exists('$PSMODULEPATH')
  let &l:path = expand('$PSMODULEPATH')
endif

" Low key i think we could add 'n' to this if we set up formatlistpat
" to figure out those weird ass headers people add to  functions
setlocal formatoptions=tcqro
" Enable autocompletion of hyphenated PowerShell commands,
" e.g. Get-Content or Get-ADUser
setlocal iskeyword+=-
" Recognize powershell's goofy ass hyphenated commands
" Actually it's easier to have this off. Maybe. Maybe make a buffer local
" mapping where you can toggle it?
" setlocal iskeyword-=-
setlocal colorcolumn=80,120
setlocal suffixesadd+=.ps1

let &l:matchpairs .= '\<if\>:\<endif\>'
" So this'll be tricky to do period and it's gonna {probably} be a bitch to
" implement in any sort of portable manner...but how can we set up keywordprg
setlocal foldmethod=syntax

" }}}

" Plugins: {{{
" Matchit isn't skipping comments
let b:match_skip = 's:comment\|string'
" or moving from if to endif goddamn
"
let b:ale_fixers = [ 'remove_trailing_lines', 'trim_whitespace']

try
  compiler powershell
catch  /.*/
endtry

let s:pwsh = get(g:, 'powershell_command', '')

" Look up keywords by Get-Help:
" check for PowerShell Core in Windows, Linux or MacOS
if executable('pwsh') | let s:pwsh_cmd = 'pwsh'
  " on Windows Subsystem for Linux, check for PowerShell Core in Windows
elseif exists('$WSLENV') && executable('pwsh.exe') | let s:pwsh_cmd = 'pwsh.exe'
  " check for PowerShell <= 5.1 in Windows
elseif executable('powershell.exe') | let s:pwsh_cmd = 'powershell.exe'
endif

if exists('s:pwsh_cmd')
  if !has('gui_running') && executable('less') &&
        \ !(exists('$ConEmuBuild') && &term =~? '^xterm')
    " For exclusion of ConEmu, see https://github.com/Maximus5/ConEmu/issues/2048
    command! -buffer -nargs=1 GetHelp silent exe '!' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>" | ' . (has('unix') ? 'LESS= less' : 'less') | redraw!
  elseif has('terminal')
    command! -buffer -nargs=1 GetHelp silent exe 'term ' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>"' . (executable('less') ? ' | less' : '')
  else
    command! -buffer -nargs=1 GetHelp echo system(s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full <args>')
  endif
endif
setlocal keywordprg=:GetHelp

" }}}

" Atexit: {{{
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                \. '|setlocal et< sw< sts< cms< tw<'
                \. '|setlocal fdi< isk< cc< sua< fdm< fo< '
                \. '|delc GetHelp'
                \. '|setlocal kp< '
                \. '|unlet! b:match_skip'
                \. '|unlet! b:ale_fixers'
                \. '|unlet! b:undo_ftplugin'
                \. '|unlet! b:did_ftplugin'
