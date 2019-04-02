" Neovim Configuration:
" Maintainer: Faris Chugthai
" Last Change: Mar 23, 2019

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

if has('$TMUX')
    Plug 'christoomey/vim-tmux-navigator'
endif

Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Plug 'gu-fan/riv.vim', { 'for': ['python', 'python3', 'rst'] }
Plug 'greyblake/vim-preview'
Plug 'lifepillar/vim-cheat40'
Plug 'autozimu/LanguageClient-neovim'
Plug 'ryanoasis/vim-devicons'           " Keep at end!
call plug#end()

" Preliminaries: {{{1

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
    endif
endif

" Also add a python2 remote host
if executable(expand('$_ROOT') . '/bin/python2')
    let g:python_host_prog = expand('$_ROOT') . '/bin/python2'
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python2'
else
    let g:loaded_python_provider = 1
endif

" OS Setup: {{{2

" Platforms: {{{3
let s:termux = exists('$PREFIX') && has('unix')
let s:ubuntu = !exists('$PREFIX') && has('unix')
let s:windows = has('win32') || has('win64')

let s:winrc = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/winrc.vim'
if s:windows && filereadable(s:winrc)
    execute 'source' s:winrc
endif

" unabashedly stolen from junegunn dude is too good.
let s:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/init.vim.local'
if filereadable(s:local_vimrc)
    execute 'source' s:local_vimrc
endif

" Session Options: {{{3

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

" Remote Hosts: {{{3
if s:termux
    " holy fuck that was a doozy to find
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'
    let g:ruby_host_prog = expand($_ROOT) . '/bin/neovim-ruby-host'

elseif s:ubuntu
    let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'
    " So the one above could very easily be merged. No idea how to do the
    " below unless I just leave it up to the system.
    try
        let g:ruby_host_prog = expand('~') . '/.rvm/gems/default/bin/neovim-ruby-host'
    catch
        let g:ruby_host_prog = expand('$_ROOT') . '/local/bin/neovim-ruby-host'
    endtry

endif

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
    " Courtesy of fzf <3 vim. But make it shorter
    inoremap <expr> <c-x><k> fzf#vim#complete('cat /usr/share/dict/words')
endif

if filereadable('/usr/share/dict/american-english')
    set dictionary+=/usr/share/dict/american-english
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

" Navigate buffers more easily
nnoremap <Leader>bn <Cmd>bnext<CR>
nnoremap <Leader>bp <Cmd>bprev<CR>
nnoremap <Leader>bl <Cmd>blast<CR>
nnoremap <Leader>bf <Cmd>bfirst<CR>

" Wanna navigate windows more easily?
" |CTRL-W_gF|   CTRL-W g F     edit file name under the cursor in a new
"                  tab page and jump to the line number
"                  following the file name.
"
" Rebind that to C-w t and we can open the filename in a new tab.

" Navigate tabs more easily
noremap <A-Right> <Cmd>tabnext<CR>
noremap <A-Left> <Cmd>tabprev<CR>
nnoremap <Leader>tn <Cmd>tabnext<CR>
nnoremap <Leader>tp <Cmd>tabprev<CR>
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <Leader>te <Cmd>tabedit <c-r>=expand("%:p:h")<CR>
nnoremap <Leader>tq <Cmd>tabclose<CR>

" It should also be easier to edit the config. Bind similarly to tmux
nnoremap <Leader>ed <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>
noremap <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

" Now reload it
nnoremap <Leader>re :so $MYVIMRC<CR>

" I feel really slick for this one. Modify ftplugin
let g:ftplug=$MYVIMRC.'/after/ftplugin/'.&filetype.'.vim'
" Goddamnit it opens a buffernnamed g:ftplug
" map <F10> <Cmd>e g:ftplug<CR>

" General_Mappings: {{{2

noremap <silent> <Leader>ts <Cmd>!termux-share -a send %<CR>

" Junegunn:
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
xnoremap < <gv
xnoremap > >gv
nnoremap j gj
nnoremap k gk

" Switch CWD to the directory of the open buffer
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Utilize the mouse!
map <silent> <ScrollWheelUp> <C-Y>
map <silent> <S-ScrollWheelUp> <C-U>
map <silent> <ScrollWheelDown> <C-E>
map <silent> <S-ScrollWheelDown> <C-D>

" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Spell Checking:
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

" Deoplete_Jedi: {{{2

" Setting things up with the `if ubuntu` phrase was oddly a lot easier than
" i expected it to be...
if s:ubuntu
    let g:deoplete#sources#jedi#enable_typeinfo = 1
    let g:deoplete#sources#jedi#show_docstring = 1
elseif s:termux
    let g:deoplete#sources#jedi#enable_typeinfo = 0
endif

" Zim: {{{2
let g:zim_notebooks_dir = expand('~/Notebooks/Notes')
let g:zim_notebook = expand('~/Notebooks/Notes')
let g:zim_dev = 1

" Here's an exciting little note about Zim. Ignoring how ...odd this plugin is
" Voom actually gets pretty close to handling Zimwiki if you recognize it as
" as dokuwiki!

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
let g:loaded_getsciptPlugin    = 1
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

augroup filetypes
    autocmd Filetype *
        \   if &omnifunc == "" |
        \       setlocal omnifunc=syntaxcomplete#Complete |
        \   endif
            " This is probably a terrible idea but idk whats fucking up my com
            let &commentstring = '# %s'
            set comments="
augroup END

" Functions_Commands: {{{1

" Up until Rename are from Junegunn so credit to him

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
        setlocal number relativenumber
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

" Syntax Highlighting Functions: {{{2

" HL: {{{3
" Whats the highlighting group under my cursor?
function! s:hl()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction

command! HL call <SID>hl()

" HiC: {{{3
" Heres a possibly easier way to do this. Still in testing.
" Mar 17, 2019: So far does the exact same thing!
function! s:HiC()
    echo 'Highlighting group: ' . synIDattr(synID(line('.'), col('.'), 1), 'name')
    echo 'Foreground color: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')
endfunction

command! HiC call <SID>HiC()

" HiDebug: {{{3
" function! s:HiD()
"     echo join(map(synstack(line('.'), col('.')), 'synIDattr(id, "name")') '\n')
" endfunction

" command! HiD call <SID>HiD()

" HiAll: {{{3
function! s:HiQF()
  " synstack returns a list. takes lnum and col.
  " map is crazy specific in its argument requirements. map(list, string)
  " cexpr evals a command and adds it to the quickfist list
  cexpr! map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

command! HiQF call <SID>HiQF()


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
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'
  let dicons = ' %{WebDevIconsGetFileTypeSymbol()} '


  return '[%n] %F '.dicons.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()

" Except for...
autocmd TermOpen * setlocal statusline=%{b:term_title}

" Rename: {{{2
" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>

" YAPF: {{{2

command! YAPF exec '!yapf <cfile>'
command! YAPFI exec '!yapf -i <cfile>'
command! YAPFD cexpr! exec '!yapf -d <cfile'

" Chmod: {{{2

"	:S	Escape special characters for use with a shell command (see
"		|shellescape()|). Must be the last one. Examples: >
"		    :!dir <cfile>:S
"		    :call system('chmod +w -- ' . expand('%:S'))
" From :he filename-modifiers in the cmdline page.

command! Chmod call system('chmod +x -- ' . expand('%:S')

" Could do word under cursor. Could tack it on to some fzf variation. idk

" Colorscheme: {{{1

" Gruvbox: {{{2
" I feel like I should put this in a command or something so I can easily
" toggle it.
function! s:gruvbox()
    set background=dark
    let g:gruvbox_italic = 1
    let g:gruvbox_contrast_dark = 'hard'
    " let g:gruvbox_improved_strings=1 shockingly terrible
    let g:gruvbox_improved_warnings = 1
    let g:gruvbox_invert_tabline = 1
    let g:gruvbox_italicize_strings = 1
endfunction

" From here I can keep making expressions to the effect of elseif colors==onedark
" then set it up like and so forth
colorscheme gruvbox

if g:colors_name ==# 'gruvbox'
    call <SID>gruvbox()
endif

command! -nargs=0 Gruvbox call s:gruvbox()

" General Syntax Highlighting: {{{2

" Lower max syntax highlighting
set synmaxcol=400

syntax sync minlines=500
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
