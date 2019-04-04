" ============================================================================
    " File: deoplete_jedi.vim
    " Author: Faris Chugthai
    " Description: Deoplete Jedi configurations
    " Last Modified: April 01, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'deoplete_jedi')
    finish
endif

if exists('g:did_deoplete_jedi') || &compatible || v:version < 700
    finish
endif
let g:did_deoplete_jedi = 1


" Options: {{{1
" Setting things up with the `if ubuntu` phrase was oddly a lot easier than
" i expected it to be...
if s:ubuntu
    let g:deoplete#sources#jedi#enable_typeinfo = 1
    let g:deoplete#sources#jedi#show_docstring = 1
elseif s:termux
    let g:deoplete#sources#jedi#enable_typeinfo = 0
endif
