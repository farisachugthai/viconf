" ============================================================================
  " File: options.vim
  " Author: Faris Chugthai
  " Description: Global options
  " Last Modified: February 16, 2020
" ============================================================================

" if exists('g:loaded_options') || &compatible || v:version < 700
"   finish
" endif
" let g:loaded_options = 1

scriptencoding utf-8
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

" Global Options: {{{
" Folds: {{{

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
" }}}

" Diffs:{{{
setglobal diffopt=filler,context:0,iblank,iwhite,iwhiteeol,indent-heuristic,hiddenoff,foldcolumn:1

if has('patch-8.1.0360') || has('nvim')
  setglobal diffopt+=internal,algorithm:patience
endif
" todo: closeoff
" }}}

if &tabstop > 4 | setglobal tabstop=4 | endif
if &shiftwidth > 4  | setglobal shiftwidth=4 | endif
setglobal expandtab smarttab softtabstop=4

setglobal tags=tags,**/tags
setglobal tagcase=smart showfulltag

function! TagFunc(pattern, flags, info) abort   " {{{
" Lol literally what is this option?
" well fuck. just errored on nvim4
  function! CompareFilenames(item1, item2) abort
    let f1 = a:item1['filename']
    let f2 = a:item2['filename']
    return f1 >=# f2 ?
    \ -1 : f1 <=# f2 ? 1 : 0
  endfunction

  let result = taglist(a:pattern)
  call sort(result, 'CompareFilenames')

  return result
endfunction  " }}}

if exists('&tagfunc')
  let &g:tagfunc = 'TagFunc'
endif

" Platform Specific Options: {{{

if has('unix')
  call unix#UnixOptions()
else
  call msdos#set_shell_cmd()
endif
" }}}

" Grepprg: {{{
try
  " if you don't have fd or rg installed you shouldn't lose highlighting
  call syncom#grepprg()
catch /.*/
endtry
" }}}


if exists('$ANDROID_DATA')   " {{{ Remote Hosts
  " Fuck i had to change this because wsl was loading termux jesus christ
  call find_files#termux_remote()
elseif !has('unix')
  " Note: dude holy hell is it necessary to call the msdos#set_shell_cmd()
  " func. you do so in ./plugin/unix.vim but jesus christ did it fuck stuff up
  " when that got deleted
  call find_files#msdos_remote()
else
  call find_files#ubuntu_remote()
endif
" }}}

" }}}

" Web Devicon: {{{
let g:webdevicons_enable_nerdtree = 1               " adding the flags to NERDTree
let g:webdevicons_enable_startify = 1

let g:airline_powerline_fonts = 1
let g:DevIconsEnableFoldersOpenClose = 1

" change the default character when no match found
" Heres the original
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

" ALE: {{{

" UI: {{{
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix =  'ALE: '
let g:ale_virtualtext_delay = 200
let g:ale_sign_highlight_linenrs = 1

" But lets try opening the preview window when the cursor moves to something
" let g:ale_cursor_detail = 1
" holy fuck no
let g:ale_close_preview_on_insert = 1
let g:ale_echo_cursor = 1

let g:ale_completion_enabled = 1

" }}}

" Signs: {{{

let g:ale_set_signs = 1
let g:ale_sign_column_always = 1
let g:ale_change_sign_column_color = 1
let g:ale_sign_warning = 'W'
let g:ale_sign_info = 'I'
let g:ale_sign_error = 'E'
let g:ale_sign_highlight_linenrs = 1
let g:ale_sign_style_warning = 'E'

" More:

let g:ale_pattern_options_enabled = 1
let g:ale_pattern_options = {'\.min.js$': {'ale_enabled': 0}}

" For buffer specific options, see ../ftplugin/*.vim
let g:ale_fixers = { '*': [ 'remove_trailing_lines', 'trim_whitespace' ] }
let g:ale_fix_on_save = 1

" When ALE is linting bash files recognize it as sh
let g:ale_linter_aliases = {
      \ 'ps1': 'powershell',
      \ 'htmljinja': ['html', 'handlebars'],
      \ 'htmldjango': 'html',
      \ 'bash': 'sh',
      \ }

" When ale is linting C# only use OmniSharp
let g:ale_linters = {
      \ 'cs': ['OmniSharp']
      \ }

" forgot how annoying open list was
" let g:ale_open_list = 1
let g:ale_list_vertical = 1
" }}}

" Python specific globals: {{{

" Goddamn this is so long I might wanna autoload this no?
" Eh. Nah.
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

if isdirectory(expand('~/virtualenvs'))
  let g:ale_virtualenv_dir_names += [expand('~/virtualenvs')]
endif

if isdirectory(expand('~/miniconda3'))
  let g:ale_virtualenv_dir_names +=  [expand('~/miniconda3')]
elseif isdirectory('C:/tools/miniconda3')
  let g:ale_virtualenv_dir_names += ['C:/tools/miniconda3']
endif

if isdirectory(expand('~/.local/share/virtualenvs'))
  let g:ale_virtualenv_dir_names += [ expand('~/.local/share/virtualenvs') ]
endif

let g:ale_cache_executable_check_failures = v:true
let g:ale_linters_ignore = {'python': ['pylint']}

" Example from the help page
" Use just ESLint for linting and fixing files which end in '.foo.js'
let g:ale_pattern_options = {
\   '\.foo\.js$': {
\       'ale_linters': ['eslint'],
\       'ale_fixers': ['eslint'],
\   },
\}
let g:ale_lsp_show_message_severity = 'information'

" }}}

" }}}

" NERDTree: {{{

let g:NERDTreeCustomOpenArgs = {
      \ 'file': {
            \ 'reuse': 'all',
            \ 'where': 'p',
            \ 'keepopen': 1,
      \ },
      \ 'dir': {}}

" When you open a buffer, how do we do it? Don't only silent edit, keep jumps
" too
let g:NERDTreeCreatePrefix = 'silent keepalt keepjumps'

let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = 'right'

" UI: {{{
let g:NERDTreeShowHidden = 1

" This setting controls the method by which the list of user bookmarks is
" sorted. When sorted, bookmarks will render in alphabetical order by name.
let g:NERDTreeBookmarksSort = 1  " case sensitive

let g:NERDTreeShowBookmarks = 1

let g:NERDTreeNaturalSort = 1

" }}}

" change cwd every time NerdTree root changes: {{{
" let g:NERDTreeChDirMode = 2

let g:NERDTreeShowLineNumbers = 1

 " Open dir with 1 keys, files with 2
let g:NERDTreeMouseMode = 2

let g:NERDTreeIgnore = [ '.pyc$', '.pyo$', '__pycache__$', '.git$', '.mypy', 'node_modules']
let g:NERDTreeRespectWildIgnore = 1

" Let's give netrw a shot I guess. No lets not.
let g:NERDTreeHijackNetrw = 1

let g:NERDTreeAutoDeleteBuffer = 1

" Why did i do this?
" That nerdtree.root.path.str() is too long to see on Termux tho
" let s:stl = &statusline

" default
" let g:NERDTreeStatusline = "%{exists('b:NERDTree') ? b:NERDTree.root.path.str() : s:stl }"

let g:NERDTreeMapToggleZoom = 'Z'  " Z is for Zoom why the hell is the default A?

" let g:NERDTreeGlyphReadOnly = 'U+237A'  " literally never gonna remember i did this but oh well

" To open a file always in the current tab, and expand directories in place, >
" let g:NERDTreeCustomOpenArgs = {'file': {'reuse':'currenttab', 'where':'p', 'keepopen':1, 'stay':1}}

" This setting governs whether the NERDTree window or the bookmarks table closes
" after opening a file with the |NERDTree-o|, |NERDTree-i|, |NERDTree-t| and
" |NERDTree-T| mappings.

"  Value  | NERDTree Window Behavior
"  -------+-------------------------------------------------------
"  0      | No change
"  1      | Closes after opening a file
"  2      | Closes the bookmark table after opening a bookmark
"  3(1+2) | Same as both 1 and 2

let g:NERDTreeQuitOnOpen = 3

" }}}

" }}}

" Fugitive: {{{

let g:fugitive_git_executable = 'git'

" }}}

" Tagbar: {{{

" General Options: {{{

" I want the spacebar back
let g:tagbar_map_showproto = '?'
let g:tagbar_left = 1
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
let g:tagbar_autoclose = 1

" -1: Use the global line number settings.
" Well that just feels like the courteous thing to do right?
let g:tagbar_show_linenumbers = -1

" Actually let's fold this a bit more.
" Default is 99 btw
let g:tagbar_foldlevel = 1

" If this variable is set to 1 then moving the cursor in the Tagbar window will
" automatically show the current tag in the preview window.
" Dude it takes up a crazy amount of room on termux and is generally quite annoying
" Don't know why we only went with windows only. that setting is annoying
" everywhere.
let g:tagbar_autopreview = 0

let g:tagbar_map_zoomwin = 'Z'

" }}}

" Platform Specific Options: {{{
if !has('unix')

  " let g:tagbar_autopreview = 1
  " Find the ctags executable: {{{
  if filereadable(expand('$HOME/src/ctags/ctags.exe'))
    let g:tagbar_ctags_bin = expand('$HOME/src/ctags/ctags.exe')
  elseif executable(exepath('ctags'))
    let g:tagbar_ctags_bin = exepath('ctags')
  endif  " }}}

  if filereadable(expand('$HOME/.ctags.d/new_universal.ctags'))
    let g:tagbar_ctags_options = [expand('~/.ctags.d/new_universal.ctags')]
  endif
  " Icon Chars
        " let g:tagbar_iconchars = ['▸', '▾']
        " let g:tagbar_iconchars = ['▷', '◢']
        " let g:tagbar_iconchars = ['+', '-']  (default on Windows)
  " Uh so all of these displayed correctly even on windows so give me some
  " cooler ones
  let g:tagbar_iconchars = ['▶', '▼']
else
  let g:tagbar_iconchars = ['▷', '◢']

endif

" Setting this option will result in Tagbar omitting the short help at the
" top of the window and the blank lines in between top-level scopes in order to
" save screen real estate.
" Termux needs this
if exists($ANDROID_ROOT) | let g:tagbar_compact = 1 | endif
" }}}

" Tagbar Types: {{{
let g:tagbar_type_ansible = {
	\ 'ctagstype' : 'ansible',
	\ 'kinds' : [
	\ 't:tasks'
	\ ],
	\ 'sort' : 0
  \ }

let g:tagbar_type_css = {
    \ 'ctagstype' : 'Css',
    \ 'kinds'     : [
    \ 'c:classes',
    \ 's:selectors',
    \ 'i:identities'
    \ ]
    \ }

let g:tagbar_type_make = {
            \ 'kinds':[
            \ 'm:macros',
            \ 't:targets'
            \ ]
            \ }

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

  " \ 'ctagsargs' : ['-f', 'tags', '--encoding="utf-8"',
  "                \ '--sort=yes', '--sro="»"'],

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
" Could check for loaded_gutentags = 1 but idk if we're loading before him or
" not
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

" Oddly, setting this var only sets it in select-mode though.
" So let's add a few mappings to help us along.

" }}}

" Supertab: {{{
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
  elseif filereadable(fnamemodify(expand('<sfile>') ':p:h:h') . '/spell/en.utf-8.add')
    return "\<C-x>\<C-k>"
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

" let g:startify_use_env = 1
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
" let g:startify_session_sort = 1
" let g:startify_relative_path = 1
let g:startify_change_to_vcs_root = 0

" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
" let g:startify_session_autoload = 1
" let g:startify_session_sort = 1

let g:startify_session_savevars = [
       \ 'g:startify_session_savevars',
       \ 'g:startify_session_savecmds',
       \ ]

       " 'g:random_plugin_use_feature'
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
" TODO:
" so obviously only do this on windows. shit there are so many things that we need to configure
" list.source.tags.command: ~/bin/ctags.exe -R --options=~/.ctags/universal_ctags.ctags .,

" if exists('g:node_host_prog') | let g:coc_node_path = g:node_host_prog | endif
if !has('unix')
  let g:coc_node_path = 'C:\Users\fac\scoop\apps\nvm\current\v13.7.0\node.exe'
endif

" TODO:
" May have to extend after a has('unix') check.
" Yeah probably need to make system checks to get rid of incorrect
" non portable definitions in the JSON file.
let g:WorkspaceFolders = [
      \ stdpath('config'),
      \ expand('$HOME/projects/dynamic_ipython'),
      \ expand('$HOME/projects/viconf'),
      \ expand('$HOME/python/tutorials'),
      \ ]

let g:coc_quickfix_open_command = 'cwindow'
" let g:coc_snippet_next = '<Tab>'
" let g:coc_snippet_prev = '<S-Tab>'

let g:coc_enable_locationlist = 1
let $NVIM_COC_LOG_LEVEL = 'WARN'
let $NVIM_COC_LOG_FILE = stdpath('data') . '/site/coc.log'
let $NVIM_NODE_LOG_FILE = stdpath('data') . '/site/node.log'
let $NVIM_NODE_LOG_LEVEL = 'WARN'

" Lets define this.
let g:coc_jump_locations = []

" This raises a lot of errors
" call coc#snippet#enable()
" }}}

" FZF: {{{

" Ensure it actually loaded: {{{

