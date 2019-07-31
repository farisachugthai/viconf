" ============================================================================{{{}}}
    " File: junegunn.vim
    " Author: Faris Chugthai
    " Description: " Isolate where I define my plugins.
    " Last Modified: June 09, 2019
" ============================================================================

" Guard: {{{1
scriptencoding utf-8
let s:cpo_save = &cpoptions
set cpoptions-=C
" Note that this will only work on neovim as it it makes a call

" guard

" Plugins: {{{1
" 07/16/2019: I don't think this is needed on windows anymore!
" execute 'source ' . stdpath('data') . '/site/autoload/plug.vim'

call plug#begin(stdpath('data') . '/plugged')

Plug 'junegunn/vim-plug'        " plugception
let g:plug_window = 'tabe'
" Wait is the fact that I didn't use expand the reason FZF hasn't been working?
Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
" Plug 'w0rp/ale'

if !empty(g:windows)
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif

if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
Plug 'greyblake/vim-preview'
Plug 'luffah/vim-zim', {'for': ['zimwiki', 'zimindex']}
Plug 'tomtom/tlib_vim'  " this library is incredible

" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
if !empty(g:ubuntu)
  " I don't know rust but honestly its a model ftplugin so download it for
  " reference
  Plug 'rust-lang/rust.vim'
endif

if empty(g:termux)
  Plug 'chrisbra/csv.vim', {'for': 'csv'}
  Plug 'omnisharp/omnisharp-vim', {'for': 'cs'}
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  Plug 'ekalinin/Dockerfile.vim', {'for': 'dockerfile'}
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  Plug 'itspriddle/vim-shellcheck', { 'for': ['sh', 'bash'] }
endif

" I feel like the lazy loaded ones can come out here
Plug 'mbbill/undotree', {'on': 'UndoTreeToggle'}
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<Plug>(GrepperOperator)'] }

Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Commands: {{{1

" I utilize this command so often I may as well save the characters
command! -nargs=0 Plugins echo keys(plugs)


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
