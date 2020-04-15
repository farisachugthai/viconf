" Vim syntax file for xonsh
" Language: Xonsh Shell Script
" Maintainer: Faris Chugthai
" Previous Maintainer: Abhishek Mukherjee
" Latest Revision: Nov 28, 2019

if exists('b:current_syntax')
  finish
endif

let g:xsh_highlight_all = 1

if exists('g:xsh_highlight_all')
  let g:xsh_highlight_numbers = 1
  let g:xsh_highlight_builtins = 1
  let g:xsh_highlight_exceptions = 1
  let g:xsh_highlight_space_errors = 1
endif

" Include python files goddamn
let g:python_highlight_all = 1
let g:python_space_error_highlight = 1

unlet! b:current_syntax
syntax include $VIMRUNTIME/syntax/python.vim

syn keyword xshStatement    as assert break continue del except exec finally
syn keyword xshStatement    global lambda pass print raise return try with
syn keyword xshStatement    yield
syn keyword xshStatement    def class nextgroup=xshFunction skipwhite
syn keyword xshRepeat    for while
syn keyword xshConditional    if elif else
syn keyword xshOperator    and in is not or
syn keyword xshPreCondit    import from
syn keyword xshTodo    TODO FIXME XXX contained

syn match xshComment    '#.*$' contains=xshTodo
syn match xshFunction    '[a-zA-Z_][a-zA-Z0-9_]*' contained
syn match xshEnvironmentVariable '\v\$[a-zA-Z0-9_]+'

" Do not spell doctests inside strings.
" Notice that the end of a string, either ''', or """, will end the contained
" doctest too.  Thus, we do *not* need to have it as an end pattern.
syn region pythonDoctest
      \ start="^\s*>>>\s" end="^\s*$"
      \ contained contains=ALLBUT,pythonDoctest,pythonFunction,@Spell
syn region pythonDoctestValue
      \ start=+^\s*\%(>>>\s\|\.\.\.\s\|"""\|'''\)\@!\S\++ end="$"
	  \ contained
syn region xshString    matchgroup=Normal start=+[uU]\='+ end=+'+ skip=+\\\\\|\\'+ contains=xshEscape
syn region xshString    matchgroup=Normal start=+[uU]\="+ end=+"+ skip=+\\\\\|\\"+ contains=xshEscape
syn region xshString    matchgroup=Normal start=+[uU]\="""+ end=+"""+  contains=xshEscape
syn region xshString    matchgroup=Normal start=+[uU]\='''+ end=+'''+  contains=xshEscape
syn region xshString    matchgroup=Normal start=+[uU]\=[rR]'+ end=+'+ skip=+\\\\\|\\'+
syn region xshString    matchgroup=Normal start=+[uU]\=[rR]"+ end=+"+ skip=+\\\\\|\\"+
syn region xshString    matchgroup=Normal start=+[uU]\=[rR]"""+ end=+"""+
syn region xshString    matchgroup=Normal start=+[uU]\=[rR]'''+ end=+'''+

syn match xshEscape    +\\[abfnrtv\'"\\]+ contained
syn match xshEscape    "\\\o\{1,3}" contained
syn match xshEscape    "\\x\x\{2}" contained
syn match xshEscape    "\(\\u\x\{4}\|\\U\x\{8}\)" contained

syn match xshEscape    "\\$"

syn match xshNumber    "\<0x\x\+[Ll]\=\>"
syn match xshNumber    "\<\d\+[LljJ]\=\>"
syn match xshNumber    "\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
syn match xshNumber    "\<\d\+\.\([eE][+-]\=\d\+\)\=[jJ]\=\>"
syn match xshNumber    "\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"


syn keyword xshBuiltin    Ellipsis False None NotImplemented True __debug__
syn keyword xshBuiltin    __import__ abs all any apply basestring bin bool
syn keyword xshBuiltin    buffer bytearray bytes callable chr classmethod
syn keyword xshBuiltin    cmp coerce compile complex copyright credits
syn keyword xshBuiltin    delattr dict dir divmod enumerate eval execfile
syn keyword xshBuiltin    exit file filter float format frozenset getattr
syn keyword xshBuiltin    globals hasattr hash help hex id input int intern
syn keyword xshBuiltin    isinstance issubclass iter len license list
syn keyword xshBuiltin    locals long map max memoryview min next object
syn keyword xshBuiltin    oct open ord pow print property quit range
syn keyword xshBuiltin    raw_input reduce reload repr reversed round set
syn keyword xshBuiltin    setattr slice sorted staticmethod str sum super
syn keyword xshBuiltin    tuple type unichr unicode vars xrange zip


syn keyword xshException    ArithmeticError AssertionError AttributeError
syn keyword xshException    BaseException BufferError BytesWarning
syn keyword xshException    DeprecationWarning EOFError EnvironmentError
syn keyword xshException    Exception FloatingPointError FutureWarning
syn keyword xshException    GeneratorExit IOError ImportError ImportWarning
syn keyword xshException    IndentationError IndexError KeyError
syn keyword xshException    KeyboardInterrupt LookupError MemoryError
syn keyword xshException    ModuleNotFoundError
syn keyword xshException    NameError NotImplementedError OSError
syn keyword xshException    OverflowError PendingDeprecationWarning
syn keyword xshException    ReferenceError RuntimeError RuntimeWarning
syn keyword xshException    StandardError StopIteration SyntaxError
syn keyword xshException    SyntaxWarning SystemError SystemExit TabError
syn keyword xshException    TypeError UnboundLocalError UnicodeDecodeError
syn keyword xshException    UnicodeEncodeError UnicodeError
syn keyword xshException    UnicodeTranslateError UnicodeWarning
syn keyword xshException    UserWarning ValueError Warning
syn keyword xshException    ZeroDivisionError

syn match xshSpaceError    display excludenl "\S\s\+$"ms=s+1
syn match xshSpaceError    display " \+\t"
syn match xshSpaceError    display "\t\+ "

hi def link xshComment Comment
hi def link xshConditional Conditional
hi def link xshEscape Special
hi def link xshFunction Function
hi def link xshOperator Operator
hi def link xshPreCondit PreCondit
hi def link xshRepeat Repeat
hi def link xshStatement Statement
hi def link xshString String
hi def link xshTodo Todo

hi def link xshNumber Number
hi def link xshEnvironmentVariable Number

hi def link xshBuiltin Function
hi def link xshException Exception
hi def link xshSpaceError Error

" Uncomment the 'minlines' statement line and comment out the 'maxlines'
" statement line; changes behaviour to look at least 2000 lines previously for
" syntax matches instead of at most 200 lines
syn sync match xshSync grouphere NONE "):$"

" syn sync maxlines=200
syn sync 
syn sync  minlines=2000 fromstart

let b:current_syntax = 'xonsh'
