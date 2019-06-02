" A Vim Script to isolate where I define my plugins.

" Note that this will only work on neovim as it it makes a call
" to Vim-Plug using the function stdpath() which only exists on neovim

" General Plugins: {{{1
" I don't know why this isn't working but let's try this

" this is unreal. how is this saying 'undefined variable C...That's the fucking
" name of the root drive on Windows!!
" exec 'call plug#begin(' . stdpath('data') . '/plugged)'

" This works but i'm gonna have to make a conditional for the func call which
" feels like a waste..
" Actually i should just refactor all of the vim-plug stuff out of this file
" so that if plug.vim ever doesn't get sourced correctly i can still load
" nvim to SOME extent...

" we still aren't sourcing plug.vim in it at the right time
" GOT IT! I checked `echo &rtp` and it's looking for the site folder in the nvim not nvim-data!!
" ...well now that we got that sorted out can we not waste this time on the source?
" exec 'source ' stdpath('config') . '/site/autoload/plug.vim'
" let s:plugged_dir = stdpath('data') . '/plugged'

" call plug#begin(s:plugged_dir)

" Well that crashed horribly
"
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
else
  " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif

if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
Plug 'greyblake/vim-preview'
" Plug 'luffah/vim-zim', {'for': ['zimwiki', 'zimindex']}
Plug 'tomtom/tlib_vim'  " this library is incredible

" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
if !g:termux
    Plug 'autozimu/LanguageClient-neovim', {'do': ':UpdateRemotePlugins'}
    Plug 'godlygeek/tabular'
    Plug 'Rykka/InstantRst', {'for': 'rst'}
    Plug 'gu-fan/riv.vim', {'for': 'rst'}
    Plug 'junegunn/vim-peekaboo'
    Plug 'tpope/vim-surround'
    Plug 'mbbill/undotree', {'on': 'UndoTreeToggle'}
    Plug 'chrisbra/csv.vim', {'for': 'csv'}
    Plug 'omnisharp/omnisharp-vim', {'for': 'cs'}
    Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
endif

Plug 'vim-voom/voom'
Plug 'neoclide/coc.nvim'
Plug 'ervandew/supertab'

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()
