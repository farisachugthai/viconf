" ============================================================================
  " File: options.vim
  " Author: Faris Chugthai
  " Description: Global options
  " Last Modified: February 16, 2020
" ============================================================================

" Global Options:
scriptencoding utf-8
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

" Folds And Diffs: {{{
set foldopen=insert,jump,block,hor,mark,percent,quickfix,search,tag,undo
setglobal foldnestmax=10
" Oddly needs to be set locally?
set foldmethod=marker foldcolumn=2
" Automatically close all folds from the beginning.
setglobal foldlevelstart=99
" Everything is a fold even if it's one line
setglobal foldminlines=0
" And yes even if it's a comment
setglobal foldignore=
" Automatically open and close folds as i move out and in them.
" setglobal foldopen=all foldclose=all
" nah this is really annoying
setglobal diffopt=filler,context:0,iblank,iwhite,iwhiteeol,indent-heuristic,hiddenoff,foldcolumn:1

if has('patch-8.1.0360') || has('nvim')
  setglobal diffopt+=internal,algorithm:patience
endif
" todo: closeoff
" }}}

" Completions: {{{
setglobal wildignorecase fileignorecase
setglobal wildmode=full:list:longest,full:list
setglobal wildignore=*~,versions/*,.cache/*,.tox/*,.pytest_cache/*,__pycache__/*,build/*,dist/*,.*mypy**/**
setglobal wildcharm=<C-z>
" C-n and C-p now use the same input that every other C-x does combined!
" Remove includes they're pretty slow
setglobal complete=.,w,b,t,kspell,d,k
setglobal completeopt=menu,menuone,noselect,noinsert,preview
" both smartcase and infercase require ignorecase to be set:
setglobal ignorecase

" Path:
let &g:path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'  . ',' . stdpath('config')
if exists('*stdpath')
  let s:stddata = stdpath("data")
else
  let s:stddata = resolve(expand('~/.local/share/nvim'))
endif
let s:stdconfig = exists('*stdpath') ? stdpath('config') : resolve(expand('~/.config/nvim'))

let &g:path = &path . ',' . s:stddata
setglobal path-=/usr/include

" Indentation:
setlocal indentkeys+=<:>,=elif,=except
setlocal indentkeys-=0#
setglobal smartcase infercase smartindent
setglobal regexpengine=2
setglobal cscopetagorder=1  " why does this default to search cscope first?
setglobal shada='100,<50,s10,:3000,%
" default but specify it.
let &g:shadafile = s:stddata.'/site/shada/main.shada'
setglobal formatoptions=crq1j

" Tags:
setglobal tags=tags,**/tags
setglobal tagcase=smart
setglobal showfulltag
if exists('&tagfunc')
  let &g:tagfunc = 'CocTagFunc'
endif
setglobal showfulltag
" }}}

" Other: {{{
packadd! matchit
packadd! justify

setglobal pyxversion=3
" managed to lose this along the way
" to enable transparency but force the current selected element to be fully opaque: >
if exists("&pumblend")
  set pumblend=15
  hi PmenuSel blend=0
endif
setglobal autochdir autowrite autoread

" TODO: clipboards fucking up on windows
setglobal clipboard=unnamed,unnamedplus
set modeline modelines=5

" Tabs:
if &tabstop > 4 | setglobal tabstop=4 | endif
if &shiftwidth > 4  | setglobal shiftwidth=4 | endif
setglobal expandtab smarttab softtabstop=4

if &textwidth!=0 | setl colorcolumn=+1 | else | setl colorcolumn=80 | endif

setglobal cdpath=$HOME,$VIMRUNTIME

" Movement:
" It get kinda annoying movin around without _ as a word delimiter
" Dont use = as an identifier in gf it frequently isn't part of the fname
setglobal isfname-==
setglobal iskeyword=@,48-57,_,192-255   " Idk how but i managed to mess up the default isk
setglobal iskeyword-=.,_

