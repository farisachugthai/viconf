" init.vim
" neovim configuration
" Nvim: set verbose=1:

" All: {{{ 1

" About: {{{ 2
let g:snips_author = 'Faris Chugthai'
let g:snips_email = 'farischugthai@gmail.com'
let g:snips_github = 'https://github.com/farisachugthai'
" }}}

" Vim Plug: {{{ 2

call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
" Nothing happens if we open a directory to start nvim
" TODO: one of the expressions in the loop needs to be prepended with silent
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END
Plug 'davidhalter/jedi-vim', { 'for': ['python', 'python3'] }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'         " Lighter version of NERDCom since i don't use most features anyway
Plug 'w0rp/ale'
Plug 'morhetz/gruvbox'
Plug 'christoomey/vim-tmux-navigator'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next',
    \ 'do': 'bash install.sh' }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'mhinz/vim-startify'

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'godlygeek/tabular'
Plug 'vim-voom/voom'
Plug 'ryanoasis/vim-devicons'           " Keep at end!

call plug#end()
" }}}

" Nvim Specific: {{{ 2
set background=dark

" unabashedly stolen from junegunn dude is too good.
let s:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/init.vim.local'
if filereadable(s:local_vimrc)
    execute 'source' s:local_vimrc
endif

set inccommand=split                    " This alone is enough to never go back
set termguicolors
if has('nvim')
    set inccommand=split                    " This alone is enough to never go back
    set termguicolors
endif
set inccommand=split                    " This alone is enough to never go back
" }}}

" Python Executables: {{{ 2
if has('python3')
" if we have a virtual env start there
    if exists('$VIRTUAL_ENV')
        let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'

    elseif exists('$CONDA_PYTHON_EXE')
        let g:python3_host_prog = expand('$CONDA_PYTHON_EXE')

    " otherwise break up termux and linux
    elseif exists('$PREFIX')
        " and just use the system python
        if executable('$PREFIX/bin/python')
            let g:python3_host_prog = '$PREFIX/bin/python'
        endif
    else
        if executable('/usr/bin/python3')
            let g:python3_host_prog = '/usr/bin/python3'
        endif
    endif
endif

" }}}

" Global Options: {{{ 2

" Leader_Viminfo: {{{ 3
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

if !has('nvim')
    set viminfo='100,<200,s200,n$HOME/.vim/viminfo
endif
" }}}

" Pep8 Global Options: {{{ 3
set tabstop=4                           " show existing tab with 4 spaces width
set shiftwidth=4                        " when indenting with '>', use 4 spaces width
set expandtab smarttab                  " On pressing tab, insert 4 spaces
set softtabstop=4
let g:python_highlight_all = 1
" }}}

" Folds: {{{ 3
set foldenable
set foldlevelstart=1                    " Enables most folds
set foldnestmax=10
set foldmethod=marker
" }}}

" Buffers Windows Tabs: {{{ 3
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

set hidden
set splitbelow
set splitright
" }}}

" Spell Checker: {{{ 3
set encoding=UTF-8                       " Set default encoding
scriptencoding UTF-8                     " Vint believes encoding should be done first
set fileencoding=UTF-8
set spelllang=en

if filereadable(glob('~/.config/nvim/spell/en_US.utf-8.add'))
    set spellfile=~/.config/nvim/spell/en_US.utf-8.add
endif

if !has('nvim')
    set spelllang+=$VIMRUNTIME/spell/en.utf-8.spl
endif

set complete+=kspell                    " Autocomplete in insert mode
set spellsuggest=5                      " Limit the number of suggestions from 'spell suggest'

if filereadable('/usr/share/dict/words')
    set dictionary+=/usr/share/dict/words
    " Replace the default dictionary completion with fzf-based fuzzy completion
    " Courtesy of fzf <3 vim
    inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
endif

if filereadable('/usr/share/dict/american-english')
    setlocal dictionary+=/usr/share/dict/american-english
endif

if filereadable('$HOME/.config/nvim/spell/en.hun.spl')
    set spelllang+=$HOME/.config/nvim/spell/en.hun.spl
endif

if filereadable(glob('~/.vim/autocorrect.vim'))
    source ~/.vim/autocorrect.vim
endif
" }}}

" Fun With Clipboards: {{{ 3
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
" }}}

