" ============================================================================
    " File: tagbar.vim
    " Author: Faris Chugthai
    " Description: Tagbar configuration
    " Last Modified: March 19, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'tagbar')
    finish
endif

if exists('g:loaded_tagbar') || &compatible || v:version < 700
    finish
endif
let g:loaded_tagbar = 1


" Options: {{{1
" just a thought i had. For any normal mode remaps you have, add the same
" thing and prefix <Esc> to the RHS and boom!
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_sort = 0

" Mappings: {{{1
" This works perfectly and should be how you handle all plugins and their
" mappings !!!!!
noremap <silent> <F8> <Cmd>TagbarToggle<CR>
