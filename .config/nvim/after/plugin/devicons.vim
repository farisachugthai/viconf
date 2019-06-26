" ============================================================================
    " File: devicons.vim
    " Author: Faris Chugthai
    " Description: Devicons conf
    " Last Modified: March 28, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'vim-devicons')
    finish
endif

if exists('g:did_webdevicons_after_plugin') || &compatible || v:version < 700
    finish
endif


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
let g:did_webdevicons_after_plugin = 1

" change the default character when no match found
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = 'ƛ'

" enable file extension pattern matching glyphs on folder/directory (disabled by default with 0)
let g:DevIconsEnableFolderExtensionPatternMatching = 1

" Enable this for a specific ftplugin I'm curious what thisll look like. We
" already call that func but the rest I'm curious about.
" setlocal statusline=%f\ %{WebDevIconsGetFileTypeSymbol()}\ %h%w%m%r\ %=%(%l,%c%V\ %Y\ %=\ %P%)
"
" -------------------------------------------------------------------------------
" How do I solve issues after re-sourcing my *vimrc*?

" - Try adding this to the bottom of your |vimrc|

if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif
