" ============================================================================
  " File: xonsh.vim
  " Author: Faris Chugthai
  " Description: Xonsh ftplugin
  " Last Modified: November 29, 2019
" ============================================================================

" Sourcing Everything: {{{1
let s:this_dir = fnameescape(fnamemodify(expand('<sfile>'), ':p:h'))

exec 'source ' . s:this_dir . '/python.vim'
" We source the runtime python file there so dont do it here
" }}}

" Options: {{{
setlocal keywordprg=:PydocShow
noremap <buffer> <F5> <Cmd>py3f %<CR>
noremap! <buffer> <F5> <Cmd>py3f %<CR>

if executable('black')
  setlocal equalprg=black
  setlocal formatprg=black

elseif executable('yapf')
  setlocal equalprg=yapf
  setlocal formatprg=yapf
elseif executable('autopep8')
  setlocal equalprg=autopep8
  setlocal formatprg=autopep8
endif

let &l:path  = py#PythonPath()
setlocal syntax=xonsh
syntax sync fromstart

setlocal foldmethod=indent
setlocal suffixesadd+=,.xsh,.xonshrc,
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
" }}}

" Compiler: {{{1

" TODO: how do we undo_ftplugin for a compiler?
" Well this is neat!
if executable('pytest')
  compiler pytest
  setlocal makeprg=py.test\ --tb=short\ -q\ --color=no
  echomsg 'Using pytest as a compiler!'
else
  compiler pylint
  echomsg 'Using pylint as a compiler!'
endif  " }}}

" Atexit: {{{
let b:undo_ftplugin = 'setlocal fdm< syntax< sua< '
            \ . '|unlet! b:undo_ftplugin'
            \ . '|unlet! b:did_ftplugin'
