" Vim filetype plugin file
" Language:             readline(3) configuration file
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2008-07-09

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setl com< cms< fo< inc<"

setlocal include=^\s*#\s*\$include
" So this addition makes matchit work!
setlocal iskeyword+=$
setlocal comments=:# commentstring=#\ %s formatoptions-=t formatoptions+=croql

" yo just saying... the syntax highlighting for readline is damn impressive
" Let's utilize it!

" Set completion with CTRL-X CTRL-O to autoloaded function.
" This check is in place in case this script is
" sourced directly instead of using the autoload feature.
if exists('+omnifunc')
    " Do not set the option if already set since this
    " results in an E117 warning.
    if &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
        let b:undo_ftplugin .= '|setl ofu<'
    endif
endif

" From ftplugin/cmake.vim
" *if you're wondering how i knew it was there, i didn't.*
" :grep match_words $VIMRUNTIME/ftplugin
if exists('loaded_matchit')
  let b:match_words = '\<\$if\>:\<\$elseif\>\|\<\$else\>:\<\$endif\>'
  let b:match_ignorecase = 1

  let b:undo_ftplugin .= "|unlet! b:match_words"
endif

let &cpo = s:cpo_save
unlet s:cpo_save
