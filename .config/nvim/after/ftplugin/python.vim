" Python:
" Maintainer: Faris Chugthai

" Options: {{{1
setl linebreak
setl textwidth=120

" PEP Indenting: {{{1
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
let b:python_highlight_all = 1

" The external program vim uses for gg=G can be configured
" Hey you in the future. You can use :set *prg<Tab> and see all of the
" configuration options you have.
if executable('yapf')
    setlocal equalprg=yapf
endif

setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
" Dude the columns line was destroying nvim's redraw when you split tmux panes

" Autocommands: {{{1
" Highlight characters after 120 chars
augroup vimrc_autocmds
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

" Plugins: {{{1

" ALE: {{{2

let b:ale_linters = [ 'flake8', 'pycodestyle', 'pydocstyle' , 'pyls' ]
let b:ale_linters_explicit = 1

if isdirectory('~/virtualenvs')
    let b:ale_virtualenv_dir_names += '~/virtualenvs'
endif

" This is tough because what if theres a project file? hm.
let b:ale_python_flake8_options = '--config ~/.config/flake8'
let b:ale_python_pycodestyle_options = '--config ~/.config/pycodestyle'

" TODO:
" Here's a suggestion. Write your own buffer fixer using ALE and yapf.
" You do it anyway so why not nnoremap <Leader>bf <expr> py3do % or %yapf or
" set makeprg=unittest.TestRunner()...or even sphinx build or something. lots
" of choices.
" Python Language Server: {{{2
" Delete the mappings off of here since they're defined in init.vim
let b:LanguageClient_autoStart = 1
let b:LanguageClient_selectionUI = 'fzf'

" Riv: {{{2
" Riv is a plugin for reStructuredText in Vim.
" The following setting allows docstrings in python files
" to be properly highlighted. I'm inordinately excited.
let b:riv_python_rst_hl = 1
