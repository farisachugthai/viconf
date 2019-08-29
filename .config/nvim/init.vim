" Neovim Configuration:
" Maintainer: Faris Chugthai
" Last Change: Aug 24, 2019

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

runtime junegunn.vim 
" Don't assume that the InstallPlug() func worked so ensure it's defined
if empty('plugs') | let plugs = {} | endif
" Uh I don't know how this happens but stdpath('config') is no longer the first entry in rtp?
" So let's move that and stdpath('data')/site up front. Definitely stays after the plugins definition.
let &rtp = stdpath('config') . ',' . stdpath('data') . '/site,' . &rtp

" Global Options: {{{1
runtime remote.vim

if !has('unix') | runtime autoload/msdos.vim | endif
set synmaxcol=400                       " Lower max syntax highlighting
syntax sync fromstart

function! Gruvbox() abort
  " Define Gruvbox parameters and then set the colorscheme.
  let g:gruvbox_contrast_hard = 1
  let g:gruvbox_contrast_soft = 0
  let g:gruvbox_improved_strings = 1
  let g:gruvbox_italic = 1
  colorscheme gruvbox
endfunction
call Gruvbox()

if &term =~# 'xterm-256color' || &term ==# 'cygwin' || &term ==# 'builtin_tmux'
      \ || &term ==# 'tmux-256color' || &term ==# 'builtin-vtpcon' || &term==# 'screen-256color'
  set termguicolors
endif

let g:loaded_vimballPlugin     = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1

noremap <Space> <nop>
let g:maplocalleader = '<Space>'
map <Space> <Leader>

if has('nvim-0.4')   " Fun new features!
  set wildoptions+=pum   " Insert mode style completion...in Ex mode holy fuck
  let &shadafile = stdpath('data') . '/shada/main.shada'
  set pumblend=80   " toggle transparency in the pum
  try | set pyxversion=3 | catch /^Vim:E518:*/ | endtry
endif

" Protect changes between writes. Default values of updatecount
" (200 keystrokes) and updatetime (4 seconds) are fine
set swapfile undofile
" persist the undo tree for each file
let &undodir = stdpath('config') . '/undodir'
set backupext='.bak'
set writebackup        " protect against crash-during-write
set nobackup           " but do not persist backup after successful write
set backupcopy=auto    " use rename-and-write-new method whenever safe
" patch required to honor double slash at end
if has('patch-8.1.0251')
	" consolidate the writebackups -- they usually get deleted
  let &backupdir=stdpath('config') . '/undodir//'
end

if &tabstop > 4 | set tabstop=4 | endif
if &shiftwidth > 4  | set shiftwidth=4 | endif
set expandtab smarttab      " On pressing tab, insert 4 spaces
set softtabstop=4
set foldenable
set foldlevelstart=0 foldlevel=0 foldnestmax=10 foldmethod=marker foldcolumn=2
set signcolumn=yes
try | set switchbuf=useopen,usetab,newtab | catch | endtry
set hidden
set splitbelow splitright
set winfixheight winfixwidth
if &textwidth!=0 | setl colorcolumn=+1 | else | setl colorcolumn=80 | endif
set cmdheight=2
set number relativenumber
set spelllang=en spellsuggest=5

if filereadable(stdpath('config') . '/spell/en.utf-8.add')
  let &spellfile = stdpath('config') . '/spell/en.utf-8.add'
endif

set wildmode=full:list:longest,full:list
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
let &wildoptions.='tagfile'
set complete+=kspell
" Create a preview window and display all possibilities but don't insert
set completeopt=menu,menuone,noselect,noinsert,preview
" don't show more than 15 choices in the popup menu. defaults to 0
set pumheight=15
" both smartcase and infercase require ignorecase to be set
set ignorecase
set smartcase infercase

set path+=**               " Recursively search dirs with :find
let &path = &path . ',' . stdpath('config')
let &path = &path . ',' . expand('$VIMRUNTIME')

set makeencoding=char         " Used by the makeprg. system locale is used
set sessionoptions+=unix,slash viewoptions+=unix,slash
set sessionoptions-=buffers,winsize viewoptions-=options
if &formatexpr ==# ''
  setlocal formatexpr=format#Format()  " check the autoload directory
endif
set tags+=./tags,./*/tags
set tagcase=smart showfulltag
set mouse=a
set autowrite autochdir
set wildignorecase
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
set nojoinspaces
" Filler lines to keep text synced, 3 lines of context on diffs, don't diff hidden files,default foldcolumn is 2
set diffopt=filler,context:0,hiddenoff,foldcolumn:2,icase,iwhite,indent-heuristic
 if has('patch-8.1.0360') | set diffopt+=internal,algorithm:patience | endif

set modeline
if exists('modelineexpr') | set modelineexpr | endif
set browsedir="buffer"   " which directory is used for the file browser
let &showbreak = '↳ '                   " Indent wrapped lines correctly
set breakindent breakindentopt=sbr
set updatetime=100
set inccommand=split
let g:tutor_debug = 1
set terse     " Don't display the message when a search hits the end of file
set shortmess=aoOsAItTWAc
set sidescroll=5                       " Didn't realize the default is 1

set title titlestring=%<%F%=%l/%L-%P   " leaves a cool title for tmux

" Mappings: {{{1
noremap q; q:
noremap Q @q
vnoremap <BS> d
" Save a file as root
noremap <Leader>W <Cmd>w !sudo tee % > /dev/null<CR>
noremap <Leader>sp <Cmd>setlocal spell!<CR>

noremap <Leader>o o<Esc>
noremap <Leader>O O<Esc>
vnoremap < <gv
vnoremap > >gv
" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
" Help docs reminded me I hadn't done this!
noremap <Up> gk
noremap <Down> gj
" I mess this up constantly thinking that gI does what gi does
inoremap gI gi
" Avoid accidental hits of <F1> while aiming for <Esc>
noremap! <F1> <Esc>
" Dude read over :he getcharsearch(). Now ; and , search forward backward no matter what!!!
noremap <expr> ; getcharsearch().forward ? ';' : ','
noremap <expr> , getcharsearch().forward ? ',' : ';'

runtime macros/matchit.vim
set showmatch matchpairs+=<:>
set matchtime=20  " Show the matching pair for 2 seconds
let g:matchparen_timeout = 500
let g:matchparen_insert_timeout = 300

if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
