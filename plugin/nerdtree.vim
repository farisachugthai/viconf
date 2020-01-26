" ============================================================================
    " File: nerdtree.vim
    " Author: Faris Chugthai
    " Description: NERDTree Configuration File
    " Last Modified: February 27, 2019
" ============================================================================

" Options: {{{1

" When you open a buffer, how do we do it? Don't only silent edit, keep jumps
" too
let g:NERDTreeCreatePrefix = 'silent keepalt keepjumps'

let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = 'right'

" UI: {{{2
let g:NERDTreeShowHidden = 1

" This setting controls the method by which the list of user bookmarks is
" sorted. When sorted, bookmarks will render in alphabetical order by name.
let g:NERDTreeBookmarksSort = 1  " case sensitive

let g:NERDTreeShowBookmarks = 1

let g:NERDTreeNaturalSort = 1

" change cwd every time NerdTree root changes: {{{2
let g:NERDTreeChDirMode = 2

let g:NERDTreeShowLineNumbers = 1

 " Open dir with 1 keys, files with 2
let g:NERDTreeMouseMode = 2

let g:NERDTreeIgnore = [ '.pyc$', '.pyo$', '__pycache__$', '.git$', '.mypy', 'node_modules']
let g:NERDTreeRespectWildIgnore = 1

" Let's give netrw a shot I guess. No lets not.
let g:NERDTreeHijackNetrw = 1

let g:NERDTreeAutoDeleteBuffer = 1

" Why did i do this?
" That nerdtree.root.path.str() is too long to see on Termux tho
" let s:stl = &statusline

" default
" let g:NERDTreeStatusline = "%{exists('b:NERDTree') ? b:NERDTree.root.path.str() : s:stl }"

let g:NERDTreeMapToggleZoom = 'Z'  " Z is for Zoom why the hell is the default A?

let g:NERDTreeGlyphReadOnly = 'U+237A'  " literally never gonna remember i did this but oh well

" To open a file always in the current tab, and expand directories in place, >
let g:NERDTreeCustomOpenArgs = {'file': {'reuse':'currenttab', 'where':'p', 'keepopen':1, 'stay':1}}

" This setting governs whether the NERDTree window or the bookmarks table closes
" after opening a file with the |NERDTree-o|, |NERDTree-i|, |NERDTree-t| and
" |NERDTree-T| mappings.

"  Value  | NERDTree Window Behavior
"  -------+-------------------------------------------------------
"  0      | No change
"  1      | Closes after opening a file
"  2      | Closes the bookmark table after opening a bookmark
"  3(1+2) | Same as both 1 and 2

let g:NERDTreeQuitOnOpen = 3
