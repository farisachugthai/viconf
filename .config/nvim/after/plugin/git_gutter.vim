" ============================================================================
    " File: git_gutter.vim
    " Author: Faris Chugthai
    " Description: Git gutter configuration
    " Last Modified: June 02, 2019
" ============================================================================

" Guard: {{{1
if !has_keys(plugs, 'vim-gitgutter')
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

" Mappings: {{{1
nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

omap ic <Plug>GitGutterTextObjectInnerPending
omap ac <Plug>GitGutterTextObjectOuterPending
xmap ic <Plug>GitGutterTextObjectInnerVisual
xmap ac <Plug>GitGutterTextObjectOuterVisual
