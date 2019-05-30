" Author:       Lifepillar
" Maintainer:   Lifepillar
" License:      Distributed under the same terms as Vim itself. See :help license.

" Todo: I copied this over because I wanna do more of those if empty('g:some_option') | let g:some_option = default_value checks


" Then we can define a few variables and skip a bunch of the unnecessary loops in this plugin

" Guards: {{{1
if exists('g:loaded_cheatsheet_plugin') || &compatible || v:version < 700
  finish
endif
let g:loaded_cheatsheet_plugin = 1


" Configuration: {{{1
" I wanna use my own cheatsheet sorry man
if !exists('g:cheat40_use_default')
    let g:cheat40_use_default = 0
endif

if !exists('g:cheat40_file')
    let g:cheat40_file = expand('$XDG_CONFIG_HOME') . '/nvim/cheat40.txt'
endif


" Commands: {{{1
command! -bar -nargs=0 -bang Cheat40 call cheat40#open('<bang>' ==# '!')


" Mappings: {{{1
if mapcheck('<LocalLeader>?', 'n') ==# ''
  noremap <LocalLeader>? <Cmd>Cheat40<CR>
endif
