" ============================================================================
    " File: jedi.vim
    " Author: Faris Chugthai
    " Description: jedi modifications
    " Last Modified: April 14, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'jedi.vim')
    finish
endif

if exists('g:did_jedi') || &compatible || v:version < 700
    finish
endif
let g:did_jedi = 1

" Options: {{{1
let g:jedi#use_tabs_not_buffers = 1         " easy to maintain workspaces
let g:jedi#usages_command = '<Leader>u'
let g:jedi#rename_command = '<F2>'
if g:termux
    let g:jedi#show_call_signatures_delay = 1000
elseif g:ubuntu
    let g:jedi#show_call_signatures_delay = 100
endif

let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 3
let g:jedi#enable_completions = 0
