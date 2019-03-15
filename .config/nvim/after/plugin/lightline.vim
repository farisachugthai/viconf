" ============================================================================
    " File: lightline.vim
    " Author: Faris Chugthai
    " Description: Old lightline mods
    " Last Modified: March 14, 2019
" ============================================================================

if !has_key(plugs, 'lightline')
    finish
endif

if g:loaded_lightline
    finish
endif

let g:loaded_lightline = 1

let s:cpo_save = &cpo
set cpo&vim

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
