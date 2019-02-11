" Windows_Vimrc:

" Options: {{{1
set linespace=3

" Its basically impossible to describe how excited this option makes me.
if exists('+shellslash')
    set shellslash
endif

set fileformat=dos, unix

" Appearance: {{{1
" Leave these commented out in case you wanna come back to them
" set guifont=Inconsolata:h12
" set guifont=Hack:h11:i:cANSI:qDRAFT
" love that gvim can handle the italics

" Node Executable Path: {{{1
" Not needed currently but I could easily imagine it becoming helpful soon.
" g:ale_windows_node_executable_path
" g:ale_windows_node_executable_path         *g:ale_windows_node_executable_path*
"                                            *b:ale_windows_node_executable_path*

"   Type: |String|
"   Default: `'node.exe'`

"   This variable is used as the path to the executable to use for executing
"   scripts with Node.js on Windows.

"   For Windows, any file with a `.js` file extension needs to be executed with
"   the node executable explicitly. Otherwise, Windows could try and open the
"   scripts with other applications, like a text editor. Therefore, these
"   scripts are executed with whatever executable is configured with this
"   setting.

" Environment: {{{1
" let g:VIMRC = '~\vimfiles\vimrc'
" " So that I can stop getting this file when using :e $MYVIMRC
" let g:NVIMRC = '~\Appdata\Local\nvim\init.vim'
