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
" Don't set to debug that is WAY too much
" let $NVIM_COC_LOG_LEVEL = 'DEBUG'
let $NVIM_COC_LOG_LEVEL = 'ERROR'

" Plug 'junegunn/vim-plug'
let g:plug_window = 'tabe'

Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': ['NERDTreeToggle', 'NERDTreeVCS'] }

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }  " Follow spacemacs lead and use e for errors
noremap <Leader>a <Cmd>ALEEnable<CR><Cmd>echomsg 'ALE Enabled'<CR>

if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
noremap <silent> <F8> <Cmd>TagbarToggle<CR>
noremap! <silent> <F8> <Cmd>TagbarToggle<CR>
tnoremap <silent> <F8> <Cmd>TagbarToggle<CR>


if !empty(s:ubuntu)
  Plug 'ekalinin/Dockerfile.vim', {'for': 'dockerfile'}
endif

" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
if empty(s:termux)
  " Plug 'chrisbra/csv.vim', {'for': 'csv'}
  Plug 'greyblake/vim-preview', {'on': 'Preview'}

  " needed if for nothing else but the ftdetect
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
endif

" I feel like the lazy loaded ones can come out here
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
nnoremap U :UndotreeToggle<CR>

" The 'tabular' plugin must come _before_ 'vim-markdown'.
Plug 'godlygeek/tabular'
Plug 'itspriddle/vim-shellcheck', { 'for': ['sh', 'bash'] }
  Plug 'mitsuhiko/vim-jinja'
Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom'
Plug 'romainl/vim-qf'

if empty(s:termux)
  " Plug 'mustache/vim-mustache-handlebars'
  Plug 'raimon49/requirements.txt.vim'
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'elzr/vim-json', { 'for': 'json' }

endif

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Commands: {{{1

" I utilize this command so often I may as well save the characters
command! -nargs=0 Plugins echo keys(plugs)


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
