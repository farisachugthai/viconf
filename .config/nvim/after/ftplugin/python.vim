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

" This may be hard on termux but feels necessary.
if &columns < 80
    setlocal columns=80
endif

" I feel like theres really not many commas in python
let b:maplocalleader = ','
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
" }}}

" }}}

" PYUNIT COMPILER						*compiler-pyunit*

" This is not actually a compiler, but a unit testing framework for the
" Python language.  It is included into standard Python distribution
" starting from version 2.0.  For older versions, you can get it from
" http://pyunit.sourceforge.net.

" When you run your tests with the help of the framework, possible errors
" are parsed by Vim and presented for you in quick-fix mode.

" Unfortunately, there is no standard way to run the tests.
" The alltests.py script seems to be used quite often, that's all.
" Useful values for the 'makeprg' options therefore are:
"  setlocal makeprg=./alltests.py " Run a testsuite
"  setlocal makeprg=python\ %:S   " Run a single testcase

" Also see http://vim.sourceforge.net/tip_view.php?tip_id=280.
"
"
" Alternatively...
" First shot at a compiler!
" CompilerSet makeprg=flake8\ --format=default\ %
" CompilerSet errorformat=
"     \%E%f:%l:\ could\ not\ compile,%-Z%p^,
"     \%A%f:%l:%c:\ %t%n\ %m,
"     \%A%f:%l:\ %t%n\ %m,
"     \%-G%.%#



" " }}}
