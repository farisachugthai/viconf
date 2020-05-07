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
setlocal include=^\s*#\s*\$include
setlocal iskeyword+=$

let b:undo_ftplugin = 'setl com< cms< fo< inc< isk<'

" No default matchit definition
if exists('loaded_matchit')
  let b:match_words = '\<\$if\>:\<\$else\>:\<\$endif\>'
  let b:match_ignorecase = 1

  let b:undo_ftplugin .= '| unlet b:match_words'
endif
