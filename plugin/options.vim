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
setglobal foldnestmax=10
" Oddly needs to be set locally?
set foldmethod=marker foldcolumn=2
" Automatically close all folds from the beginning.
setglobal foldlevelstart=0
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
setglobal wildignorecase
setglobal wildmode=full:list:longest,full:list
setglobal wildignore=*~,versions/*,cache/*,.tox/*,.pytest_cache/*,__pycache__/*
setglobal wildcharm=<C-z>
" C-n and C-p now use the same input that every other C-x does combined!
" Remove includes they're pretty slow
setglobal complete=.,w,b,t,kspell,d,k
setglobal completeopt=menu,menuone,noselect,noinsert,preview
" both smartcase and infercase require ignorecase to be set:
setglobal ignorecase
setglobal smartcase infercase smartindent

" Couple tag related things
setglobal tags=tags,**/tags
setglobal tagcase=smart
setglobal showfulltag
if exists('&tagfunc')
  let &g:tagfunc = 'CocTagFunc'
endif
" }}}

" Other: {{{
packadd! matchit
packadd! justify
setglobal autochdir autowrite autoread
if &tabstop > 4 | setglobal tabstop=4 | endif
if &shiftwidth > 4  | setglobal shiftwidth=4 | endif
setglobal expandtab smarttab softtabstop=4
set nohlsearch
if &textwidth!=0 | setl colorcolumn=+1 | else | setl colorcolumn=80 | endif
setglobal cdpath+=$HOME,$VIMRUNTIME
setglobal iskeyword=@,48-57,_,192-255   " Idk how but i managed to mess up the default isk
setlocal termguicolors
colo gruvbox-material
set winblend=10
setglobal suffixes=.bak,~,.o,.info,.swp,.aux,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.inx,.jpg,.log,.out,.png,.toc,.pyc,*.a,*.obj,*.dll,*.exe,*.lib,*.mui,*.swp,*.tmp,

setglobal pastetoggle=<F9>   " fuck me this is what windows terminal uses for something
setglobal signcolumn=auto:4  " this might be a nvim 4 thing
try | setglobal switchbuf=useopen,usetab,split | catch | endtry
setglobal splitbelow splitright
setglobal sidescroll=5 hidden
" dude these stopped setting when i set global them
set number relativenumber
setglobal cmdheight=3
setglobal helpheight=8  " why is 20? help windows can be really intrusive with it that high

if filereadable(s:repo_root . '/spell/en.utf-8.add')
  let &g:spellfile = s:repo_root . '/spell/en.utf-8.add'
endif
let &g:path = &path . ',' . stdpath('data')
setglobal path-=/usr/include
setglobal sessionoptions-=buffers,winsize viewoptions-=options sessionoptions+=globals
setglobal mouse=a
setglobal nojoinspaces
setglobal modeline
if exists('&modelineexpr') | setglobal modelineexpr | endif

setglobal whichwrap+=<,>,h,l,[,]              " Reasonable line wrapping
" TODO: closeoff needs to be added conditionally. how?
setglobal browsedir="buffer"   " which directory is used for the file browser

let &g:listchars = "tab:\u21e5\u00b7,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
" trail:\u2423 doesn't work with hack as font
let &g:fillchars = "stl:' ',stlnc:' ',vert:\u250b,fold:\u00b7,diff:'.'"
" set fillchars=stl:^,stlnc:=,vert:│,fold:·,diff:-

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
" dude holy hell are we running faster on termux set termguicolors
setglobal synmaxcol=1000
" }}}

" Platform Specific Options: {{{
if has('unix')
  call unix#UnixOptions()
  let g:startify_change_to_dir = 1
  let g:tagbar_iconchars = ['▷', '◢']
  let g:startify_change_to_dir = 1
else
  " XXX: might wanna change this:
  " let $FZF_DEFAULT_COMMAND = 'rg --hidden -M 200 -m 200 --smart-case --passthru --files . '
  " let $FZF_DEFAULT_COMMAND = 'fd --hidden --follow -d 6 -t f '
  unlet! $FZF_DEFAULT_OPTS
  unlet! $FZF_DEFAULT_COMMAND
  call msdos#set_shell_cmd()

  " Find The Ctags Executable:
  if filereadable(expand('$HOME/src/ctags/ctags.exe'))
    let g:tagbar_ctags_bin = expand('$HOME/src/ctags/ctags.exe')
  elseif executable(exepath('ctags'))
    let g:tagbar_ctags_bin = exepath('ctags')
  endif

  if filereadable(expand('$HOME/.ctags.d/new_universal.ctags'))
    let g:tagbar_ctags_options = [expand('~/.ctags.d/new_universal.ctags')]
  endif
  " Icon Chars
  let g:tagbar_iconchars = ['▶', '▼']
endif
" }}}

" Backups: {{{
" Protect changes between writes. Default values of updatecount
" (200 keystrokes) and updatetime (4 seconds) are fine
setglobal swapfile undofile backupext='.bak'
" use rename-and-write-new method whenever safe. actually might go with yes
" its slower but idc
setglobal backupcopy=yes
" patch required to honor double slash at end consolidate the writebackups -- they usually get deleted
let &g:backupdir=stdpath('data') . '/site/undo//'
" Gotta be honest this part was stolen almost entirely from arch:

let &g:directory= stdpath('data') . '/site/cache//'
let &g:undodir = stdpath('data') . '/site/undo//'
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
" }}}

" Remote Hosts: {{{
if exists('$ANDROID_DATA')
  call find_files#termux_remote()

  let g:tagbar_compact = 1
elseif !has('unix')
  " Note: dude holy hell is it necessary to call the msdos#set_shell_cmd()
  " func. you do so in ./plugin/unix.vim but jesus christ did it fuck stuff up
  " when that got deleted
  call find_files#msdos_remote()
else
  call find_files#ubuntu_remote()
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

" Black: {{{
let g:load_black = 'py1.0'
if !exists('g:black_virtualenv')
  if has('nvim')
    let g:black_virtualenv = '~/.local/share/nvim/black'
  else
    let g:black_virtualenv = '~/.vim/black'
  endif
endif
if !exists('g:black_fast')
  let g:black_fast = 0
endif
if !exists('g:black_linelength')
  let g:black_linelength = 88
endif
if !exists('g:black_skip_string_normalization')
  let g:black_skip_string_normalization = 0
endif

" If things slow down autoload these.
command! Black py3 Black()
command! BlackUpgrade py3 BlackUpgrade()
command! BlackVersion py3 BlackVersion()
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
let g:NERDTreeCreatePrefix = 'silent keepalt keepjumps'
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = 'right'
let g:NERDTreeShowHidden = 1
" This setting controls the method by which the list of user bookmarks is
" sorted. When sorted, bookmarks will render in alphabetical order by name.
let g:NERDTreeBookmarksSort = 1  " case sensitive
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeNaturalSort = 1
" change cwd every time NerdTree root changes:
" let g:NERDTreeChDirMode = 2
let g:NERDTreeShowLineNumbers = 1
 " Open dir with 1 keys, files with 2
let g:NERDTreeMouseMode = 2
let g:NERDTreeIgnore = [ '.pyc$', '.pyo$', '__pycache__$', '.git$', '.mypy']
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMapToggleZoom = 'Z'  " Z is for Zoom why the hell is the default A?
let g:NERDTreeQuitOnOpen = 3
" }}}

" Tagbar: {{{
" I want the spacebar back
let g:tagbar_map_showproto = '?'
let g:tagbar_left = 2
let g:tagbar_width = 30
let g:tagbar_sort = 0
let g:tagbar_singleclick = 1
let g:tagbar_hide_nonpublic = 0
let g:tagbar_autoshowtag = 1

" Literally ruins my ability to see any other messages i might care about
let g:tagbar_silent = 1

" If you set this option the Tagbar window will automatically close when you
" jump to a tag. This implies |g:tagbar_autofocus|. If enabled the "C" flag will
" be shown in the statusline of the Tagbar window.
" Actually I like having it open
let g:tagbar_autoclose = 0

