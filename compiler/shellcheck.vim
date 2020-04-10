" ============================================================================
  " File: shellcheck.vim
  " Author: Faris Chugthai
  " Description: shellcheck compiler
  " Last Modified: April 10, 2020
" ============================================================================
"
if exists('current_compiler')
  finish
endif

let b:current_compiler = 'shellcheck'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=shellcheck\ -f\ gcc\ $*\ %:S

CompilerSet errorformat=
  \%f:%l:%c:\ %trror:\ %m,
  \%f:%l:%c:\ %tarning:\ %m,
  \%I%f:%l:%c:\ note:\ %m

" vim:ft=vim:ts=2:sw=2:sts=2:et
