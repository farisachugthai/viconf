" ============================================================================
    " File: powershell.vim
    " Author: Faris Chugthai
    " Description: Powershell modifications
    " Last Modified: Oct 22, 2019
" ============================================================================

" Options: {{{
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal commentstring=#\ %s
setlocal textwidth=120

" Recognize powershell's goofy ass hyphenated commands
" Actually it's easier to have this off. Maybe. Maybe make a buffer local
" mapping where you can toggle it?
setlocal iskeyword-=-

setlocal suffixesadd+=.ps1

" So this'll be tricky to do period and it's gonna {probably} be a bitch to
" implement in any sort of portable manner...but how can we set up keywordprg
setlocal foldmethod=syntax

let b:ale_fixers = ['powershell']

" }}}

" Atexit: {{{

let b:undo_ftplugin = 'setlocal et< sw< sts< cms< tw< isk< sua< fdm< '
      \ . '|unlet! b:ale_fixers'
      \ . '|unlet! b:undo_ftplugin'

" }}}
