" ============================================================================
    " File: ts.vim
    " Author: Faris Chugthai
    " Description: Typescript Vim Ftplugin
    " Last Modified: January 05, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_ts_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_ts_after_ftplugin = 1

" Plugins: {{{1

" Ale: {{{2
" Dude that was way too complicated to get. :redir @n, let ale_fixers, "np,
" Then get rid of {} from global to buffer ale_fixers, all just to add that
" one thing. jesus.
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace', 'tslint']
