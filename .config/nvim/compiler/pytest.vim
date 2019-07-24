" ============================================================================
  " File: pytest.vim
  " Author: Faris Chugthai
  " Description: Pytest compiler for Vim
  " Last Modified: July 19, 2019 
" ============================================================================

" Guards: {{{1
if exists('current_compiler')
  finish
endif
let current_compiler = 'pytest'

if exists(':CompilerSet') != 2 " older Vim always used :setlocal
  command! -nargs=* CompilerSet setlocal <args>
endif
 
let s:cpo_save = &cpoptions
set cpoptions-=C
 
CompilerSet makeprg=py.test\ --tb=short\ -q
 
CompilerSet errorformat=
      \%-G=%#\ ERRORS\ =%#,
      \%-G=%#\ FAILURES\ =%#,
      \%-G%\\s%\\*%\\d%\\+\ tests\ deselected%.%#,
      \ERROR:\ %m,
      \%E_%\\+\ %m\ _%\\+,
      \%Cfile\ %f\\,\ line\ %l,
      \%CE\ %#%m,
      \%EE\ \ \ \ \ File\ \"%f\"\\,\ line\ %l,
      \%ZE\ \ \ %[%^\ ]%\\@=%m,
      \%Z%f:%l:\ %m,
      \%Z%f:%l,
      \%C%.%#,
      \%-G%.%#\ seconds,
      \%-G%.%#,
 
let &cpoptions = s:cpo_save
unlet s:cpo_save
