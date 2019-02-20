" Python:
" Maintainer: Faris Chugthai

" PEP Indenting: {{{1
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
let b:python_highlight_all = 1

" Options: {{{1
setl linebreak
setl textwidth=120

set commentstring=#\ %s


" TODO: Should set makeprg to something that could execute tests
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" also let's know where the line needs to end visually but not invoke the
" linters to react.
setlocal colorcolumn=80,120
" Dude the columns line was destroying nvim's redraw when you split tmux panes

if isdirectory('/usr/lib/python3/')
    setl path+=/usr/lib/python3*
endif
" Completions: {{{2
" Idk if this is right.
if &omnifunc==?''
   set omnifunc=python3#completer
endif


" Autocommands: {{{1

" Highlight characters after 120 chars
augroup pythonchars
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

" Plugins: {{{1

" ALE: {{{2

" Jan 24, 2019: pyls went because A) it doesn't output an error message B) it
" uses flake8 and jedi anyway and C) its slow
" Ugh! But flake8 isn't returning any message to ALE so i suppose enable it.
let b:ale_linters = [ 'flake8', 'pydocstyle', 'pyls' ]
let b:ale_linters_explicit = 1

" Alright let's just do this manually

let b:ale_python_pyls_options = {
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
else
    if executable('autopep8')
        setlocal equalprg=autopep8
        setlocal formatprg=autopep8
        let b:ale_fixers += ['autopep8']
    endif
endif

" TODO:
" Here's a suggestion. Write your own buffer fixer using ALE and yapf.
" You do it anyway so why not nnoremap <Leader>bf <expr> py3do % or %yapf or
" set makeprg=unittest.TestRunner()...or even sphinx build or something.
" Todo: #2: Map something so that it does "run this line with the py3 host


" Virtualenvs: {{{3
if isdirectory('~/virtualenvs')
    let b:ale_virtualenv_dir_names += '~/virtualenvs'
endif

" Python Language Server: {{{2
" Delete the mappings off of here since they're defined in init.vim

" Vim-plug exports a dictionary with all of the info it gathers about your
" plugins!
if has_key(plugs, 'LanguageClient-neovim')
    let b:LanguageClient_autoStart = 1
    let b:LanguageClient_selectionUI = 'fzf'
endif

" Riv:

" Riv is a plugin for reStructuredText in Vim.
" The following setting allows docstrings in python files
" to be properly highlighted. I'm inordinately excited.
let b:riv_python_rst_hl = 1
