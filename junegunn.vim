" ============================================================================
    " File: junegunn.vim
    " Author: Faris Chugthai
    " Description: Isolate where I define my plugins.
    " Last Modified: Oct 01, 2019
" ============================================================================

" Guard: {{{1
scriptencoding utf-8
let s:cpo_save = &cpoptions
set cpoptions-=C

" Plugins: {{{1
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)                   " Windows is !has('unix') but WSL checks explicitly
let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim' ", {'do': 'yarn install --frozen-lockfile'}
let $NVIM_COC_LOG_FILE = stdpath('data')  . '/site/coc.log'
let $NVIM_COC_LOG_LEVEL = 'ERROR'

" So you can't use dir: ./vim-plug because it'll put vim-plug in the cwd not
" this one
" doesnt work either
" Plug 'junegunn/vim-plug', {'dir': expand('~/projects/viconf/vim-plug')}
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

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-vinegar'

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }  " Follow spacemacs lead and use e for errors

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
" Plug 'godlygeek/tabular'
Plug 'itspriddle/vim-shellcheck', { 'for': ['sh', 'bash'] }
Plug 'mitsuhiko/vim-jinja', {'for': ['html', 'jinja2', 'htmljinja', 'htmldjango'] }
Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom', {'on': ['Voom', 'VoomToggle', 'VoomExec'] }
Plug 'romainl/vim-qf'

Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
" Plug 'ntpeters/vim-better-whitespace'

if empty(s:termux)
" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
  Plug 'chrisbra/csv.vim', {'for': ['csv', 'tsv']}

  " needed if for nothing else but the ftdetect
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  " Plug 'mustache/vim-mustache-handlebars'
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'elzr/vim-json', { 'for': 'json' }
  " Plug 'omnisharp/omnisharp-vim', {'for': 'cs'}

  Plug 'ludovicchabant/vim-gutentags'

  " Well this looks sweet
  Plug 'psf/black', {'for': 'python'}
endif

" Plug 'michaeljsmith/vim-indent-object'
" Plug 'tomtom/tlib_vim'
Plug 'ryanoasis/vim-devicons'           " Keep at end!

call plug#end()

" Commands: {{{1

" I utilize this command so often I may as well save the characters
command! -nargs=0 Plugins echo map(keys(plugs), '"\n" . v:val')
