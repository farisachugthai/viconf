" ============================================================================
    " File: ale.vim
    " Author: Faris Chugthai
    " Description: Ale configuration. Had to be moved out of after/plugin
    " Last Modified: Dec 27, 2019
" ============================================================================

" Virtualtext: {{{
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix =  'ALE: '
let g:ale_virtualtext_delay = 200
let g:ale_sign_highlight_linenrs = 1

" But lets try opening the preview window when the cursor moves to something
" let g:ale_cursor_detail = 1
" holy fuck no
let g:ale_close_preview_on_insert = 1
let g:ale_echo_cursor = 0

" }}}
"
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

" Python specific globals: {{{1

" Goddamn this is so long I might wanna autoload this no?

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

" Vim: set fdm=marker:
