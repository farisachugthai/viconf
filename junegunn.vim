" ============================================================================
    " File: junegunn.vim
    " Author: Faris Chugthai
    " Description: Isolate where I define my plugins.
    " Last Modified: Oct 01, 2019
" ============================================================================

scriptencoding utf-8

" Preliminary Options: {{{
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)                   " Windows is !has('unix') but WSL checks explicitly
let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

" Few options I wanna set in advance
let g:no_default_tabular_maps = 1
let g:plug_shallow = 1
let g:undotree_SetFocusWhenToggle = 1

" }}}

" List of plugins: {{{

call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
let $NVIM_COC_LOG_FILE = stdpath('data')  . '/site/coc.log'
let $NVIM_COC_LOG_LEVEL = 'ERROR'

Plug 'junegunn/vim-plug' ", {'dir': expand('~/projects/viconf/vim-plug')}
let g:plug_window = 'tabe'

Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" NerdTree: {{{
Plug 'scrooloose/nerdTree', { 'on': ['NERDTreeToggleVCS', 'NERDTreeVCS', 'NERDTreeFind'] }
nnoremap <Leader>nt <Cmd>NERDTreeToggleVCS<CR>zz
nnoremap <Leader>nf <Cmd>NERDTreeFind<CR>

" Switch NERDTree root to dir of currently focused window.
" Make mapping match Spacemacs.
if exists(':GuiTreeviewToggle')
  nnoremap <Leader>0 <Cmd>GuiTreeviewToggle<CR>
else
  nnoremap <Leader>0 <Cmd>NERDTreeToggleVCS<CR>
endif

augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdTree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END
" }}}

" TPope: {{{
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
" Sorry but this invokes the python interpreter on startup making it slow as
" dog shit
" Plug 'tpope/vim-apathy'
Plug 'tpope/vim-scriptease'
" }}}

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }
nnoremap <Leader>a <Cmd>ALEEnable<CR><bar>:sil call plugins#AleMappings()<CR>
nnoremap <Leader>et <Cmd>ALEToggle()<CR><bar>:sil call plugins#AleMappings()<CR>

if exists('$TMUX')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'

Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
noremap <silent> <F8> <Cmd>TagbarToggle<CR>
noremap! <silent> <F8> <Cmd>TagbarToggle<CR>
tnoremap <silent> <F8> <Cmd>TagbarToggle<CR>

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
nnoremap U <Cmd>UndotreeToggle<CR>

Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom', {'on': ['Voom', 'VoomToggle', 'VoomExec'] }
Plug 'romainl/vim-qf'

if empty(s:termux)  " {{{
  Plug 'godlygeek/tabular', {'on': 'Tabularize'}
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  " Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'elzr/vim-json', { 'for': 'json' }
  Plug 'omnisharp/omnisharp-vim' " , {'for': ['cs', 'ps1',] }
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'liuchengxu/vista.vim'
endif  " }}}

Plug 'ludovicchabant/vim-gutentags'
Plug 'tomtom/tlib_vim'

Plug 'neovim/nvim-lsp', { 'on': 'LspInstall' }

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()
" }}}

" Commands: {{{

" I utilize this command so often I may as well save the characters
command! Plugins echo map(keys(g:plugs), '"\n" . v:val')

" }}}
" Vim: set fdm=marker foldlevelstart=0:
