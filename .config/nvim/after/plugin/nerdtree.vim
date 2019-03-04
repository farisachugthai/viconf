" ============================================================================
    " File: nerdtree.vim
    " Author: Faris Chugthai
    " Description: NERDTree Configuration File
    " Last Modified: February 27, 2019
" ============================================================================

" Plugin Guard: {{{1

" Don't do this with a lazy loaded plugin!!!!
" if !has_key(plugs, 'nerdtree')
"     finish
" endif

if exists('b:did_nerdtree') || &cp || v:version < 700
    finish
endif
let b:did_nerdtree = 1


" nerd_loader: {{{1
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
    autocmd bufenter *
        \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
        \| q
        \| endif
augroup END

" Mappings: {{{1

" Simple way to speed up startup
nnoremap <Leader>nt :NERDTreeToggle<CR>
" Switch NERDTree root to dir of currently focused window.
nnoremap <Leader>ncd :NERDTreeCWD


" Options: {{{1

let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = 'right'
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeNaturalSort = 1
let g:NERDTreeChDirMode = 2             " change cwd every time NT root changes
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeMouseMode = 2             " Open dir with 1 keys, files with 2
let g:NERDTreeIgnore = ['\.pyc$', '\.pyo$', '__pycache__$', '\.git$', '\.mypy*']
let g:NERDTreeRespectWildIgnore = 1     " yeah i meant those ones too