" if !exists(':FZF') | call plug#load('fzf') | endif
" " let g:fzf_command_prefix = 'Fuf'
" if !exists(':Rg') | call plug#load('fzf.vim') | endif

" Set up windows to have the correct commands
if !exists('$FZF_DEFAULT_COMMAND')  || !has('unix')
  " let $FZF_DEFAULT_COMMAND = 'rg --hidden -M 200 -m 200 --smart-case --passthru --files . '
  let $FZF_DEFAULT_COMMAND = 'fd --hidden --follow -d 6 -t f '
endif  " }}}

" Options: {{{
let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" NOTE: Use of stdpath() requires nvim0.3>
let g:fzf_history_dir = stdpath('data') . '/site/fzf-history'

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
  let g:fzf_layout = { 'window': 'call plugins#FloatingFZF()' }
else
  let g:fzf_layout = { 'window': '-tabnew' }
endif

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

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = ' --graph'
      \ . ' --color=always --all --branches --pretty'
      \ . ' --format="h%d %s $* " '

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
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

function! s:fzf_statusline()
  " Override statusline as you like
  hi! fzf1 cterm=bold,underline,reverse gui=bold,underline,reverse guifg=#7daea3
  hi! link fzf2 fzf1
  hi! link fzf3 fzf1
  setlocal statusline=%#fzf1#\ FZF:\ %#fzf2#fz%#fzf3#f
endfunction

" NOTE: This has to remain the name of the augroup it's what Junegunn calls
augroup FZFStatusline
  au!
  autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END

" }}}
" }}}

" Statusline: {{{

function! StatusDiagnostic() abort  " {{{
  if !exists('g:loaded_coc') | return '' | endif

  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction  " }}}

function! s:Statusline() abort  " {{{

  " Define statusline groups for WebDevIcons, Fugitive and other plugins.
  " Define empty fallbacks if those plugins aren't installed. Then
  " use the builtins to fill out the information.
  if exists('*WebDevIconsGetFileTypeSymbol')
    let dicons = '%{WebDevIconsGetFileTypeSymbol()}'
  else
    let dicons = ''
  endif
  let fug = " %{exists('g:loaded_fugitive') ? FugitiveStatusline() : ''} "
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '

  if exists('*CSV_WCol')
    " Doing it the exact way he specifies in the help docs means you don't get
    " tsv support
    if &filetype ==# 'tsv' || &filetype ==# 'csv'
      let csv = '%1*%{CSV_WCol()}%*'
    else
      let csv = ''
    endif
  else
    let csv = ''
  endif

  if exists('*strftime')
    " Overtakes the whole screen when Termux zooms in
    if &columns > 80
      let tstmp = ' %{strftime("%H:%M %m-%d-%Y", getftime(expand("%:p")))}'
      " last modified timestamp
    else
      let tstmp = ''
    endif
  else
    let tstmp = ''  " ternary expressions should get on the todo list
  endif

  " from he 'statusline'.
  " Each status line item is of the form:
  " %-0{minwid}.{maxwid}{item}
  let cos = " %{exists('g:did_coc_loaded') ? coc#status() : ''} "

  let cog = ' %{exists("coc_git_status") ? coc_git_status : ""} '

  " shit g:ale_enabled == 0 returns True
  let ale_stl = '%{exists("g:ale_enabled") ? "[ALE]" : ""}'

  let s:gutentags = '%{exists("g:gutentags_enabled") ? gutentags#statusline() : ""}'


  return '[%n] ' . dicons . '%m' . '%r' . ' %y '
        \. fug . csv
        \. ' %{&ff} ' . tstmp
        \. cos . cog
        \. StatusDiagnostic()
        \. ' %f'
        \. sep
        \. ale_stl
        \. s:gutentags
        \. pos . '%*' . ' %P'

endfunction  " }}}

function! Statusline_expr() abort  " {{{
  " Lets give a nicer clean entry point.
  return s:Statusline()
endfunction  " }}}

augroup UserStatusline  " {{{

  au!
  au BufEnter * let &statusline = Statusline_expr()
augroup END  " }}}

command! -bar ReloadStatusline call s:Statusline()
" }}}

" Fix the path: {{{

if !exists('b:did_ftplugin')
  if exists('*stdpath')  " fuckin vim
    let &path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'  . ',' . stdpath('config')
  else
    let &path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'
  endif
endif " }}}

" Last Call For Options: {{{
if &omnifunc ==# '' | setlocal omnifunc=syntaxcomplete#Complete | endif

if &completefunc ==# '' | setlocal completefunc=syntaxcomplete#Complete | endif  " }}}

" Vim: set fdm=marker:
