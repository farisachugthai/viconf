" ============================================================================
  " File: htmljinja.vim
  " Author: Faris Chugthai
  " Description: htmljinja ftplugin
  " Last Modified: April 16, 2020
" ============================================================================

setlocal textwidth=80
setlocal colorcolumn=80,120
setlocal foldlevel=1
setlocal foldlevelstart=1
setlocal keywordprg=:PydocShow
setlocal indentkeys=o,O,*<Return>,{,},o,O,!^F,<>>

setlocal suffixesadd=.py,.rst,.rst.txt
" TODO: XXX
" Well somethings very fucking wrong because this adds 200ms to vim's startuptime.
let &l:path = py#PythonPath()

if exists("loaded_matchit")
    let b:match_ignorecase = 1
    let b:match_skip = 's:Comment'
    let b:match_words = '<:>,' .
    \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
    \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
    \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
    \ '{% *block\>.\{-}%}:{% *endblock\>.\{-}%},' .
    \ '{% *blocktrans\>.\{-}%}:{% *endblocktrans\>.\{-}%},' .
    \ '{% *cache\>.\{-}%}:{% *endcache\>.\{-}%},' .
    \ '{% *comment\>.\{-}%}:{% *endcomment\>.\{-}%},' .
    \ '{% *filter\>.\{-}%}:{% *endfilter\>.\{-}%},' .
    \ '{% *for\>.\{-}%}:{% *empty\>.\{-}%}:{% *endfor\>.\{-}%},' .
    \ '{% *if\>.\{-}%}:{% *else\>.\{-}%}:{% *elif\>.\{-}%}:{% *endif\>.\{-}%},' .
    \ '{% *ifchanged\>.\{-}%}:{% *else\>.\{-}%}:{% *endifchanged\>.\{-}%},' .
    \ '{% *ifequal\>.\{-}%}:{% *else\>.\{-}%}:{% *endifequal\>.\{-}%},' .
    \ '{% *ifnotequal\>.\{-}%}:{% *else\>.\{-}%}:{% *endifnotequal\>.\{-}%},' .
    \ '{% *spaceless\>.\{-}%}:{% *endspaceless\>.\{-}%},' .
    \ '{% *verbatim\>.\{-}%}:{% *endverbatim\>.\{-}%},' .
    \ '{% *with\>.\{-}%}:{% *endwith\>.\{-}%}'
endif
