" Vim compiler file
" Compiler:             sphinx >= 1.0.8, http://www.sphinx-doc.org
" Description:          reStructuredText Documentation Format
" Maintainer:           Faris Chugthai
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      Jun 29, 2019

" Guards: {{{1
if exists('current_compiler')
  finish
endif
let current_compiler = 'rst'

let s:cpo_save = &cpoptions
set cpoptions&vim

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
if exists(':CompilerSet') != 2
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

" Makeprg: {{{1
if filereadable('Makefile')
  CompilerSet makeprg=make
else
  let &makeprg = 'sphinx-build -b html'
endif

" Invoke the command with something to the effect of :make -b html . _build

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save

  " Fuck what old vim did
  " Well I tried getting smart and now this code doesn't work so....
" let &errorformat=
"       \%f\\:%l:\ %tEBUG:\ %m,
"       \%f\\:%l:\ %tNFO:\ %m,
"       \%f\\:%l:\ %tARNING:\ %m,
"       \%f\\:%l:\ %tRROR:\ %m,
"       \%f\\:%l:\ %tEVERE:\ %m,
"       \%f\\:%s:\ %tARNING:\ %m,
"       \%f\\:%s:\ %tRROR:\ %m,
"       \%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',
"       \%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',
"       \%DMaking\ %*\\a\ in\ %f

" " Makeprg: {{{1
" " TODO: Could possibly do a few if globpath('.', 'build') | let &makeprg .=
" " 'build' so we can have that automatically set but eh it'd be really
" " complicated and not work consistently
" let s:cur_dir = fnamemodify('%', ':p:h')

" if filereadable(s:cur_dir . '/Makefile')
"   let &makeprg = 'make '

" else
"   if executable('sphinx-build')
"     let &makeprg = 'sphinx-build '
"     echomsg 'compiler/rst.vim: Using sphinx as the compiler.'
"   endif
" endif

" " Invoke the command with something to the effect of :make -b html . _build

" " Atexit: {{{1
" let &cpoptions = s:cpo_save
" unlet s:cpo_save