" Autocompletion: {{{ 3
set wildmenu                            " Show list instead of just completing
set wildmode=longest,list:longest       " Longest string or list alternatives
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
set fileignorecase                      " when searching for files don't use case
set wildignorecase                      " on the cmdline ignore case in filenames

" set completefunc here and then let b:omnifunc in ftplugins
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" }}}

" Other Global Options: {{{ 3
set tags+=./tags,./../tags,./*/tags     " usr_29
set tags+=~/projects/tags               " consider generating a few large tag
set tags+=~python/tags                  " files rather than recursive searches
set mouse=a                             " Automatically enable mouse usage
" set cursorline                          " Might wanna have off. Or change color
if &textwidth!=0
    set colorcolumn=+1                  " I don't know why this didn't set
endif
set cmdheight=2
set number
set showmatch
set ignorecase smartcase
set infercase
set autoindent smartindent              " :he options: set with smartindent
set noswapfile

if has('gui_running')
    set guifont='Fira\ Code\ Mono:11'
endif

" In case you wanted to see the guicursor default for gvim win64
" set gcr=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,
" i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,
" sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

 set path+=**        			        " Recursively search dirs with :find
set autochdir
set fileformat=unix
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
set nojoinspaces
set diffopt=vertical,context:3          " vertical split d: Recent modifications from jupyter nteractiffs. def cont is 6

if has('persistent_undo')                " i think neovim always does
    set undodir=~/.config/nvim/undodir
    set undofile                        " keep an undo file
endif

set backupdir=~/.config/nvim/undodir
set modeline
set lazyredraw
set browsedir="buffer"                  " which directory is used for the file browser
" }}}

" }}}

" Mappings: {{{ 2

" General Mappings: {{{ 3

" Note that F7 is bound to pastetoggle so don't map it
" Navigate windows more easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Navigate tabs more easily. Should be everywhere. Just be defensive w/ unique
map <unique> <A-Right> :tabnext<CR>
map <unique> <A-Left> :tabprev<CR>

" Simple way to speed up startup
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>a :echo('No. Use :%y')<CR>
" F5 to run *.py. Currently doesn't work or at least doesn't display anything
inoremap <F5> <Esc>:w<CR>:!clear;python %
" It should be easier to get help
nnoremap <Leader>he :helpgrep<space>
" It should also be easier to edit the config
nnoremap <F9> :tabe ~/projects/viconf/.config/nvim/init.vim<CR>
" TODO: What is Vim's version of realpath()? Can't find it even w/ helpgrep
nnoremap <Leader>ed :tabe ~/projects/viconf/.config/nvim/init.vim<CR>

inoremap jk <Esc>
vnoremap jk <Esc>

" Junegunn:
nnoremap <Leader>o o<esc>
nnoremap <Leader>O O<esc>
xnoremap < <gv
xnoremap > >gv

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <Leader>te :tabedit <c-r>=expand("%:p:h")<CR>

" Switch CWD to the directory of the open buffer
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<cr>

" I use this command constantly
nnoremap <Leader>sn :Snippets<CR>
" }}}

" Unimpaired: {{{ 3
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
" In addition I've mapped ]a and [a for Ale nextwrap.
" }}}

" Spell Checking: {{{ 3
nnoremap <Leader>sp :setlocal spell!<CR>
" Based off the default value for spell suggest.
" Don't end with <CR> because this an interactive command!
nnoremap <Leader>s= z=
" }}}

" RSI: {{{ 3
" For Emacs-style editing on the command line. Also considering using these
" insert mode as well. Well i don't know why some of these maps aren't working
" start of line
cnoremap <C-a> <Home>
" back one character
cnoremap <C-b> <Left>
" delete character under cursor
cnoremap <C-d> <Del>
" end of line
cnoremap <C-e> <End>
" forward one character
cnoremap <C-f> <Right>

" **YO! I added unique to these because I went with a general map statement
" Error messages go flying up but they close away immediately
" Either redirect them or do something to make them persist and fix them

" recall newer command-line. {Actually C-n and C-p on Emacs}
map <unique> <A-n> <Down>
" recall previous (older) command-line. {But we can't lose C-n and C-p}
map <unique> <A-p> <Up>
" back one word
map <unique> <A-b> <S-Left>
" forward one word
map <unique> <A-f> <S-Right>
" page down
cnoremap <C-v> <PageDown>
" page up
map <unique> <A-v> <PageUp>
" Let's try this with insert mode since the command mode isn't doing much
inoremap <A-d> <Esc>ldeli
" Well that felt very hacky so I'm going to stop
" In case you were curious what your options were,
" <A-BS> is delete previous word
" C-k is kill from cursor to end of line
" C-u is either kill from cursor to beginning of line or an indication of a
" count with a command
" C-y is yank.
" }}}

" Terminal: {{{ 3
" If running a terminal in Vim, go into Normal mode with Esc
tnoremap <Esc> <C-\><C-n>
" From he term. Rewrite for FZF
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
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
" }}}

" ALE: {{{ 3
nnoremap <Leader>l <Plug>(ale_toggle_buffer) <CR>
nnoremap ]a <Plug>(ale_next_wrap)
nnoremap [a <Plug>(ale_previous_wrap)
" TODO: `:ALEInfoToFile` will write the ALE runtime information to a given
" filename. The filename works just like |:w|. *what does |:w| mean?
nnoremap <unique> <A-a> <Plug>(ale_detail)
" }}}

" Fugitive: {{{ 3
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
nnoremap <silent> <leader>gE :Gedit<space>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gq :Gwq<CR>
nnoremap <silent> <leader>gQ :Gwq!<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gR :Gread<space>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gW :Gwrite!<CR>
" }}}

" Python Language Server: {{{ 3
" }}}

" Tagbar: {{{ 3
nnoremap <silent> <F8> :TagbarToggle<CR>
let g:tagbar_left = 1
" }}}

" Airline: {{{ 3
let g:airline#extensions#tabline#buffer_idx_mode = 1
" originally was nmap and that might've been better. Might clobber markdown.
" headers would be perfect for leader 1
nnoremap <leader>1 <Plug>AirlineSelectTab1
nnoremap <leader>2 <Plug>AirlineSelectTab2
nnoremap <leader>3 <Plug>AirlineSelectTab3
nnoremap <leader>4 <Plug>AirlineSelectTab4
nnoremap <leader>5 <Plug>AirlineSelectTab5
nnoremap <leader>6 <Plug>AirlineSelectTab6
nnoremap <leader>7 <Plug>AirlineSelectTab7
nnoremap <leader>8 <Plug>AirlineSelectTab8
nnoremap <leader>9 <Plug>AirlineSelectTab9
nnoremap <leader>- <Plug>AirlineSelectPrevTab
nnoremap <leader>+ <Plug>AirlineSelectNextTab
" }}}

" }}}

" Macros: {{{ 2
" nvim automatically sources this
if !has('nvim')
    runtime! ftplugin/man.vim
    let g:ft_man_folding_enable = 0
    setlocal keywordprg=Man
else
    setlocal keywordprg=man\ -a
endif

runtime! macros/matchit.vim

set matchpairs+=<:>

" To every plugin I've never used before. Stop slowing me down.
let g:loaded_vimballPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_getsciptPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
" Let's see if this speeds things up because I've never used most of them
" }}}

" FZF: {{{ 2
if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

augroup fzf
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup end

" An action can be a reference to a function that processes selected lines
" is this is a default value in fzf.vim? aka can we scrap it?
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" FZF Colors: {{{ 3
" Customize FZF colors to match your color scheme.
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" }}}

let g:fzf_history_dir = '~/.local/share/fzf-history'

" Between this and FZF.vim you have :Ag and :grep using ag, you should be fine
if executable('ag')
  let &grepprg = 'ag --nogroup --nocolor --column --vimgrep'
  set grepformat=%f%l%c%m
else
  let &grepprg = 'grep -rn $* *'
endif
command! -nargs=1 -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen
" }}}

" FZF_VIM: {{{ 2
" If you're willing to consider it separate than the FZF plugin

" Insert mode completion
" the spell checker already implements something like this but that's why we
" allow remapping and not everyone {termux} has that file
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" command local options:
" [buffers] jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[b]commits] customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%c(auto)%h%d %s %c(black)%c(bold)%cr"'
" [tags] command to generate tags file
let g:fzf_tags_command = 'ctags -r' "
" [commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Ag: {{{ 3
" global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
    \ 'prefix': '^.*$',
    \ 'source': 'rg -n ^ --color always',
    \ 'options': '--ansi --delimiter : --nth 3..',
    \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

" Those last 2 )) are highlighted as a vimopererror and i don't know why
" and it's annoying the fuck out of me

" }}}

" FZF_Statusline: {{{ 3
" custom fzf statusline
function! s:fzf_statusline()
    " override statusline as you like
    highlight fzf1 ctermfg=161 ctermbg=251
    highlight fzf2 ctermfg=23 ctermbg=251
    highlight fzf3 ctermfg=237 ctermbg=251
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

augroup fzfstatusline
    autocmd!
    autocmd! user fzfstatusline call <sid>fzf_statusline()
augroup end

" }}}

" }}}

" Remaining Plugins: {{{ 2

" NERDTree: {{{ 3
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
    autocmd bufenter *
        \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
        \| q
        \| endif
augroup END
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = 'right'
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeNaturalSort = 1
let g:NERDTreeChDirMode = 2                         " change cwd every time NT root changes
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeMouseMode = 2                         " Open dirs with 1 click files with 2
let g:NERDTreeIgnore = ['\.pyc$', '\.pyo$', '__pycache__$', '\.git$']
let g:NERDTreeRespectWildIgnore = 1                 " yeah i meant those ones too
" }}}

" ALE: {{{ 3
let g:ale_fixers = { '*': [ 'remove_trailing_lines', 'trim_whitespace' ] }
let g:ale_fix_on_save = 1
" Default: `'%code: %%s'`
let g:ale_echo_msg_format = '%linter% - %code: %%s %severity%'
let g:ale_set_signs = 1
let g:ale_sign_column_always = 1
let g:ale_lint_delay = 1000
" }}}

" Devicons: {{{ 3
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
" }}}

" Vim_Startify: {{{ 3
" What shows up in the startify list?

function! s:list_commits()
    let git = 'git -C ~/projects/viconf/'
    let commits = systemlist(git .' log --oneline | head -n10')
    let git = 'G'. git[1:]
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

let g:startify_lists = [
    \ { 'header': ['   MRU'],            'type': 'files' },
    \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
    \ { 'header': ['   Sessions'],       'type': 'sessions' },
    \ { 'header': ['   Commits'],        'type': function('s:list_commits') },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ ]

let g:startify_session_sort = 1
let g:startify_update_oldfiles = 1

" Setup devicons
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" Center the header and footer
function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())

" Don't show these files
let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc', ]
    " its explained why this won't. actually great explanation of those weird,
    " afile cfile sfile vars
    " \ '~/.local/share/nvim/plugged/' .*/doc',
    " \ ]
if has('gui_win32')
    let g:startify_session_dir = '$HOME\vimfiles\session'
else
    let g:startify_session_dir = '~/.vim/session'
endif
" TODO: Figure out how to set let g:startify_bookmarks = [ Contents of
" NERDTreeBookmarks ]
let g:startify_change_to_dir = 1
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
let g:startify_session_autoload = 1
" Not 100% sure if the code below works but here's hoping!
let g:startify_skiplist = [
        \ 'COMMIT_EDITMSG',
        \ glob('plugged/*/doc'),
        \ 'C:\Program Files\Vim\vim81\doc',
        \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
        \ ]
" }}}

" UltiSnips: {{{ 3
let g:UltiSnipsSnippetDir = [ '~/.config/nvim/UltiSnips' ]
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'
inoremap <C-Tab> * <Esc>:call ultisnips#listsnippets()<CR>
let g:ultisnips_python_style='numpy'
let g:UltiSnips_python_quoting_style='double'
let g:UltiSnips_python_quoting_style = 'GOOGLE'
let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsEditSplit = 'vertical'

" TODO: Come up with a mapping for it. Also what is E746
" Go to the annotations for an explanation of this function.
" function UltiSnips#IsExpandable()
"     return !(
"         \ col('.') <= 1
"         \ || !empty(matchstr(getline('.'), '\%' . (col('.') - 1) . 'c\s'))
"         \ || empty(UltiSnips#SnippetsInCurrentScope())
"         \ )
" endfunction

" }}}

"Colorscheme: {{{ 3
colorscheme gruvbox
if g:colors_name ==# 'gruvbox'
    let g:gruvbox_contrast_dark = 'hard'
endif
hi NonText guifg=NONE guibg=NONE
" }}}

" Language Client: {{{ 3
" TODO: On termux take this out of mappings. And also debug it because it's erring out
" function LC_maps()
"     if has_key(g:LanguageClient_serverCommands, &filetype)
"         nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
"         nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
"         nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
"     endif
" endfunction

" autocmd FileType * call LC_maps()

if executable('pyls')
    let b:LanguageClient_serverCommands = {
        \ 'python': [ 'pyls' ]
        \ }
endif

let b:LanguageClient_autoStart = 1
let b:LanguageClient_selectionUI = 'fzf'

" }}}

" Jedi: {{{ 3
let g:jedi#use_tabs_not_buffers = 1         " easy to maintain workspaces
" let g:jedi#completions_command = '<C-N>'
let g:jedi#documentation_command = '<leader>h'
let g:jedi#usages_command = '<leader>u'
let g:jedi#show_call_signatures_delay = 100     " wait 100ms instead of 500 to show CS
let g:jedi#smart_auto_mappings = 0              " must be set
let g:jedi#force_py_version = 3
" }}}

" Deoplete_Jedi: {{{ 3
" speed things up
let g:deoplete#sources#jedi#enable_typeinfo = 0
" }}}

" **UNTESTED**: {{{

" just a thought i had. For any normal mode remaps you have, add the same
" thing and prefix <Esc> to the RHS and boom!
if has('b:Tagbar')  " or any plugin
    let g:tagbar_sort=0
    inoremap <F3> <esc>:TagbarToggle<CR>
    nnoremap <F3> :TagbarToggle<CR>
endif
" }}}

" Airline: {{{ 3
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline_skip_empty_sections = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" TODO: Need to add one for the venv nvim
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#tabline#enabled = 0
" }}}

" }}}

" Filetype Specific Options: {{{ 2

augroup ftpersonal
" IPython:
    au BufRead,BufNewFile *.ipy setlocal filetype=python
" Web Dev:
    au filetype javascript,html,css setlocal shiftwidth=2 softtabstop=2 tabstop=2
" Markdown:
    autocmd BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown
augroup end

" Diff: {{{ 3
" It's visually noisy and setting the syntax highlighting to none speeds things
" up to an incredible level.
highlight DiffChanged guibg=None
"
" }}}

" }}}

" Functions: {{{ 2

" Next few are from Junegunn so credit to him

" Todo Function: {{{ 3
function! s:todo() abort
    let entries = []
    for cmd in ['git grep -niI -e TODO -e todo -e FIXME -e XXX 2> /dev/null',
                \ 'grep -rniI -e TODO -e todo -e FIXME -e XXX * 2> /dev/null']
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
" }}}

" Explore: {{{ 3
" Here's one where he uses FZF and Explore to search a packages docs
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
" }}}

" Scriptnames: {{{ 3
" command to filter :scriptnames output by a regex
command! -nargs=1 Scriptnames call <sid>scriptnames(<f-args>)
function! s:scriptnames(re) abort
    redir => scriptnames
    silent scriptnames
    redir END

    let filtered = filter(split(scriptnames, "\n"), "v:val =~ '" . a:re . "'")
    echo join(filtered, "\n")
endfunction
" }}}

" Helptabs: {{{ 3
function! s:helptab()
    if &buftype == 'help'
        wincmd T
        nnoremap <buffer> q :q<CR>
    endif
endfunction
" keeps erroring idk why.
" autocmd vimrc BufEnter *.txt call s:helptab()
" }}}

" AutoSave: {{{ 3
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
" }}}

" HL: {{{ 3
" Whats the syntax group under my cursor?
function! s:hl()
  " echo synIDattr(synID(line('.'), col('.'), 0), 'name')
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction
command! HL call <SID>hl()
" }}}

" *:DiffOrig* *diff-original-file* {{{ 3
" Since 'diff' is a window-local option, it's possible to view the same buffer
" in diff mode in one window and 'normal' in another window.  It is also
" possible to view the changes you have made to a buffer since the file was
" loaded.  Since Vim doesn't allow having two buffers for the same file, you
" need another buffer.  This command is useful: >
command! DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_
    \ | diffthis | wincmd p | diffthis
" Use ':DiffOrig' to see the differences
" between the current buffer and the file it was loaded from.

" }}}

" }}}

" }}}