set winblend=10

setglobal suffixes=.bak,~,.o,.info,.swp,.aux,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.inx,.jpg,.log,.out,.png,.toc,.pyc,*.a,*.obj,*.dll,*.exe,*.lib,*.mui,*.swp,*.tmp,

" Buffers Windows:
setglobal pastetoggle=<F9>   " fuck me this is what windows terminal uses for something
setglobal signcolumn=auto:4  " this might be a nvim 4 thing
try | setglobal switchbuf=useopen,split | catch | endtry
setglobal splitbelow splitright
" sidescroll needs to be set low
setglobal sidescroll=0 sidescrolloff=5
setglobal nostartofline
setglobal hidden
set number relativenumber
setglobal cmdheight=3
" why is 20? help windows can be really intrusive with it that high
let s:height = &lines / 4
let &g:previewheight  = s:height
let &g:helpheight = s:height
setglobal scrolloff=0

if filereadable(s:repo_root . '/spell/en.utf-8.add')
  let &g:spellfile = s:repo_root . '/spell/en.utf-8.add'
endif

setglobal sessionoptions-=buffers,winsize viewoptions-=options sessionoptions+=globals
setglobal mouse=a
setglobal selectmode=mouse  " start select mode instead of visual mode because why not
setglobal nojoinspaces
setglobal modeline
if exists('&modelineexpr') | setglobal modelineexpr | endif

setglobal whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
" TODO: closeoff needs to be added conditionally. how?
setglobal browsedir='buffer'   " which directory is used for the file browser

" Unicode Symbols:
let &g:listchars = 'tab:\u21e5\u00b7,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7'
" trail:\u2423 doesn't work with hack as font
let &g:fillchars = "stl:' ',stlnc:' ',vert:\u250b,fold:\u00b7,diff:'.'"
" set fillchars=stl:^,stlnc:=,vert:│,fold:·,diff:-
let &g:showbreak = '↳ '

" Indent wrapped lines correctly
setglobal breakindent breakindentopt=sbr
let &g:showbreak = '↳ '                   " Indent wrapped lines correctly
setglobal updatetime=400 lazyredraw
setglobal inccommand=split
setglobal terse shortmess=aoOsItTWcF
setglobal title titlestring=%<%F%=%l/%L-%P   " leaves a cool title for tmux
setglobal conceallevel=2 concealcursor=nc    " enable concealing
setglobal spellsuggest=5
setglobal showmatch matchpairs+=<:>
setglobal matchtime=20  " Show the matching pair for 2 seconds
set termguicolors
setglobal synmaxcol=1000
set nohlsearch
setglobal regexpengine=2

" Todo:
" g:fugitive_browse_handlers',

" currently dont have enough tlib stuff to warrant a section
let g:tlib_extend_keyagents_InputList_s = {
    \ 10: 'tlib#agent#Down',
    \ 11: 'tlib#agent#Up'
    \ }

" }}}

" Platform Specific Options: {{{
" Fuck this section is slowing startup from 400ms to 1000ms
" if has('unix')
"   call unix#UnixOptions()
"   if getenv($WSL_DISTRO_NAME)
"     let g:coc_cygqwin_path_prefixes = {'c:/Users/fac': '/root'}
"   endif
" else
"   call msdos#set_shell_cmd()

"   let g:coc_cygqwin_path_prefixes = v:false
"   " Find The Ctags Executable:
"   if filereadable(expand('$HOME/src/ctags/ctags.exe'))
"     let g:tagbar_ctags_bin = expand('$HOME/src/ctags/ctags.exe')
"   " elseif executable(exepath('ctags'))
"   "   let g:tagbar_ctags_bin = exepath('ctags')
"   endif

"   " Icon Chars
"   let g:tagbar_iconchars = ['▶', '▼']
" }}}

" Backups: {{{
" Protect changes between writes. Default values of updatecount
" (200 keystrokes) and updatetime (4 seconds) are fine
setglobal swapfile undofile backupext='.bak'
" use rename-and-write-new method whenever safe. actually might go with yes
" its slower but idc
setglobal backupcopy=yes
" patch required to honor double slash at end consolidate the writebackups -- they usually get deleted
let &g:backupdir= s:stddata . '/site/undo//'
" Gotta be honest this part was stolen almost entirely from arch:

let &g:directory=  s:stddata . '/site/cache//'
let &g:undodir =  s:stddata . '/site/undo//'
" Create directories if they doesn't exist
if !isdirectory(expand(&g:directory))
  silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if !isdirectory(expand(&g:backupdir))
  silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if !isdirectory(expand(&g:undodir))
  silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
  let g:fzf_layout = { 'window': 'call plugins#FloatingFZF()' }
else
  let g:fzf_layout = { 'window': '-tabnew' }
endif
" }}}

" QF: {{{
let g:qf_window_bottom = 0
" Huh so this has to be defined for the next 2 to not raise an error
let g:qf_statusline = {}
let g:qf_statusline.before = '%<\ '
let g:qf_statusline.after = '\ %f%=%l\/%-6L\ \ \ \ \ '
let g:qf_mapping_ack_style = 1
let g:qf_max_height = 6
let g:qf_auto_quit = 0
" }}}

" Web Devicon: {{{
let g:webdevicons_enable_nerdtree = 1               " adding the flags to NERDTree
let g:webdevicons_enable_startify = 1
let g:airline_powerline_fonts = 1
let g:DevIconsEnableFoldersOpenClose = 1
" let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''
" Heres a neat one! Fuck
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''
" enable file extension pattern matching glyphs on folder/directory (disabled by default with 0)
let g:DevIconsEnableFolderExtensionPatternMatching = 1
" Heres an example of how to override filetypes.
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed or else it cries that the var wasn't declared in advance
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sqlite'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['python'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cs'] = ''
" }}}

" NERDTree: {{{
let g:NERDTreeCustomOpenArgs = {
      \ 'file': {
            \ 'reuse': 'all',
            \ 'where': 'p',
            \ 'keepopen': 1,
      \ },
      \ 'dir': {}}

" When you open a buffer, how do we do it? Don't only silent edit, keep jumps too
let g:NERDTreeCreatePrefix = 'silent! keepalt keepjumps'
let g:NERDTreeDirArrows = 1
" let g:NERDTreeWinPos = 'right'
let g:NERDTreeShowHidden = 1
" This setting controls the method by which the list of user bookmarks is
" sorted. When sorted, bookmarks will render in alphabetical order by name.
let g:NERDTreeBookmarksSort = 1  " case sensitive
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeNaturalSort = 1
" let g:NERDTreeChdirMode = 1
" change cwd every time NerdTree root changes:
" let g:NERDTreeChDirMode = 2
let g:NERDTreeShowLineNumbers = 1
 " Open dir with 1 keys, files with 2
let g:NERDTreeMouseMode = 2
let g:NERDTreeIgnore = [ '.pyc$', '.pyo$', '__pycache__$', '.git$', '.mypy']
let g:NERDTreeRespectWildIgnore = 1
" let g:NERDTreeAutoDeleteBuffer = 1
" Z is for Zoom why the hell is the default A?
let g:NERDTreeMapToggleZoom = 'Z'
" let g:NERDTreeQuitOnOpen = 3
"
" Is there a way to do this and also make sure that p does the same thing?
" I think we can do something like
" nnoremap - <Cmd>call nerdtree#ui_glue#invokeKeyMap('p')<CR>
" and that'll do exactly what i want; however that'll only work I think if nerdtree's already been
let g:NERDTreeMapJumpParent = '-'

" }}}

" Tagbar: {{{
" I want the spacebar back
let g:tagbar_map_showproto = '?'
" let g:tagbar_left = 2
let g:tagbar_singleclick = 1
let g:tagbar_map_zoomwin = 'Z'
if filereadable(expand('$HOME/.ctags.d/new_universal.ctags'))
  let g:tagbar_ctags_options = [expand('~/.ctags.d/new_universal.ctags')]
endif

let g:tagbar_silent = 1
" }}}

" Gutentags: {{{
let g:gutentags_ctags_exclude = [
      \ '.pyc',
      \ '.eggs',
      \ '.egg-info',
      \ '_static',
      \ '__pycache__',
      \ 'elpy',
      \ 'elpa',
      \ '.ipynb_checkpoints',
      \ '.idea',
      \ 'node_modules',
      \ '_build',
      \ 'build',
      \ '.git',
      \ 'log',
      \ 'tmp',
      \ 'dist',
      \ '.tox',
      \ '.venv',
      \ ]

let g:gutentags_resolve_symlinks = 1
let g:gutentags_file_list_command = 'fd -H -t f --follow .'
" If there's a vscode dir in the root, then use that.
if isdirectory('.vscode')
  let g:gutentags_ctags_tagfile = '.vscode/tags'
endif
" }}}

" UltiSnips: {{{
function! UltiSnipsConf() abort
  let g:UltiSnipsExpandTrigger = '<Tab>'
  let g:UltiSnipsJumpForwardTrigger= '<Tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
  let g:ultisnips_python_style = 'numpy'
  let g:ultisnips_python_quoting_style = 'double'
  let g:UltiSnipsEnableSnipMate = 0
  " context is an interesting option. it's a vert split unless textwidth <= 80
  let g:UltiSnipsEditSplit = 'context'
  let g:snips_author = 'Faris Chugthai'
  let g:snips_github = 'https://github.com/farisachugthai'
  " Defining it and limiting it to 1 directory means that UltiSnips doesn't
  " iterate through every dir in &rtp which saves an immense amount of time
  " on startup.
  let g:UltiSnipsSnippetDirectories = [ expand('$HOME') . '/.config/nvim/UltiSnips' ]
  let g:UltiSnipsUsePythonVersion = 3
  let g:UltiSnipsListSnippets = '<C-/>'
  " Wait is this option still a thing??
  let g:UltiSnipsSnippetDir = [s:stdconfig . '/UltiSnips']
endfunction

call UltiSnipsConf()

" In case you're wondering about this, ultisnips requires python from vim.
" however neovim has it's python interation set up externally. so when i manage
" to fuck it up, ultisnips breaks. so i need to be able to disable it and then
" re-enable it when the python integration is fixed
" }}}

" Supertab: {{{
let g:SuperTabLongestEnhanced = 1
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
        \ ['&completefunc:<c-x><c-u>', '&omnifunc:<c-x><c-o>']

function! MyTagContext() abort
  if filereadable(expand('%:p:h') . '/tags')
    return '\<c-x>\<c-]>'
  endif
  " no return will result in the evaluation of the next
  " configured context
endfunction

function! MyDictContext() abort
  " TODO: Man i otta copy the pathogen slash func because this in't gonna work
  " on windows
  if filereadable('/usr/share/dict/words')
    return '\<C-x>\<C-k>'
  endif

  let l:dict_context = fnamemodify(expand('<sfile>') . ':p:h:h')
  if filereadable(l:dict_context . '/spell/en.utf-8.add')
    return '\<C-x>\<C-k>'
  else
    echo l:dict_context
  endif
endfunction

let g:SuperTabCompletionContexts = [ 's:ContextText', 's:ContextDiscover', 'MyTagContext', 'MyDictContext']
" When enabled, <CR> will cancel completion mode preserving the current text.
let g:SuperTabCrMapping = 1
let g:SuperTabClosePreviewOnPopupClose = 1  " (default value: 0)
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
" }}}

" Startify: {{{
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 0
let g:startify_session_savevars = [
       \ 'g:startify_session_savevars',
       \ 'g:startify_session_savecmds',
       \ ]

" Commands and bookmarks officially use A B C D E F G H I!
let g:startify_commands = [
      \ {'a': 'Ag!'},
      \ {'b': 'e $MYVIMRC'},
      \ {'f': 'FZF! ~'},
      \ {'g': ['Git status!', 'Gstatus'],},
      \ {'h': ['Vim Reference', 'he index.txt'],},
      \ {'m': 'Maps'},
      \ {'o': ['Options', 'exec "e " . stdpath("config") . "/plugin/options.vim"']},
    \ ]

" Also utilize his skiplist
let g:startify_skiplist = [
      \ 'runtime/doc/.*\.txt',
      \ 'bundle/.*/doc/.*\.txt',
      \ 'plugged/.*/doc/.*\.txt',
      \ '/.git/',
      \ 'fugitiveblame$',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc/.*\.txt',
      \ 'COMMIT_EDITMSG',
      \ '^/tmp',
      \ escape(fnamemodify($HOME, ':p'), '\') .'.ssh',
      \ ]

let g:startify_bookmarks = [
      \ { 'c': '~/.local/share/nvim/plugged/coc.nvim'},
      \ { 'd': '~/projects/dynamic_ipython/README.rst'},
      \ { 'i': '~/projects/viconf/init.vim' },
      \ ]

let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions']              },
    \ { 'type': 'commands',  'header': ['   Commands']              },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']             },
    \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()]       },
    \ { 'type': 'files',     'header': ['   MRU']                   },
    \ ]


function! StartifyEntryFormat() abort
  let l:entry_format = "repeat(' ', (3 - strlen(index)))"

  if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
    let l:entry_format .= ". WebDevIconsGetFileTypeSymbol(entry_path) .' '.  entry_path"
    let s:path = WebDevIconsGetFileTypeSymbol(fnamemodify(expand('%'), ':p'))
    return s:path . ' ' . l:entry_format
  else
    let l:entry_format .= '. entry_path'
    return l:entry_format
  endif
endfunction

let g:startify_custom_header ='startify#center(startify#fortune#cowsay())'
" }}}

" Coc: {{{
let g:WorkspaceFolders = [
      \ stdpath('config'),
      \ expand('$HOME/projects/dynamic_ipython'),
      \ expand('$HOME/projects/viconf'),
      \ expand('$HOME/python/tutorials'),
      \ ]

let g:coc_quickfix_open_command = 'cwindow'
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'

let g:coc_enable_locationlist = 1
let $NVIM_COC_LOG_LEVEL = 'WARN'
let $NVIM_COC_LOG_FILE =  s:stddata . '/site/coc.log'
let $NVIM_NODE_LOG_FILE =  s:stddata . '/site/node.log'
let $NVIM_NODE_LOG_LEVEL = 'WARN'
let $NVIM_NODE_HOST_DEBUG = 1
let g:coc_jump_locations = []
let g:node_client_debug = 1
let g:coc_list_loading_status = "I love undocumented features!"

function! s:InitCoc() abort

  if !exists('g:coc_global_extensions')
    let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-python',
          \'coc-git', 'coc-lists', 'coc-snippets', 'coc-sh',
          \ 'coc-highlight', 'coc-tslint-plugin']
  endif

  " Windows setup
    if !has('unix')
      let g:coc_node_path = 'C:\\Users\\fac\\scoop\\apps\\winpython\\current\\n\\node.exe'
      if executable(expand('../node_modules/.bin/bash-language-server'))
        let s:bashlsp = expand('../node_modules/.bin/bash-language-server.cmd')
      else
        let s:bashlsp = 'bash-language-server.cmd'
      endif

      if executable(expand('../node_modules/.bin/vim-language-server'))
        let s:vimlsp = expand('../node_modules/.bin/vim-language-server.cmd')
      else " honestly usually arch just figures this shit out on it's own
        let s:vimlsp = 'vim-language-server.cmd'
      endif

    " unix
    else
      let s:vimlsp = 'vim-language-server'
      let s:bashlsp = 'bash-language-server'
    endif

  if !empty($ANDROID_DATA)
    call coc#config('python.jediEnabled', v:false)
  endif

    call coc#config('languageserver', {
                    \ 'bash': {
                    \   'args': [ 'start' ],
                  \ 'command': s:bashlsp,
                  \ 'filetypes': ['sh', 'bash']}})

  call coc#config('languageserver', {
                  \ 'vimlsp': {
                  \   'command': s:vimlsp,
                  \   'args': ['--stdio'],
                  \   'initializationOptions': {
                  \     'iskeyword': '@,48-57,_,192-255,-#',
                  \     'vimruntime': '$VIMRUNTIME',
                  \     'runtimepath': v:false,
                  \     'diagnostic': {
                  \       'enable': v:true
                  \     },
                  \   'indexes': {
                  \     'count': 3,
                  \     'gap': 100,
                  \     'runtimepath': v:true,
                  \   },
                  \   'suggest': {
                  \     'fromRuntimepath': v:false,
                  \     'fromVimruntime': v:true,
                  \   }},
                  \ 'filetypes': ['vim']}})

endfunction

call s:InitCoc()

" }}}

" FZF: {{{

" Options: {{{

let g:fzf_preview_window = 'right:60%'

let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" NOTE: Use of stdpath() requires nvim0.3>
let g:fzf_history_dir =  s:stddata . '/site/fzf-history'
let g:fzf_ag_options = ' --smart-case -u -g " " --'
let g:fzf_rg_options = ' --hidden --max-columns 300 --max-depth 8 '
      \. '--max-count 50 --color ansi --context 0 '
      \. ' --auto-hybrid-regex --max-columns-preview --smart-case '
      \. '--glob "!{.git,node_modules,*.txt,*.csv,*.json,*.html}" '
let g:fzf_options = [
      \   '--ansi', '--multi', '--tiebreak=index', '--layout=reverse-list',
      \   '--inline-info', '--prompt', '> ', '--bind=ctrl-s:toggle-sort',
      \   '--header', ' Press CTRL-S to toggle sort, CTRL-Y to yank commit hashes',
      \   '--expect=ctrl-y', '--bind', 'alt-a:select-all,alt-d:deselect-all',
      \   '--border', '--cycle'
      \ ]

if exists('$TMUX')
  let g:fzf_prefer_tmux = 1
endif

let g:fzf_commits_log_options = ' --graph --abbrev-commit --abbrev --date=relative'
      \ . ' --color=always --all --branches --pretty'
      \ . ' --format="h%d %Cred%h%Creset -%C(yellow)%d%Creset %s"'
      \ . ' %Cgreen(%cr) %C(bold blue)<%an>%Creset $* " '

let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags -R'
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
  let g:fzf_layout = { 'window': 'call plugins#FloatingFZF()' }
else
  let g:fzf_layout = { 'window': '-tabnew' }
endif
" FOUND ONE
" let g:fzf_files_options = g:fzf_options
" found another one. What is this???
" nnoremap <plug>(-fzf-vim-do) :execute g:__fzf_command<cr>
" }}}

" Statusline and Colorscheme: {{{
let g:fzf_colors =  {
      \  'fg':      ['fg', '#fbf1c7'],
      \  'bg':      ['bg', '#1d2021'],
      \  'hl':      ['fg', '#83a598'],
      \  'fg+':     ['fg', '#ec3836', '#3c3836', '#ebdbb2'],
      \  'bg+':     ['bg', '#ec3836', '#3c3836'],
      \  'hl+':     ['fg', '#fb4934'],
      \  'border':  ['fg', 'Ignore'],
      \  'info':    ['fg', '#fabd2f'],
      \  'prompt':  ['fg', '#fe8019'],
      \  'pointer': ['fg', '#fb4934'],
      \  'marker':  ['fg', '#fb4934'],
      \  'spinner': ['fg', '#b8bb26'],
      \  'header':  ['fg', '#83a598']
      \ }
" }}}
" }}}

" Tmuxline: {{{
let g:tmuxline_status_justify = 'centre'
let g:tmuxline_preset = {
      \ 'a'    : ['#[fg=#504945,bg=#dfbf8e] ▶ #S'],
      \ 'win'  : ['#I', '#W'],
      \ 'cwin' : ['#I', '#W'],
      \ 'y'    : ['#(uptime  | cut -d " " -f 1,2,3)'],
      \ 'z'    : ['#(whoami)', '#H'],}

" After defining all of these groups and format blocks, let's
" define the tmux line to match our vim statusline
let s:tmuxline_themes =  s:stddata . '/plugged/tmuxline.vim/autoload/themes'

if filereadable(s:tmuxline_themes . '/vim_statusline_3.vim')
  execute 'source ' . s:tmuxline_themes . '/vim_statusline_3.vim'
  let g:tmuxline_theme = 'vim_statusline_3'
endif

let g:tmuxline_powerline_separators = {
     \ 'left' : '»',
     \ 'left_alt': '▶',
     \ 'right' : '«',
     \ 'right_alt' : '◀',
     \ 'space' : ' '}
" }}}

" Voom: {{{
let g:voom_ft_modes = {'markdown': 'markdown', 'rst': 'rst', 'zimwiki': 'dokuwiki'}
let g:voom_default_mode = 'rst'
let g:voom_python_versions = [3,2]
" You conditionally can't use << or <C-Left> unless your node is the furthest down the stack
" But that's kinda dumb.
let g:voom_always_allow_move_left = 1
" }}}

" Omnisharp: {{{

let g:OmniSharp_want_snippet=1
" Otherwise it goes in some random cache folder that I'll end up deleting
let g:OmniSharp_server_install =  s:stddata . '/site/omnisharp'

let g:OmniSharp_server_stdio = 1
" let g:OmniSharp_server_stdio = 1

" Dude they wrote everything python that's dope
let g:OmniSharp_loglevel = 'DEBUG'

" It's faster when it's not in python though
let g:OmniSharp_server_stdio = 1

" Python logging path
let g:OmniSharp_python_path =  s:stddata . '/site/log'

" " Defaults:
" let g:OmniSharp_highlight_groups = {
" \ 'csUserIdentifier': [
" \   'constant name', 'enum member name', 'field name', 'identifier',
" \   'local name', 'parameter name', 'property name', 'static symbol'],
" \ 'csUserInterface': ['interface name'],
" \ 'csUserMethod': ['extension method name', 'method name'],
" \ 'csUserType': ['class name', 'enum name', 'namespace name', 'struct name']
" \}

let g:OmniSharp_timeout = 5

" Update semantic highlighting after all text changes
" let g:OmniSharp_highlight_types = 3
" Update semantic highlighting on BufEnter and InsertLeave
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_selector_ui = 'fzf'

" }}}

" Which Key: {{{

let g:which_key_align_by_seperator = 1
let g:which_key_use_floating_win = 1
let g:which_key_run_map_on_popup = 1
let g:which_key_fallback_to_native_key=1

let g:which_key_map = {}
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : ['resize +5'  , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : ['resize -5'  , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window']            ,
      \ }

" Create new menus not based on existing mappings:
  let g:which_key_map.b = {
       \ 'name' : '+buffer' ,
       \ '1' : ['b1'        , 'buffer 1']        ,
       \ '2' : ['b2'        , 'buffer 2']        ,
       \ 'd' : ['bd'        , 'delete-buffer']   ,
       \ 'f' : ['bfirst'    , 'first-buffer']    ,
       \ 'h' : ['Startify'  , 'home-buffer']     ,
       \ 'l' : ['blast'     , 'last-buffer']     ,
       \ 'n' : ['bnext'     , 'next-buffer']     ,
       \ 'p' : ['bprevious' , 'previous-buffer'] ,
       \ '?' : ['Buffers'   , 'fzf-buffer']      ,
       \ }
" }}}

" ALE: {{{
" Example from the help page
" Use just ESLint for linting and fixing files which end in '.js'
let g:ale_pattern_options = {
            \   '\.js$': {
            \       'ale_linters': ['eslint'],
            \       'ale_fixers': ['eslint'],
            \ },
            \ }

let g:ale_lsp_show_message_severity = 'information'

  let g:ale_python_pyls_config = {
        \   'pyls': {
        \     'plugins': {
        \       'flake8': {
        \         'enabled': v:true
        \       },
        \ 'jedi_completion': {
        \   'enabled': v:true
        \ },
        \ 'jedi_hover': {
        \   'enabled': v:true
        \ },
        \ 'jedi_references': {
        \   'enabled': v:true
        \ },
        \ 'jedi_signature_help': {
        \   'enabled': v:true
        \ },
        \ 'jedi_symbols': {
        \   'all_scopes': v:true,
        \   'enabled': v:true
        \ },
        \ 'mccabe': {
        \   'enabled': v:true,
        \   'threshold': 15
        \ },
        \ 'preload': {
        \   'enabled': v:true
        \ },
        \ 'pycodestyle': {
        \   'enabled': v:false
        \ },
        \ 'pydocstyle': {
        \   'enabled': v:true,
        \   'match': '(?!test_).*\\.py',
        \   'matchDir': '[^\\.].*'
        \ },
        \ 'pyflakes': {
        \   'enabled': v:true
        \ },
        \ 'rope_completion': {
        \   'enabled': v:true
        \ },
        \ 'yapf': {
        \   'enabled': v:true
        \       }
        \     }
        \   }
        \ }

  let g:ale_python_auto_pipenv = 1
  let g:ale_python_black_auto_pipenv = 1
  let g:ale_python_pydocstyle_auto_pipenv = 1
  let g:ale_python_flake8_auto_pipenv = 1
  let g:ale_python_pyls_auto_pipenv = 1

  " Checkout ale/autoload/ale/python.vim this is the base definition
  let g:ale_virtualenv_dir_names = [
      \   '.env',
      \   '.venv',
      \   'env',
      \   've-py3',
      \   've',
      \   'virtualenv',
      \   'venv',
      \ ]

  if isdirectory(expand('~/.virtualenvs'))
    let g:ale_virtualenv_dir_names += [expand('~/.virtualenvs')]
  endif

  if isdirectory(expand('~/scoop/apps/winpython/current'))
    let g:ale_virtualenv_dir_names +=  [expand('~/scoop/apps/winpython/current')]
  endif

  if isdirectory(expand('~/.local/share/virtualenvs'))
    let g:ale_virtualenv_dir_names += [ expand('~/.local/share/virtualenvs') ]
  endif

  let g:ale_cache_executable_check_failures = v:true
  " let g:ale_linters_ignore = {'python': ['pylint']}


" from the indent.vim
" ***
" BUG
" ***
" Uh setting this raises on windows...constantly
" let g:pyindent_disable_parentheses_indenting = 0

let g:pyindent_searchpair_timeout = '250'
" ALE
let g:python_pyls_auto_pipenv = 1
" from the indent.vim
" ***
" BUG
" ***
" Uh setting this raises on windows...constantly
" let g:pyindent_disable_parentheses_indenting = 0

let g:pyindent_searchpair_timeout = '250'
" ALE
let g:python_pyls_auto_pipenv = 1
" }}}

" Vim: set fdm=marker:
