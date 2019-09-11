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
let $NVIM_COC_LOG_FILE = stdpath('data')  . '/coc.log'
let $NVIM_COC_LOG_LEVEL = 'error'

" Plug 'junegunn/vim-plug'
let g:plug_window = 'tabe'

Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': ['NERDTreeToggle', 'NERDTreeVCS'] }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'w0rp/ale', { 'on': ['ALEEnable', 'ALEToggle'] }  " Follow spacemacs lead and use e for errors
noremap <Leader>e <Cmd>ALEEnable<CR><Cmd>echomsg 'ALE Enabled'<CR>
noremap <Leader>a <Cmd>ALEToggle<CR><Cmd>echomsg 'ALE Toggled'<CR>

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
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  Plug 'itspriddle/vim-shellcheck', { 'for': ['sh', 'bash'] }
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  Plug 'ekalinin/Dockerfile.vim', {'for': 'dockerfile'}
  Plug 'fatih/vim-go'  " could add in {'do': ':GoInstallBinaries'}
endif

" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
if empty(s:termux)
  Plug 'chrisbra/csv.vim', {'for': 'csv'}
  Plug 'greyblake/vim-preview', {'on': 'Preview'}
  Plug 'mitsuhiko/vim-jinja'
endif

" I feel like the lazy loaded ones can come out here
Plug 'mbbill/undotree', {'on': 'UndoTreeToggle'}
nnoremap U :UndotreeToggle<CR>
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom'

if has('python3') && empty(s:termux)
  " Plug 'jupyter-vim/jupyter-vim'  " This plugin only makes sense when pythons loaded
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'raimon49/requirements.txt.vim'
endif

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Commands: {{{1

" I utilize this command so often I may as well save the characters
command! -nargs=0 Plugins echo keys(plugs)


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
