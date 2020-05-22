" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: May 12, 2020
" ============================================================================

" Globals:
  let g:python_highlight_all = 1
  let g:python_space_error_highlight = 1
  let g:pydoc_executable = 1
  if exists('b:did_ftplugin') | finish | endif


" Filetype Specific Options:
  if has('win32') || has('win64')
    setlocal keywordprg=python\ -m\ pydoc\
  else
    setlocal keywordprg=pydoc
  endif

  source $VIMRUNTIME/autoload/python3complete.vim
  setlocal omnifunc=python3complete#Complete
  source $VIMRUNTIME/ftplugin/python.vim

  setlocal tagcase=smart
  setlocal tabstop=4
  setlocal colorcolumn=80,120
  setlocal foldmethod=indent
  setlocal foldlevelstart=0 foldignore=

  setlocal tags=tags,**,$HOME/**
  setlocal suffixesadd=.py,pyi,__init__.py
  setlocal suffixes+=.pyc

  setlocal isfname+=.
  setlocal iskeyword-=.,_
  setlocal shiftround
  setlocal cindent
  let &l:path = py#PythonPath()

  if exists('loaded_matchit')
    " Use case with matchit.
    let b:match_ignorecase = 0

    " You can use |zero-width| patterns such as |\@<=| and |\zs|.  (The latter has
    " not been thouroughly tested in matchit.vim.)  For example, if the keyword "if"
    " must occur at the start of the line, with optional white space, you might use
    " the pattern "\(^\s*\)\@<=if" so that the cursor will end on the "i" instead of
    " at the start of the line.
    let b:match_words = '\(^\s*\)\@<=\<if\>:\<elif\>:\<else\>,'
                    \ . '\(^\s*\)\@<=\<def\>:\<return\>,'

  endif


" Mappings:
  noremap <buffer> <F5> <Cmd>py3f %<CR>
  noremap! <buffer> <F5> <Cmd>py3f %<CR>

  " TODO: should we do the xnoremap part too?
  nnoremap <buffer> g<C-]> <Cmd>call pydoc_help#Pydoc('', expand('<cfile>'))<CR>
  nnoremap <buffer> gK <Cmd>PydocShow<CR>

  nnoremap <buffer> g<C-]> <Cmd>call pydoc_help#Pydoc('', expand('<cfile>'))<CR>
  nnoremap <buffer> gK <Cmd>PydocShow<CR>

  " Lol spacemacs had me do this a few times
  nnoremap <buffer> ,eb <Cmd>py3f %<CR>

  " Dude i forgot how awesome this function is
  nnoremap <expr><buffer> <C-p> pydoc_help#async_cfile()


" Commands And Cleanup:
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
    let b:ale_linters = ['flake8', 'pydocstyle', 'pyls']
    let b:ale_linters_explicit = 1
    let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
    let b:ale_fixers += [ 'reorder-python-imports' ]
    let b:ale_fixers += ['autopep8']
    let b:ale_fixers += ['isort']
    let b:loaded_ale_python = 1
  endif


let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal lbr< tw< cms<'
      \. '|setlocal et< sts< ts< su< sw< cc< fdm<'
      \. '|setlocal fdls< fdi< kp< sr< sua< isf< ep<'
      \. '|setlocal fp< path< cinw< mp< efm<'
      \. '|setlocal isk< tags< com< inc< inex<'
      \. '|setlocal indk< inde ofu< ai< cin< cink<'
      \. '|silent! unmap <buffer> <F5>'
      \. '|silent! nunmap <buffer> K'
      \. '|silent! unmap! <buffer> <F5>'
      \. '|silent! nunmap <buffer> ,eb'
      \. '|silent! nunmap <buffer> g<C-]>'
      \. '|silent! nunmap <buffer> gK'
      \. '|unlet! b:undo_ftplugin'
      \. '|unlet! b:did_ftplugin'
      \. '|unlet! b:did_indent'
      \. '|unlet! b:ale_linters'
      \. '|unlet! b:ale_fixers'
      \. '|unlet! b:ale_linters_explicit'
      \. '|unlet! b:loaded_ale_python'

