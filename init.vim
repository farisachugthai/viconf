" ============================================================================
  " File: init.vim
  " Author: Faris Chugthai
  " Description: Neovim configuration
  " Last Modified: Feb 12, 2020
" ============================================================================

" Preliminary: {{{
scriptencoding utf-8
setglobal fileformats=unix,dos
setglobal cpoptions-=c,e,_  " couple options that bugged me
setglobal fileencodings=utf-8,latin1   " UGHHHHH
" }}}

" Set paths correctly: {{{
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)
" let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h'))
" Seriously how does this keep getting fucked up. omfg packpath is worse???
setglobal runtimepath=$HOME/.config/nvim,$HOME/.local/share/nvim/site,$VIMRUNTIME
setglobal packpath=~/.config/nvim/pack,~/.local/share/nvim/site/pack,$VIMRUNTIME
if !has('unix')
  setglobal runtimepath+=C:\Neovim\share\nvim-qt\runtime
endif
" Source ginit. Why is this getting set even in the TUI?
if exists('g:GuiLoaded') | exec 'source ' s:repo_root . '/ginit.vim' | endif
" TODO: clipboards fucking up on windows
setglobal clipboard=unnamed,unnamedplus
" if has('unnamedplus') | setglobal clipboard+=unnamed,unnamedplus | else | setglobal clipboard+=unnamed | endif
" }}}

" Macros, Leader, and Nvim specific features: {{{
let g:loaded_vimballPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_netrwPlugin = 1

noremap <Space> <nop>
let g:maplocalleader = '<Space>'
map <Space> <Leader>

if has('nvim-0.4')   " Fun new features!
  let &shadafile = stdpath('data') . '/site/shada/main.shada'
  " toggle transparency in the pum and windows. don't set higher than 10 it becomes hard to read higher than that
  " setglobal pumblend=10 winblend=5
  try | setglobal pyxversion=3 | catch /^Vim:E518:*/ | endtry
endif

let g:matchparen_timeout = 500
let g:matchparen_insert_timeout = 300
" }}}

" Load Plugins Preliminary Options: {{{
" Few options I wanna set in advance
let g:no_default_tabular_maps = 1
let g:plug_shallow = 1
let g:plug_window = 'tabe'
let g:undotree_SetFocusWhenToggle = 1
" Windows gets all kinds of fucked up otherwise
let g:plug_url = 'https://github.com/%s.git'
let g:peekaboo_compact = 1

function! LoadMyPlugins() abort

  if !exists('plug#load')  | unlet! g:loaded_plug | exec 'source ' . s:repo_root . '/vim-plug/plug.vim' | endif
  call plug#begin(stdpath('data'). '/plugged')

  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
  let $NVIM_COC_LOG_FILE = stdpath('data')  . '/site/coc.log'
  let $NVIM_COC_LOG_LEVEL = 'ERROR'
  Plug 'junegunn/fzf', { 
                  \ 'dir': expand('~/.fzf'),
                  \ 'do': './install --all' 
                  \ }
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/vim-peekaboo'

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

  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-apathy'
  Plug 'tpope/vim-scriptease'
  Plug 'SirVer/ultisnips'
  Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }
  nnoremap <Leader>a <Cmd>sil! ALEEnable<CR><bar>:sil! call plugins#AleMappings()<CR><bar>:sil! CocDisable<CR>:sil! redraw!<CR>:ALELint<CR>
  nnoremap <Leader>et <Cmd>ALEToggle<CR>:sil! call plugins#AleMappings()<CR>:sil! redraw!<CR>

  if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
  endif

  Plug 'mhinz/vim-startify', {'on': 'Startify'}
  Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
  noremap <silent> <F8> <Cmd>TagbarToggle<CR>
  noremap! <silent> <F8> <Cmd>TagbarToggle<CR>
  tnoremap <silent> <F8> <Cmd>TagbarToggle<CR>

  " yo this mapping is great
  nnoremap ,t <Cmd>CocCommand tags.generate<CR><Cmd>TagbarToggle<CR>
  Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
  Plug 'ervandew/supertab'
  Plug 'junegunn/vim-peekaboo' 
  Plug 'vim-voom/voom', {'on': ['Voom', 'VoomToggle', 'VoomExec'] }
  Plug 'romainl/vim-qf'
  Plug 'tomtom/tlib_vim'
  " Dont know how i didnt realize lazy loaded plugins arent added to rtp.
  Plug 'mitsuhiko/vim-jinja', {'for': 'jinja2'},

  Plug 'cespare/vim-toml', {'for': 'toml'}

  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
  Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
  Plug 'omnisharp/omnisharp-vim', {'for': ['cs', 'ps1'] }
  Plug 'itspriddle/vim-shellcheck', {'for': ['sh', 'bash'] } 
  Plug 'morhetz/gruvbox'

  if empty(s:termux)  " {{{
    Plug 'godlygeek/tabular', {'on': 'Tabularize'}
    Plug 'ludovicchabant/vim-gutentags'
  endif
  " }}}
  Plug 'kshenoy/vim-signature'
  Plug 'ryanoasis/vim-devicons'           " Keep at end!
  call plug#end()

endfunction

call LoadMyPlugins()
" }}}

" Commands: {{{
" I utilize this command so often I may as well save the characters
command! Plugins echo map(keys(g:plugs), '"\n" . v:val')

let g:syntax_cmd = "enable"
" }}}

" Vim: set fdm=marker foldlevelstart=0:
