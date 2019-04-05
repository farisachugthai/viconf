" Init:
" Windows Vimrc
"
" Preliminaries: {{{1

" XDG Check: {{{2
" The whole file is now predicated on these existing. Need to add checks in.
" In $VIMRUNTIME/filetype.vim it looks like Bram himself checks env vars this way
if empty('$XDG_DATA_HOME')
    echoerr 'XDG_DATA_HOME not set. Exiting'
    finish
endif

if empty('$XDG_CONFIG_HOME')
    echoerr 'XDG_CONFIG_HOME not set. Exiting.'
    finish
endif

" The below is an env var set as a convenient bridge between Ubuntu and Termux
" As a result it messes things up if not set, but there's no reason to halt
" everything. Feel free to discard if you copy/paste my vimrc
if empty('$_ROOT')
    echoerr '_ROOT env var not set'
endif


" OS Setup: {{{2

" This got moved up so we can check what OS we have and decide what options
" to set from there
let g:termux = exists('$PREFIX') && has('unix')
let g:ubuntu = !exists('$PREFIX') && has('unix')
let g:windows = has('win32') || has('win64')
" ^-- This feels dangerous but I'll let it slide.

let g:winrc = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/winrc.vim'
if g:windows && filereadable(g:winrc)
    execute 'source' g:winrc
endif

" unabashedly stolen from junegunn dude is too good.
let g:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/init.vim.local'
if filereadable(g:local_vimrc)
    execute 'source' g:local_vimrc
endif

if g:windows
    " How do i check if I'm on cmd or powershell?
    " Awh fuck I just thought about the fact that I have powershell installed on Linux too :/
    " set shell=powershell shellquote=( shellpipe=\| shellredir=> shellxquote=
    " set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
endif

" Session Options: {{{3
" From :he options
" 'slash' and 'unix' are useful on Windows when sharing session files
" with Unix.  The Unix version of Vim cannot source dos format scripts,
" but the Windows version of Vim can source unix format scripts.
set sessionoptions+=unix,slash

" Remote Hosts: {{{2
if g:termux
    " holy fuck that was a doozy to find
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'
    let g:ruby_host_prog = expand($_ROOT) . '/bin/neovim-ruby-host'

elseif g:ubuntu
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'
    " So the one above could very easily be merged. No idea how to do the
    " below unless I just leave it up to the system.
    try
        let g:ruby_host_prog = expand('~') . '/.rvm/gems/default/bin/neovim-ruby-host'
    catch
        let g:ruby_host_prog = expand('$_ROOT') . '/local/bin/neovim-ruby-host'
    endtry

endif

" Python Executables: {{{2

" if we have a virtual env start there
if exists('$VIRTUAL_ENV')
    let g:python3_host_prog = expand('$VIRTUAL_ENV') . '/bin/python'
    let &path = &path . ',' . expand('$VIRTUAL_ENV') . '/lib/python3'

" or a conda env.
elseif exists('$CONDA_PREFIX')
    " Needs to use CONDA_PREFIX as the other env vars conda sets will only establish the base env not the current one
    let g:python3_host_prog = expand('$CONDA_PREFIX/bin/python3')
    " Let's hope I don't break things for Windows
    let &path = &path . ',' . expand('$CONDA_PREFIX/lib/python3')

else
    " If not then just use the system python
    if executable(expand('$_ROOT') . '/bin/python3')
        let g:python3_host_prog = expand('$_ROOT') . '/bin/python3'
        let &path = &path . ',' . expand('$_ROOT') . '/lib/python3'

    " well that's if we can find it anyway
    elseif executable('/usr/bin/python3')
        let g:python3_host_prog = '/usr/bin/python3'
        let &path = &path . ',' . '/usr/lib/python3'
    endif
endif

" Also add a python2 remote host
if executable(expand('$_ROOT') . '/bin/python2')
    let g:python_host_prog = expand('$_ROOT') . '/bin/python2'
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python2'
elseif executable('/usr/bin/python2')
    let g:python3_host_prog = '/usr/bin/python2'
    let &path = &path . ',' . '/usr/lib/python2'
else
    let g:loaded_python_provider = 1
endif

" General Plugins: {{{1
call plug#begin(expand($XDG_DATA_HOME) . '/nvim/plugged')

Plug 'junegunn/vim-plug'        " plugception
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
Plug 'davidhalter/jedi-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'         " Lighter version of NERDCom since i don't use most features anyway
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips'

if has('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'greyblake/vim-preview'
Plug 'lifepillar/vim-cheat40'

if !g:termux
    Plug 'autozimu/LanguageClient-neovim'
    Plug 'godlygeek/tabular'
    Plug 'vim-voom/voom'
    Plug 'Rykka/InstantRst'
    Plug 'gu-fan/riv.vim', { 'for': ['python', 'python3', 'rst'] }
    Plug 'junegunn/vim-peekaboo'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    " Plug 'mbbill/undotree'    " not yet but soon
endif

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Options: {{{1

set linespace=3
set cmdheight=3
set relativenumber
set hidden
set foldmethod=marker

" Its basically impossible to describe how excited this option makes me.
" Handle paths by using forward slashes even when `:has('win32')`
if exists('+shellslash')
    set shellslash
endif

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set browsedir=buffer

" This source file comes from git-for-windows build-extra repository (git-extra/vimrc): {{{1

ru! defaults.vim                " Use Enhanced Vim defaults
set mouse=a                     " Reset the mouse setting from defaults
aug vimStartup | au! | aug END  " Revert last positioned jump, as it is defined below
let g:skip_defaults_vim = 1     " Do not source defaults.vim again (after loading this system vimrc)

set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set showmode                    " show the current mode
set wildmode=list:longest,longest:full   " Better command line completion

" Show EOL type and last modified timestamp, right after the filename
" Set the statusline
set statusline=%f               " filename relative to current $PWD
set statusline+=%h              " help file flag
set statusline+=%m              " modified flag
set statusline+=%r              " readonly flag
set statusline+=\ [%{&ff}]      " Fileformat [unix]/[dos] etc...
set statusline+=\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})  " last modified timestamp
set statusline+=%=              " Rest: right align
set statusline+=%l,%c%V         " Position in buffer: linenumber, column, virtual column
set statusline+=\ %P            " Position in buffer: Percentage

if &term =~ 'xterm-256color'    " mintty identifies itself as xterm-compatible
" Mintty does but nvim-qt doesn't. idk what conemu or cmder identify as
" but i doubt powershell does. w/e
  set termguicolors             " Uncomment to allow truecolors on mintty
endif
"------------------------------------------------------------------------------
augroup gitconf
    " Set UTF-8 as the default encoding for commit messages
    autocmd BufReadPre COMMIT_EDITMSG,MERGE_MSG,git-rebase-todo setlocal fileencodings=utf-8

    " Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && &filetype !~# 'commit\|gitrebase'
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff" |
      \   exe "normal g`\"" |
      \ endif

      autocmd BufNewFile,BufRead *.patch set filetype=diff

      autocmd Filetype diff
      \ highlight WhiteSpaceEOL ctermbg=red |
      \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/

augroup END

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
"   setting." Set options and add mapping such that Vim behaves a lot like MS-Windows
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>: {{{1
" Last change:	2017 Oct 28

" bail out if this isn't wanted (mrsvim.vim uses this).
if exists("g:skip_loading_mswin") && g:skip_loading_mswin
  finish
endif

" set the 'cpoptions' to its Vim default
if 1	" only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
behave mswin

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
vnoremap <BS> d

if has("clipboard")
    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x

    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " CTRL-V and SHIFT-Insert are Paste
    map <C-V>		"+gP
    map <S-Insert>		"+gP

    cmap <C-V>		<C-R>+
    cmap <S-Insert>		<C-R>+
endif

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
" Use CTRL-G u to have CTRL-Z only undo the paste.

exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" Use CTRL-S for saving, also in Insert mode (<C-O> doesn't work well when
" using completions).
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<Esc>:update<CR>gi

" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <Cmd>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <Cmd><C-R>

" Alt-Space is System menu
" Whoa! Nvim-qt evals this to 0 but Alt-Space still gives the system menu!
" Maybe add it to the init.vim
if has("gui")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
" cnoremap <C-A> <C-C>gggH<C-O>G. 
" Dude i totally thought i was gonna go to the beginning of the cmdline...
" well just to be safe...
" onoremap <C-A> <C-C>gggH<C-O>G
" snoremap <C-A> <C-C>gggH<C-O>G
" xnoremap <C-A> <C-C>ggVG

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

if has("gui")
  " CTRL-F is the search dialog
  noremap  <expr> <C-F> has("gui_running") ? ":promptfind\<CR>" : "/"
  inoremap <expr> <C-F> has("gui_running") ? "\<C-\>\<C-O>:promptfind\<CR>" : "\<C-\>\<C-O>/"
  cnoremap <expr> <C-F> has("gui_running") ? "\<C-\>\<C-C>:promptfind\<CR>" : "\<C-\>\<C-O>/"

  " CTRL-H is the replace dialog,
  " but in console, it might be backspace, so don't map it there
  nnoremap <expr> <C-H> has("gui_running") ? ":promptrepl\<CR>" : "\<C-H>"
  inoremap <expr> <C-H> has("gui_running") ? "\<C-\>\<C-O>:promptrepl\<CR>" : "\<C-H>"
  cnoremap <expr> <C-H> has("gui_running") ? "\<C-\>\<C-C>:promptrepl\<CR>" : "\<C-H>"
endif

" restore 'cpoptions'
set cpo&
let &cpoptions = s:save_cpo
unlet s:save_cpo
