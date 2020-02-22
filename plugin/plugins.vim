" ============================================================================
  " File: plugins
  " Author: Faris Chugthai
  " Description: Plugins
  " Last Modified: February 17, 2020
" ============================================================================

scriptencoding utf-8
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

" Load Plugins:
if !exists('plug#load')  | exec 'source ' . s:repo_root . '/vim-plug/plug.vim' | endif

" Don't assume that worked. Needs to be defined but increasingly not as needed

" Preliminary Options: {{{
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
" let s:wsl = !empty($WSL_DISTRO_NAME)                   " Windows is !has('unix') but WSL checks explicitly

" Few options I wanna set in advance
let g:no_default_tabular_maps = 1
let g:plug_shallow = 1
let g:plug_window = 'tabe'
let g:undotree_SetFocusWhenToggle = 1

" }}}

" List of plugins: {{{

call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
let $NVIM_COC_LOG_FILE = stdpath('data')  . '/site/coc.log'
let $NVIM_COC_LOG_LEVEL = 'ERROR'

Plug 'junegunn/vim-plug' ", {'dir': expand('~/projects/viconf/vim-plug')}

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

augroup UserNerdLoader

  autocmd!
  " Was raising an error according to verbosefile
  " autocmd VimEnter * silent! autocmd! FileExplorer

  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdTree')
        \|   execute 'autocmd! UserNerdLoader'
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

Plug 'SirVer/ultisnips'
" | Plug 'honza/vim-snippets'

Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }
nnoremap <Leader>a <Cmd>sil! ALEEnable<CR><bar>:sil! call plugins#AleMappings()<CR><bar>:sil! CocDisable<CR>:sil! redraw!<CR>
nnoremap <Leader>et <Cmd>ALEToggle()<CR><bar>:sil! call plugins#AleMappings()<CR>

if exists('$TMUX')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'edkolev/tmuxline.vim'
augroup UserTmuxline
  au!
  " saying Tmuxline isnt a command ergh
  autocmd BufEnter * ++once
        \  if exists(':Tmuxline')
        \| exec 'Tmuxline vim_statusline_3'
        \| endif

augroup END
endif

Plug 'mhinz/vim-startify'

Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
noremap <silent> <F8> <Cmd>TagbarToggle<CR>
noremap! <silent> <F8> <Cmd>TagbarToggle<CR>
tnoremap <silent> <F8> <Cmd>TagbarToggle<CR>
" yo this mapping is great
nnoremap ,t <Cmd>CocCommand tags.generate<CR><bar>:TagbarToggle<CR>

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
nnoremap U <Cmd>UndotreeToggle<CR>

Plug 'ervandew/supertab'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-voom/voom', {'on': ['Voom', 'VoomToggle', 'VoomExec'] }
Plug 'romainl/vim-qf'

if empty(s:termux)  " {{{
  Plug 'godlygeek/tabular', {'on': 'Tabularize'}
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
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

" Autocmds:
" Needed to be defined after supertab
" {{{
" This might need to go in the after dir because SuperTabChain STILL isn't
" registered
" if !exists('*SuperTabChain')
"   call plug#load('supertab')
" endif

" augroup SuperTabOmniFunc
"   autocmd!
"   autocmd FileType *
"     \ if &omnifunc != '' |
"     \   call SuperTabChain(&omnifunc, "<c-p>", 1) |
"     \ endif
" augroup END

" }}}

packadd! matchit
packadd! justify

" Vim: set fdm=marker foldlevelstart=0:
