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
setglobal fencs=utf-8,latin1   " UGHHHHH
" }}}

" Set paths correctly: {{{
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)
" let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h'))

" Seriously how does this keep getting fucked up. omfg packpath is worse???
if has('unix')
  let &g:runtimepath = stdpath('config') . ',' .  stdpath('data') . ',' . expand($VIMRUNTIME)
  setglobal packpath=~/.config/nvim/pack,~/.local/share/nvim/site/pack,$VIMRUNTIME,~/.config/nvim/after/pack
else
  setglobal runtimepath=$USERPROFILE\AppData\Local\nvim,$USERPROFILE\AppData\Local\nvim-data\site,$VIMRUNTIME,C:\Neovim\share\nvim-qt\runtime
  setglobal packpath=~\AppData\Local\nvim\pack,~\AppData\Local\nvim-data\site\pack,$VIMRUNTIME,C:\Neovim\share\nvim-qt\runtime\pack
endif

" Source ginit. Why is this getting set even in the TUI?
if exists('g:GuiLoaded') | exec 'source ' s:repo_root . '\ginit.vim' | endif
if has('unnamedplus') | setglobal clipboard+=unnamed,unnamedplus | else | setglobal clipboard+=unnamed | endif
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
  let &shadafile = stdpath('data') . '/shada/main.shada'
  " toggle transparency in the pum and windows. don't set higher than 10 it becomes hard to read higher than that
  " setglobal pumblend=10 winblend=5
  try | setglobal pyxversion=3 | catch /^Vim:E518:*/ | endtry
endif

let g:matchparen_timeout = 500
let g:matchparen_insert_timeout = 300
" }}}

" Backups: {{{
" Protect changes between writes. Default values of updatecount
" (200 keystrokes) and updatetime (4 seconds) are fine
setglobal swapfile undofile backupext='.bak'
setglobal writebackup        " protect against crash-during-write
setglobal nobackup           " but do not persist backup after successful write

" use rename-and-write-new method whenever safe. actually might go with yes
" its slower but idc
setglobal backupcopy=yes
" patch required to honor double slash at end consolidate the writebackups -- they usually get deleted
if has('patch-8.1.0251')
 let &g:backupdir=stdpath('config') . '/undodir//'
 endif
" Gotta be honest this part was stolen almost entirely from arch:

" Move temporary files to a secure location to protect against CVE-2017-1000382
if exists('$XDG_CACHE_HOME')
  let &g:directory=$XDG_CACHE_HOME
else
  let $XDG_CACHE_HOME = $HOME . '/.cache'
  let &g:directory=$HOME . '/.cache'
endif
let &g:undodir = &g:directory . '/vim/undo//'
let &g:backupdir = &g:directory . '/vim/backup//'
let &g:directory .= '/vim/swap//'
" }}}

" Completion: {{{
setglobal suffixes=.bak,~,.o,.info,.swp,.aux,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.inx,.jpg,.log,.out,.png,.toc,.pyc,*.a,*.obj,*.dll,*.exe,*.lib,*.mui,*.swp,*.tmp,

setglobal wildignorecase
setglobal wildmode=full:list:longest,full:list
setglobal wildignore=*~,versions/*,cache/*,.tox/*,.pytest_cache/*,__pycache__/*
setglobal wildcharm=<C-z>

" C-n and C-p now use the same input that every other C-x does combined!
" Remove includes they're pretty slow
setglobal complete+=kspell,d,k complete-=u,i

" Create a preview window and display all possibilities but don't insert
" dude what am i doing wrong that i don't get the cool autocompletion that NORC gets??
setglobal completeopt=menu,menuone,noselect,noinsert,preview
" both smartcase and infercase require ignorecase to be set:
setglobal ignorecase
setglobal smartcase infercase smartindent
" }}}

" Options: {{{
setglobal pastetoggle=<F9>   " fuck me this is what windows terminal uses for something

setglobal signcolumn=auto:4  " this might be a nvim 4 thing
try | setglobal switchbuf=useopen,usetab,split | catch | endtry
setglobal splitbelow splitright
setglobal sidescroll=5 hidden
" dude these stopped setting when i set global them
set number relativenumber
setglobal cmdheight=2
setglobal helpheight=8  " why is 20? help windows can be really intrusive with it that high
setglobal isfname-==
setglobal iskeyword=@,48-57,_,192-255   " Idk how but i managed to mess up the default isk

if filereadable(s:repo_root . '/spell/en.utf-8.add')
  let &g:spellfile = s:repo_root . '/spell/en.utf-8.add'
endif

setglobal path-=/usr/include
setglobal sessionoptions-=buffers,winsize viewoptions-=options sessionoptions+=globals
setglobal mouse=a
setglobal nojoinspaces
setglobal modeline
if exists('&modelineexpr') | setglobal modelineexpr | endif

setglobal whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
" TODO: closeoff needs to be added conditionally. how?
setglobal browsedir="buffer"   " which directory is used for the file browser

let &g:listchars = "tab:\u21e5\u00b7,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
" trail:\u2423 doesn't work with hack as font
let &fillchars = "stl:' ',stlnc:' ',vert:\u250b,fold:\u00b7,diff:'.'"

setglobal breakindent breakindentopt=sbr
let &g:showbreak = '↳ '                   " Indent wrapped lines correctly
setglobal updatetime=400 lazyredraw
setglobal inccommand=split
setglobal terse shortmess=aoOsItTWcF
setglobal title titlestring=%<%F%=%l/%L-%P   " leaves a cool title for tmux
setglobal conceallevel=2 concealcursor=nc    " enable concealing
setglobal spellsuggest=5
setglobal showmatch matchpairs+=<:>
setglobal matchtime=20  " Show the matching pair for 2 seconds
" dude holy hell are we running faster on termux set termguicolors
setglobal synmaxcol=1000  " }}}

" Load Plugins: {{{
if !exists('plug#load')  | unlet! g:loaded_plug | exec 'source ' . s:repo_root . '/vim-plug/plug.vim' | endif
" Preliminary Options: {{{
" Few options I wanna set in advance
let g:no_default_tabular_maps = 1
let g:plug_shallow = 1
let g:plug_window = 'tabe'
let g:undotree_SetFocusWhenToggle = 1

" }}}

" List of plugins: {{{

function! LoadMyPlugins() abort

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
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-scriptease'
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  Plug 'dense-analysis/ale', { 'on': ['ALEEnable', 'ALEToggle'] }
  nnoremap <Leader>a <Cmd>sil! ALEEnable<CR><bar>:sil! call plugins#AleMappings()<CR><bar>:sil! CocDisable<CR>:sil! redraw!<CR>:ALELint<CR>
  nnoremap <Leader>et <Cmd>ALEToggle<CR>:sil! call plugins#AleMappings()<CR>:sil! redraw!<CR>

  if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
    augroup UserTmuxline
      au!
      autocmd VimEnter *
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
    Plug 'omnisharp/omnisharp-vim', {'for': ['cs', 'ps1',] }
    Plug 'HiPhish/jinja.vim'
  endif
  " }}}

  Plug 'ludovicchabant/vim-gutentags'
  Plug 'tomtom/tlib_vim'
  Plug 'ryanoasis/vim-devicons'           " Keep at end!
  call plug#end()

endfunction

call LoadMyPlugins()
" }}}

" Commands: {{{

" I utilize this command so often I may as well save the characters
command! Plugins echo map(keys(g:plugs), '"\n" . v:val')

" Idk why but this became necessary on windows again. and wsl
set termguicolors
colo gruvbox-material
packadd! matchit
packadd! justify
" }}}
" }}}

" Vim: set fdm=marker foldlevelstart=0:
