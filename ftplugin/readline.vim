" Vim filetype plugin file
" Language:             readline(3) configuration file
" Maintainer:           Faris A. Chugthai
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2008-07-09

let g:readline_has_bash = 1

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal comments=:# commentstring=#\ %s formatoptions-=t formatoptions+=croql

" Recognize inputrcs can have $include fname in them
" For a bash shell this would reasonably imply include either a file with no extension, a file named ~/.inputrc or one pointed to by $INPUTRC
" point being, no includeexpr needed.
setlocal include=^\s*#\s*\$include
setlocal path=.,$HOME,**,

" todo maybe set up a lil macro that determines the root a little better
let s:root_permissions = getfperm(expand("$PREFIX/etc/inputrc"))
if matchstr(s:root_permissions, '^rw')
  setlocal path+=$PREFIX/etc
endif

setlocal iskeyword+=$

let b:undo_ftplugin = 'setl com< cms< fo< inc< isk<'

" No default matchit definition
if exists('g:loaded_matchit') && !exists('b:match_words')
  let b:match_words = '\<\$if\>:\<\$else\>:\<\$endif\>'
  let b:match_ignorecase = 1

  let b:undo_ftplugin .= '| unlet! b:match_words b:match_ignorecase'
endif
