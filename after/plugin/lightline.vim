" ============================================================================
    " File: lightline.vim
    " Author: Faris Chugthai
    " Description: Old lightline mods
    " Last Modified: March 14, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'lightline')
    finish
endif

if exists('g:did_lightline_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_lightline_after_plugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Options: {{{1

let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head',
    \   'filetype': 'MyFiletype',
    \   'fileformat': 'MyFileformat',
    \ },
    \ }


" function! MyFiletype()
"     return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
" endfunction


" function! MyFileformat()
"     return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
" endfunction

" let g:lightline.colorscheme = 'seoul256'

let &cpo = s:cpo_save
unlet s:cpo_save
