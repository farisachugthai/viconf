" ============================================================================
    " File: ts.vim
    " Author: Faris Chugthai
    " Description: Typescript Vim Ftplugin
    " Last Modified: January 05, 2019
" ============================================================================
if v:version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif

" Plugins: {{{1

" Ale: {{{2
" Dude that was way too complicated to get. :redir @n, let ale_fixers, "np,
" Then get rid of {} from global to buffer ale_fixers, all just to add that
" one thing. jesus.
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace', 'tslint']
