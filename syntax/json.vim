" Vim syntax file
" Language:	JSON
" Maintainer:	Eli Parra <eli@elzr.com>
" Last Change:	2014 Aug 23
" Version:      0.12

" Had to copy paste because the only variable you're allowed to configure
" turns of ALL json error highlight. I only need to turn off json comment
" error...

" Guard: {{{

if !exists("main_syntax")
  " quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'json'
else
  finish
endif
" }}}

syntax sync fromstart
syntax case ignore

syntax match   jsonNoise           /\%(:\|,\)/
syn keyword jsonTodo FIXME NOTE TODO XXX contained

" NOTE that for the concealing to work your conceallevel should be set to 2

" Syntax: Strings {{{

" Separated into a match and region because a region by itself is always greedy
syn match  jsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonString
if has('conceal')
	syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ concealends contains=jsonEscape contained
else
	syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ contains=jsonEscape contained
endif
" }}}

" Syntax: JSON does not allow strings with single quotes, unlike JavaScript. {{{
syn region  jsonStringSQError oneline  start=+'+  skip=+\\\\\|\\"+  end=+'+
" }}}

" Syntax: JSON Keywords {{{
" Separated into a match and region because a region by itself is always greedy
syn match  jsonKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=jsonKeyword
if has('conceal')
   syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ concealends contained
else
   syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ contained
endif
" }}}

" Syntax: Escape sequences {{{
syn match   jsonEscape    "\\["\\/bfnrt]" contained
syn match   jsonEscape    "\\u\x\{4}" contained
" }}}

" Syntax: Numbers {{{
syn match   jsonNumber    "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>\ze[[:blank:]\r\n]*[,}\]]"
" }}}

" ERROR WARNINGS **********************************************

if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)

  " Strings should always be enclosed with quotes.
  " syn match   jsonNoQuotesError  "\<[[:alpha:]][[:alnum:]]*\>"
  syn match   jsonTripleQuotesError  /"""/

  " An integer part of 0 followed by other digits is not allowed.
  syn match   jsonNumError  "-\=\<0\d\.\d*\>"

  " Decimals smaller than one should begin with 0 (so .1 should be 0.1).
  syn match   jsonNumError  "\:\@<=[[:blank:]\r\n]*\zs\.\d\+"

  " No comments in JSON, see http://stackoverflow.com/questions/244777/can-i-comment-a-json-file
  " syn match   jsonCommentError  '//.*'
  " syn match   jsonCommentError  '\(/\*\)\|\(\*/\)'

  " jsonc has comments and that's good enough for me.
  syn region  jsoncLineComment    start=+\/\/+ end=+$+ keepend
  syn region  jsoncLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend fold
  syn region  jsoncComment        start="/\*"  end="\*/" fold

  " No semicolons in JSON
  syn match   jsonSemicolonError  ";"

  " No trailing comma after the last element of arrays or objects
  syn match   jsonTrailingCommaError  ",\_s*[}\]]"

  " Watch out for missing commas between elements
  syn match   jsonMissingCommaError /\("\|\]\|\d\)\zs\_s\+\ze"/
  syn match   jsonMissingCommaError /\(\]\|\}\)\_s\+\ze"/ "arrays/objects as values
  syn match   jsonMissingCommaError /}\_s\+\ze{/ "objects as elements in an array
  syn match   jsonMissingCommaError /\(true\|false\)\_s\+\ze"/ "true/false as value
endif

" ********************************************** END OF ERROR WARNINGS
" Allowances for JSONP: function call at the beginning of the file,
" parenthesis and semicolon at the end.
" Function name validation based on
" http://stackoverflow.com/questions/2008279/validate-a-javascript-function-name/2008444#2008444
syn match  jsonPadding "\%^[[:blank:]\r\n]*[_$[:alpha:]][_$[:alnum:]]*[[:blank:]\r\n]*("
syn match  jsonPadding ");[[:blank:]\r\n]*\%$"

" Syntax: Boolean
syn match  jsonBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/

" Syntax: Null
syn keyword  jsonNull      null

" Syntax: Braces
syn region  jsonFold matchgroup=jsonBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ transparent fold
syn region  jsonFold matchgroup=jsonBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ transparent fold

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link jsonTodo            Todo
hi def link jsonPadding         Operator
hi def link jsonString          String
hi def link jsonTest            Label
hi def link jsonEscape          Special
hi def link jsonNumber          Number
hi def link jsonBraces          Delimiter
hi def link jsonNull            Function
hi def link jsonBoolean         Boolean
hi def link jsonKeyword         Label

if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
  hi def link jsonNumError        Error
  " hi def link jsonCommentError    Error
  hi def link jsonSemicolonError  Error
  hi def link jsonTrailingCommaError     Error
  hi def link jsonMissingCommaError      Error
  hi def link jsonStringSQError        	Error
  " hi def link jsonNoQuotesError        	Error
  hi def link jsonTripleQuotesError     	Error
endif
hi def link jsonQuote           Quote
hi def link jsonNoise           Noise

let b:current_syntax = "json"
" vim: set ts=8 fdm=marker:
