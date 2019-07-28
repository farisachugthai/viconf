" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: Jun 13, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_python_vim') || &compatible || v:version < 700
  finish
endif
let g:did_python_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=c

let s:debug = 0

" Options: {{{1
setlocal linebreak
setlocal textwidth=120

setlocal commentstring=#\ %s
setlocal tabstop=8 shiftwidth=4 expandtab softtabstop=4
let b:python_highlight_all = 1
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
setlocal foldmethod=indent

setlocal keywordprg=pydoc

setlocal suffixesadd+=.py

" Path: {{{2

" Undo ftplugin?
if isdirectory(expand('$_ROOT') . '/lib/python3')
    " Double check globbing in vim
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python3'
endif

if isdirectory(expand('~/.local/lib/python3.7'))
    " Double check globbing in vim
    let &path = &path . ',' . expand('~') . '/.local/lib/python3.7'
endif

function! PythonPath()

  let s:orig_path = &path

  if !empty(g:python3_host_prog)
    let s:root_dir = fnamemodify(g:python3_host_prog, ':h:h')
  else
    return s:orig_path
  endif
  let s:site_pack = s:root_dir . '/lib/python3.7/site-packages/**3'  " max out at 3 dir deep

  let &path = &path . ',' . s:site_pack

  return &path

endfunction

let &path = PythonPath()

" Autocmd: Highlight 120 Chars: {{{1
" augroup pythonchars
"     autocmd!
"     autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
"     autocmd FileType python match Excess /\%120v.*/
" augroup END

" Compiler: {{{1

" Well this is neat!
if executable('pylint')
  compiler pylint
  echomsg 'Using pylint as buffer-local compiler. Run `:make %` to use.'
else
  compiler pytest
endif

" Mappings: {{{1

" Don't know how I haven't done this yet.
noremap <F5> <Cmd>py3f %<CR>
noremap! <F5> <Cmd>py3f %<CR>

" Formatters: {{{1

if executable('yapf')
    setlocal equalprg=yapf
    setlocal formatprg=yapf
    " Don't forget this advice from usr_41
    " USER COMMANDS
    " To add a user command for a specific file type, so that it can only be used in
    " one buffer, use the "-buffer" argument to |:command|.:
  function! YAPF() abort
    if exists(':TBrowseOutput')
      " Realistically should accept func args
      :TBrowseOutput !yapf %
    endif
  endfunction

  command! -buffer -complete=buffer -nargs=0 YAPF exec '!yapf %'
  command! -buffer -complete=buffer -nargs=0 YAPFI exec '!yapf -i %'
  command! -buffer -complete=buffer -nargs=0 YAPFD cexpr! exec '!yapf -d %'

else
    if executable('autopep8')
        setlocal equalprg=autopep8
        setlocal formatprg=autopep8

        command! -nargs=0 -complete=buffer -buffer Autopep8 exec '!autopep8 %'
        " command! -nargs=0 Autopep8 exec '!autopep8 -i %'
        " command! -nargs=0 Autopep8 cexpr! exec '!autopep8 -d %'
    endif
endif

" ALE: {{{1

function! ALE_Python_Conf()

    if s:debug
        echomsg 'Did the function call?'
    endif

    let b:ale_linters = ['flake8', 'pydocstyle', 'pyls']

    let b:ale_linters_explicit = 1

    let b:ale_python_pyls_config = {
          \   'pyls': {
          \     'plugins': {
          \       'pycodestyle': {
          \         'enabled': v:false
          \       },
          \       'flake8': {
          \         'enabled': v:true
          \       }
          \     }
          \   },
          \ }

    let g:ale_virtualenv_dir_names = []
    if isdirectory(expand('~/virtualenvs'))
      let g:ale_virtualenv_dir_names += expand('~/virtualenvs')
    elseif isdirectory(expand('~/Anaconda3'))
      let g:ale_virtualenv_dir_names += expand('~/Anaconda3')
    endif

    if isdirectory(expand('~/.local/share/virtualenvs'))
      let g:ale_virtualenv_dir_names += expand('~/.local/share/virtualenvs')
    endif

  let b:ale_fixers = [
        \ 'remove_trailing_lines',
        \ 'trim_whitespace',
        \ 'reorder-python-imports',
        \ ]

  if executable('yapf')
      let b:ale_fixers += ['yapf']
  else
      if executable('autopep8')
          let b:ale_fixers += ['autopep8']
      endif
  endif

endfunction

if has_key(plugs, 'ale') && &filetype==#'python'
  call ALE_Python_Conf()
endif

" That'll do. Holy fuck that actually worked....

" Atexit: {{{1

" A bunch missing. Check :he your-runtime-path somewhere around there is a
" good starter for writing an ftplugin
let b:undo_ftplugin = 'set lbr< tw< cms< et< sts< ts< sw< cc< fdm< kp< sua<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
