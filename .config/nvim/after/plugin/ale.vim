" ============================================================================
    " File: ale.vim
    " Author: Faris Chugthai
    " Description: Ale configuration
    " Last Modified: Sep 29, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_ale_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_ale_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Mappings: {{{1

" Follow the lead of vim-unimpaired with a for ale
noremap ]a <Cmd>ALENextWrap<CR>zv
noremap [a <Cmd>ALEPreviousWrap<CR>zv

" `:ALEInfoToFile` will write the ALE runtime information to a given filename.
" The filename works just like |:w|.

" <Meta-a> now gives detailed messages about what the linters have sent to ALE
noremap <A-a> <Cmd>ALEDetail<CR>zz

" I'm gonna make all my ALE mappings start with Alt so it's easier to
" distinguish
noremap <A-r> <Cmd>ALEFindReference<CR>

" Dude why can't i get plug mappings right???
noremap <A-i> <Plug>(ale-info)zzza
" noremap <A-i> <Cmd>ALEInfo<CR>

" Options: {{{1

" For buffer specific options, see ../ftplugin/*.vim
let g:ale_fixers = { '*': [ 'remove_trailing_lines', 'trim_whitespace' ] }
let g:ale_fix_on_save = 1

" let g:ale_linters_explicit = 1
let g:ale_linter_aliases = {
      \ 'ps1': 'powershell'
      \ }

" Now because you fix the trailing whitespace and trailing lines
" let g:ale_warn_about_trailing_whitespace = 0
" let g:ale_warn_about_trailing_blank_lines = 0

" forgot how annoying open list was
" let g:ale_open_list = 1
let g:ale_list_vertical = 1

let g:ale_set_signs = 1
let g:ale_sign_column_always = 1
let g:ale_change_sign_column_color = 1

" Virtualenvs: {{{1

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

" Node: {{{1

if !has('unix')
  if executable(exepath('node.exe'))
    let g:ale_windows_node_executable_path = exepath('node.exe')
  endif
endif

" Quickfix: {{{1

" By default ale uses location list which I never remember
" let g:ale_set_quickfix = 1
" let g:ale_set_loclist = 0
" Yeah but theres a reason they do it. Location list is window specific so you
" only want linting information for your current buffer to populate the list.
" More importantly, you don't want every buffer to wipe your quickfix list
" while you're in the middle of recompiling something.

let g:ale_virtualtext_cursor = 1
let g:ale_sign_highlight_linenrs = 1

let g:ale_pattern_options = {'\.min.js$': {'ale_enabled': 0}}


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
