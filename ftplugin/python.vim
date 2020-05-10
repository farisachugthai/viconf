" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: Oct 18, 2019
" ============================================================================

" Globals: {{{
let g:python_highlight_all = 1
let g:python_space_error_highlight = 1

" Indent after an open paren: >
let g:pyindent_open_paren = 'shiftwidth() * 2'
" Indent after a nested paren: >
let g:pyindent_nested_paren = 'shiftwidth()'
" Indent for a continuation line: >
let g:pyindent_continue = 'shiftwidth() * 2'
let g:pydoc_executable = 1
" from the indent.vim
let g:pyindent_disable_parentheses_indenting = 0
let g:pyindent_searchpair_timeout = '250'
" ALE
let g:python_pyls_auto_pipenv = 1

" }}}

" Filetype Specific Options: {{{
if has('win32') || has('win64')
  setlocal keywordprg=python\ -m\ pydoc\
else
  setlocal keywordprg=pydoc
endif

source $VIMRUNTIME/ftplugin/python.vim
if exists('b:did_indent') | unlet! b:did_indent | endif
source $VIMRUNTIME/indent/python.vim

" Idk why but their indentexpr wont stop raising
" First one from $VIMRUNTIME/indent/python.vim 2nd from the ftplugin
setlocal indentkeys+=<:>,=elif,=except
setlocal indentkeys-=0#
" But lets set the other stuff first
setlocal autoindent
setlocal indentexpr=
setlocal nowrap

setlocal nolinebreak  " Dont set this on itll create syntaxerors
setlocal textwidth=80
setlocal tagcase=smart
setlocal comments=b:#,fb:-
setlocal commentstring=#\ %s
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4

setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal cinkeys-=0#

setlocal nolisp		" Make sure lisp indenting doesn't supersede us

setlocal include=^\\s*\\(from\\\|import\\)
" this is in the help docs for `:he includeexpr` and states for java but i bet
" itd work for python
setlocal includeexpr=substitute(v:fname,'\\.','/','g')

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
setlocal foldmethod=indent

setlocal tags=tags,**,$HOME/**
setlocal suffixesadd=.py,pyi,__init__.py
setlocal suffixes+=.pyc
setlocal omnifunc=python3complete#Complete

setlocal isfname+=.
" It get kinda annoying movin around without _ as a word delimiter
setlocal iskeyword-=.,_

setlocal shiftround
setlocal cindent
let &l:path = py#PythonPath()

" Dude the original ftplugin doesn't set up match words. why are the vim
" ftplugins so fucking sparse?
if exists('loaded_matchit')
  " Use case with matchit.
  let b:match_ignorecase = 0

  " why dont more ftplugins utilize matchit?
  " oh it's because this is hard as fuck
  " You can use |zero-width| patterns such as |\@<=| and |\zs|.  (The latter has
  " not been thouroughly tested in matchit.vim.)  For example, if the keyword "if"
  " must occur at the start of the line, with optional white space, you might use
  " the pattern "\(^\s*\)\@<=if" so that the cursor will end on the "i" instead of
  " at the start of the line.
  "
  " UGH FUCK THIS DOESNT WORK
  let b:match_words = '\(^\s*\)\@<=\<if\>:\<elif\>:\<else\>,'
                  \ . '\(^\s*\)\@<=\<def\>:\<return\>,'

  " let b:match_words = '\<if\>:\<elif\>:\<else\>,'
  "                 \ . '\<repeat\>:\<until\>'

  " let b:match_words = '\<if\>:\<elif\>:\<else\>,'

endif
" }}}

" Mappings: {{{

" Don't know how I haven't done this yet.
" TODO: Add ranges so we can do py3do on lines
noremap <buffer> <F5> <Cmd>py3f %<CR>
noremap! <buffer> <F5> <Cmd>py3f %<CR>

" TODO: should we do the xnoremap part too?
nnoremap <buffer> K <Cmd>PydocShow<CR>

" Lol spacemacs had me do this a few times
nnoremap <buffer> ,eb <Cmd>py3f %<CR>
" }}}

" Commands And Cleanup: {{{
" if executable('yapf')
"   command! -buffer -complete=buffer -nargs=0 YAPF call py#YAPF()
"   command! -buffer -complete=buffer -nargs=0 YAPFI exec '!yapf -i %'
"   command! -buffer -complete=buffer -nargs=0 YAPFD cexpr! exec '!yapf -d %'

" else
"   if executable('autopep8')
"     command! -nargs=0 -complete=buffer -buffer Autopep8 cexpr! exec '!autopep8 -i ' . shellescape(<q-args>) . expand('%')
"     command! -nargs=0 Autopep8 exec '!autopep8 -i %'
"   endif
" endif

call py#ALE_Python_Conf()

" Just tried this and it worked! So keep checking :CocCommand output
if !empty('g:did_coc_loaded')
  command! -nargs=* -bar CocPython call CocActionAsync('runCommand', 'python.startREPL', shellescape(<q-args>))
endif

" Use standard compiler settings unless user wants otherwise
if !exists("current_compiler")
  if executable('pytest')
    compiler pytest
    setlocal makeprg=pytest\ -q\ %
  else
    " note this compiler actually setting mp for us too!
    compiler pylint
  endif
endif

if !exists('b:loaded_ale_python')

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

  " Example from the help page
  " Use just ESLint for linting and fixing files which end in '.js'
  let g:ale_pattern_options = {
              \   '\.js$': {
              \       'ale_linters': ['eslint'],
              \       'ale_fixers': ['eslint'],
              \ },
              \ }

  let g:ale_lsp_show_message_severity = 'information'
  let b:loaded_ale_python = 1
endif


let b:undo_ftplugin .= '|setlocal lbr< tw< cms< et< sts< ts<'
      \ . '|setlocal su< sw< cc< fdm< kp<'
      \ . '|setlocal sr< sua< isf< ep< fp< path< cinw<'
      \ . '|setlocal mp< efm< isk< tags<'
      \ . '|setlocal comments<'
      \ . '|setlocal include< inex<'
      \ . '|setlocal indk< inde'
      \ . '|setlocal omnifunc<'
      \ . '|setlocal ai< cin< cink<'
      \ . '|silent! unmap <buffer> <F5>'
      \ . '|silent! nunmap <buffer> K'
      \ . '|silent! unmap! <buffer> <F5>'
      \ . '|silent! nunmap <buffer> ,eb'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
" }}}
"
