" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: Jun 13, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions&vim

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

" Autocommands: {{{1

" Highlight I20 Chars: {{{2

augroup pythonchars
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
augroup END

" Compiler: {{{1

" Well this is neat!
if executable('pylint')
    compiler pylint
    echomsg 'Using pylint as buffer-local compiler. Run `:make %` to use.'
endif

" Mappings: {{{1

" Don't know how I haven't done this yet.
noremap <F5> <Cmd>py3f %<CR>
noremap! <F5> <Cmd>py3f %<CR>

" Commands: {{{1

if executable('yapf')
    setlocal equalprg=yapf
    setlocal formatprg=yapf
    " Don't forget this advice from usr_41
    " USER COMMANDS
    " To add a user command for a specific file type, so that it can only be used in
    " one buffer, use the "-buffer" argument to |:command|.:
  function! YAPF() abort
    " ughhhhh this is gonna be a pain in the ass to modify so it reads into a buffer
    redir => b:tmp_var
    exec '!yapf %'
    redir END
    enew
    " shit how do we read in the output.... TODO: alternatively try
    " `:TBrowseOutput because tlib is the bees knees
  endfunction

  command! -buffer -complete=buffer -nargs=0 YAPF exec '!yapf %'
  command! -buffer -complete=buffer -nargs=0 YAPFI exec '!yapf -i %'
  command! -buffer -complete=buffer -nargs=0 YAPFD cexpr! exec '!yapf -d %'

else
    if executable('autopep8')
        setlocal equalprg=autopep8
        setlocal formatprg=autopep8

        command! -nargs=0 Autopep8 exec '!autopep8 %'
        " command! -nargs=0 Autopep8 exec '!autopep8 -i %'
        " command! -nargs=0 Autopep8 cexpr! exec '!autopep8 -d %'
    endif
endif

" ALE: {{{1

function! ALE_Python_Conf() abort

  let b:ale_linters_explicit = 1

  " Functions don't globalize buffer local variables...So everything has to
  " be a g: prefixed var
  let g:ale_linters = extend(g:ale_linters, {'python': [ 'flake8', 'pydocstyle', 'pyls' ]})

  let g:ale_python_pyls_config = {
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

  " The external program vim uses for gg=G can be configured
  " Hey you in the future. You can use :set *prg<Tab> and see all of the
  " configuration options you have.
  " Now you can also use gq for yapf
  let g:ale_fixers = extend(g:ale_fixers, {'python': 'reorder-python-imports'})

  if executable('yapf')
      let g:ale_fixers += extend(g:ale_fixers, {'python': 'yapf'})
  else
      if executable('autopep8')
          let b:ale_fixers += extend(g:ale_fixers, {'python': 'autopep8'})
      endif
  endif

endfunction

" I don't know why none of my autocommands are working but fuck it

if &filetype=='python'
  call ALE_Python_Conf()
endif

" That'll do. Holy fuck that actually worked....

" Atexit: {{{1

" A bunch missing. Check :he your-runtime-path somewhere around there is a
" good starter for writing an ftplugin
let b:undo_ftplugin = 'set lbr< tw< cms< et< sts< ts< sw< cc< fdm< sua<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
