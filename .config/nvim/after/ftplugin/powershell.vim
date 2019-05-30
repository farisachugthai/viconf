" ============================================================================
    " File: powershell.vim
    " Author: Faris Chugthai
    " Description: Powershell modifications
    " Last Modified: May 19, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_powershell_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_powershell_after_ftplugin = 1

" Options: {{{1
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal commentstring=#\ %s
setlocal textwidth=0
" Recognize powershell's goofy ass hyphenated commands
setlocal iskeyword+=-


" So this'll be tricky to do period and it's gonna {probably} be a bitch to
" implement in any sort of portable manner...but how can we set up keywordprg

let b:undo_ftplugin = 'set et< sw< sts< cms< tw< isk<'