" -1: Use the global line number settings.
" Well that just feels like the courteous thing to do right?
let g:tagbar_show_linenumbers = -1

" Actually let's fold this a bit more. Default is 99 btw
let g:tagbar_foldlevel = 0

" If this variable is set to 1 then moving the cursor in the Tagbar window will
" automatically show the current tag in the preview window.
" Dude it takes up a crazy amount of room on termux and is generally quite annoying
let g:tagbar_autopreview = 0

let g:tagbar_map_zoomwin = 'Z'

" Tagbar Types: {{{
let g:tagbar_type_ansible = {
	\ 'ctagstype' : 'ansible',
	\ 'kinds' : [
	\ 't:tasks'],
	\ 'sort' : 0 }

let g:tagbar_type_css = {
    \ 'ctagstype' : 'Css',
    \ 'kinds'     : [
    \ 'c:classes',
    \ 's:selectors',
    \ 'i:identities']}

let g:tagbar_type_make = {'kinds':[
            \ 'm:macros',
            \ 't:targets'
            \ ]}

let g:tagbar_type_javascript = {
      \ 'ctagstype': 'javascript',
      \ 'kinds': [
      \ 'A:arrays',
      \ 'P:properties',
      \ 'T:tags',
      \ 'O:objects',
      \ 'G:generator functions',
      \ 'F:functions',
      \ 'C:constructors/classes',
      \ 'M:methods',
      \ 'V:variables',
      \ 'I:imports',
      \ 'E:exports',
      \ 'S:styled components',
      \ ]}

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
\ }

let g:tagbar_type_ps1 = {
    \ 'ctagstype' : 'powershell',
    \ 'kinds'     : [
        \ 'f:function',
        \ 'i:filter',
        \ 'a:alias'
    \ ]
\ }

let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : expand('$HOME/src/rst2ctags/rst2ctags.py'),
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
  \ 'c:classes',
  \ 'n:modules',
  \ 'f:functions',
  \ 'v:variables',
  \ 'v:varlambdas',
  \ 'm:members',
  \ 'i:interfaces',
  \ 'e:enums',
  \ ]
  \ }

let g:tagbar_type_snippets = {
      \ 'ctagstype' : 'snippets',
      \ 'kinds' : [
      \ 's:snippets',
      \ ]
      \ }
" }}}

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

" g:gutentags_file_list_command
" Specifies command(s) to use to list files for which tags should be generated, instead of recursively
" examining all files within the project root. When invoked, file list commands will execute in the
" project root directory.
" This setting is useful in projects using source control to restrict tag generation to only files
" tracked in the repository.

let g:gutentags_file_list_command = 'fd -H -t f --follow .'

" If there's a vscode dir in the root, then use that.
if isdirectory('.vscode')
  let g:gutentags_ctags_tagfile = '.vscode/tags'
endif

" }}}

" UltiSnips: {{{
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:ultisnips_python_style = 'numpy'
let g:ultisnips_python_quoting_style = 'double'
let g:UltiSnipsEnableSnipMate = 0
" context is an interesting option. it's a vert split unless textwidth <= 80
let g:UltiSnipsEditSplit = 'context'
let g:snips_author = 'Faris Chugthai'
let g:snips_github = 'https://github.com/farisachugthai'
let g:UltiSnipsSnippetDir = [stdpath('config') . '/UltiSnips']
" Defining it and limiting it to 1 directory means that UltiSnips doesn't
" iterate through every dir in &rtp which saves an immense amount of time
" on startup.
let g:UltiSnipsSnippetDirectories = [ stdpath('config') . '/UltiSnips' ]
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsListSnippets = '<C-/>'
" }}}

" Supertab: {{{

let g:SuperTabLongestEnhanced = 1
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
        \ ['&completefunc:<c-x><c-u>', '&omnifunc:<c-x><c-o>']

function! MyTagContext() abort
  if filereadable(expand('%:p:h') . '/tags')
    return "\<c-x>\<c-]>"
  endif
  " no return will result in the evaluation of the next
  " configured context
endfunction

function! MyDictContext() abort
  " TODO: Man i otta copy the pathogen slash func because this in't gonna work
  " on windows
  if filereadable('/usr/share/dict/words')
    return "\<C-x>\<C-k>"
  endif

  let l:dict_context = fnamemodify(expand('<sfile>') . ':p:h:h')
  if filereadable(l:dict_context . '/spell/en.utf-8.add')
    return "\<C-x>\<C-k>"
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
if has('unix')
  let g:startify_change_to_dir = 1
endif

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
      \ {'b': 'Buffers!'},
      \ {'f': ['FZF! ~', 'FZF! ~'],},
      \ {'g': ['Git status!', 'Gstatus'],},
      \ {'h': ['Vim Reference', 'h ref'],},
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
  let entry_format = "repeat(' ', (3 - strlen(index)))"

  if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
    let entry_format .= ". WebDevIconsGetFileTypeSymbol(entry_path) .' '.  entry_path"
    let s:path = WebDevIconsGetFileTypeSymbol(fnamemodify(expand('%'), ':p'))
    return s:path . " " . entry_path
  else
    let entry_format .= '. entry_path'
    return entry_format
  endif
endfunction

let g:startify_custom_header ='startify#center(startify#fortune#cowsay())'
" }}}

" Coc: {{{
" Yeah probably need to make system checks to get rid of incorrect
" non portable definitions in the JSON file. Like pythonPath? Holy shit.
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
let $NVIM_COC_LOG_FILE = stdpath('data') . '/site/coc.log'
let $NVIM_NODE_LOG_FILE = stdpath('data') . '/site/node.log'
let $NVIM_NODE_LOG_LEVEL = 'WARN'
let $NVIM_NODE_HOST_DEBUG = 1
let g:coc_jump_locations = []

" This info gets mixed up on windows too often. But it should probs be a
" function. whatever
for i in ['coc-json', 'coc-tsserver', 'coc-python', 'coc-git', 'coc-lists', 'coc-snippets', 'coc-sh']
  if exists('g:coc_global_extensions')
    if !index(g:coc_global_extensions, i)
      exec 'call coc#add_extension(' . i . ')'
    endif
  endif
endfor
" }}}

" FZF: {{{

" Options: {{{
let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" NOTE: Use of stdpath() requires nvim0.3>
let g:fzf_history_dir = stdpath('data') . '/site/fzf-history'

let g:fzf_ag_options = ' --smart-case -u -g " " --'

" TODO: Might wanna consider turning this into a list
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
let g:tmuxline_powerline_separators = 1
let g:tmuxline_status_justify = 'centre'
let g:tmuxline_powerline_separators = 1
let g:tmuxline_preset = {
      \ 'a'    : ['#[fg=#504945,bg=#dfbf8e] ▶ #S'],
      \ 'win'  : ['#I', '#W'],
      \ 'cwin' : ['#I', '#W'],
      \ 'y'    : ['#(uptime  | cut -d " " -f 1,2,3)'],
      \ 'z'    : ['#(whoami)', '#H'],}

" After defining all of these groups and format blocks, let's
" define the tmux line to match our vim statusline
let s:tmuxline_themes = stdpath('data') . '/plugged/tmuxline.vim/autoload/themes'

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

" Goyo: {{{

function! s:goyo_enter()  " {{{
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  " ... Limelight
endfunction  " }}}

function! s:goyo_leave()   " {{{
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  " ... Limelight!
endfunction  " }}}

" }}}

" Voom: {{{
let g:voom_ft_modes = {'markdown': 'markdown', 'rst': 'rst', 'zimwiki': 'dokuwiki'}
let g:voom_default_mode = 'rst'
let g:voom_python_versions = [3,2]
" You conditionally can't use << or <C-Left> unless your node is the furthest down the stack
" But that's kinda dumb.
let g:voom_always_allow_move_left = 1
" }}}

" Fix the path + Last Call For Options: {{{
let &path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'  . ',' . stdpath('config')

if &omnifunc ==# '' | setlocal omnifunc=syntaxcomplete#Complete | endif
if &completefunc ==# '' | setlocal completefunc=syntaxcomplete#Complete | endif
" }}}
"
" Vim: set fdm=marker:
