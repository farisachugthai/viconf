" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: python ftplugin
    " Last Modified: April 17, 2019
" ============================================================================

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

" Plugins: {{{1

" ALE: {{{2

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
    setlocal equalprg=yapf
    setlocal formatprg=yapf
    let b:ale_fixers += ['yapf']

    " Is it unnecessary to do it this way? Sure. But it means that the only
    " time these commands get defined is when I'm in a python file with YAPF installed

    " Don't forget this advice from usr_41
" USER COMMANDS

" To add a user command for a specific file type, so that it can only be used in
" one buffer, use the "-buffer" argument to |:command|.  Example: >
    command! -buffer -nargs=0 YAPF exec '!yapf <cfile>'
    command! -buffer -nargs=0 YAPFI exec '!yapf -i <cfile>'
    command! -buffer -nargs=0 YAPFD cexpr! exec '!yapf -d <cfile>'

else
    if executable('autopep8')
        setlocal equalprg=autopep8
        setlocal formatprg=autopep8
        let b:ale_fixers += ['autopep8']
    endif
endif

if isdirectory('~/virtualenvs')
    let b:ale_virtualenv_dir_names += '~/virtualenvs'
endif

" Python Language Server: {{{2
if has_key(plugs, 'LanguageClient-neovim')
endif

" Riv: {{{2
let b:riv_python_rst_hl = 1
