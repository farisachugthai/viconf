" python.vim
" Maintainer: Faris Chugthai

" All: {{{ 1

" Options: {{{ 2

" Pep Indenting
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
let b:python_highlight_all = 1

" The external program vim uses for gg=G can be configured
if executable('yapf')
    setlocal equalprg=yapf
endif

setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
set colorcolumn=79
" }}}

" Autocommands: {{{ 2
" Highlight characters after 120 chars
augroup vimrc_autocmds
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END
" }}}

" Plugins: {{{ 2

" Ale: {{{ 3
" 1st. use b not g. 2. it automatically does this. you're ignoring project
" co figuration files as a result
" let g:ale_python_flake8_options = '--config ~/.config/flake8'
if isdirectory('~/virtualenvs')
    let b:ale_virtualenv_dir_names+='virtualenvs'
endif
" }}}

" }}}

" }}}
