" ============================================================================
    " File: devicons.vim
    " Author: Faris Chugthai
    " Description: Devicons conf
    " Last Modified: March 28, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'devicons')
    finish
endif

if exists('g:loaded_devicons_conf') || &compatible || v:version < 700
    finish
endif
let g:loaded_devicons_conf = 1


" Options: {{{1
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1               " adding the flags to NERDTree
let g:airline_powerline_fonts = 1

" For startify
let entry_format = "'   ['. index .']'. repeat(' ', (3 - strlen(index)))"

if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
    let entry_format .= ". WebDevIconsGetFileTypeSymbol(entry_path) .' '.  entry_path"
else
    let entry_format .= '. entry_path'
endif
