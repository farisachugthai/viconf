" ============================================================================
  " File: init.vim
  " Author: Faris Chugthai
  " Description: Neovim configuration
  " Last Modified: Feb 12, 2020
" ============================================================================

" Preliminary: {{{
if exists('g:did_init_vim') || &compatible || v:version < 700
    finish
endif
let g:did_init_vim = 1

scriptencoding utf-8
setglobal fileformats=unix,dos
setglobal cpoptions-=c,e,_  " couple options that bugged me
setglobal fencs=utf-8,latin1   " UGHHHHH
" }}}

" Set paths correctly: {{{
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)
" let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

let s:this_dir = fnameescape(fnamemodify(expand('$MYVIMRC'), ':p:h'))
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
if exists('g:GuiLoaded') | exec 'source ' s:this_dir . '\ginit.vim' | endif
if has('unnamedplus') | setglobal clipboard+=unnamed,unnamedplus | else | setglobal clipboard+=unnamed | endif
" }}}

" Macros, Leader, and Nvim specific features: {{{
let g:loaded_vimballPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_netrwPlugin = 1
" Wth why doesn't match it have a loaded check?
let g:loaded_matchit = 1
packadd matchit

noremap <Space> <nop>
let g:maplocalleader = '<Space>'
map <Space> <Leader>

if has('nvim-0.4')   " Fun new features!
  let &shadafile = stdpath('data') . '/shada/main.shada'
  " toggle transparency in the pum and windows. don't set higher than 10 it becomes hard to read higher than that
  setglobal pumblend=10 winblend=5
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
" }}}

" Gotta be honest this part was stolen almost entirely from arch!: {{{

" Move temporary files to a secure location to protect against CVE-2017-1000382
if exists('$XDG_CACHE_HOME')
  let &g:directory=$XDG_CACHE_HOME
else
  let &g:directory=$HOME . '/.cache'
endif
let &g:undodir=&g:directory . '/vim/undo//'
let &g:backupdir=&g:directory . '/vim/backup//'
let &g:directory.='/vim/swap//'
" Create directories if they doesn't exist
if !isdirectory(expand(&g:directory))
  silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if !isdirectory(expand(&g:backupdir))
  silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if !isdirectory(expand(&g:undodir))
  silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif
" }}}

" Options: {{{
setglobal pastetoggle=<F9>   " fuck me this is what windows terminal uses for something

" Completion: {{{
setglobal suffixes=.bak,~,.o,.info,.swp,.aux,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.inx,.jpg,.log,.out,.png,.toc,.pyc,*.a,*.obj,*.dll,*.exe,*.lib,*.mui,*.swp,*.tmp,

setglobal wildignorecase wildmode=full:list:longest,full:list
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

setglobal foldnestmax=10
set foldmethod=marker foldcolumn=2
setglobal foldignore=
setglobal foldopen+=jump,insert foldminlines=0  foldlevelstart=0

setglobal signcolumn=auto:4  " this might be a nvim 4 thing
try | setglobal switchbuf=useopen,usetab,split | catch | endtry
setglobal splitbelow splitright
setglobal sidescroll=5 hidden
set number relativenumber cmdheight=1  " dude these stopped setting when i set global them
setglobal isfname-==
setglobal iskeyword=@,48-57,_,192-255   " Idk how but i managed to mess up the default isk

if filereadable(s:this_dir . '/spell/en.utf-8.add')
  let &g:spellfile = s:this_dir . '/spell/en.utf-8.add'
endif

setglobal path-=/usr/include
setglobal sessionoptions-=buffers,winsize viewoptions-=options sessionoptions+=globals
setglobal mouse=a
setglobal nojoinspaces
setglobal autowrite autochdir

setglobal modeline
if exists('&modelineexpr') | set modelineexpr | endif

setglobal whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
" TODO: closeoff needs to be added conditionally. how?
if has('patch-8.1.0360') || has('nvim')
  setglobal diffopt+=internal,algorithm:patience
endif
setglobal browsedir="buffer"   " which directory is used for the file browser

let &g:listchars = "tab:\u21e5\u00b7,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
" trail:\u2423 doesn't work with hack as font
let &g:fillchars = "stl:' ',stlnc:' ',vert:\u250b,fold:\u00b7,diff:'.'"

setglobal breakindent breakindentopt=sbr
let &g:showbreak = '↳ '                   " Indent wrapped lines correctly
setglobal updatetime=100 lazyredraw
setglobal inccommand=split
setglobal terse shortmess=aoOsItTWcF
setglobal title titlestring=%<%F%=%l/%L-%P   " leaves a cool title for tmux
setglobal conceallevel=2 concealcursor=nc    " enable concealing
setglobal spellsuggest=5
setglobal showmatch matchpairs+=<:>
setglobal lazyredraw matchtime=20  " Show the matching pair for 2 seconds
" }}}

" Colorscheme:  {{{
" Don't assume that the InstallPlug() func worked so ensure it's defined
setglobal termguicolors
setglobal synmaxcol=1000
if !exists('plug#load')  | exec 'source ' . s:repo_root . '/vim-plug/plug.vim' | endif " }}}

" Load Plugins: {{{
exec 'source ' . s:this_dir . '/junegunn.vim'
" Don't assume that worked. Needs to be defined but increasingly not as needed
if !exists('g:plugs') | let g:plugs = {} | endif
" }}}

if exists('$ANDROID_DATA')   " {{{
  " Fuck i had to change this because wsl was loading termux jesus christ
  call find_files#termux_remote()
elseif !has('unix')
  " Note: dude holy hell is it necessary to call the msdos#set_shell_cmd()
  " func. you do so in ./plugin/unix.vim but jesus christ did it fuck stuff up
  " when that got deleted
  call find_files#msdos_remote()
else
  call find_files#ubuntu_remote()
endif
" }}}

" Vim: set fdm=marker foldlevelstart=0:
