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
" linters to react. AKA don't set textwidth
setlocal colorcolumn=80,120
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
let b:ale_linters = [ 'pydocstyle', 'flake8', 'pycodestyle', 'yapf', 'pyls' ]
let b:ale_linters_ignore = [ 'pylint', 'mypy' ]

if isdirectory('~/virtualenvs')
    let b:ale_virtualenv_dir_names+='virtualenvs'
endif

" let b:ale_python_flake8_options = '--config ~/.config/flake8'
" }}}

" Python Language Server: {{{ 3
" useless err msg but better to have checks when we have behavior that's dependant on 3rd party tools
if executable('pyls')
    let b:LanguageClient_serverCommands = { 'python': ['pyls'] }
else
    echo 'pyls is not installed!!!'
endif
let b:LanguageClient_autoStart = 1
let b:LanguageClient_selectionUI = 'fzf'
" the mapping below clobbers your run *.py mapping
" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" this isn't pulling up docs like i want
" nnoremap K :call LanguageClient_textDocument_hover()<CR>
nnoremap gd :call LanguageClient_textDocument_definition()<CR>
" }}}

" }}}

" }}}
