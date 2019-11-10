" ============================================================================
    " File: Fugitive.vim
    " Author: Faris Chugthai
    " Description: Fugitive ftplugin
    " Last Modified: Oct 12, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1
" Admittedly this feels quite weird; however, fugitive creates the status
" buffer in it's own filetype and it doesn't have my usual mappings!
" Not only that but it's created in GIT_DIR/.git so it doesn't even count as a
" usual file in the git tree.

" Its also probably worth noting that plugins doesnt refer to the plugin
" dir.
" Note: plugins refers to ../autoload/plugins.vim
call plugins#FugitiveMappings()

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
