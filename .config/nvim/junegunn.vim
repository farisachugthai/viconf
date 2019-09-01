" ============================================================================
    " File: junegunn.vim
    " Author: Faris Chugthai
    " Description: Isolate where I define my plugins.
    " Last Modified: June 09, 2019
" ============================================================================

" Guard: {{{1
scriptencoding utf-8
let s:cpo_save = &cpoptions
set cpoptions-=C

" Plugins: {{{1
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)
let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
let $NVIM_COC_LOG_LEVEL='debug'
let g:plug_window = 'tabe'
" Wait is the fact that I didn't use expand the reason FZF hasn't been working?
Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
  " FUCK! This hasn't worked for MONTHS and it's because the plugin is called nerdTree not nerdtree...
        \|   call plug#load('nerdTree')
        \|   execute 'NERDTreeToggle'
        \|   execute 'autocmd! nerd_loader'
        \| endif
    autocmd bufenter *
        \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
        \| q
        \| endif
augroup END

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'w0rp/ale', { 'on': ['ALEEnable', 'ALEDetail'] }  " Follow spacemacs lead and use e for errors
noremap <Leader>e <Plug>ALEEnable <bar> echomsg 'ALE Enable'
noremap <Leader>ed <Plug>ALEDetail<CR>

if !has('unix')
  " might not be necessary because of coc-powershell
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
endif

if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}

if !empty(s:ubuntu)
  " I don't know rust but honestly its a model ftplugin so download it for
  " reference
  Plug 'rust-lang/rust.vim'
  Plug 'itspriddle/vim-shellcheck', { 'for': ['sh', 'bash'] }
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  Plug 'ekalinin/Dockerfile.vim', {'for': 'dockerfile'}
  Plug 'luffah/vim-zim', {'for': ['zimwiki', 'zimindex']}
  Plug 'fatih/vim-go'  " could add in {'do': ':GoInstallBinaries'}
endif

" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
if empty(s:termux)
  Plug 'chrisbra/csv.vim', {'for': 'csv'}
  Plug 'greyblake/vim-preview', {'on': 'Preview'}
  Plug 'tomtom/tlib_vim'  " this library is incredible
endif

" I feel like the lazy loaded ones can come out here
Plug 'mbbill/undotree', {'on': 'UndoTreeToggle'}
nnoremap U :UndotreeToggle<CR>
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

if has('python3') && empty(s:termux)
  Plug 'jupyter-vim/jupyter-vim'  " This plugin only makes sense when pythons loaded
endif
Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Commands: {{{1

" I utilize this command so often I may as well save the characters
command! -nargs=0 Plugins echo keys(plugs)


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
