" ============================================================================{{{}}}
    " File: nerdtree.vim
    " Author: Faris Chugthai
    " Description: NERDTree Configuration File
    " Last Modified: February 27, 2019
" ============================================================================

" Plugin Guard: {{{1

if exists('g:did_nerdtree_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_nerdtree_after_plugin = 1


" Mappings: {{{1

" Simple way to speed up startup
noremap <Leader>nt :NERDTreeToggle<CR>
" Switch NERDTree root to dir of currently focused window.
noremap <Leader>ncd :NERDTreeCWD

" Options: {{{1

let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = 'right'
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeNaturalSort = 1

" change cwd every time NT root changes
let g:NERDTreeChDirMode = 2

let g:NERDTreeShowLineNumbers = 1

 " Open dir with 1 keys, files with 2
let g:NERDTreeMouseMode = 2

let g:NERDTreeIgnore = ['.pyc$', '.pyo$', '__pycache__', '.git$', '.mypy*', '*node_modules*']
let g:NERDTreeRespectWildIgnore = 1

" Let's give netrw a shot I guess
let g:NERDTreeHijackNetrw = 0
