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
let g:DevIconsEnableFoldersOpenClose = 1

" change the default character when no match found
" let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = 'ƛ'
" Heres the original
" let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''

" Heres a neat one! Fuck
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''


" enable file extension pattern matching glyphs on folder/directory (disabled by default with 0)
let g:DevIconsEnableFolderExtensionPatternMatching = 1

" Enable this for a specific ftplugin I'm curious what thisll look like. We
" already call that func but the rest I'm curious about.
" Tried netrw and it looks weird.
" setlocal statusline=%f\ %{WebDevIconsGetFileTypeSymbol()}\ %h%w%m%r\ %=%(%l,%c%V\ %Y\ %=\ %P%)
