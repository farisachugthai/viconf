" Init:
" Neovim Configuration:

" About: {{{1
let g:snips_author = 'Faris Chugthai'
let g:snips_github = 'https://github.com/farisachugthai'

" Vim Plug: {{{1
" Plug Check: {{{2
" Shout out Justinmk! Never wanted to go through a full check for vim-plug
" since it's there 99% of the time but this is a real smart workaround
" https://github.com/justinmk/config/blob/291ec0ae12b0b4b35b4cf9315f1878db00b780ec/.config/nvim/init.vim#L12
let s:plugins = filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim', 1))
let s:plugins_extra = s:plugins

if expand('OS') !=# 'Windows_NT'
    if !s:plugins
        fun! InstallPlug() "bootstrap plug.vim on new systems
            silent call mkdir(expand('~/.local/share/nvim/site/autoload', 1), 'p')
            execute '!curl -fLo '.expand('~/.local/share/nvim/site/autoload/plug.vim', 1)
          \ .' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      endfun
    endif
endif

" General Plugins: {{{2
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/vim-plug'        " plugception
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
Plug 'davidhalter/jedi-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'         " Lighter version of NERDCom since i don't use most features anyway
Plug 'w0rp/ale'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next' }
Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'zchee/deoplete-jedi', { 'for': ['python', 'python3'] }
Plug 'fszymanski/deoplete-emoji'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'godlygeek/tabular'
Plug 'vim-voom/voom'
Plug 'Rykka/InstantRst'
Plug 'gu-fan/riv.vim'
Plug 'greyblake/vim-preview'
Plug 'SidOfc/mkdx'  " This plugin has an almost comically long readme. Check it:
" https://github.com/SidOfc/mkdx
Plug 'lifepillar/vim-cheat40'
Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Nvim Specific: {{{1

if has('nvim')
    set inccommand=split                    " This alone is enough to never go back
    set termguicolors
endif

unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

" Python Executables: {{{1

" if we have a virtual env start there
if exists('$VIRTUAL_ENV')
    let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'

" or a conda env.
elseif exists('$CONDA_PYTHON_EXE')
    let g:python3_host_prog = expand('$CONDA_PYTHON_EXE')

" otherwise break up termux and linux
elseif exists('$PREFIX')

    " and just use the system python
    if executable(expand('$PREFIX/bin/python'))
        let g:python3_host_prog = expand('$PREFIX/bin/python')
    endif

else
    if executable('/usr/bin/python3')
        let g:python3_host_prog = '/usr/bin/python3'

        if executable('/usr/bin/python2')       " why not
            let g:python_host_prog = '/usr/bin/python2'
        endif
    endif
endif

" OS Setup: {{{1

let s:termux = exists('$PREFIX') && has('unix')
let s:ubuntu = !exists('$PREFIX') && has('unix')
let s:windows = has('win32') || has('win64')

let s:winrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/winrc.vim'
if s:windows && filereadable(s:winrc)
    execute 'source' s:winrc
endif

" unabashedly stolen from junegunn dude is too good.
let s:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/init.vim.local'
if filereadable(s:local_vimrc)
    execute 'source' s:local_vimrc
endif

" Here's a nice little setting to encourage interoperability
" UNIX AND MS-WINDOWS

" Some people have to do work on MS-Windows systems one day and on Unix another
" day.  If you are one of them, consider adding 'slash' and 'unix' to
" 'sessionoptions'.  The session files will then be written in a format that can
" be used on both systems.  This is the command to put in your |init.vim| file:
set sessionoptions+=unix,slash
" Vim will use the Unix format then, because the MS-Windows Vim can read and
" write Unix files, but Unix Vim can't read MS-Windows format session files.
" Similarly, MS-Windows Vim understands file names with / to separate names, but
" Unix Vim doesn't understand \.

" Not related but I wanted to strike these down because they're annoying.
set sessionoptions-=blank,folds

" Global Options: {{{1

" Leader_Viminfo: {{{2
" let g:mapleader = '\<Space>'
noremap <Space> <nop>
map <Space> <Leader>
let g:maplocalleader = '\,'

if !has('nvim')
    set viminfo='100,<200,s200,n$HOME/.vim/viminfo
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
set foldlevelstart=0        " I'm fine with this level of folding to start
set foldlevel=0
set foldnestmax=10
set foldmethod=marker
" Use 1 column to indicate fold level and whether a fold is open or closed.
" Trade off for valuable window real estate though....
set foldcolumn=1

" Buffers Windows Tabs: {{{2
try
    set switchbuf=useopen,usetab,newtab
    set showtabline=2
catch
endtry

set hidden
set splitbelow splitright

" Spell Checker: {{{2

set encoding=utf-8                       " Set default encoding
scriptencoding utf-8                     " Vint believes encoding should be done first
set fileencoding=utf-8
set termencoding=utf-8

setlocal spelllang=en

" This is is definitely one of the things that needs to get ported over to nvim
if filereadable(expand('~/.config/nvim/spell/en.utf-8.add'))
    set spellfile=~/.config/nvim/spell/en.utf-8.add
elseif filereadable(glob('~/projects/viconf/.vim/spell/en.utf-8.add'))
    set spellfile=~/projects/viconf/.vim/spell/en.utf-8.add
else
    echoerr 'Spell file not found.'
endif

if !has('nvim')
    set spelllang+=$VIMRUNTIME/spell/en.utf-8.spl
endif

set complete+=kspell                    " Autocomplete in insert mode
set spellsuggest=5                      " Limit the number of suggestions from 'spell suggest'

if filereadable('/usr/share/dict/words')
    set dictionary+=/usr/share/dict/words
    " Replace the default dictionary completion with fzf-based fuzzy completion
    " Courtesy of fzf <3 vim. But make it shorter
    inoremap <expr> <c-x><k> fzf#vim#complete('cat /usr/share/dict/words')
endif

if filereadable('/usr/share/dict/american-english')
    setlocal dictionary+=/usr/share/dict/american-english
endif

if filereadable('$HOME/.config/nvim/spell/en.hun.spl')
    set spelllang+=$HOME/.config/nvim/spell/en.hun.spl
endif

" Fun With Clipboards: {{{2
if has('unnamedplus')                   " Use the system clipboard.
    set clipboard+=unnamed,unnamedplus
else                                    " Accommodate Termux
    set clipboard+=unnamed
endif

set pastetoggle=<F7>

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
endif

" Autocompletion: {{{2
set wildmenu
set wildmode=longest,list:longest       " Longest string or list alternatives
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
set fileignorecase                      " when searching for files don't use case
set wildignorecase

" Other Global Options: {{{2

set tags+=./tags,./../tags,./*/tags     " usr_29
set tags+=~/projects/tags               " consider generating a few large tag
set tags+=~python/tags                  " files rather than recursive searches
set mouse=a                             " Automatically enable mouse usage
if &textwidth!=0
    set colorcolumn=+1                  " I don't know why this didn't set
endif
set cmdheight=2
set number
set showmatch
set ignorecase smartcase
set infercase
set autoindent smartindent              " :he options: set with smartindent
" FOOBAR=~/<CTRL-><CTRL-F> will now autocomplete!
set isfname-==

if has('gui_running')
    set guifont=Fira\ Code\ weight=450\ 10
endif

" In case you wanted to see the guicursor default for gvim win64
" set gcr=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor, i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor, sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

set path+=**                            " Recursively search dirs with :find
if isdirectory('/usr/include/libcs50')
    set path+=/usr/include/libcs50          " Also I want those headers
endif

if isdirectory(expand('$_ROOT/lib/python3'))
    set path+=expand('$_ROOT')./lib/python3'
endif

set autochdir
set fileformat=unix
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
set nojoinspaces
set diffopt=filler,context:3          " vertical split d: Recent modifications from jupyter nteractiffs. def cont is 6

if has('persistent_undo')
    set undodir=~/.config/nvim/undodir
    set undofile
endif

set backup
set backupdir=~/.config/nvim/undodir,/tmp
set backupext='.bak'        " like wth is that ~ nonsense?

" Directory won't need to be set because it defaults to
" xdg_data_home/nvim/swap
set modeline
set lazyredraw
set browsedir="buffer"                  " which directory is used for the file browser

" Mappings: {{{1

" Window_Buf_Tab_Mappings: {{{2

" Navigate buffers more easily
nnoremap <Leader>bn <Cmd>bnext<CR>
nnoremap <Leader>bp <Cmd>bprev<CR>

" Wanna navigate windows more easily?
" |CTRL-W_gF|   CTRL-W g F     edit file name under the cursor in a new
"                  tab page and jump to the line number
"                  following the file name.
"
" Rebind that to C-w t and we can open the filename in a new tab.

" Navigate tabs more easily
nnoremap <A-Right> <Cmd>tabnext<CR>
nnoremap <A-Left> <Cmd>tabprev<CR>
nnoremap <Leader>tn <Cmd>tabnext<CR>
nnoremap <Leader>tp <Cmd>tabprev<CR>
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <Leader>te <Cmd>tabedit <c-r>=expand("%:p:h")<CR>

" It should also be easier to edit the config. Bind similarly to tmux
nnoremap <Leader>ed <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>
nnoremap <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>
inoremap <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

" Now reload it
nnoremap <Leader>re :so $MYVIMRC<CR>

" I feel really slick for this one. Modify ftplugin
let g:ftplug=$MYVIMRC.'/after/ftplugin/'.&filetype.'.vim'
" Goddamnit it opens a buffernnamed g:ftplug
" map <F10> <Cmd>e g:ftplug<CR>

" General_Mappings: {{{2

noremap <silent> <Leader>ts <Cmd>!termux-share -a send %<CR>

" Simple way to speed up startup
nnoremap <Leader>nt :NERDTreeToggle<CR>

" Junegunn:
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
xnoremap < <gv
xnoremap > >gv
nnoremap j gj
nnoremap k gk

" Switch CWD to the directory of the open buffer
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Switch NERDTree root to dir of currently focused window.
nnoremap <Leader>ncd :NERDTreeCWD

" Utilize the mouse!
map <ScrollWheelUp> <C-Y>
map <S-ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-E>
map <S-ScrollWheelDown> <C-D>

" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" UltiSnips: {{{2

" TODO: Is it better to put <Cmd> here? For the insert mode ones maybe.
" I use this command constantly
nnoremap <Leader>se <Cmd>UltiSnipsEdit<CR>
nnoremap <Leader>sn <Cmd>UltiSnipsEdit<CR>

" TODO: Is C-o better than Esc? Also add a check that if has_key(plug['fzf'])
" then and only then make these mappings. should just move to fzf plugin
inoremap <F6> <C-o>:Snippets<CR>
nnoremap <F6> :Snippets<CR>

" Unimpaired: {{{2
" Note that ]c and [c are mapped by git-gutter and ALE has ]a and [a
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :cfirst<CR>
nnoremap [Q :clast<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap ]L :lfirst<CR>
nnoremap [L :llast<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]B :blast<CR>
nnoremap [B :bfirst<CR>
nnoremap ]t :tabn<CR>
nnoremap [t :tabp<CR>
nnoremap ]T :tfirst<CR>
nnoremap [T :tlast<CR>

" Spell Checking: {{{2
nnoremap <Leader>sp :setlocal spell!<CR>
nnoremap <Leader>s= z=

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
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" ALE: {{{2

nnoremap <Leader>l <Plug>(ale_toggle_buffer)<CR>
nnoremap ]a <Plug>(ale_next_wrap)
nnoremap [a <Plug>(ale_previous_wrap)

" `:ALEInfoToFile` will write the ALE runtime information to a given filename.
" The filename works just like |:w|.

" <Meta-a> now gives detailed messages about what the linters have sent to ALE
nnoremap <A-a> <Plug>(ale_detail)

" This might be a good idea. * is already 'search for the cword' so let ALE
" work in a similar manner right?
nnoremap <Leader>* <Plug>(ale_go_to_reference)

nnoremap <Leader>a :ALEInfo<CR>

" Fugitive: {{{2
nnoremap <silent> <Leader>gb   <Cmd>Gblame<CR>
nnoremap <silent> <Leader>gc   <Cmd>Gcommit<CR>
cmap <silent> gch <Cmd>Git checkout<Space>
nnoremap <silent> <Leader>gd   <Cmd>Gdiff<CR>
nnoremap <silent> <Leader>gds  <Cmd>Gdiff --staged<CR>
nnoremap <silent> <Leader>gds2 <Cmd>Git diff --stat --staged<CR>
nnoremap <silent> <Leader>ge   :Gedit<Space>
nnoremap <silent> <Leader>gf   <Cmd>Gfetch<CR>
nnoremap <silent> <Leader>gg   <Cmd>Ggrep<CR>
nnoremap <silent> <Leader>gl   <Cmd>0Glog<CR>
nnoremap <silent> <Leader>gL   <Cmd>0Glog --pretty=oneline --graph --decorate --abbrev --all --branches<CR>
nnoremap <silent> <Leader>gm   <Cmd>Gmerge<CR>
" Make the mapping longer but clear as to whether gp would pull or push
nnoremap <silent> <Leader>gpl  <Cmd>Gpull<CR>
nnoremap <silent> <Leader>gps  <Cmd>Gpush<CR>
nnoremap <silent> <Leader>gq   <Cmd>Gwq<CR>
nnoremap <silent> <Leader>gQ   <Cmd>Gwq!<CR>
nnoremap <silent> <Leader>gR   :Gread<Space>
" FZF took it. Check ./after/plugin/fzf.vim {btw i love the gf binding}
" nnoremap <silent> <Leader>gs   <Cmd>Gstatus<CR>
nnoremap <silent> <Leader>gst  <Cmd>Git diff --stat<CR>
nnoremap <silent> <Leader>gw   <Cmd>Gwrite<CR>
nnoremap <silent> <Leader>gW   <Cmd>Gwrite!<CR>

" Language Server: {{{2
" This is a good way to give LangClient the necessary bindings it needs;
" while, first ensuring that the plugin loaded and that it only applies for
" relevant filetypes.
function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <Leader>lh :call LanguageClient#textDocument_hover()<CR>
        inoremap <buffer> <Leader><F2> <Esc>:call LanguageClient#textDocument_rename()<CR>
        nnoremap <buffer> <Leader>ld :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <Leader>lr :call LanguageClient#textDocument_rename()<CR>
        nnoremap <buffer> <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
        nnoremap <buffer> <Leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
        nnoremap <buffer> <Leader>lx :call LanguageClient#textDocument_references()<CR>
        nnoremap <buffer> <Leader>la :call LanguageClient_workspace_applyEdit()<CR>
        nnoremap <buffer> <Leader>lc :call LanguageClient#textDocument_completion()<CR>
        nnoremap <buffer> <Leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
        nnoremap <buffer> <Leader>lm :call LanguageClient_contextMenu()<CR>
        set completefunc=LanguageClient#complete
        set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
    endif
endfunction

" Tagbar: {{{2
" This works perfectly and should be how you handle all plugins and their
" mappings !!!!!
if has_key(plugs, 'tagbar')
    nnoremap <silent> <F8> <Cmd>TagbarToggle<CR>
    inoremap <silent> <F8> <Cmd>TagbarToggle<CR>
endif

" Macros: {{{1
if !has('nvim')
    runtime! ftplugin/man.vim
    let g:ft_man_folding_enable = 0
endif

runtime! macros/matchit.vim

set matchpairs+=<:>

" To every plugin I've never used before. Stop slowing me down.
let g:loaded_vimballPlugin     = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_getsciptPlugin    = 1
let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1
" let g:loaded_netrw             = 1
" let g:loaded_netrwPlugin       = 1
" Let's see if this speeds things up because I've never used most of them

" Remaining Plugins: {{{1

" Vim_Plug: {{{2
let g:plug_window = 'tabe'


" ALE: {{{2
let g:ale_fixers = { '*': [ 'remove_trailing_lines', 'trim_whitespace' ] }
let g:ale_fix_on_save = 1
" Now because you fix the trailing whitespace and trailing lines
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_warn_about_trailing_blank_lines = 0

" Modify how ale notifies us of stuff
let g:ale_echo_cursor = 1
" Default: `'%code: %%s'`
let g:ale_echo_msg_format = '%linter% - %code: %%s %severity%'
let g:ale_list_vertical = 1

let g:ale_set_signs = 1
let g:ale_sign_column_always = 1
let g:ale_virtualenv_dir_names = [ '$HOME/virtualenvs' ]
" Display progress while linting.
let s:ale_running = 0
augroup ALEProgress
    autocmd!
    autocmd User ALELintPre  let s:ale_running = 1 | redrawstatus
    autocmd User ALELintPost let s:ale_running = 0 | redrawstatus
augroup END

" Devicons: {{{2
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1               " adding the flags to NERDTree
let g:airline_powerline_fonts = 1

" For startify
let entry_format = "'   ['. index .']'. repeat(' ', (3 - strlen(index)))"

if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
    let entry_format .= ". WebDevIconsGetFileTypeSymbol(entry_path) .' '.  entry_path"
else
    let entry_format .= '. entry_path'
endif

" UltiSnips: {{{2
let g:UltiSnipsSnippetDir = [ '~/.config/nvim/UltiSnips' ]
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsListSnippets = '<C-Tab>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
inoremap <C-Tab> * <Esc>:call ultisnips#listsnippets()<CR>
let g:ultisnips_python_style = 'numpy'
let g:ultisnips_python_quoting_style = 'double'
let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsEditSplit = 'tabdo'
" Defining it in this way means that UltiSnips doesn't iterate
" through every dir in &rtp which should save a lot of time
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']

" Language Client: {{{2
let g:LanguageClient_serverCommands = {
            \ 'python': [ 'pyls' ],
            \ 'c': ['clangd'],
            \ 'cpp': ['clangd'],
            \ 'js': ['tsserver'],
            \ 'ts': ['tsserver'],
            \ 'css': ['css-languageserver'],
            \ 'html': ['html-languageserver'],
            \ 'tsx': ['tsserver']
            \ }

let g:LanguageClient_autoStart = 1
let g:LanguageClient_selectionUI = 'fzf'
let g:LanguageClient_settingsPath = expand('~/.config/nvim/settings.json')
let g:LanguageClient_loggingFile = expand('~/.local/share/nvim/LC.log')

" Jedi: {{{2
let g:jedi#use_tabs_not_buffers = 1         " easy to maintain workspaces
let g:jedi#usages_command = '<Leader>u'
let g:jedi#rename_command = '<F2>'
let g:jedi#show_call_signatures_delay = 100
let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 3
let g:jedi#enable_completions = 0

" Deoplete_Jedi: {{{2

" Setting things up with the `if ubuntu` phrase was oddly a lot easier than
" i expected it to be...
if s:ubuntu
    let g:deoplete#sources#jedi#enable_typeinfo = 1
    let g:deoplete#sources#jedi#show_docstring = 1
elseif s:termux
    let g:deoplete#sources#jedi#enable_typeinfo = 0
endif

" Tagbar: {{{2
" just a thought i had. For any normal mode remaps you have, add the same
" thing and prefix <Esc> to the RHS and boom!
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_sort = 0

" Zim: {{{2
let g:zim_notebooks_dir = expand('~/Notebooks.git')
let g:zim_notebook = expand('~/Notebooks.git')
let g:zim_dev = 1

" Here's an exciting little note about Zim. Ignoring how ...odd this plugin is
" Voom actually gets pretty close to handling Zimwiki if you recognize it as
" as dokuwiki!
" Riv: {{{2

" Highlight py docstrings with rst highlighting
let g:riv_python_rst_hl = 1
let g:riv_file_link_style = 2  " Add support for :doc:`something` directive.
let g:riv_ignored_maps = '<Tab>'
let g:riv_ignored_nmaps = '<Tab>'
let g:riv_i_tab_pum_next = 0

let g:riv_global_leader=','

" From he riv-instructions. **THIS IS THE ONE!!** UltiSnips finally works again
let g:riv_i_tab_user_cmd = "\<c-g>u\<c-r>=UltiSnips#ExpandSnippet()\<cr>"
let g:riv_fuzzy_help = 1

" Mkdx: {{{2
" Similar to Riv, this is for working with Markdown documents
let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 1 } },
                        \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 1 } }
" Voom: {{{2

"g:voom_ft_modes" is a Vim dictionary: keys are filetypes (|ft|), values are
" corresponding markup modes (|voom-markup-modes|). Example:
    " let g:voom_ft_modes = {'markdown': 'markdown', 'tex': 'latex'}
" This option allows automatic selection of markup mode according to the filetype
" of the source buffer. If 'g:voom_ft_modes' is defined as above, and 'filetype'
" of the current buffer is 'tex', then the command
    " :Voom
" is identical to the command
    " :Voom latex

" g:voom_default_mode" is a string with the name of the default markup mode.
" For example, if there is this in .vimrc:
    " let g:voom_default_mode = 'asciidoc'
" then, the command
    " :Voom
" is identical to
    " :Voom asciidoc
" unless 'g:voom_ft_modes' is also defined and has an entry for the current
" filetype.

let g:voom_ft_modes = {'markdown': 'markdown', 'rst': 'rst', 'zimwiki': 'dokuwiki'}
let g:voom_default_mode = 'rst'
let g:voom_python_versions = [3]

" Cheat40: {{{2

" I can already tell I'm going to end up making too many modifications to it
let g:cheat40_use_default = 0

" Filetype Specific Options: {{{1

if &ft ==# 'c'
    set makeprg=make\ %<.o
endif
" Noticed this bit in he syntax line 2800
let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heredoc folding)
" Let's hope this doesn't make things too slow.

" he rst.vim or ft-rst-syntax or syntax 2600. Don't put bash instead of sh.
" $VIMRUNTIME/syntax/rst.vim iterates over this var and if it can't find a
" bash.vim syntax file it will crash.
let rst_syntax_code_list = ['vim', 'python', 'sh', 'markdown', 'lisp']

" highlighting readline options
let readline_has_bash = 1

" from runtime/ftplugin/html.vim
let g:ft_html_autocomment = 1

" Functions_Commands: {{{1

" Up until Rename are from Junegunn so credit to him

" Grep: {{{ 2

if executable('ag')
    let &grepprg = 'ag --nogroup --nocolor --column --vimgrep $*'
    set grepformat=%f:%l:%c:%m
elseif executable('rg')
    let &grepprg = 'rg --vimgrep'
    set grepformat=%f:%l:%c:%m
else
  let &grepprg = 'grep -rn $* *'
endif

command! -nargs=1 -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen

" Todo Function: {{{2
" Grep for todos in the current repo and populate the quickfix list with them.
" You could run an if then to check you're in a git repo.
" Also could use ag/rg/fd and fzf instead of grep to supercharge this.
function! s:todo() abort
    let entries = []
    for cmd in ['git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null',
                \ 'grep -rniI -e TODO -e todo -e FIXME -e XXX -e HACK * 2> /dev/null']
        let lines = split(system(cmd), '\n')
        if v:shell_error != 0 | continue | endif
        for line in lines
            let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
            call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
        endfor
        break
    endfor

    if !empty(entries)
        call setqflist(entries)
        copen
    endif
endfunction
command! Todo call s:todo()

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
function! s:helptab()
    if &buftype ==# 'help'
        wincmd T
        nnoremap <buffer> q :q<cr>
    " need to make an else for if ft isn't help then open a help page with the
    " first argument
    endif
endfunction
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

" HL: {{{2
" Whats the syntax group under my cursor?
function! s:hl()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction

command! HL call <SID>hl()

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
  \ 'sink':   function('s:plug_help_sink')}))

" Rename: {{{2
" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>

" UltiSnips: {{{2

" GetAllSnippets: {{{3
" Definitely a TODO
function! GetAllSnippets()
  call UltiSnips#SnippetsInCurrentScope(1)
  let list = []
  for [key, info] in items(g:current_ulti_dict_info)
    let parts = split(info.location, ':')
    call add(list, {
      \'key': key,
      \'path': parts[0],
      \'linenr': parts[1],
      \'description': info.description,
      \})
  endfor
  return list
endfunction

" Expandable:{{{3

" TODO: Come up with a mapping for it. Also what is E746
" Go to the annotations for an explanation of this function.
" function UltiSnips#IsExpandable()
"     return !(
"         \ col('.') <= 1
"         \ || !empty(matchstr(getline('.'), '\%' . (col('.') - 1) . 'c\s'))
"         \ || empty(UltiSnips#SnippetsInCurrentScope())
"         \ )
" endfunction

" ExpandPossibleShorterSnippet: {{{3

function! ExpandPossibleShorterSnippet()
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe 'normal a' . curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction
inoremap <silent> <C-L> <C-R>=(ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

" Expand Snippet Or CR: {{{3
" Hopefully will expand snippets or CR. Or it'll destroy deoplete's
" ability to close the pum. *shrugs*
function! ExpandSnippetOrCarriageReturn() abort
  let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
      return snippet
    else
      return "\<CR>"
    endif
endfunction

inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" LanguageClient Check:{{{2
" Check if the LanguageClient is running.
function! s:lc_check()
  let s:lc_Check = LanguageClient#serverStatus()
  echo s:lc_Check
endfunction
command! LCS call <SID>lc_check()

" Colorscheme: {{{1
" I feel like I should put this in a command or something so I can easily
" toggle it.
function! s:gruvbox()
    set bg=dark
    let g:gruvbox_contrast_dark = 'hard'
    " let g:gruvbox_improved_strings=1 shockingly terrible
    let g:gruvbox_improved_warnings=1
    syntax on
endfunction

" From here I can keep making expressions to the effect of elseif colors==onedark
" then set it up like and so forth
colorscheme gruvbox

if g:colors_name ==# 'gruvbox'
    call <SID>gruvbox()
endif

command! -nargs=0 Gruvbox call s:gruvbox()

" 12/17/18: Here's a phenomenal autocmd for ensuring we can set nohlsearch but
" still get highlights ONLY while searching!!
"
" Jan 30, 2019:
" A) Fugitive is seriously amazing. `:Gblame` to get revision dates is such a useful feature.
" TODO: Also this exits and clears the highlighting
" pattern as soon as you hit enter. So if you type a word, it'll highlight all
" matches. But once you hit enter to find the next one it clears. Hmmm.
set nohlsearch
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
