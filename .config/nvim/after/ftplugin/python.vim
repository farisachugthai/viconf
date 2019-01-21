" python.vim
" Maintainer: Faris Chugthai

" PEP Indenting: {{{1
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
let b:python_highlight_all = 1

" Options: {{{1
setl linebreak
setl textwidth=120

" The external program vim uses for gg=G can be configured
" Hey you in the future. You can use :set *prg<Tab> and see all of the
" configuration options you have.
if executable('yapf')
    setlocal equalprg=yapf
endif

" TODO: Should set makeprg to something that could execute tests
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
" Dude the columns line was destroying nvim's redraw when you split tmux panes

" This is QUITE the mapping. Let's see I guess.
" 
imap <silent> <expr> <buffer> <CR> pumvisible() ? "<CR><C-R>=(col('.')-1&&match(getline(line('.')), '\\.', \ col('.')-2) == col('.')-2)?\"\<lt>C-X>\<lt>C-O>\":\"\"<CR>" \ : "<CR>" 

" Autocommands: {{{1
" Highlight characters after 120 chars
augroup vimrc_autocmds
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

" Plugins:{{{1

" ALE: {{{2
let b:ale_linters = [ 'flake8', 'pydocstyle' ]
" Jan 07, 2019: Got rid of pycodestyle. Not listening to configs and emitting
" noise and a large number of false positives. also flake8 is pycodestyle so..
let b:ale_linters_explicit = 1

" This is tough because what if theres a project file? hm.
let b:ale_python_flake8_options = '--config ~/.config/flake8'
" let b:ale_python_pycodestyle_options = '--config ~/.config/pycodestyle'

" Now that linters are set, add fixers
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace', 'yapf']

" Virtualenvs
if isdirectory('~/virtualenvs')
    let b:ale_virtualenv_dir_names += '~/virtualenvs'
endif

" Riv: {{{2
" Riv is a plugin for reStructuredText in Vim.
" This setting allows docstrings in python files to be properly highlighted.
let b:riv_python_rst_hl = 1
