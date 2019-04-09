" Neovim Configuration:
" Maintainer: Faris Chugthai
" Last Change: Apr 02, 2019

" Preliminaries: {{{1

" XDG Check: {{{2
" The whole file is now predicated on these existing. Need to add checks in.
" In $VIMRUNTIME/filetype.vim it looks like Bram himself checks env vars this way
if empty('$XDG_DATA_HOME')
    echoerr 'XDG_DATA_HOME not set. Exiting'
    finish
endif

if empty('$XDG_CONFIG_HOME')
    echoerr 'XDG_CONFIG_HOME not set. Exiting.'
    finish
endif

" The below is an env var set as a convenient bridge between Ubuntu and Termux
" As a result it messes things up if not set, but there's no reason to halt
" everything. Feel free to discard if you copy/paste my vimrc
if empty('$_ROOT')
    echoerr '_ROOT env var not set'
endif


" OS Setup: {{{2

" This got moved up so we can check what OS we have and decide what options
" to set from there
let g:termux = exists('$PREFIX') && has('unix')
let g:ubuntu = !exists('$PREFIX') && has('unix')
let g:windows = has('win32') || has('win64')
" ^-- This feels dangerous but I'll let it slide.

let g:winrc = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/winrc.vim'
if g:windows && filereadable(g:winrc)
    execute 'source' g:winrc
endif

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

" Session Options: {{{3
" From :he options
" 'slash' and 'unix' are useful on Windows when sharing session files
" with Unix.  The Unix version of Vim cannot source dos format scripts,
" but the Windows version of Vim can source unix format scripts.
set sessionoptions+=unix,slash

" Remote Hosts: {{{2
" Set the node and ruby remote hosts

if g:termux
    " holy fuck that was a doozy to find
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'
    let g:ruby_host_prog = expand($_ROOT) . '/bin/neovim-ruby-host'

elseif g:ubuntu
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'
    " So the one above could very easily be merged. No idea how to do the
    " below unless I just leave it up to the system.
    try
        let g:ruby_host_prog = expand('~') . '/.rvm/gems/default/bin/neovim-ruby-host'
    catch
        let g:ruby_host_prog = expand('$_ROOT') . '/local/bin/neovim-ruby-host'
    endtry

endif

" Python Executables: {{{2

" if we have a virtual env start there
if exists('$VIRTUAL_ENV')
    let g:python3_host_prog = expand('$VIRTUAL_ENV') . '/bin/python'
    let &path = &path . ',' . expand('$VIRTUAL_ENV') . '/lib/python3'

" or a conda env.
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
" Shout out Justinmk!
" https://github.com/justinmk/config/blob/291ec0ae12b0b4b35b4cf9315f1878db00b780ec/.config/nvim/init.vim#L12
let s:plugins = filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim', 1))

if expand('OS') !=# 'Windows_NT'
    if !s:plugins
        " bootstrap plug.vim on new systems
        fun! InstallPlug()
            silent call mkdir(expand('~/.local/share/nvim/site/autoload', 1), 'p')
            execute '!curl -fLo ' . expand('~/.local/share/nvim/site/autoload/plug.vim', 1) . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      endfun
    endif
endif


" General Plugins: {{{2
call plug#begin(expand($XDG_DATA_HOME) . '/nvim/plugged')

Plug 'junegunn/vim-plug'        " plugception
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
Plug 'davidhalter/jedi-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'         " Lighter version of NERDCom since i don't use most features anyway
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips'

if exists('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'greyblake/vim-preview'
Plug 'lifepillar/vim-cheat40'

" It's very frustrating having termux slow down beyond repair but also frustrating
" not being able to use more than 15 plugins at any point in time
if !g:termux
    Plug 'autozimu/LanguageClient-neovim'
    Plug 'godlygeek/tabular'
    Plug 'vim-voom/voom'
    Plug 'Rykka/InstantRst'
    Plug 'gu-fan/riv.vim'
    Plug 'junegunn/vim-peekaboo'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    " Plug 'mbbill/undotree'    " not yet but soon
endif

Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Global Options: {{{1

" Leader And Viminfo: {{{2
noremap <Space> <nop>
map <Space> <Leader>
let g:maplocalleader = '<Space>'

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
    let &spellfile=expand('$XDG_CONFIG_HOME') . '/nvim/spell/en.utf-8.add'

elseif filereadable(expand('~/projects/viconf/.config/nvim/spell/en.utf-8.add'))
    let &spellfile=expand('$HOME') . '/projects/viconf/.config/nvim/spell/en.utf-8.add'
endif

set complete+=kspell                    " Autocomplete in insert mode
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

if isdirectory(expand('$_ROOT') . '/lib/python3')
    " Double check globbing in vim
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python3'
endif

if isdirectory(expand('~/.local/lib/python3.7'))
    " Double check globbing in vim
    let &path = &path . ',' . expand('~') . '/.local/lib/python3.7'
endif

" TODO: How do we glob in vimscript? There's some weird thing about using * and ** right?
" if isdirectory(expand('$_ROOT/lib/python3'))

" endif

" Other Global Options: {{{2

scriptencoding utf-8
set tags+=./tags,./*/tags
set tags+=~/projects/tags
set mouse=a
if &textwidth!=0
    setl colorcolumn=+1
else
    setl colorcolumn=80
endif
set cmdheight=2
set number relativenumber
set smartcase
set infercase
" FOOBAR=~/<CTRL-><CTRL-F> will now autocomplete!
set isfname-==

set autochdir
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
set nojoinspaces
set diffopt=filler,context:3
" vertical split d: Recent modifications from jupyter nteractiffs. def cont is 6

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

set inccommand=split
set termguicolors

let g:tutor_debug = 1

" Mappings: {{{1

" Window_Buf_Tab_Mappings: {{{2

" Navigate windows more easily
noremap <C-h> <Cmd>wincmd h<CR>
noremap <C-j> <Cmd>wincmd j<CR>
noremap <C-k> <Cmd>wincmd k<CR>
noremap <C-l> <Cmd>wincmd l<CR>

" Resize them more easily. Finish more later. TODO
noremap <C-w>< <Cmd>wincmd 5<<CR>
noremap <C-w>> <Cmd>wincmd 5><CR>

" Navigate buffers more easily
noremap <Leader>bn <Cmd>bnext<CR>
noremap <Leader>bp <Cmd>bprev<CR>
noremap <Leader>bl <Cmd>blast<CR>
noremap <Leader>bf <Cmd>bfirst<CR>
noremap <Leader>bd <Cmd>bdelete<CR>
noremap <Leader>bo <Cmd>bonly<CR>


" Wanna navigate windows more easily?
" |CTRL-W_gF|   CTRL-W g F     edit file name under the cursor in a new
"                  tab page and jump to the line number
"                  following the file name.
"
" Rebind that to C-w t and we can open the filename in a new tab.

" Navigate tabs more easily. First check we have more than 1 tho.
if len(nvim_list_tabpages()) > 1
    noremap <A-Right>  <Cmd>tabnext<CR>
    noremap <A-Left>   <Cmd>tabprev<CR>
    noremap! <A-Right> <Cmd>tabnext<CR>
    noremap! <A-Left>  <Cmd>tabprev<CR>
elseif len(nvim_list_wins()) > 1
    noremap <A-Right>  <Cmd>wincmd l<CR>
    noremap <A-Left>   <Cmd>wincmd h<CR>
    noremap! <A-Right> <Cmd>wincmd l<CR>
    noremap! <A-Left>  <Cmd>wincmd h<CR>
endif

nnoremap <Leader>tn <Cmd>tabnext<CR>
nnoremap <Leader>tp <Cmd>tabprev<CR>
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <Leader>te <Cmd>tabedit <c-r>=expand("%:p:h")<CR>
nnoremap <Leader>tq <Cmd>tabclose<CR>

" It should also be easier to edit the config. Bind similarly to tmux
nnoremap <Leader>ed <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

noremap <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>
" Don't forget to add in mappings when in insert/cmd mode
noremap! <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

" Now reload it
noremap <Leader>re <Cmd>so $MYVIMRC<CR><Cmd>echo 'Vimrc reloaded!'<CR>

" I feel really slick for this one. Modify ftplugin
" let g:ftplug=$MYVIMRC.'/after/ftplugin/'.&filetype.'.vim'
" Goddamnit it opens a buffernnamed g:ftplug
" map <F10> <Cmd>e g:ftplug<CR>

" General_Mappings: {{{2

if g:termux
    noremap <silent> <Leader>ts <Cmd>!termux-share -a send %<CR>
endif

" Junegunn:
noremap <Leader>o o<Esc>
noremap <Leader>O O<Esc>
vnoremap < <gv
vnoremap > >gv
" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
noremap <C-]> g<C-]>

" Switch CWD to the directory of the open buffer
noremap <Leader>cd <Cmd>cd %:p:h<CR><Cmd>pwd<CR>

" backspace in Visual mode deletes selection
vnoremap <BS> d

" Mouse Maps: {{{3
noremap <silent> <ScrollWheelUp> <C-Y>
noremap <silent> <S-ScrollWheelUp> <C-U>
noremap <silent> <ScrollWheelDown> <C-E>
noremap <silent> <S-ScrollWheelDown> <C-D>
noremap! <silent> <ScrollWheelUp> <C-Y>
noremap! <silent> <S-ScrollWheelUp> <C-U>
noremap! <silent> <ScrollWheelDown> <C-E>
noremap! <silent> <S-ScrollWheelDown> <C-D>

" Save a file as root
noremap <leader>W <Cmd>w !sudo tee % > /dev/null<CR>

" Spell Checking:
noremap <Leader>sp <Cmd>setlocal spell!<CR>
noremap <Leader>s= z=

" ALT Navigation: {{{3
" Originally this inspired primarily for terminal use but why not put it everywhere?
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l
noremap! <A-h> <C-w>h
noremap! <A-j> <C-w>j
noremap! <A-k> <C-w>k
noremap! <A-l> <C-w>l

" Terminal: {{{2
" If running a terminal in Vim, go into Normal mode with Esc
tnoremap <Esc> <C-\><C-n>
" From he term. Alt-R is better because this causes us to lose C-r in every
" command we run from nvim
tnoremap <expr> <A-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
" From :he terminal
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

tnoremap <A-A> <Esc>A
tnoremap <A-b> <Esc>b
tnoremap <A-d> <Esc>d
tnoremap <A-f> <Esc>f

" Remaining Plugins: {{{1

" Vim_Plug: {{{2
let g:plug_window = 'tabe'

" Jedi: {{{2
let g:jedi#use_tabs_not_buffers = 1         " easy to maintain workspaces
let g:jedi#usages_command = '<Leader>u'
let g:jedi#rename_command = '<F2>'
let g:jedi#show_call_signatures_delay = 100
let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 3
let g:jedi#enable_completions = 0

" Zim: {{{2
let g:zim_notebooks_dir = expand('~/Notebooks/Notes')
let g:zim_notebook = expand('~/Notebooks/Notes')
let g:zim_dev = 1

" Here's an exciting little note about Zim. Ignoring how ...odd this plugin is
" Voom actually gets pretty close to handling Zimwiki if you recognize it as
" as dokuwiki!

" Runtime: {{{1

" Matching Parenthesis: {{{2

runtime! macros/matchit.vim

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
let g:sh_fold_enabled= 3  "   (enables function and heredoc folding)

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
let g:vimsyn_embed = 'lPr'

" Turn off errors because 50% of them are wrong.
let g:vimsyn_noerror = 1

						" *g:vimsyn_folding*

" Some folding is now supported with syntax/vim.vim:

   " g:vimsyn_folding == 0 or doesn't exist: no syntax-based folding
   " g:vimsyn_folding =~ 'a' : augroups
   " g:vimsyn_folding =~ 'f' : fold functions
   " g:vimsyn_folding =~ 'P' : fold python   script
let g:vimsyn_folding = 'afP'

" Omnifuncs: {{{3
augroup omnifunc
    autocmd!
    autocmd Filetype python,xonsh     setlocal omnifunc=python3complete#Complete
    autocmd Filetype html,xhtml       setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd Filetype xml              setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd Filetype css              setlocal omnifunc=csscomplete#CompleteCSS
    autocmd Filetype javascript       setlocal omnifunc=javascriptcomplete#CompleteJS
    " If there isn't a default or built-in, use the syntax highlighter
    autocmd Filetype *
        \   if &omnifunc == "" |
        \       setlocal omnifunc=syntaxcomplete#Complete |
        \   endif
augroup END

" Functions_Commands: {{{1

" Up until Rename are from Junegunn so credit to him

" Todo Function: {{{2
command! Todo call todo#Todo()
" Scriptnames: {{{2
" command to filter :scriptnames output by a regex
command! -nargs=1 Scriptnames call <sid>scriptnames(<f-args>)

function! s:scriptnames(re) abort
    redir => scriptnames
    silent scriptnames
    redir END

    let filtered = filter(split(scriptnames, "\n"), "v:val =~ '" . a:re . "'")
    echo join(filtered, '\n')
endfunction

" Helptabs: {{{2
" I've pretty heavily modified this one but junegunn gets the initial credit.
function! s:helptab()
    if &buftype ==# 'help'
        setlocal number relativenumber
        try
            wincmd T
        catch
        endtry

        noremap <buffer> q <Cmd>q<CR>
    " need to make an else for if ft isn't help then open a help page with the
    " first argument
    endif
endfunction

augroup mantabs
    autocmd!
    autocmd Filetype man,help call s:helptab()
augroup END

command! -nargs=1 Help call <SID>helptab()

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

" Syntax Commands: {{{2

command! HL call syncom#HL()

command! HiC call syncom#HiC()

command! HiQF call syncom#HiQF()

" Explore PlugHelp: {{{2
" Call :PlugHelp to use fzf to open a window with all of the plugins
" you have installed listed and upon pressing enter open the help
" docs. That's not a great explanation but honestly easier to explain
" with a picture.
" TODO: Screenshot usage.
function! s:plug_help_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink'  :   function('s:plug_help_sink')}))

" Statusline: {{{2
"
" Yeah junegunn gets this one too.
function! s:statusline_expr()
  let dicons = ' %{WebDevIconsGetFileTypeSymbol()} '
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'
" %n is buffer #, %f is filename relative to $PWD, sep is right align

  return '[%n] %f '.dicons.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()

" Except for...
augroup TermStatusline
    autocmd!
    autocmd TermOpen * setlocal statusline=%{b:term_title}
augroup END

" Rename: {{{2
" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>

" YAPF: {{{2

command! YAPF exec '!yapf <cfile>'
command! YAPFI exec '!yapf -i <cfile>'
command! YAPFD cexpr! exec '!yapf -d <cfile>'

" Chmod: {{{2

"	:S	Escape special characters for use with a shell command (see
"		|shellescape()|). Must be the last one. Examples:
"		    :!dir <cfile>:S
"		    :call system('chmod +w -- ' . expand('%:S'))
" From :he filename-modifiers in the cmdline page.

command! -nargs=1 -complete=file Chmod call system('chmod +x ' . expand('%:S'))

" Could do word under cursor. Could tack it on to some fzf variation. idk

" Finger: {{{2
" Example from :he command-complete
" The following example lists user names to a Finger command
command! -complete=custom,ListUsers -nargs=1 Finger !finger <args>

function! ListUsers(A,L,P)
    return system("cut -d: -f1 /etc/passwd")
endfun

"
" The following example completes filenames from the directories specified in
" the 'path' option:
command! -nargs=1 -bang -complete=customlist,EditFileComplete
   	\ EF edit<bang> <args>
function! EditFileComplete(A,L,P)
    return split(globpath(&path, a:A), "\n")
endfun

" This example does not work for file names with spaces!

" Profile: {{{2
function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start expand('$_ROOT') . 'tmp/profile.log'
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0)



colorscheme gruvbox

" General Syntax Highlighting: {{{2

" Lower max syntax highlighting
set synmaxcol=400

syntax sync fromstart
syntax on

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
