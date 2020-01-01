" ============================================================================
  " File: init.vim
  " Author: Faris Chugthai
  " Description: Neovim configuration
  " Last Modified: September 23, 2019
" ============================================================================

scriptencoding utf-8
set fileformat=unix fileformats=unix,dos  " don't let DOS fuck up the EOL
let s:cpo_save = &cpoptions
set cpoptions-=C
setglobal cpoptions-=c,e,_  " couple options that bugged me

let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)
let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

if !empty('s:termux') | call find_files#termux_remote() | elseif !has('unix')
  | call find_files#msdos_remote() | else | call find_files#ubuntu_remote() | endif

set synmaxcol=400 termguicolors  " Set up the colorscheme
syntax sync fromstart linebreaks=2

" So loading plugins almost immediately is definitely the best way to go
let s:vim_plug = filereadable(glob(fnameescape(stdpath('data') . '/site/autoload/plug.vim')))
if empty(s:vim_plug) && exists('*plugins#InstallPlug') | call plugins#InstallPlug() | endif
runtime junegunn.vim  " Load my plugins.

" Don't assume that the InstallPlug() func worked so ensure it's defined
if empty('plugs') | let plugs = {} | endif

let s:material_gruvbox =  syncom#gruvbox_material()
if s:material_gruvbox == v:false | call syncom#gruvbox() | endif

" Set shell correctly. TODO: do i still need this?
" if !has('unix') | runtime autoload/msdos.vim | call msdos#Cmd() | endif
if has('unnamedplus') | set clipboard+=unnamed,unnamedplus | else | set clipboard+=unnamed | endif

set pastetoggle=<F3>   " fuck me this is what windows terminal uses for something
let g:loaded_vimballPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1

noremap <Space> <nop>
let g:maplocalleader = '<Space>'
map <Space> <Leader>

if has('nvim-0.4')   " Fun new features!
  let &shadafile = stdpath('data') . '/shada/main.shada'
  " toggle transparency in the pum and windows. don't set higher than 10 it becomes hard to read higher than that
  set pumblend=10 winblend=10
  try | set pyxversion=3 | catch /^Vim:E518:*/ | endtry
endif

" Protect changes between writes. Default values of updatecount
" (200 keystrokes) and updatetime (4 seconds) are fine
set swapfile undofile backupext='.bak'
set writebackup        " protect against crash-during-write
set nobackup           " but do not persist backup after successful write
set backupcopy=auto    " use rename-and-write-new method whenever safe
" patch required to honor double slash at end consolidate the writebackups -- they usually get deleted
if has('patch-8.1.0251') | let &backupdir=stdpath('config') . '/undodir//' | endif

set foldnestmax=10 foldmethod=marker foldcolumn=2 foldopen+=jump,insert
set signcolumn=auto:2  " this might be a nvim 4 thing
try | set switchbuf=useopen,usetab,split | catch | endtry
set splitbelow splitright sidescroll=5 hidden
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

set diffopt=filler,context:0,hiddenoff,foldcolumn:2,icase,indent-heuristic,horizontal
if has('patch-8.1.0360') | set diffopt+=internal,algorithm:patience | endif
set browsedir="buffer"   " which directory is used for the file browser
let &g:listchars = "tab:\u21e5\u00b7,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
" trail:\u2423 doesn't work with hack as font
let &g:fillchars = "stl:' ',stlnc:' ',vert:\u250b,fold:\u00b7,diff:'.'"

set breakindent breakindentopt=sbr
let &showbreak = '↳ '                   " Indent wrapped lines correctly
set updatetime=100 lazyredraw
set inccommand=split
set terse shortmess=aoOsAItTWAcF
set title titlestring=%<%F%=%l/%L-%P   " leaves a cool title for tmux
set conceallevel=2 concealcursor=nc    " enable concealing
nnoremap q; q:
nnoremap Q @q
xnoremap <BS> d
set spelllang=en spellsuggest=5
nnoremap <Leader>sp <Cmd>setlocal spell!<CR>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

set showmatch matchpairs+=<:> lazyredraw matchtime=20  " Show the matching pair for 2 seconds
let g:matchparen_timeout = 500
let g:matchparen_insert_timeout = 300
packadd justify cfilter matchit  " Add some packages

let &cpoptions = s:cpo_save
unlet s:cpo_save
