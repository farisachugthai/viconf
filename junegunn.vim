" ============================================================================
    " File: junegunn.vim
    " Author: Faris Chugthai
    " Description: Isolate where I define my plugins.
    " Last Modified: Oct 01, 2019
" ============================================================================

scriptencoding utf-8
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)                   " Windows is !has('unix') but WSL checks explicitly
let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

" Few options I wanna set in advance
let g:no_default_tabular_maps = 1
let g:plug_shallow = 1

call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
let $NVIM_COC_LOG_FILE = stdpath('data')  . '/site/coc.log'
let $NVIM_COC_LOG_LEVEL = 'ERROR'

Plug 'junegunn/vim-plug' ", {'dir': expand('~/projects/viconf/vim-plug')}
let g:plug_window = 'tabe'

Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': ['NERDTreeCWD', 'NERDTreeVCS'] }
nnoremap <Leader>nt <Cmd>NERDTreeCWD<CR>zz
" Switch NERDTree root to dir of currently focused window.
" Make mapping match Spacemacs.
if exists(':GuiTreeviewToggle')
  nnoremap <Leader>0 <Cmd>GuiTreeviewToggle<CR>
else
  nnoremap <Leader>0 <Cmd>NERDTreeCWD<CR>
endif

" Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'

if has('python3')
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif
Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }  " Follow spacemacs lead and use e for errors
nnoremap <Leader>a <Cmd>ALEEnable<CR><bar>:call plugins#AleMappings()<CR>
if exists('$TMUX')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'

Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
noremap <silent> <F8> <Cmd>TagbarToggle<CR>
noremap! <silent> <F8> <Cmd>TagbarToggle<CR>
tnoremap <silent> <F8> <Cmd>TagbarToggle<CR>

if !has('unix')  " this really fucks up on windows
  Plug 'jszakmeister/rst2ctags', {'dir': expand('~/src/rst2ctags')}
endif

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
nnoremap U <Cmd>UndotreeToggle<CR>

" The 'tabular' plugin must come _before_ 'vim-markdown'.
Plug 'itspriddle/vim-shellcheck', { 'for': ['sh', 'bash'] }
Plug 'mitsuhiko/vim-jinja', {'for': ['html', 'jinja2', 'htmljinja', 'htmldjango'] }
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom', {'on': ['Voom', 'VoomToggle', 'VoomExec'] }
Plug 'romainl/vim-qf'

Plug 'raimon49/requirements.txt.vim', {'for': ['requirements', 'txt', 'config']}
Plug 'ntpeters/vim-better-whitespace'

if empty(s:termux)
" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
  Plug 'chrisbra/csv.vim', {'for': ['csv', 'tsv']}
  Plug 'godlygeek/tabular', {'on': 'Tabularize'}
  " needed if for nothing else but the ftdetect
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  " Plug 'mustache/vim-mustache-handlebars'
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'elzr/vim-json', { 'for': 'json' }
endif

Plug 'ludovicchabant/vim-gutentags'
" Plug 'michaeljsmith/vim-indent-object'
Plug 'tomtom/tlib_vim'
Plug 'ryanoasis/vim-devicons'           " Keep at end!

call plug#end()

" Commands: {{{1

" I utilize this command so often I may as well save the characters
command! -nargs=0 Plugins echo map(keys(g:plugs), '"\n" . v:val')
