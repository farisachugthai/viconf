" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: April 17, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_python_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_python_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1
setlocal linebreak
setlocal textwidth=120

setlocal commentstring=#\ %s
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
let b:python_highlight_all = 1
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
setlocal foldmethod=indent

setlocal keywordprg=pydoc

" Autocommands: {{{1

" Undo ftplugin?
if isdirectory(expand('$_ROOT') . '/lib/python3')
    " Double check globbing in vim
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python3'
endif

if isdirectory(expand('~/.local/lib/python3.7'))
    " Double check globbing in vim
    let &path = &path . ',' . expand('~') . '/.local/lib/python3.7'
endif

" TODO: How do we glob in vimscript? There's some weird thing about using * and ** right?
" if isdirectory(expand('$_ROOT/lib/python3'))

" endif

" Highlight I20 Chars: {{{2

augroup pythonchars
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python setlocal nowrap
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

noremap K call PydocKeywordprg()

" Commands: {{{1
if executable('yapf')
    setlocal equalprg=yapf
    setlocal formatprg=yapf
    " Don't forget this advice from usr_41
    " USER COMMANDS
    " To add a user command for a specific file type, so that it can only be used in
    " one buffer, use the "-buffer" argument to |:command|.  Example:
    command! -buffer -nargs=0 YAPF exec '!yapf %'
    command! -buffer -nargs=0 YAPFI exec '!yapf -i %'
    command! -buffer -nargs=0 YAPFD cexpr! exec '!yapf -d %'

else
    if executable('autopep8')
        setlocal equalprg=autopep8
        setlocal formatprg=autopep8

        command! -nargs=0 Autopep8 exec '!autopep8 %'
        " command! -nargs=0 Autopep8 exec '!autopep8 -i %'
        " command! -nargs=0 Autopep8 cexpr! exec '!autopep8 -d %'
    endif
endif

" Plugins: {{{1

" ALE: {{{2

function! ALE_Python_Conf()
    let b:ale_linters = [ 'flake8', 'pydocstyle', 'pyls' ]

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

    " The external program vim uses for gg=G can be configured
    " Hey you in the future. You can use :set *prg<Tab> and see all of the
    " configuration options you have.
    " Now you can also use gq for yapf
    let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

    if executable('yapf')
        let b:ale_fixers += ['yapf']
    else
        if executable('autopep8')
            let b:ale_fixers += ['autopep8']
        endif
    endif

    if isdirectory('~/virtualenvs')
        let b:ale_virtualenv_dir_names += '~/virtualenvs'
    endif
endfunction

augroup alepythonconf
    au!
    autocmd Filetype python if has_key(plugs, 'ale') | call ALE_Python_Conf() | endif
augroup END

" Atexit: {{{1
" A bunch missing. Check :he your-runtime-path somewhere around there is a
" good starter for writing an ftplugin
let b:undo_ftplugin = 'set lbr< tw< cms< et< sts< ts< sw< cc< fdm<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
