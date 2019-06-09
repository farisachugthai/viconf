" ============================================================================
    " File: junegunn.vim
    " Author: Faris Chugthai
    " Description: " Isolate where I define my plugins.
    " Last Modified: June 09, 2019
" ============================================================================

scriptencoding utf-8
let s:cpo_save = &cpoptions
set cpoptions&vim
" Note that this will only work on neovim as it it makes a call
" to Vim-Plug using the function stdpath() which only exists on neovim
" todo: get the plugin guard in here

" General Plugins: {{{1
" GOT IT! I checked `echo &rtp` and it's looking for the site folder in the nvim not nvim-data!!

" Plugins: {{{1
execute 'source ' . stdpath('data') . '/site/autoload/plug.vim'

call plug#begin(stdpath('data') . '/plugged')

Plug 'junegunn/vim-plug'        " plugception
let g:plug_window = 'tabe'
" Wait is the fact that I didn't use expand the reason FZF hasn't been working?
Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'

if !empty(g:windows)
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
" else
  " I just expanded 2 snippets on Windows...Coc expanded them without
  " UltiSnips being loaded...
  " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
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
  Plug 'Rykka/InstantRst', {'for': 'rst'}
 " uses python2 syntax and that's killing windows
  Plug 'gu-fan/riv.vim', {'for': 'rst'}
endif

if empty(g:termux)
    " honestly this almost never actually begins the language server
    " Plug 'autozimu/LanguageClient-neovim', {'do': ':UpdateRemotePlugins'}
    Plug 'godlygeek/tabular'
    Plug 'junegunn/vim-peekaboo'
    Plug 'tpope/vim-surround'
    Plug 'mbbill/undotree', {'on': 'UndoTreeToggle'}
    Plug 'chrisbra/csv.vim', {'for': 'csv'}
    Plug 'omnisharp/omnisharp-vim', {'for': 'cs'}
    Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
    Plug 'ekalinin/Dockerfile.vim', {'for': 'dockerfile'}
endif

Plug 'vim-voom/voom'
Plug 'neoclide/coc.nvim'
Plug 'ervandew/supertab'

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
