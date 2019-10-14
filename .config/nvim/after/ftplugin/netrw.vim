" ============================================================================
    " File: netrw.vim
    " Author: Faris Chugthai
    " Description: Yes netrw is a ftplugin
    " Last Modified: Oct 14, 2019
" ============================================================================

" Guards: {{{1
if exists('b:did_netrw_after_ftplugin') || &compatible || v:version < 700
    finish
endif
let b:did_netrw_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1
" Can be modified interactively using `:NetrwSettings` !!

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
    let g:netrw_browsex_viewer= 'xdg-open'
else
    let g:netrw_browsex_viewer= 'firefox %s'
endif

" TODO:               *netrw_filehandler*

let g:netrw_sizestyle = 'h'

" Only display errors as messages
let g:netrw_errorlvl          = 2

" Mappings: {{{1
"
" wth why is this a thing
unmap <buffer> a

noremap <buffer> ^ <Plug>NetrwBrowseUpDir<Space>

" I have no idea why but this line isn't working and its generating an error
" that netrw buffers aren't modifiable....
" nnoremap <buffer> <F1>			:he netrw-quickhelp<cr>
" ....wtf?
nnoremap <buffer> <F1> <Cmd>help netrw-quickhelp<CR>

" Atexit: {{{1
let b:undo_ftplugin = '| unmap <buffer> ^'

let &cpoptions = s:cpo_save
unlet s:cpo_save
