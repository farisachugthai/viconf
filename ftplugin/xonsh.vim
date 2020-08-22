" ============================================================================
  " File: xonsh.vim
  " Author: Faris Chugthai
  " Description: Xonsh ftplugin
  " Last Modified: November 29, 2019
" ============================================================================

" Sourcing Everything:
  if exists('b:did_ftplugin') | finish | endif

  let s:this_dir = fnameescape(fnamemodify(expand('<sfile>'), ':p:h'))

  exec 'source ' . s:this_dir . '/python.vim'

" Options:
  setlocal keywordprg=:PydocShow
  let &l:path = py#PythonPath()
  setlocal syntax=xonsh
  setlocal foldlevelstart=0
  setlocal foldmethod=marker
  setlocal suffixesadd=.py,.xsh,.xonshrc,
  setlocal include=^\\s*\\(from\\\|import\\)
  setlocal includeexpr=substitute(v:fname,'\\.','/','g')
  setlocal commentstring=#\ %s
  setlocal formatoptions=jcroql
  setlocal expandtab shiftwidth=4 sts=4 ts=4
  setlocal shiftround
  setlocal iskeyword-=_

" Compiler:
  if executable('pytest')
    compiler pytest
    setlocal makeprg=py.test\ --tb=short\ -q\ --color=no
    echomsg 'Using pytest as a compiler!'
  else
    compiler pylint
    echomsg 'Using pylint as a compiler!'
  endif

" Mappings:
  nnoremap <buffer> K <Cmd>PydocShow<CR>
  noremap <buffer> <F5> <Cmd>py3f %<CR>
  noremap! <buffer> <F5> <Cmd>py3f %<CR>

" Atexit:
  let b:undo_ftplugin .= get(b:, 'undo_ftplugin', '')
                  \. '|setlocal kp< ep< fp< path< syntax< fdls< sua< include< '
                  \. '|setlocal includeexpr< cms< fo< et< sw< sts< ts<'
                  \. '|setlocal sr< mp< fdm< isk<'
                  \. '|unlet! b:undo_ftplugin'
                  \. '|unlet! b:did_ftplugin'
                  \. '|unlet! b:current_compiler'
                  \. '|silent! nunmap <buffer> <F5>'
                  \. '|silent! unmap <buffer> <F5>'
                  \. '|silent! nunmap <buffer> K'

