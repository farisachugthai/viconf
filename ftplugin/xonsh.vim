" ============================================================================
  " File: xonsh.vim
  " Author: Faris Chugthai
  " Description: Xonsh ftplugin
  " Last Modified: November 29, 2019
" ============================================================================

" Sourcing Everything: {{{
if exists('b:did_ftplugin') | finish | endif

let s:this_dir = fnameescape(fnamemodify(expand('<sfile>'), ':p:h'))

exec 'source ' . s:this_dir . '/python.vim'
" }}}

" Options: {{{
" fuck keywordprg all it says is 'trailing characters'
" setlocal keywordprg=:PydocShow
nnoremap <buffer> K <Cmd>PydocShow<CR>
noremap <buffer> <F5> <Cmd>py3f %<CR>
noremap! <buffer> <F5> <Cmd>py3f %<CR>

if executable('black')
  setlocal equalprg=black
  setlocal formatprg=black

elseif executable('yapf')
  setlocal equalprg=yapf\ -i\ expand('%')
  setlocal formatprg=yapf\ -i\ expand('%')
elseif executable('autopep8')
  setlocal equalprg=autopep8
  setlocal formatprg=autopep8
endif

let &l:path = py#PythonPath()
" syn enable
" setlocal syntax=xonsh
" syntax sync fromstart
setlocal foldlevelstart=0
setlocal suffixesadd=.py,.xsh,.xonshrc,
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal cms=#\ %s
setlocal formatoptions=jcroql
setlocal expandtab shiftwidth=4 sts=4 ts=4
setlocal shiftround
" }}}

" Compiler: {{{

" TODO: how do we undo_ftplugin for a compiler?
" Well this is neat!
if executable('pytest')
  compiler pytest
  setlocal makeprg=py.test\ --tb=short\ -q\ --color=no
  echomsg 'Using pytest as a compiler!'
else
  compiler pylint
  echomsg 'Using pylint as a compiler!'
endif
" }}}

" Atexit: {{{
let b:undo_ftplugin = 'setlocal kp< ep< fp< path< syntax< fdls< sua< include< '
                \ . '|setlocal includeexpr< cms< fo< et< sw< sts< ts< sr< mp<'
                \ . '|unlet! b:undo_ftplugin'
                \ . '|unlet! b:did_ftplugin'
" }}}

