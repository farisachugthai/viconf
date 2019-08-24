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
set cpoptions-=C

" Oddly I don't have an ftplugin guard setup. But rst sourced this in so...
if &filetype != 'python'
  finish
endif

" I mean is it not a little ridiculous that I have to do shit like that

let s:debug = 0

" Options: {{{1
setlocal linebreak
setlocal textwidth=120

setlocal commentstring=#\ %s
setlocal tabstop=8 shiftwidth=4 expandtab softtabstop=4
let b:python_highlight_all = 1
let g:python_highlight_all = 1
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
setlocal foldmethod=indent

setlocal keywordprg=:PydocThis

setlocal suffixesadd+=.py

setlocal omnifunc=python3complete#Complete

" Path: {{{2

let &path = pydoc_help#PythonPath()

" Compiler: {{{1

" Well this is neat!
if executable('pytest')
  compiler pytest
  echomsg 'Using pytest as a compiler!'
else
  compiler pylint
  echomsg 'Using pylint as a compiler!'
endif

" Mappings: {{{1

" Don't know how I haven't done this yet.
noremap <F5> <Cmd>py3f %<CR>
noremap! <F5> <Cmd>py3f %<CR>

" Formatters: {{{1

if executable('yapf')
    setlocal equalprg=yapf
    setlocal formatprg=yapf

  command! -buffer -complete=buffer -nargs=0 YAPF call YAPF()
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

if has_key(plugs, 'ale')
  call pydoc_help#ALE_Python_Conf()
endif

" That'll do. Holy fuck that actually worked....

" Atexit: {{{1

" A bunch missing. Check :he your-runtime-path somewhere around there is a
" good starter for writing an ftplugin
let b:undo_ftplugin = 'set lbr< tw< cms< et< sts< ts< sw< cc< fdm< kp< sua<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
