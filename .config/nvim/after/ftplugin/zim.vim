" ============================================================================
    " File: zim.vim
    " Author: Faris Chugthai
    " Description: A description of the file below
    " Last Modified: May 09, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'vim-zim')
    finish
endif

if exists('b:did_zim_vim_after_ftplugin') || &compatible || v:version < 700
    finish
endif
let b:did_zim_vim_after_ftplugin = 1

" Options: {{{1

" You set these in ../plugin/zim.vim
" let g:zim_notebooks_dir = expand('~/Notebooks/Notes')
" let g:zim_notebook = expand('~/Notebooks/Notes')
let g:zim_dev = 1

" Here's an exciting little note about Zim. Ignoring how ...odd this plugin is
" Voom actually gets pretty close to handling Zimwiki if you recognize it as
" as dokuwiki!

" c style comments
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

" also
setlocal commentstring=#\ %s

" Links should be one word but are separated by colons
setlocal iskeyword+=:
" Realistically idk why there would be comments but whatever.

" Futz with the path
let &path = path . ',' . expand('~/Notebooks/Notes/**')

let b:undo_ftplugin = 'setlocal com< cms< path<'
" Dude the ruby ftplugin is amazing. Take notes.
