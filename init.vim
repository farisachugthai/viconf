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
  setglobal runtimepath=~/.config/nvim,~/.local/share/nvim/site,$VIMRUNTIME,~/.config/nvim/after
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
if has('patch-8.1.0251') | let &g:backupdir=stdpath('config') . '/undodir//' | endif
" Gotta be honest this part was stolen almost entirely from arch:

" Move temporary files to a secure location to protect against CVE-2017-1000382
if exists('$XDG_CACHE_HOME')
  let &g:directory=$XDG_CACHE_HOME
else
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
setglobal autowrite autochdir

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

" Vim: set fdm=marker foldlevelstart=0:
