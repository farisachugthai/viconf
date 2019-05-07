" Neovim Configuration:
" Maintainer: Faris Chugthai
" Last Change: Apr 16, 2019
scriptencoding utf-8

" Preliminaries: {{{1

" OS Setup: {{{2

" Termux check from Evervim. Thanks!
let g:termux = isdirectory('/data/data/com.termux')
let g:ubuntu = has('unix') && !has('macunix')
" This got moved up so we can check what OS we have and decide what options
" to set from there
" how the literal fuck is `has('win32')` a nvim specific thing.
" Just tried it in vim and it didn't work!!
let g:windows = has('win32') || has('win64')
let g:wsl = has('wsl')   " The fact that this is a thing blows my mind

" unabashedly stolen from junegunn dude is too good.
let g:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/init.vim.local'
if filereadable(g:local_vimrc)
    execute 'source' g:local_vimrc
endif

if g:windows

    " How do i check if I'm on cmd or powershell?
    " Awh fuck I just thought about the fact that I have powershell installed on Linux too :/
    " set shell=powershell shellquote=( shellpipe=\| shellredir=> shellxquote=
    " set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
endif

" XDG Check: {{{2
" The whole file is now predicated on these existing. Need to add checks in.
" In $VIMRUNTIME/filetype.vim it looks like Bram himself checks env vars this way
if empty('$XDG_DATA_HOME')
  " May 07, 2019: Just realized you could set these. :facepalm:
  if empty(g:windows)
    let $XDG_DATA_HOME = expand('~/.local/share')
  else
    let $XDG_DATA_HOME = expand('~/AppData/Local')
  endif
endif

if empty('$XDG_CONFIG_HOME')
  if empty(g:windows)
    let $XDG_CONFIG_HOME = expand('~/.config')
  else
    let $XDG_CONFIG_HOME = expand('~/AppData/Local')
  endif
endif

" $_ROOT: {{{2
" The below is an env var set as a convenient bridge between Ubuntu and Termux
" As a result it messes things up if not set, but there's no reason to halt
" everything. Feel free to discard if you copy/paste my vimrc

if !exists('$_ROOT') && expand(g:termux) == 1
    let $_ROOT = expand('$PREFIX')
elseif !exists('$_ROOT') && expand(g:ubuntu) == 1
    let $_ROOT = '/usr'
endif

" Remote Hosts: {{{2
    " Set the node and ruby remote hosts

if g:termux
    " holy fuck that was a doozy to find
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'

    if filereadable(expand($_ROOT) . 'lib/ruby/gems/2.6.3/gems/neovim-0.8.0/exe/neovim-ruby-host')
        let g:ruby_host_prog = expand($_ROOT) . 'lib/ruby/gems/2.6.3/gems/neovim-0.8.0/exe/neovim-ruby-host'
    elseif filereadable(expand('$_ROOT') . 'bin/neovim-ruby-host')
        let g:ruby_host_prog = expand('$_ROOT') . 'bin/neovim-ruby-host'
    endif

elseif g:ubuntu
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'

    if executable('rvm')
        let g:ruby_host_prog = 'rvm system do neovim-ruby-host'
    elseif filereadable(expand('$_ROOT') . '/local/bin/neovim-ruby-host')
        let g:ruby_host_prog = expand('$_ROOT') . '/local/bin/neovim-ruby-host'
    elseif filereadable('~/.local/bin/neovim-ruby-host')
        let g:ruby_host_prog = '~/.local/bin/neovim-ruby-host'
    endif

elseif g:windows
  if filereadable(expand('$XDG_DATA_HOME') . '/Yarn/Data/global/node_modules/.bin/neovim-node-host.cmd')
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/Yarn/Data/global/node_modules/.bin/neovim-node-host.cmd'
  endif

endif

" Python Executables: {{{2

" If we have a virtual env start there
if exists('$VIRTUAL_ENV')
    let g:python3_host_prog = expand('$VIRTUAL_ENV') . '/bin/python'
    let &path = &path . ',' . expand('$VIRTUAL_ENV') . '/lib/python3'

" Or a conda env. Not trying to ruin your day here but Windows sets a var
" '$CONDA_PREFIX_1' if CONDA_SHLVL > 1....
elseif exists('$CONDA_PREFIX')
    " Needs to use CONDA_PREFIX as the other env vars conda sets will only establish the base env not the current one
    let g:python3_host_prog = expand('$CONDA_PREFIX/bin/python3')
    " Let's hope I don't break things for Windows
    let &path = &path . ',' . expand('$CONDA_PREFIX/lib/python3')

else
    " If not then just use the system python
    if executable(expand('$_ROOT') . '/bin/python3')
        let g:python3_host_prog = expand('$_ROOT') . '/bin/python3'
        let &path = &path . ',' . expand('$_ROOT') . '/lib/python3'

    " well that's if we can find it anyway
    elseif executable('/usr/bin/python3')
        let g:python3_host_prog = '/usr/bin/python3'
        let &path = &path . ',' . '/usr/lib/python3'
    endif
endif

" Also add a python2 remote host
if executable(expand('$_ROOT') . '/bin/python2')
    let g:python_host_prog = expand('$_ROOT') . '/bin/python2'
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python2'
elseif executable('/usr/bin/python2')
    let g:python3_host_prog = '/usr/bin/python2'
    let &path = &path . ',' . '/usr/lib/python2'
else
    let g:loaded_python_provider = 1
endif

" Vim Plug: {{{1

" Plug Check: {{{2
" https://github.com/justinmk/config/blob/291ec0ae12b0b4b35b4cf9315f1878db00b780ec/.config/nvim/init.vim#L12
let s:plugins = filereadable(expand('$XDG_DATA_HOME/nvim/site/autoload/plug.vim', 1))

if !s:plugins
  " bootstrap plug.vim on new systems
  function! s:InstallPlug()
    try
      execute '!curl -fLo --create-dirs ' . expand('$XDG_DATA_HOME/nvim/site/autoload/plug.vim', 1) . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    catch
      echo v:exception
    endtry
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endfunction
endif

" General Plugins: {{{2

call plug#begin(expand('$XDG_DATA_HOME') . '/nvim/plugged')

Plug 'junegunn/vim-plug'        " plugception
let g:plug_window = 'tabe'
" Wait is the fact that I didn't use expand the reason FZF hasn't been working?
Plug 'junegunn/fzf', { 'dir': expand('~/.fzf'), 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
Plug 'davidhalter/jedi-vim', {'for': ['rst', 'python'] }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
if empty(g:windows)
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif

if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
Plug 'greyblake/vim-preview'
Plug 'lifepillar/vim-cheat40'
Plug 'luffah/vim-zim', {'for': ['zimwiki', 'zimindex']}
Plug 'tomtom/tlib_vim'  " this library is incredible

" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time

if !g:termux
    Plug 'autozimu/LanguageClient-neovim', {'do': ':UpdateRemotePlugins'}
    Plug 'godlygeek/tabular'
    Plug 'vim-voom/voom'
    Plug 'Rykka/InstantRst', {'for': 'rst'}
    Plug 'gu-fan/riv.vim', {'for': 'rst'}
    Plug 'junegunn/vim-peekaboo'
    Plug 'tpope/vim-surround'
    Plug 'mbbill/undotree'
    Plug 'chrisbra/csv.vim', {'for': 'csv'}
    Plug 'omnisharp/omnisharp-vim', {'for': 'cs'}
    Plug 'neoclide/coc.nvim'
    Plug 'ervandew/supertab'
endif

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Global Options: {{{1

" Get this going as soon as possible
runtime! plugin/**/*.vim

" Idk if this is necessary. *shrugs*
filetype plugin indent on
" Leader And Viminfo: {{{2
noremap <Space> <nop>
map <Space> <Leader>
let g:maplocalleader = '<Space>'

if has('nvim-0.4')
    let &shadafile = expand('$XDG_DATA_HOME') . '/nvim/shada/main.shada'

  try
    set pyx=3
  catch /^Vim:E518:*/
  endtry
    " Damnit it happened AGAIN.
else
   set shada+=n$XDG_DATA_HOME/nvim/shada/main.shada
endif

" Pep8 Global Options: {{{2
if &tabstop > 4
    set tabstop=4           " show existing tab with 4 spaces width
endif
if &shiftwidth > 4
    set shiftwidth=4        " when indenting with '>', use 4 spaces width
endif
set expandtab smarttab      " On pressing tab, insert 4 spaces
set softtabstop=4
let g:python_highlight_all = 1

" Folds: {{{2
set foldenable
set foldlevelstart=0
set foldlevel=0
set foldnestmax=10
set foldmethod=marker
" Use 1 column to indicate fold level and whether a fold is open or closed.
" Trade off for valuable window real estate though....
set foldcolumn=1

" Buffers Windows Tabs: {{{2
try
    set switchbuf=useopen,usetab,newtab
catch
endtry

set hidden
set splitbelow splitright

" Spell Checker: {{{2
set spelllang=en

if filereadable(expand('$XDG_CONFIG_HOME') . '/nvim/spell/en.utf-8.add')
    let &spellfile = expand('$XDG_CONFIG_HOME') . '/nvim/spell/en.utf-8.add'

elseif filereadable(expand('~/projects/viconf/.config/nvim/spell/en.utf-8.add'))
    let &spellfile = expand('$HOME') . '/projects/viconf/.config/nvim/spell/en.utf-8.add'
endif

set spellsuggest=5                      " Limit the number of suggestions from 'spell suggest'

if filereadable('/usr/share/dict/words')
    set dictionary+=/usr/share/dict/words
    " Replace the default dictionary completion with fzf-based fuzzy completion
    " Courtesy of fzf <3 vim.
    inoremap <expr> <C-x><C-k> fzf#vim#complete('cat /usr/share/dict/words')
endif

if filereadable('/usr/share/dict/american-english')
    set dictionary+=/usr/share/dict/american-english
endif

" Fun With Clipboards: {{{2

" I've been using vim for almost 3 years. I still don't have copy paste ironed out...
if exists('$TMUX')
    let g:clipboard = {
        \   'name': 'myClipboard',
        \   'copy': {
        \      '+': 'tmux load-buffer -',
        \      '*': 'tmux load-buffer -',
        \    },
        \   'paste': {
        \      '+': 'tmux save-buffer -',
        \      '*': 'tmux save-buffer -',
        \   },
        \   'cache_enabled': 1,
        \ }

    " Double check if we need to do this but sometimes the clipboard fries when set this way
	runtime autoload/provider/clipboard.vim

elseif has('unnamedplus')                   " Use the system clipboard.
    set clipboard+=unnamed,unnamedplus
else                                        " Accommodate Termux
    set clipboard+=unnamed
endif

set pastetoggle=<F7>

" Autocompletion: {{{2

set wildmenu
set wildmode=longest,list:longest       " Longest string or list alternatives
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp

" A list of words that change how command line completion is done.
" Currently only one word is allowed: tagfile
set wildoptions=tagfile
setlocal suffixesadd=*.vim

set complete+=kspell                    " Autocomplete in insert mode
set completeopt=menu,menuone,noselect,noinsert,preview
" Path: {{{2

" DON'T USE LET. LET ALLOWS FOR EXPRESSION EVALUATION. MUST BE DONE WITH SET
" OR THE ** WILL EXPAND {rendering it as nothing}
set path+=**                            " Recursively search dirs with :find

" TODO: Come up with a function that checks if i a directory exists and then
" adds to path. also come up with another that checks if a  file exists and
" return a bool because man is it annoying to do that as is
" function! s:pathadder() abort
"     if is
" double check syntax on adding parameters

if isdirectory(expand('$_ROOT/local/include/'))
    let &path = &path . ',' . expand('$_ROOT/local/include')
endif

if isdirectory(expand('$_ROOT') . '/include/libcs50')
    let &path = &path .','. expand('$_ROOT') . '/include/libcs50'
endif

let &path = &path . ',' . expand('$VIMRUNTIME/*')

" Write Once Debug Everywhere: {{{2

" The following are options set in order to promote one plug and play configuration
" regardless of unix/windows/android etc
set sessionoptions+=unix,slash

if exists('+shellslash')   " don't drop the +!
  set shellslash
endif


if &term =~ 'xterm-256color' || &term ==# 'cygwin'
" mintty identifies itself as xterm-compatible
" Yeah mintty does. Conemu/Cmder identify as cygwin sooo. we get ansi colors
  set termguicolors
endif

" Other Global Options: {{{2

if &formatexpr ==# ''
  setlocal formatexpr=format#Format()
endif

set tags+=./tags,./*/tags
set tags+=~/projects/**/tags
" set tagcase=smartcase

set mouse=a

if &textwidth!=0
    setl colorcolumn=+1
else
    setl colorcolumn=80
endif

set cmdheight=2
set number relativenumber
set smartcase infercase
" FOOBAR=~/<CTRL-><CTRL-F> will now autocomplete!
set isfname-==

set autochdir
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
set nojoinspaces
" Filler lines to keep text synced, 3 lines of context on diffs, don't diff hidden files,default foldcolumn is 2
set diffopt=filler,context:3,hiddenoff,foldcolumn:1

let &undodir = expand('$XDG_CONFIG_HOME') . '/nvim/undodir'
set undofile

set backup
let &backupdir=expand('$XDG_CONFIG_HOME') . '/nvim/undodir'
set backupext='.bak'        " like wth is that ~ nonsense?
" Directory won't need to be set because it defaults to
" xdg_data_home/nvim/swap

set modeline
set browsedir="buffer"                  " which directory is used for the file browser

let &showbreak = '↳ '                   " Indent wrapped lines correctly
set breakindent
set breakindentopt=sbr

set updatetime=100

" 3 options below are nvim specific.
set inccommand=split
let g:tutor_debug = 1

" When set: Add 's' flag to 'shortmess' option (this makes the message
" for a search that hits the start or end of the file not being displayed)
set terse

" Mappings: {{{1

" General_Mappings: {{{2
" Todo: map this to a key in a manner similar to unimpaired
" setlocal comments=:# commentstring=#\ %s formatoptions-=t formatoptions+=croql

if g:termux
    noremap <silent> <Leader>ts <Cmd>!termux-share -a send %<CR>
endif

" Switch CWD to the directory of the open buffer
noremap <Leader>cd <Cmd>cd %:p:h<CR><Cmd>pwd<CR>

" Backspace in Visual mode deletes selection
vnoremap <BS> d

noremap <Leader>cd <Cmd>cd %:p:h<CR><Cmd>pwd<CR>

" Save a file as root
noremap <Leader>W <Cmd>w !sudo tee % > /dev/null<CR>

noremap <Leader>sp <Cmd>setlocal spell!<CR>
noremap <Leader>s= z=

" ALT Navigation: {{{2
" Originally this inspired primarily for terminal use but why not put it everywhere?
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l
noremap! <A-h> <C-w>h
noremap! <A-j> <C-w>j
noremap! <A-k> <C-w>k
noremap! <A-l> <C-w>l

" Junegunn: {{{2
noremap <Leader>o o<Esc>
noremap <Leader>O O<Esc>
vnoremap < <gv
vnoremap > >gv
" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
noremap <C-]> g<C-]>

" Runtime: {{{1

" Matching Parenthesis: {{{2

runtime macros/matchit.vim

set showmatch
set matchpairs+=<:>
" Show the matching pair for 2 seconds
set matchtime=20

" From pi_paren.txt
" Matching parenthesises are highlighted A timeout of 300 msec (60 msec in Insert mode). This can be changed with the
let g:matchparen_timeout = 500
" and
let g:matchparen_insert_timeout = 300
" variables and their buffer-local equivalents b:matchparen_timeout and b:matchparen_insert_timeout.

" Builtin Plugins: {{{2
" To every plugin I've never used before. Stop slowing me down.
let g:loaded_vimballPlugin     = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1

" Filetype Specific Options: {{{2

if &filetype ==# 'c'
    set makeprg=make\ %<.o
endif

" Noticed this bit in he syntax line 2800
let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heregoc folding)

" he rst.vim or ft-rst-syntax or syntax 2600. Don't put bash instead of sh.
" $VIMRUNTIME/syntax/rst.vim iterates over this var and if it can't find a
" bash.vim syntax file it will crash.
let rst_syntax_code_list = ['vim', 'python', 'sh', 'markdown', 'lisp']

" highlighting readline options
let readline_has_bash = 1

" from runtime/ftplugin/html.vim
let g:ft_html_autocomment = 1

" From `:he ft-lisp-syntax. Color parentheses differently up to 10 levels deep
let g:lisp_rainbow = 1

" From he syntax
" VIM			*vim.vim*		*ft-vim-syntax*
" 			*g:vimsyn_minlines*	*g:vimsyn_maxlines*
" Support embedded lua python nd ruby syntax highlighting in vim ftypes. No idea what your other options are.
   " GOT IT!
" Allows users to specify the type of embedded script highlighting
" they want:  (perl/python/ruby/tcl support)
"   g:vimsyn_embed == 0   : don't embed any scripts
"   g:vimsyn_embed =~# 'l' : embed lua
"   g:vimsyn_embed =~# 'm' : embed mzscheme
"   g:vimsyn_embed =~# 'p' : embed perl
"   g:vimsyn_embed =~# 'P' : embed python
"   g:vimsyn_embed =~# 'r' : embed ruby
"   g:vimsyn_embed =~# 't' : embed tcl
let g:vimsyn_embed = 'lmtPr'

" Turn off errors because 50% of them are wrong.
let g:vimsyn_noerror = 1

						" *g:vimsyn_folding*

" Some folding is now supported with syntax/vim.vim:

   " g:vimsyn_folding == 0 or doesn't exist: no syntax-based folding
   " g:vimsyn_folding =~ 'a' : augroups
   " g:vimsyn_folding =~ 'f' : fold functions
   " g:vimsyn_folding =~ 'P' : fold python   script

" Are we allowed to combine these?
let g:vimsyn_folding = 'afP'

let g:vimsyn_maxlines = 500  " why is the default 60???

" Omnifuncs: {{{3

augroup omnifunc
    autocmd!
    autocmd Filetype python,xonsh     setlocal completefunc=python3complete#Complete
    autocmd Filetype html,xhtml       setlocal completefunc=htmlcomplete#CompleteTags
    autocmd Filetype xml              setlocal completefunc=xmlcomplete#CompleteTags
    autocmd Filetype css              setlocal completefunc=csscomplete#CompleteCSS
    autocmd Filetype javascript       setlocal completefunc=javascriptcomplete#CompleteJS
    " If there isn't a default or built-in, use the syntax highlighter

    autocmd Filetype *
        \   if &omnifunc == "" |
        \       setlocal completefunc=syntaxcomplete#Complete |
        \   endif
augroup END

" Functions_Commands: {{{1

" Helptabs: {{{2
" I've pretty heavily modified this one but junegunn gets the initial credit.
function! g:Helptab()
    setlocal number relativenumber
    if len(nvim_list_wins()) > 1
        wincmd T
    endif

    setlocal nomodified
    setlocal buflisted
    " Complains that we can't modify any buffer. But its a local option so yes we can
    silent setlocal nomodifiable

    noremap <buffer> q <Cmd>q<CR>
    " Check the rplugin/python3/pydoc.py file
    noremap <buffer> P <Cmd>Pydoc<CR>
endfunction

augroup mantabs
    autocmd!
    autocmd Filetype man,help call g:Helptab()
augroup END

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
command! -nargs=1 -complete=help Help call g:Helptab()

" AutoSave: {{{2
" I feel like I need to put this in a autocmd but I'm not sure what I would
" want to trigger it.
" Even better would be if it called :Gwrite haha!
function! s:autosave(enable)
  augroup autosave
    autocmd!
    if a:enable
      autocmd TextChanged,InsertLeave <buffer>
            \  if empty(&buftype) && !empty(bufname(''))
            \|   silent! update
            \| endif
    endif
  augroup END
endfunction

command! -bang Autosave call s:autosave(<bang>1)

" Statusline: {{{2
" Apr 16, 2019: I wonder if Vim doesn't have the same statusline expressions as Neovim because literally half of these are builtin flags...

function! s:statusline_expr()

  let dicons = ' %{WebDevIconsGetFileTypeSymbol()} '
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  " let ro  = "%{&readonly ? '[RO] ' : ''}"
  " let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'
" %n is buffer #, %f is filename relative to $PWD, sep is right align
if exists('*CSV_WCol')
    let csv = '%1*%{&ft=~"csv" ? CSV_WCol() : ""}%*'
else
    let csv = ''
endif

  return '[%n] %f '. dicons . mod . '%r' . '%y' . fug . csv . sep.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()

" Except for...
augroup TermGroup
    autocmd!
    autocmd TermOpen * setlocal statusline=%{b:term_title}
    " `set nomodified` so Nvim stops prompting you when you
    " try to close a buftype==terminal buffer
    autocmd TermOpen * setlocal nomodified
augroup END

" TODO: Integrate this into the statusline I like what bram left us with a lot
" Show EOL type and last modified timestamp, right after the filename
" Set the statusline
" set statusline=%f               " filename relative to current $PWD
" set statusline+=%h              " help file flag
" set statusline+=%m              " modified flag
" set statusline+=%r              " readonly flag
" set statusline+=\ [%{&ff}]      " Fileformat [unix]/[dos] etc...
" set statusline+=\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})  " last modified timestamp
" set statusline+=%=              " Rest: right align
" set statusline+=%l,%c%V         " Position in buffer: linenumber, column, virtual column
" set statusline+=\ %P            " Position in buffer: Percentage

" Rename: {{{2
" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>

" Chmod: {{{2

"	:S	Escape special characters for use with a shell command (see
"		|shellescape()|). Must be the last one. Examples:
"		    :!dir <cfile>:S
"		    :call system('chmod +w -- ' . expand('%:S'))
" From :he filename-modifiers in the cmdline page.

command! -nargs=1 -complete=file Chmod call system('chmod +x ' . expand('%:S'))

" Could do word under cursor. Could tack it on to some fzf variation. idk

" General Syntax Highlighting: {{{2
" Lower max syntax highlighting
set synmaxcol=400

syntax sync fromstart

" Try to keep as close to the bottom of the file as possible
colorscheme gruvbox
let g:gruvbox_contrast_hard = 1
let g:gruvbox_contrast_soft = 0
let g:gruvbox_improved_strings = 1
let g:gruvbox_italic = 1

" Clear Hlsearch: {{{2

" TODO: Also this exits and clears the highlighting
" pattern as soon as you hit enter. So if you type a word, it'll highlight all
" matches. But once you hit enter to find the next one it clears. Hmmm.
set nohlsearch
augroup vimrc_incsearch_highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Plug: {{{2
" I utilize this command so often I may as well save the characters
command -nargs=0 Pl echo keys(plugs)
