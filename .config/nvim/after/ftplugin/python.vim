" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: April 17, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_python_vim') || &cp || v:version < 700
    finish
endif
let g:did_python_vim = 1

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

" Highlight I20 Chars: {{{1
augroup pythonchars
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python setlocal nowrap
augroup END

" Pylint Compiler: {{{1
" Well this is neat!
if executable('pylint')
    compiler pylint
    echomsg 'Using pylint as buffer-local compiler. Run `:make %` to use.'
endif

" Commands: {{{1
if executable('yapf')
    setlocal equalprg=yapf
    setlocal formatprg=yapf

    " Is it unnecessary to do it this way? Sure. But it means that the only
    " time these commands get defined is when I'm in a python file with YAPF installed
    command! -nargs=0 Yapf exec '!yapf %'
    command! -nargs=0 Yapfi exec '!yapf -i %'
    command! -nargs=0 Yapfd cexpr! exec '!yapf -d %'

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

if has_key(plugs, 'ale')
    call ALE_conf()
endif

function! ALE_conf()
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
