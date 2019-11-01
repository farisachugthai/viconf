" ============================================================================
  " File: init.vim
  " Author: Faris Chugthai
  " Description: Neovim configuration
  " Last Modified: September 23, 2019
" ============================================================================

" Preliminaries: {{{1
scriptencoding utf-8
let s:cpo_save = &cpoptions
set cpoptions-=C

let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:wsl = !empty($WSL_DISTRO_NAME)
let s:ubuntu = has('unix') && !has('macunix') && empty(s:termux) && empty(s:wsl)

let s:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/init.vim.local'
runtime s:local_vimrc

" Vim Plug And Third Party Packages: {{{1

let s:vim_plug = filereadable(glob(fnameescape(stdpath('data') . '/site/autoload/plug.vim')))

if empty(s:vim_plug) && exists('*plugins#InstallPlug')
  call plugins#InstallPlug()
endif

" runtime junegunn.vim  " Load my plugins. 10/30/19 commented because in plugins
" Don't assume that the InstallPlug() func worked so ensure it's defined
if empty('plugs') | let plugs = {} | endif
" Uh I don't know how this happens but stdpath('config') is no longer the first entry in rtp?
" So let's move that and stdpath('data')/site up front. Definitely stays after the plugins definition.
let &rtp = stdpath('config') . ',' . stdpath('data') . '/site,' . &rtp

" Add some packages
packadd justify cfilter matchit

set synmaxcol=400 termguicolors  " Set up the colorscheme
syntax sync fromstart linebreaks=2

let s:material_gruvbox =  syncom#gruvbox_material()
if s:material_gruvbox == v:false | call syncom#gruvbox() | endif

" Setup neovim's python and node hosts. Optionally clipboards etc
" runtime remote.vim
" Set shell correctly
if !has('unix') | runtime autoload/msdos.vim | call msdos#Cmd() | endif

let g:loaded_vimballPlugin     = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1

noremap <Space> <nop>
let g:maplocalleader = '<Space>'
map <Space> <Leader>

if has('nvim-0.4')   " Fun new features!
  let &shadafile = stdpath('data') . '/shada/main.shada'
  set pumblend=20   " toggle transparency in the pum
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

if &tabstop > 4 | setlocal tabstop=4 | endif
if &shiftwidth > 4  | setlocal shiftwidth=4 | endif
setlocal expandtab smarttab softtabstop=4

set foldenable foldlevelstart=1 foldlevel=1
set foldnestmax=10 foldmethod=marker foldcolumn=2
set foldopen=quickfix,search,tag,undo,jump
set signcolumn=auto:2  " this might be a nvim 4 thing

try | set switchbuf=useopen,usetab,newtab | catch | endtry

set hidden
set splitbelow splitright sidescroll=5

if &textwidth!=0 | setl colorcolumn=+1 | else | setl colorcolumn=80 | endif

set number relativenumber cmdheight=1
set isfname-==
if filereadable(stdpath('config') . '/spell/en.utf-8.add')
  let &spellfile = stdpath('config') . '/spell/en.utf-8.add'
endif

set wildignorecase wildmode=full:list:longest,full:list
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
" C-n and C-p now use the same input that every other C-x does combined!
set complete+=kspell,d,k complete-=u,i

" Create a preview window and display all possibilities but don't insert
" dude what am i doing wrong that i don't get the cool autocompletion that NORC gets??
set completeopt=menu,menuone,noselect,noinsert,preview
" don't show more than 15 choices in the popup menu. defaults to 0
set pumheight=15

set completefunc=syntaxcomplete#Complete

" both smartcase and infercase require ignorecase to be set
set ignorecase
set smartcase infercase

set makeencoding=char         " Used by the makeprg. system locale is used
set sessionoptions-=buffers,winsize viewoptions-=options sessionoptions+=globals

set tags+=./tags,./*/tags
set tags^=./.git/tags tagcase=smart showfulltag

set mouse=a
set autowrite autochdir
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
set nojoinspaces

" Filler lines to keep text synced, 3 lines of context on diffs,
" don't diff hidden files,default foldcolumn is 2
set diffopt=filler,context:0,hiddenoff,foldcolumn:2,icase,iwhite,indent-heuristic
if has('patch-8.1.0360') | set diffopt+=internal,algorithm:patience | endif

set modeline
if exists('&modelineexpr') | set modelineexpr | endif

set browsedir="buffer"   " which directory is used for the file browser

let &g:listchars = "tab:\u21e5\u00b7,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"  " trail:\u2423 doesn't work with hack as font
let &g:fillchars = "vert:\u250b,fold:\u00b7"
set breakindent breakindentopt=sbr
let &showbreak = '↳ '                   " Indent wrapped lines correctly
set updatetime=100 lazyredraw
set inccommand=split
set terse shortmess=aoOsAItTWAcF
set title titlestring=%<%F%=%l/%L-%P   " leaves a cool title for tmux
set conceallevel=2 concealcursor=nc    " enable concealing

noremap q; q:
noremap Q @q
vnoremap <BS> d

set spelllang=en spellsuggest=5
noremap <Leader>sp <Cmd>setlocal spell!<CR>

noremap <Leader>o o<Esc>
noremap <Leader>O O<Esc>
vnoremap < <gv
vnoremap > >gv
" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
noremap <Up> gk
noremap <Down> gj
" I mess this up constantly thinking that gI does what gi does
inoremap gI gi

set showmatch matchpairs+=<:> lazyredraw
set matchtime=20  " Show the matching pair for 2 seconds
let g:matchparen_timeout = 500
let g:matchparen_insert_timeout = 300

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
