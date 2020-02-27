" ============================================================================
    " File: git_gutter.vim
    " Author: Faris Chugthai
    " Description: Git gutter configuration
    " Last Modified: June 02, 2019
" ============================================================================

" Guard: {{{1

if !exists('g:plugs')
  finish
endif
if !has_key(plugs, 'vim-gitgutter')
    finish
endif

if exists('g:did_git_gutter_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_git_gutter_after_plugin = 1

" Options: {{{1
if executable('rg')
    let g:gitgutter_grep = 'rg --color=never '
endif

let g:gitgutter_log = 1

" Default is empty like no color no external diff no context seems
" reasonable...
let g:gitgutter_diff_args = ' --no-color --no-ext-diff -U0 -- '

if g:windows
  let g:gitgutter_grep = 'rg --vimdiff --color always '
  let g:gitgutter_git_executable = 'C:\tools\Cmder\vendor\git-for-windows\git-cmd.exe'

endif

" Mappings: {{{1

" Because of coc we should check if we already have a mapping.
" Not sure how. maparg('keys') returns the RHS of a mapping so idk
nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

omap ic <Plug>GitGutterTextObjectInnerPending
omap ac <Plug>GitGutterTextObjectOuterPending
xmap ic <Plug>GitGutterTextObjectInnerVisual
xmap ac <Plug>GitGutterTextObjectOuterVisual
