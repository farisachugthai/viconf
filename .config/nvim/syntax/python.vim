" ============================================================================
    " File: python.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting for python files
    " Last Modified: April 19, 2019
" ============================================================================
" if v:version < 600
"     syntax clear
" elseif exists('b:current_syntax')
"     finish
" endif

" let b:current_syntax = 1

" " Stand on the shoulders of giants
" runtime syntax/python.vim

" syn match pythonBrackets "{[(|)]}" contained skipwhite

" syn keyword pythonLambdaExpr lambda

" " Mixed tabs and spaces
" syn match pythonIndentError "^\s*\( \t\|\t \)\s*\S"me=e-1 display
" " Trailing space.
" syn match pythonSpaceError  "\s\+$" display<Paste>
" syn region pythonString     start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
" syn region pythonString     start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
" syn region pythonString     start=+[bB]\="""+ end=+"""+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest2,pythonSpaceError,@Spell
" syn region pythonString     start=+[bB]\='''+ end=+'''+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest,pythonSpaceError,@Spell

" syn match  pythonEscape     +\\[abfnrtv'"\\]+ display contained
" syn match  pythonEscape     "\\\o\o\=\o\=" display contained
" syn match  pythonEscapeError    "\\\o\{,2}[89]" display contained
" syn match  pythonEscape     "\\x\x\{2}" display contained
" syn match  pythonEscapeError    "\\x\x\=\X" display contained
" syn match  pythonEscape     "\\$"

" " Unicode
" syn region pythonUniString  start=+[uU]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,@Spell
" syn region pythonUniString  start=+[uU]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,@Spell
" syn region pythonUniString  start=+[uU]"""+ end=+"""+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
" syn region pythonUniString  start=+[uU]'''+ end=+'''+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell

" syn match  pythonUniEscape          "\\u\x\{4}" display contained
" syn match  pythonUniEscapeError     "\\u\x\{,3}\X" display contained
" syn match  pythonUniEscape          "\\U\x\{8}" display contained
" syn match  pythonUniEscapeError     "\\U\x\{,7}\X" display contained
" syn match  pythonUniEscape          "\\N{[A-Z ]\+}" display contained
" syn match  pythonUniEscapeError "\\N{[^A-Z ]\+}" display contained

" " Raw strings
" syn region pythonRawString  start=+[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
" syn region pythonRawString  start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
" syn region pythonRawString  start=+[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
" syn region pythonRawString  start=+[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell

" syn match pythonRawEscape           +\\['"]+ display transparent contained

" " Unicode raw strings
" syn region pythonUniRawString   start=+[uU][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
" syn region pythonUniRawString   start=+[uU][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
" syn region pythonUniRawString   start=+[uU][rR]"""+ end=+"""+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest2,pythonSpaceError,@Spell
" syn region pythonUniRawString   start=+[uU][rR]'''+ end=+'''+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest,pythonSpaceError,@Spell
" syn match  pythonUniRawEscape   "\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
" syn match  pythonUniRawEscapeError  "\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained
" syn region pythonDocstring  start=+^\s*[uU]\?[rR]\?"""+ end=+"""+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
" syn region pythonDocstring  start=+^\s*[uU]\?[rR]\?'''+ end=+'''+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError

" syn match   pythonHexError  "\<0[xX][0-9a-fA-F_]*[g-zG-Z][0-9a-fA-F_]*[lL]\=\>" display
" syn match   pythonHexNumber "\<0[xX][0-9a-fA-F_]*[0-9a-fA-F][0-9a-fA-F_]*[lL]\=\>" display
" syn match   pythonOctNumber "\<0[oO][0-7_]*[0-7][0-7_]*[lL]\=\>" display
" syn match   pythonBinNumber "\<0[bB][01_]*[01][01_]*[lL]\=\>" display
" syn match   pythonNumber    "\<[0-9][0-9_]*[lLjJ]\=\>" display
" syn match   pythonFloat "\.[0-9_]*[0-9][0-9_]*\([eE][+-]\=[0-9_]*[0-9][0-9_]*\)\=[jJ]\=\>" display
" syn match   pythonFloat "\<[0-9][0-9_]*[eE][+-]\=[0-9_]\+[jJ]\=\>" display
" syn match   pythonFloat "\<[0-9][0-9_]*\.[0-9_]*\([eE][+-]\=[0-9_]*[0-9][0-9_]*\)\=[jJ]\=" display
" syn match   pythonOctError  "\<0[oO]\=[0-7_]*[8-9][0-9_]*[lL]\=\>" display
" syn match   pythonBinError  "\<0[bB][01_]*[2-9][0-9_]*[lL]\=\>" display

" hi def link  pythonStatement    Statement
" hi def link  pythonLambdaExpr   Statement
" hi def link  pythonInclude      Include
" hi def link  pythonFunction     Function
" hi def link  pythonClass        Type
" hi def link  pythonParameters   Normal
" hi def link  pythonParam        Normal
" hi def link  pythonBrackets     Normal
" hi def link  pythonClassParameters Normal
" hi def link  pythonSelf         Identifier

" hi def link  pythonConditional  Conditional
" hi def link  pythonRepeat       Repeat
" hi def link  pythonException    Exception
" hi def link  pythonOperator     Operator
" hi def link  pythonExtraOperator        Operator
" hi def link  pythonExtraPseudoOperator  Operator

" hi def link  pythonDecorator    Define
" hi def link  pythonDottedName   Function

" hi def link  pythonComment      Comment
" hi def link  pythonCoding       Special
" hi def link  pythonRun          Special
" hi def link  pythonTodo         Todo

" hi def link  pythonError        Error
" hi def link  pythonIndentError  Error
" hi def link  pythonSpaceError   Error

" hi def link  pythonString       String
" hi def link  pythonDocstring    String
" hi def link  pythonUniString    String
" hi def link  pythonRawString    String
" hi def link  pythonUniRawString String

" hi def link  pythonEscape       Special
" hi def link  pythonEscapeError  Error
" hi def link  pythonUniEscape    Special
" hi def link  pythonUniEscapeError Error
" hi def link  pythonUniRawEscape Special
" hi def link  pythonUniRawEscapeError Error

" hi def link  pythonStrFormatting Special
" hi def link  pythonStrFormat    Special
" hi def link  pythonStrTemplate  Special

" hi def link  pythonDocTest      Special
" hi def link  pythonDocTest2     Special

" hi def link  pythonNumber       Number
" hi def link  pythonHexNumber    Number
" hi def link  pythonOctNumber    Number
" hi def link  pythonBinNumber    Number
" hi def link  pythonFloat        Float
" hi def link  pythonOctError     Error
" hi def link  pythonHexError     Error
" hi def link  pythonBinError     Error

" hi def link  pythonBuiltinType  Type
" hi def link  pythonBuiltinObj   Structure
" hi def link  pythonBuiltinFunc  Function

" hi def link  pythonExClass      Structure


" TODO:
" pythonBuiltin  xxx links to GruvboxOrange
" pythonBuiltinObj xxx links to GruvboxOrange
" pythonBuiltinFunc xxx links to GruvboxOrange
" pythonFunction xxx links to GruvboxAqua
" pythonDecorator xxx links to GruvboxRed
" pythonInclude  xxx links to GruvboxBlue
" pythonImport   xxx links to GruvboxBlue
" pythonRun      xxx links to GruvboxBlue
" pythonCoding   xxx links to GruvboxBlue
" pythonOperator xxx links to GruvboxRed
" pythonException xxx links to GruvboxRed
" pythonExceptions xxx links to GruvboxPurple
" pythonBoolean  xxx links to GruvboxPurple
" pythonDot      xxx links to GruvboxFg3
" pythonConditional xxx links to GruvboxRed
" pythonRepeat   xxx links to GruvboxRed
" pythonDottedName xxx links to GruvboxGreenBol
