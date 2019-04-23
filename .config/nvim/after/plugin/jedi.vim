" ============================================================================
    " File: jedi.vim
    " Author: Faris Chugthai
    " Description: jedi modifications
    " Last Modified: April 14, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'jedi-vim')
    finish
endif

if exists('g:did_jedi') || &compatible || v:version < 700
    finish
endif
let g:did_jedi = 1

" Options: {{{1

let g:jedi#use_tabs_not_buffers = 1         " easy to maintain workspaces

if g:termux
    let g:jedi#show_call_signatures_delay = 1000
    let g:jedi#smart_auto_mappings = 0

elseif g:ubuntu
    let g:jedi#show_call_signatures_delay = 100
    let g:jedi#smart_auto_mappings = 1
endif

let g:jedi#enable_completions = 0
let g:jedi#force_py_version = 3
let g:jedi#use_splits_not_buffers = 'winwidth'

" Why would I choose C-n?

let g:jedi#completions_command = '<C-P>'
" AHHHHH. If you set ttimeoutlen or updatetime lower than usual this basically
" drops random strings in your python files. Holy shit
let g:jedi#popup_select_first = 0
