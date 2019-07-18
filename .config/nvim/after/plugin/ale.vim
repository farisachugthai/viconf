" ============================================================================
    " File: ale.vim
    " Author: Faris Chugthai
    " Description: Ale configuration
    " Last Modified: Jul 08, 2019
" ============================================================================

" Guard: 
if !has_key(plugs, 'ale')
    finish
endif

if exists('g:did_ale_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_ale_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Mappings: 

" e for error t for toggle
noremap <Leader>et <Cmd>ALEToggleBuffer<CR><bar>echo 'ALE toggled!'<CR>

" Follow the lead of vim-unimpaired with a for ale
noremap ]a <Cmd>ALENextWrap<CR>
noremap [a <Cmd>ALEPreviousWrap<CR>

" `:ALEInfoToFile` will write the ALE runtime information to a given filename.
" The filename works just like |:w|.

" <Meta-a> now gives detailed messages about what the linters have sent to ALE
noremap <A-a> <Cmd>ALEDetail<CR>

" This might be a good idea. * is already 'search for <cword>'
noremap <Leader>* <Cmd>ALEFindReference<CR>

noremap <Leader>a <Cmd>ALEInfo<CR>

" Options: 

" For buffer specific options, see ../ftplugin/*.vim
let g:ale_fixers = { '*': [ 'remove_trailing_lines', 'trim_whitespace' ] }
let g:ale_fix_on_save = 1

let g:ale_linter_aliases = {'ps1': 'powershell'}

" Now because you fix the trailing whitespace and trailing lines
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_warn_about_trailing_blank_lines = 0

" forgot how annoying open list was
" let g:ale_open_list = 1
let g:ale_list_vertical = 1

let g:ale_set_signs = 1
let g:ale_sign_column_always = 1

" Virtualenvs: 
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

if isdirectory('~/virtualenvs')
  let g:ale_virtualenv_dir_names += [expand('~/virtualenvs')]
endif

if isdirectory(expand('~/miniconda3'))
  let g:ale_virtualenv_dir_names +=  [expand('~/miniconda3')]
elseif isdirectory('C:/tools/miniconda3')
  let g:ale_virtualenv_dir_names += ['C:/tools/miniconda3']
endif

let g:ale_cache_executable_check_failures = v:true

" Node: 

if !has('unix')

  if executable('C:/Program\ Files/nodejs/node.exe')
    let g:ale_windows_node_executable_path = 'C:/Program\ Files/nodejs/node.exe'
  " TODO: make an else. possibly use some system calls but those are difficult
  " to handle if an error is raised
  endif
endif

" Quickfix: 

" By default ale uses location list which I never remember
let g:ale_set_quickfix = 1
let g:ale_set_loclist = 0

" Atexit: 
let &cpoptions = s:cpo_save
unlet s:cpo_save
