" Vim compiler file
" Compiler:             sphinx >= 1.0.8, http://www.sphinx-doc.org
" Description:          reStructuredText Documentation Format
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2017-03-31

" Guards: {{{1
if exists("current_compiler")
  finish
endif
let current_compiler = "rst"

let s:cpo_save = &cpo
set cpo&vim

" CompilerSet: {{{1
" From he exists:

" :cmdname	ex command: built-in command, user
"     command or command modifier |:command|.
"     returns:
"     1  for match with start of a command
"     2  full match with a command
"     3  matches several user commands
"     to check for a supported command
"     always check the return value to be 2.
if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=
      \%f\\:%l:\ %tEBUG:\ %m,
      \%f\\:%l:\ %tNFO:\ %m,
      \%f\\:%l:\ %tARNING:\ %m,
      \%f\\:%l:\ %tRROR:\ %m,
      \%f\\:%l:\ %tEVERE:\ %m,
      \%f\\:%s:\ %tARNING:\ %m,
      \%f\\:%s:\ %tRROR:\ %m,
      \%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',
      \%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',
      \%DMaking\ %*\\a\ in\ %f


CompilerSet 'sphinx-build'

" Invoke the command with something to the effect of :make -b html . _build

" Atexit: {{{1
let &cpo = s:cpo_save
unlet s:cpo_save
