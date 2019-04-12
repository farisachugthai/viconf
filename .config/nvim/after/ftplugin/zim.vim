" ============================================================================
    " File: zim.vim
    " Author: Faris Chugthai
    " Description: A description of the file below
    " Last Modified: April 12, 2019
" ============================================================================

if !has_key(plugs, 'zim.vim')
    finish
endif

if exists('g:did_zim_vim') || &compatible || v:version < 700
    finish
endif
let g:did_zim_vim = 1

let g:zim_notebooks_dir = expand('~/Notebooks/Notes')
let g:zim_notebook = expand('~/Notebooks/Notes')
let g:zim_dev = 1

" Here's an exciting little note about Zim. Ignoring how ...odd this plugin is
" Voom actually gets pretty close to handling Zimwiki if you recognize it as
" as dokuwiki!
