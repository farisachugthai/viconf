" Vim compiler file
" Compiler:	pytest
" Maintainer: 	Karl Bartel <karl42@gmail.com>

if exists("current_compiler")
  finish
endif
let current_compiler = "py_single_test"

if exists(':CompilerSet') != 2 " older Vim always used :setlocal
  command! -nargs=* CompilerSet setlocal <args>
endif

" CompilerSet:
if exists('g:pytest_makeprg_params')
  execute 'pytestCompilerSet makeprg=py.test\ ' . escape(g:pytest_makeprg_params, ' \|"') . '\ $*'
else
  CompilerSet makeprg=py.test\ -x\ --tb=short\ -q\ --color=no\ $*
endif


" Vim errorformat cheatsheet:
" %-G		ignore this message
" %+G		general message
" %.%#          .*

CompilerSet errorformat=%f:%l:%m  " traceback lines including file locations
CompilerSet errorformat+=file\ %f\\,\ line\ %l  " location when pytest complains about a missing fixture
CompilerSet errorformat+=%-G=%#\ FAILURES\ =%#  " FAILURES header
CompilerSet errorformat+=%-G=%#\ ERRORS\ =%#  " ERRORS header
CompilerSet errorformat+=%-G\C%[FEs.]%#\ %#[%[0-9]%#%%]  " ...F..E..     [100%] results list
CompilerSet errorformat+=%-G%[FEs.]  " single results without percentage
CompilerSet errorformat+=%-G\ \ \ \ %.%#  " traceback rows including code
CompilerSet errorformat+=%-G%.%#\ seconds,  " last '1 error in 0.53 seconds' line
CompilerSet errorformat+=%+G\ \ File\ \"%f\"\\,\ line\ %l\\,\ in\ %m  " normal python tracebacks from the logging output

"CompilerSet errorformat+=%-G______%#\ %m\ ______%#  " test name header

