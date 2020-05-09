" ============================================================================
  " File: init.vim
  " Author: Faris Chugthai
  " Description: Neovim configuration
  " Last Modified: Feb 12, 2020
" ============================================================================


" Preliminary: {{{
" These are the options that I consider the minimum requirements to running
scriptencoding utf-8
setglobal fileformats=unix,dos
setglobal cpoptions-=c,e,_  " couple options that bugged me
setglobal fileencodings=utf-8,default,latin1   " UGHHHHH
setglobal nobomb | lockvar g:nobomb
setglobal hidden
" }}}

" Set paths correctly: {{{
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h'))
" Seriously how does this keep getting fucked up. omfg packpath is worse???
setglobal runtimepath=$HOME/.config/nvim,$HOME/.local/share/nvim/site,$VIMRUNTIME
setglobal packpath=~/.config/nvim/pack,~/.local/share/nvim/site/pack,$VIMRUNTIME
if !has('unix')
  " call it silly but keep source expressions on their own line. TPope set them up in &include
  source C:/Neovim/share/nvim-qt/runtime/plugin/nvim_gui_shim.vim
endif

setglobal background=dark
set debug=msg
if exists('g:GuiLoaded') | exec 'source ' s:repo_root . '/ginit.vim' | endif
" TODO: clipboards fucking up on windows
setglobal clipboard=unnamed,unnamedplus
set modeline modelines=5
" }}}

" Macros, Leader, and Nvim specific features: {{{
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_logiPat = 1
let g:loaded_matchparen = 1
let g:loaded_netrwPlugin = 1
let g:loaded_spellfile = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin = 1

noremap <Space> <nop>
let g:maplocalleader = '<Space>'
map <Space> <Leader>

if has('nvim-0.4')   " Fun new features!
  let &shadafile = stdpath('data') . '/site/shada/main.shada'
  " toggle transparency in the pum and windows. don't set higher than 10 it becomes hard to read higher than that
  setglobal pumblend=10 winblend=5
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
let g:peekaboo_compact = 1
" }}}

function! LoadMyPlugins() abort  " {{{

  let g:plug_url = 'https://github.com/%s.git'
  if !exists('plug#load')  | unlet! g:loaded_plug | exec 'source ' . s:repo_root . '/vim-plug/plug.vim' | endif

  if !exists('*stdpath') | echohl WarningMsg | echomsg 'stdpath func does not exist.' | echohl NONE | return | endif

  call plug#begin(stdpath('data'). '/plugged')

  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
  let $NVIM_COC_LOG_FILE = stdpath('data')  . '/site/coc.log'
  let $NVIM_COC_LOG_LEVEL = 'ERROR'
  Plug 'junegunn/fzf', {
                  \ 'dir': expand('~/.fzf'),
                  \ 'do': './install --all'
                  \ }
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-peekaboo'
  Plug 'scrooloose/nerdTree', { 'on': ['NERDTreeToggleVCS', 'NERDTreeVCS', 'NERDTreeFind'] }
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-scriptease', {'for': 'vim'}
  Plug 'SirVer/ultisnips'
  Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }
  nnoremap <Leader>a <Cmd>sil! ALEEnable<CR><bar>:sil! call plugins#AleMappings()<CR><bar>:sil! CocDisable<CR>:sil! redraw!<CR>:ALELint<CR>
  nnoremap <Leader>et <Cmd>ALEToggle<CR>:sil! call plugins#AleMappings()<CR>:sil! redraw!<CR>

  if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
  endif

  Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
  noremap <F8> <Cmd>TagbarToggle<CR><Cmd>call plugins#TagbarTypes()<CR><Cmd>call tagbar#types#uctags#init({})<CR><Cmd>source ~/projects/viconf/plugin/autocmd.vim<CR>
  noremap! <F8> <Cmd>TagbarToggle<CR><Cmd>call plugins#TagbarTypes()<CR><Cmd>call tagbar#types#uctags#init({})<CR><Cmd>source ~/projects/viconf/plugin/autocmd.vim<CR>
  tnoremap <F8> <Cmd>TagbarToggle<CR><Cmd>call plugins#TagbarTypes()<CR><Cmd>call tagbar#types#uctags#init({})<CR><Cmd>source ~/projects/viconf/plugin/autocmd.vim<CR>

  " yo this mapping is great
  nnoremap ,t <Cmd>CocCommand tags.generate<CR><Cmd>TagbarToggle<CR>
  Plug 'ervandew/supertab'
  Plug 'junegunn/vim-peekaboo'
  Plug 'vim-voom/voom', {'on': ['Voom', 'VoomToggle', 'VoomExec'] }
  Plug 'romainl/vim-qf'
  Plug 'tomtom/tlib_vim'
  Plug 'godlygeek/tabular', {'on': 'Tabularize'}
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-eunuch'
  Plug 'morhetz/gruvbox'

  if empty(s:termux)  " {{{
    Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'ps1xml', 'xml'] }
    Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
    Plug 'lepture/vim-jinja'
    Plug 'honza/vim-snippets'
    Plug 'cespare/vim-toml', {'for': 'toml'}
    Plug 'pearofducks/ansible-vim', {'for': 'yaml'}
    Plug 'omnisharp/omnisharp-vim', {'for': ['cs', 'ps1'] }
    Plug 'itspriddle/vim-shellcheck', {'for': ['sh', 'bash'] }
    " Plug 'neovim/nvim-lsp'
    Plug 'mhinz/vim-startify'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
    nnoremap U <Cmd>UndoTreeToggle<CR>
    Plug 'tpope/vim-apathy'
    Plug 'liuchengxu/vim-which-key'
  endif " }}}
  Plug 'kshenoy/vim-signature'

  Plug 'ryanoasis/vim-devicons'
  call plug#end()
endfunction

call LoadMyPlugins()

" I utilize this command so often I may as well save the characters
command! -bar Plugins echomsg map(keys(g:plugs), '"\n" . v:val')
" For some reason running syntax enable clears the syntax option
" also setting background requires syntax on to reload
let g:syntax_cmd = "on"

" in case i started things with -u NONE
if &loadplugins is 0 | set loadplugins | endif
" }}}

" Vim: set fdm=marker foldlevelstart=0:
