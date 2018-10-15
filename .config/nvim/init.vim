" init.vim
" Neovim configuration

" All: {{{ 1

" TODO: Dude this made such a big performance difference
" Probably wanna put in a better spot tho
hi NonText guifg=NONE guibg=NONE

" About: {{{ 2
let g:snips_author = 'Faris Chugthai'
let g:snips_email = 'farischugthai@gmail.com'
let g:snips_github = 'https://github.com/farisachugthai'
" }}}

" Environment: {{{ 2
" Let's setup all the global vars we need. Will utilize to ensure consistency

let s:termux = exists('$PREFIX')
let s:ubuntu = !exists('$PREFIX') && has('unix')  " syntax?
" }}}

" Vim Plug: {{{ 2
" TODO: Can we have plug open in a tab not a vsplit?
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdTree', { 'on': 'NERDTreeToggle' }
" Nothing happens if we open a directory to start nvim
"TODO: one of the expressions in the loop needs to be prepended with silent
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
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'w0rp/ale'
Plug 'morhetz/gruvbox'
Plug 'christoomey/vim-tmux-navigator'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'mhinz/vim-startify'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
Plug 'zchee/deoplete-jedi', { 'for': ['python', 'python3'] }
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'godlygeek/tabular'
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

if has('nvim')
    set inccommand=split                      " This alone is enough to never go back
endif
set termguicolors
" }}}

" Python Executables: {{{ 2

" TODO: Determine OS then check if has('win32') || has('win64')
" axtually as long as linux defines conda_exe were good!
if has('python3')
" if we have a virtual env start there
    if exists('$VIRTUAL_ENV')
        let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'

    elseif exists('$CONDA_PYTHON_EXE')
        let g:python3_host_prog = $CONDA_PYTHON_EXE

    " otherwise break up termux and linux
    elseif exists('$PREFIX')
        " and just use the system python
        if executable('~/virtualenvs/neovim/bin/python3')
            let g:python3_host_prog = '~/virtualenvs/neovim/bin/python3'
        endif
    else
        if executable('~/miniconda3/envs/neovim_vscode/bin/python')
            let g:python3_host_prog = '~/miniconda3/envs/neovim_vscode/bin/python'
        endif
    endif
endif
" }}}

" Global Options: {{{ 2

" Leader_Viminfo: {{{ 3
let g:mapleader = "\<Space>"
let g:maplocalleader=','

if !has('nvim')
    set viminfo='100,<200,s200,n$HOME/.vim/viminfo
endif
" }}}

" Pep8 Global Options: {{{ 3
set tabstop=4
set shiftwidth=4
set expandtab smarttab
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

set browsedir=buffer    " now changing directories starts from your current buf
" }}}

" Spell Checker: {{{ 3

if &encoding ==# 'latin1' && has('gui_running')
    set encoding=UTF-8                       " Set default encoding
    scriptencoding UTF-8                     " Vint believes encoding should be done first
    set fileencoding=UTF-8
endif

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
    setlocal dictionary+=/usr/share/dict/words
    " Dictionary completion with fzf-based fuzzy completion
    inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
    setlocal dictionary+=/usr/share/dict/american-english
endif

if filereadable(glob('$HOME/.vim/autocorrect.vim'))
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
" }}}

" Other Global Options: {{{ 3
set tags+=./tags,./../tags,./*/tags     " usr_29
set tags+=~/projects/tags               " consider generating a few large tag
set tags+=~python/tags                  " files rather than recursive searches
set mouse=a                             " Automatically enable mouse usage
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
" set gcr=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

set path+=**        			        " Recursively search dirs with :find
set autochdir
set fileformat=unix
set whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
set nojoinspaces
set diffopt=vertical,context:3          " vertical split d: Recent modifications from jupyter nteractiffs. def cont is 6

if has('persistent_undo')
    set undodir=~/.vim/undodir
    set undofile	" keep an undo file (undo changes after closing)
endif

set backupdir=~/.vim/undodir
set modeline

set lazyredraw
set ttimeout
set ttimeoutlen=50
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

" Navigate tabs more easily
nnoremap <A-Right> :tabnext<CR>
nnoremap <A-Left> :tabprev<CR>

" Simple way to speed up startup
nnoremap <Leader>nt :NERDTreeToggle<CR>

" Select all text quickly
"nnoremap <Leader>a ggVG
" use builtin :%y
" nnoremap <Leader>a :echo('No. Use :%y')<CR>

" It should be easier to get help
nnoremap <leader>he :helpgrep<space>
" It should also be easier to edit the config. Bind similarly to tmux
" TODO: What is vims version of realpath()? Can't find it even w/ helpgrep
nnoremap <leader>ed :tabe $MYVIMRC<CR>
" Now reload it
nnoremap <leader>re :so $MYVIMRC<CR>

" Escape conveniences
inoremap jk <Esc>
vnoremap jk <Esc>

" Junegunn:
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>
xnoremap < <gv
xnoremap > >gv

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>

" Switch CWD to the directory of the open buffer
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" I use this command constantly
nnoremap <leader>sn :Snippets<cr>
" }}}

" Unimpaired: {{{ 3
" Note that ]c and [c are also mapped by git-gutter
" In addition I've mapped ]a and [a for ALE nextwrap.
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>
nnoremap ]Q :cfirst<cr>
nnoremap [Q :clast<cr>
nnoremap ]l :lnext<cr>
nnoremap [l :lprev<cr>
nnoremap ]L :lfirst<CR>
nnoremap [L :llast<CR>
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>
nnoremap ]B :blast<cr>
nnoremap [B :bfirst<cr>
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>
nnoremap ]T :tfirst<cr>
nnoremap [T :tlast<cr>
" }}}

" Spell Checking: {{{ 3
nnoremap <Leader>sp :setlocal spell!<CR>
" Based off the default value for spell suggest
nnoremap <Leader>s= :norm z=<CR>
" }}}

" RSI: {{{ 3
" For Emacs-style editing on the command-line:
" Would we consider doing this in insert mode as well?

" sonuvabitch i just found out that this is basically rsi.vim

" start of line
cnoremap <C-A> <Home>
" back one character
cnoremap <C-B> <Left>
" delete character under cursor
cnoremap <C-D> <Del>
" end of line
cnoremap <C-E> <End>
" forward one character
cnoremap <C-F> <Right>
" recall newer command-line (but leave C-n and C-p)
cnoremap <A-N> <Down>
" recall previous (older) command-line
cnoremap <A-P> <Up>
" back one word
cnoremap <Esc><C-B> <S-Left>
" forward one word
cnoremap <Esc><C-F> <S-Right>
" }}}

" Terminal: {{{ 3
" If running a terminal in Vim, go into Normal mode with Esc
tnoremap <Esc> <C-W>N
" from he term. Rewrite for FZF
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
" TODO: Implement ALEInfoToFile.
" `:ALEInfoToFile` will write the ALE runtime information to a given filename. The filename works just like |:w|.

" This might be a good idea. * is already 'search for the cword' so let ALE
" work in a similar manner right?
nnoremap <Leader>* <Plug>(ale_go_to_reference)

nnoremap <Leader>a :ALEInfo<cr>
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

" Tagbar: {{{
nnoremap <silent> <F8> :TagbarToggle<CR>
"}}}

" }}}

" Macros Packages: {{{ 2

if !has('nvim')
    " Invoke while in Vim by putting your cursor over a word and run <Leader>k
    runtime! ftplugin/man.vim
    let g:ft_man_folding_enable = 0
    setlocal keywordprg=:Man
endif

runtime! macros/matchit.vim
"}}}

" To every plugin I've never used before. Stop slowing me down.
let g:loaded_vimballPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_getsciptPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
" Let's see if this speeds things up because I've never used most of them
" }}}

" Plugins: {{{ 2


" FZF: {{{ 2

if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" An action can be a reference to a function that processes selected lines
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

" FZF Colors: {{{ 4
" Customize FZF colors to match your color scheme
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

if executable('ag')
  let &grepprg = 'ag --nogroup --nocolor --column --vimgrep'
    set grepformat=%f:%l:%c:%m
else
  let &grepprg = 'grep -rn $* *'
endif

command! -nargs=1 -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen

" Insert mode completion:
" the spell checker already implements something like this but that's why we allow remapping and not everyoone {termux} has that file
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Command local options:
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R' "
" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Ag:
"   :Ag  - Start fzf with hidden preview window that can be enabled with '?' key
" :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \ : fzf#vim#with_preview('right:50%:hidden', '?'),
    \ <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \ : fzf#vim#with_preview('right:50%:hidden', '?'),
    \ <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
    \ 'prefix': '^.*$',
    \ 'source': 'rg -n ^ --color always',
    \ 'options': '--ansi --delimiter : --nth 3..',
    \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

" Custom fzf statusline
function! s:fzf_statusline()
    " Override statusline as you like
    highlight fzf1 ctermfg=161 ctermbg=251
    highlight fzf2 ctermfg=23 ctermbg=251
    highlight fzf3 ctermfg=237 ctermbg=251
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

augroup fzfstatusline
    autocmd!
    autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END

" }}}

" Other Plugins: {{{ 2

" nvim automatically sources this
if !has('nvim')
    " Invoke while in Vim by putting your cursor over a word and run <Leader>k
    runtime! ftplugin/man.vim
    let g:ft_man_folding_enable = 0
    setlocal keywordprg=Man
else
    setl keywordprg=Man
    " g:man_default_sects="1,7,8,5"
endif

runtime! macros/matchit.vim
set matchpairs+=<:>

" NERDTree: {{{ 3
" Let's see if this works properly as a group
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
let g:NERDTreeIgnore = ['\.pyc$', '\.pyo$', '__pycache__$']
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
" }}}

" UltiSnips: {{{ 3
let g:UltiSnipsSnippetDir = ['~/.config/nvim/UltiSnips']
" don't do this. it doesn't allow for ultisnips to iterate in the way it needs
" to and snippets entirely stop working
" let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips']
" the 2 below aee the defaults yet list snippets doesn't work
let g:UltiSnipsExpandTrigger='<Tab>'
let g:UltiSnipsListSnippets='<C-Tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'
inoremap <C-Tab> * <Esc>:call UltiSnips#ListSnippets()<CR>
let g:UltiSnips_python_style='sphinx'
let g:UltiSnips_python_quoting_style = 'double'
let g:UltiSnipsEnableSnipMate = 1
let g:UltiSnipsEditSplit = 'tabdo'
" }}}

" Gruvbox: {{{ 3
colorscheme gruvbox
" can't do this because we have no let g:colors_name stmt
if g:colors_name ==# 'gruvbox'      " ==# means match case
    let g:gruvbox_contrast_dark = 'hard'
endif
" }}}

" Jedi: {{{ 3
" Isn't recognized as an ftplugin so probably needs to be in global conf
let g:jedi#use_tabs_not_buffers = 1         " easy to maintain workspaces
let g:jedi#completions_command = '<C-N>'
let g:jedi#documentation_command = '<leader>h'
let g:jedi#usages_command = '<leader>u'
let g:jedi#show_call_signatures_delay = 100
let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 3
" }}}

" Deoplete-Jedi: {{{ 3
" speed things up
let g:deoplete#sources#jedi#enable_typeinfo = 0
" }}}

" Nord: {{{ 3
" colorscheme nord
" }}}

" }}}

" Filetype Specific Options: {{{ 2
" For setting the python so that Deoplete can use it.

augroup ftpersonal

" IPython:
    au BufRead,BufNewFile *.ipy setlocal filetype=python
" Web Dev:
    au filetype javascript,html,css setlocal shiftwidth=2 softtabstop=2 tabstop=2
" Markdown:
    autocmd BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown

augroup end
" }}}

" Functions and Commands: {{{ 2

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
" Here's one where he uses fzf and Explore to search a packages docs
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
"command to filter :scriptnames output by a regex
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
    if &buftype ==# 'help'
        wincmd T
        nnoremap <buffer> q :q<cr>
    endif
endfunction
" keeps erroring idk why.
" autocmd vimrc BufEnter *.txt call s:helptab()
" Let's try this.
command! -nargs=1 Help call <SID>helptab()

" }}}

" Autosave: {{{ 3
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

" Highlighting: {{{ 3
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

" EditFileComplete: {{{
" From he map line 1287
com! -nargs=1 -bang -complete=customlist,EditFileComplete
       \ EditFile edit<bang> <args>
fun! EditFileComplete(A,L,P)
    return split(globpath(&path, a:A), "\n")
endfun

" }}}

" }}}

" }}}
