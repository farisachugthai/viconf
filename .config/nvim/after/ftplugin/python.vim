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

" Options: {{{1
setlocal linebreak
setlocal textwidth=120

setlocal commentstring=#\ %s
setlocal tabstop=8 shiftwidth=4 expandtab softtabstop=4
let g:python_highlight_all = 1
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
setlocal foldmethod=indent

" setlocal keywordprg=pydoc
let &keywordprg = ':PydocThis' . expand('<cWORD>')

" Use xnoremap because I wouldn't want this in select mode
xnoremap K <Cmd>'<,'>PydocThis<CR>

setlocal suffixesadd+=.py,.rst
setlocal omnifunc=python3complete#Complete
setlocal iskeyword+=.
let &path = ftplugins#PythonPath()

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
noremap <buffer> <F5> <Cmd>py3f %<CR>
noremap! <buffer> <F5> <Cmd>py3f %<CR>

" Formatters: {{{1

if executable('yapf')
  setlocal equalprg=yapf
  setlocal formatprg=yapf

  command! -buffer -complete=buffer -nargs=0 YAPF call ftplugins#YAPF()
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
  call ftplugins#ALE_Python_Conf()
endif

" Coc: {{{1
"
" Just tried this and it worked! So keep checking :CocCommand output
if !empty(g:did_coc_loaded)
  command! -nargs=? CocPython call CocActionAsync('runCommand', 'python.startREPL', shellescape(<q-args>))|
endif


" Atexit: {{{1

" A bunch missing. Check :he your-runtime-path somewhere around there is a
" good starter for writing an ftplugin
let b:undo_ftplugin = 'set lbr< tw< cms< et< sts< ts< sw< cc< fdm< sua< isk<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
