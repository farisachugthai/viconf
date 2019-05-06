" ============================================================================
    " File: netrw.vim
    " Author: Faris Chugthai
    " Description: Yes netrw is a ftplugin
    " Last Modified: April 30, 2019
" ============================================================================

" Can be modified interactively using `:NetrwSettings` !!

" Guards: {{{1

if exists('g:did_netrw') || &compatible || v:version < 700
    finish
endif
let g:did_netrw = 1

" Options: {{{1
" Hide that weird looking banner
let g:netrw_banner = 0

" Keep the current directory the same as the browsing directory
let g:netrw_keepdir = 0

" Open windows from netrw in a preview window. Can be achieved by pressing 'P'
let g:netrw_browse_split = 4

" 1: long listing (one file per line with time stamp information and file size)
let g:netrw_liststyle = 1

let g:netrw_list_hide = netrw_gitignore#Hide() . '.*\.swp$'

" TODO: Make sure to test on windows
if !has('win32')
    let g:netrw_localmkdir = 'mkdir -pv'
endif

let g:netrw_sizestyle = 'h'

" Only display errors as messages
let g:netrw_errorlvl          = 2
