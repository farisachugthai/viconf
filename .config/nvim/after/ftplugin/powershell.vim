" ============================================================================
    " File: powershell.vim
    " Author: Faris Chugthai
    " Description: Powershell modifications
    " Last Modified: May 19, 2019
" ============================================================================

" Guard: {{{1

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

" Functions: {{{1

let s:debug = 1

function! ALE_PowerShell_Conf() abort

  if s:debug
    echomsg 'Func was called'
  endif

  let b:ale_fixers = ['powershell']

  if s:debug
    echomsg string(g:ale_fixers)
  endif

endfunction

" Autocmds: {{{1

if has_key(plugs, 'ale') && &filetype=='ps1'

  augroup powershell
    autocmd Filetype * call ALE_PowerShell_Conf()
  augroup END

endif

" Atexit: {{{1

let b:undo_ftplugin = 'set et< sw< sts< cms< tw< isk< sua<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
