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
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_sort = 0

let g:tagbar_autoclose = 1
" If you set this option the Tagbar window will automatically close when you
" jump to a tag. This implies |g:tagbar_autofocus|. If enabled the "C" flag will
" be shown in the statusline of the Tagbar window.


let g:tagbar_show_linenumbers = -1
" -1: Use the global line number settings.
" Well that just feels like the courteous thing to do right?

let g:tagbar_foldlevel = 2


" Mappings: {{{2
nnoremap <silent> <F8> <Cmd>TagbarToggle<CR>
inoremap <silent> <F8> <Cmd>TagbarToggle<CR>
