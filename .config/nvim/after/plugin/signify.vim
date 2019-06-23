" ============================================================================
    " File: signify.vim
    " Author: Faris Chugthai
    " Description: Signify configuration.
    " Last Modified: June 22, 2019
" ============================================================================

" Plugin Guard: {{{1
if !has_key(plugs, 'vim-signify')
    finish
endif

if exists('g:did_signify_after_plugin') || &cp || v:version < 700
    finish
endif
let g:did_signify_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1
let g:signify_vcs_list = [ 'git' ]

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
