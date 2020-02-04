" ============================================================================
  " File: init.vim
  " Author: Faris Chugthai
  " Description: Neovim configuration
  " Last Modified: September 23, 2019
" ============================================================================

scriptencoding utf-8
set fileformat=unix fileformats=unix,dos  " don't let DOS fuck up the EOL
setglobal cpoptions-=c,e,_  " couple options that bugged me

let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)
let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)
let s:this_dir = fnameescape(fnamemodify(expand('$MYVIMRC'), ':p:h'))

" Seriously how does this keep getting fucked up. omfg packpath is worse???
if has('unix')
  set runtimepath=~/.config/nvim,~/.local/share/nvim/site,$VIMRUNTIME,~/.config/nvim/after
  set packpath=~/.config/nvim,~/.local/share/nvim/site,$VIMRUNTIME,~/.config/nvim/after
else
  set runtimepath=$USERPROFILE\AppData\Local\nvim,$USERPROFILE\AppData\Local\nvim-data\site,$VIMRUNTIME,C:\Neovim\share\nvim-qt\runtime
  set packpath=~\AppData\Local\nvim,~\AppData\Local\nvim-data\site,$VIMRUNTIME,C:\Neovim\share\nvim-qt\runtime
endif

" How does this get set even when i'm in a terminal?
if exists('g:GuiLoaded') | exec 'source ' s:this_dir . '\ginit.vim' | endif
if has('unnamedplus') | set clipboard+=unnamed,unnamedplus | else | set clipboard+=unnamed | endif
set pastetoggle=<F9>   " fuck me this is what windows terminal uses for something
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
  set pumblend=20 winblend=20  " toggle transparency in the pum and windows
  try | set pyxversion=3 | catch /^Vim:E518:*/ | endtry
endif

" backups: {{{
" Protect changes between writes. Default values of updatecount
" (200 keystrokes) and updatetime (4 seconds) are fine
set swapfile undofile backupext='.bak'
set writebackup        " protect against crash-during-write
set nobackup           " but do not persist backup after successful write

" use rename-and-write-new method whenever safe. actually might go with yes
" its slower but idc
set backupcopy=yes
" patch required to honor double slash at end consolidate the writebackups -- they usually get deleted
if has('patch-8.1.0251') | let &backupdir=stdpath('config') . '/undodir//' | endif

" Gotta be honest this part was stolen almost entirely from arch!

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
if ! isdirectory(expand(&g:directory))
  silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if ! isdirectory(expand(&g:backupdir))
  silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if ! isdirectory(expand(&g:undodir))
  silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif

" Make shift-insert work like in Xterm
if has('gui_running')
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

set suffixes+=.aux,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.inx,.jpg,.log,.out,.png,.toc
set suffixes-=.h,.obj

set foldnestmax=10 foldmethod=marker foldcolumn=2 foldopen+=jump,insert
set signcolumn=auto:4  " this might be a nvim 4 thing
try | set switchbuf=useopen,usetab,split | catch | endtry
set splitbelow splitright
set sidescroll=5 hidden
set number relativenumber cmdheight=1
set isfname-==
set iskeyword=@,48-57,_,192-255   " Idk how but i managed to mess up the default isk

if filereadable(stdpath('config') . '/spell/en.utf-8.add')
  let &spellfile = stdpath('config') . '/spell/en.utf-8.add'
endif
" both smartcase and infercase require ignorecase to be set
set ignorecase
set smartcase infercase

set sessionoptions-=buffers,winsize viewoptions-=options sessionoptions+=globals
set mouse=a nojoinspaces autowrite autochdir modeline
if exists('&modelineexpr') | set modelineexpr | endif
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping

set diffopt=filler,context:0,hiddenoff,foldcolumn:2,icase,indent-heuristic,horizontal,iblank,iwhite
" TODO: closeoff needs to be added conditionally. how?
if has('patch-8.1.0360') | set diffopt+=internal,algorithm:patience | endif
set browsedir="buffer"   " which directory is used for the file browser

let &g:listchars = "tab:\u21e5\u00b7,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
" trail:\u2423 doesn't work with hack as font
let &g:fillchars = "stl:' ',stlnc:' ',vert:\u250b,fold:\u00b7,diff:'.'"

set breakindent breakindentopt=sbr
let &showbreak = '↳ '                   " Indent wrapped lines correctly
set updatetime=100 lazyredraw
set inccommand=split
set terse shortmess=aoOsItTWcF
set title titlestring=%<%F%=%l/%L-%P   " leaves a cool title for tmux
set conceallevel=2 concealcursor=nc    " enable concealing
set spellsuggest=5
set showmatch matchpairs+=<:> lazyredraw matchtime=20  " Show the matching pair for 2 seconds
let g:matchparen_timeout = 500
let g:matchparen_insert_timeout = 300
" Holy shit. I was reading through the verbose file and trust me you want
" these on separate lines
packadd justify
packadd cfilter
packadd matchit

if has('unix')
  let s:vim_plug = filereadable(fnameescape(stdpath('data') . '/site/autoload/plug.vim'))
else
  let s:vim_plug = filereadable(fnameescape(stdpath('data') . '\site\autoload\plug.vim'))
endif

if empty(s:vim_plug) && exists('*plugins#InstallPlug') | call plugins#InstallPlug() | endif

exec 'source ' s:this_dir . '/junegunn.vim'
" Don't assume that the InstallPlug() func worked so ensure it's defined
if empty('plugs') | let plugs = {} | endif

set termguicolors
set synmaxcol=1000

if exists('$ANDROID_DATA')  " Fuck i had to change this because wsl was loading termux jesus christ
  call find_files#termux_remote() | echomsg 'loaded termux'
elseif !has('unix')
  " Note: dude holy hell is it necessary to call the msdos#set_shell_cmd()
  " func. you do so in ./plugin/unix.vim but jesus christ did it fuck stuff up
  " when that got deleted
  call find_files#msdos_remote() | echomsg 'loaded msdos'
else
  call find_files#ubuntu_remote() | echomsg 'loaded wsl'
endif

