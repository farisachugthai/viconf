" Name:         Gruvbox Material
" Maintainer:   Faris Chugthai
" NOTE: On line 1378 is a font bound to `Normal`. Change that before copy
" pasting!
" Last Author:  Sainnhepark <sainnhe@gmail.com>
" Last Updated: Dec 10, 2019

scriptencoding utf8  " {{{

let s:cpo_save = &cpoptions
set cpoptions-=C
hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'gruvbox-material'

let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 2
let s:italics = (((&t_ZH !=# '' && &t_ZH != '[7m') || has('gui_running')) && !has('iOS')) || has('nvim')

" }}}

" My Additions: {{{

let g:gruvbox_material_transparent_background = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_background = 'hard'

" From ned batchelder.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Standard Highlights: {{{
" These got cleared somehow.
" Screen line that the cursor is
hi! CursorLine ctermbg=237 guibg=#3c3836 guifg=NONE ctermfg=NONE cterm=NONE gui=NONE guisp=NONE

" Line number of CursorLine
hi! CursorLineNr guifg=#fabd2f guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE ctermbg=237

" Screen column that the cursor is
hi! link CursorColumn CursorLine

" Additional Links

hi link manEmail Directory
hi link manHeaderFile Statement
" hi link manHighlight
hi link NormalNC Ignore
hi link VisualNC Visual

" }}}
" Plugins: {{{

" NERDTree: {{{

hi link NERDTreeBookmarks Typedef
hi link NERDTreeCWD Underlined
hi link NERDTreeDir Directory
hi link NERDTreeDirSlash Delimiter
hi link NERDTreeNodeDelimeters Delimiter
hi link hideBracketsInNERDTree Conceal
hi! link NERDTreeFile Structure

" }}}
" Asynchronous Lint Engine: {{{

" call s:HL('ALEError', s:none, s:none, s:undercurl, s:red)
" call s:HL('ALEWarning', s:none, s:none, s:undercurl, s:yellow)
" call s:HL('ALEInfo', s:none, s:none, s:undercurl, s:blue)

hi link ALEErrorSign Error
hi link ALEWarningSign QuickFixLine
hi link ALEInfoSign Directory
hi link ALEError Error
hi link ALEWarning QuickFixLine
hi link ALEInfo Macro

" }}}
" GitGutter: {{{

hi link GitGutterAdd GruvboxGreenSign
hi link GitGutterChange Macro
hi link GitGutterDelete GruvboxRedSign
hi link GitGutterChangeDelete Macro

" }}}
" GitCommit: "{{{
" Do I have this plugin? Is this a fugitive thing?
hi link gitcommitSelectedFile GruvboxGreen
hi link gitcommitDiscardedFile GruvboxRed

" }}}
" Tagbar: {{{
hi! link TagbarSignature Question
hi! link TagbarTitle Title
" I mean this is whats displayed at the top of the buffer so why not title?
hi! link TagbarHelp Define

" }}}
" FZF: {{{

hi! fzf1 ctermfg=161 ctermbg=238 guifg=#E12672 guibg=#565656 cterm=bold,underline
hi! fzf2 ctermfg=151 ctermbg=238 guifg=#BCDDBD guibg=#565656 cterm=bold,underline
hi! fzf3 ctermfg=252 ctermbg=238 guifg=#D9D9D9 guibg=#565656 cterm=bold,underline
" }}}
" }}}
" Filetype specific ------------------------------------------------------- {{{
" Man.vim: {{{
" Define the default highlighting.
" Only when an item doesn't have highlighting yet

highlight default link manTitle          Title
highlight default link manSectionHeading Statement
highlight default link manOptionDesc     Constant
highlight default link manReference      PreProc
highlight default link manSubHeading     Function

highlight default link manUnderline Underlined
highlight default link manBold GruvboxYellowBold
highlight default link manItalic htmlItalic

" And the rest
hi! link manCError Error
hi! link manEmail Directory
hi! link manEnvVar Identifier
hi! link manEnvVarFile Identifier
hi! link manEnvVarFile Identifier
hi! link manFile GruvboxYellow
hi! link manFiles GruvboxFg0
hi! link manFooter GruvboxPurple
hi! link manHighlight GruvboxYellow
hi! link manHistory GruvboxYellow
hi! link manHeaderFile GruvboxYellow
hi! link manSectionHeading GruvboxOrangeBold
hi! link manSentence GruvboxFg2
hi! link manSignal GruvboxPurple
hi! link manURL GruvboxGreen

" }}}
" Netrw: {{{
" Hate to be that guy but Netrw is considered an ftplugin

hi link netrwClassify Directory
hi link netrwCmdNote Directory
hi link netrwCmdSep VertSplit
hi link netrwComma Delimiter
hi link netrwComment Comment
if has('nvim')
  hi link netrwCopyTgt IncSearch
else
  " Is this canoniccal vim?
  hi link netrwCopyTgt StorageClass
endif

hi link netrwDateSep Delimiter
hi link netrwDir Directory
hi link netrwExe Macro
hi link netrwGray Folded
hi link netrwHelpCmd Directory
hi link netrwHide Conceal
hi link netrwHidePat Folded
hi link netrwLib Directory
hi link netrwLink Underlined
hi link netrwList PreCondit
hi link netrwPlain String
hi link netrwQHTopic Number
hi link netrwSizeDate Delimiter
hi link netrwSlash Delimiter
hi link netrwSortBy Title
hi link netrwSortSeq netrwList
hi link netrwSpecial netrwClassify
hi link netrwSymLink Special
hi link netrwTime Delimiter
hi link netrwTimeSep Delimiter
hi link netrwTreeBar Special
hi link netrwTreeBarSpace Special
hi link netrwVersion Float

" }}}
" Rst: {{{

hi! link rstDirectivesh     Question
hi! link rstDirectivepython Question
hi! link rstInlineLiteral   Identifier

" Well heres the built in syntax file
hi link rstCitation                     String
hi link rstCitationReference            Identifier
hi link rstCodeBlock                    String
hi link rstComment                      Comment
hi link rstDelimiter                    Delimiter
hi link rstDirective                    Keyword
hi link rstDoctestBlock                 PreProc
" hi link rstExDirective                  String
" Blends in with the rest of the string
hi link rstExDirective                  Identifier
hi link rstExplicitMarkup               rstDirective
hi link rstFileLink                     rstHyperlinkReference
hi link rstFootnote                     String
hi link rstFootnoteReference            Identifier
hi link rstHyperLinkReference           Identifier
hi link rstHyperlinkTarget              String
hi link rstInlineInternalTargets        Identifier
hi link rstInlineLiteral                String
hi link rstInterpretedTextOrHyperlinkReference  Identifier
hi link rstLiteralBlock                 String
hi link rstQuotedLiteralBlock           String
hi link rstSections                     Title
hi! link rstSimpleTable                 Orange
hi! link rstSimpleTableLines            OrangeBold
hi link rstStandaloneHyperlink          Identifier
hi link rstSubstitutionDefinition       rstDirective
hi link rstSubstitutionReference        PreProc
hi! link rstTable                       Orange
hi! link rstTableLines                   Orange
hi link rstTodo                         Todo
hi link rstTransition                   rstSections

hi! link rstDirectivesh     Question
hi! link rstDirectivepython Question
hi! link rstInlineLiteral   Identifier

" }}}
" Tmux: {{{

hi def link tmuxFormatString      Identifier
hi def link tmuxAction            Boolean
hi def link tmuxBoolean           Boolean
hi def link tmuxCommands          Keyword
hi def link tmuxComment           Comment
hi def link tmuxKey               Special
hi def link tmuxNumber            Number
hi def link tmuxFlags             Identifier
hi def link tmuxOptions           Function
hi def link tmuxString            String
hi def link tmuxTodo              Todo
hi def link tmuxVariable          Identifier
hi def link tmuxVariableExpansion Identifier
hi! link tmuxColor SpecialKey

" }}}
" Diff: {{{

hi DiffAdd guifg=#b8bb26 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=100 ctermbg=234
hi DiffChange guifg=#8ec07c guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=29 ctermbg=234
hi DiffDelete guifg=#fb4934 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=124 ctermbg=234
hi DiffText guifg=#fabd2f guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=172 ctermbg=234
hi! link diffAdded GruvboxGreen
hi! link diffRemoved GruvboxRed
hi! link diffChanged Directory

hi! link diffFile GruvboxOrange
hi! link diffNewFile GruvboxYellow

hi! link diffLine GruvboxBlue

" }}}
" Html: {{{

hi link htmlScriptTag Tag

" Default syntax
hi link htmlTag                     Function
hi link htmlEndTag                  Identifier
hi link htmlArg                     Type
hi link htmlTagName                 htmlStatement
hi link htmlSpecialTagName          Exception
hi link htmlValue                     String
hi link htmlSpecialChar             Special

hi htmlBold                cterm=bold gui=bold
hi htmlBoldUnderline       cterm=bold,underline gui=bold,underline
hi htmlBoldItalic          cterm=bold,italic gui=bold,italic
hi htmlBoldUnderlineItalic  cterm=bold,italic,underline gui=bold,italic,underline
hi htmlUnderline           cterm=underline gui=underline
hi htmlUnderlineItalic     cterm=italic,underline gui=italic,underline
hi htmlItalic              cterm=italic gui=italic
hi link htmlH1                      Title
hi link htmlH2                      htmlH1
hi link htmlH3                      htmlH2
hi link htmlH4                      htmlH3
hi link htmlH5                      htmlH4
hi link htmlH6                      htmlH5
hi link htmlHead                    PreProc
hi link htmlTitle                   Title
hi link htmlBoldItalicUnderline     htmlBoldUnderlineItalic
hi link htmlUnderlineBold           htmlBoldUnderline
hi link htmlUnderlineItalicBold     htmlBoldUnderlineItalic
hi link htmlUnderlineBoldItalic     htmlBoldUnderlineItalic
hi link htmlItalicUnderline         htmlUnderlineItalic
hi link htmlItalicBold              htmlBoldItalic
hi link htmlItalicBoldUnderline     htmlBoldUnderlineItalic
hi link htmlItalicUnderlineBold     htmlBoldUnderlineItalic
hi link htmlLink                    Underlined
hi link htmlLeadingSpace            None

if v:version > 800 || v:version == 800 && has("patch1038")
		hi def htmlStrike              term=strikethrough cterm=strikethrough gui=strikethrough
else
		hi def htmlStrike              term=underline cterm=underline gui=underline
endif

hi link htmlPreStmt            PreProc
hi link htmlPreError           Error
hi link htmlPreProc            PreProc
hi link htmlPreAttr            String
hi link htmlPreProcAttrName    PreProc
hi link htmlPreProcAttrError   Error
hi link htmlSpecial            Special
hi link htmlSpecialChar        Special
hi link htmlString             String
hi link htmlStatement          Statement
hi link htmlComment            Comment
hi link htmlCommentPart        Comment
hi link htmlValue              String
hi link htmlCommentError       htmlError
hi link htmlTagError           htmlError
hi link htmlEvent              javaScript
hi link htmlError              Error

hi link javaScript             Special
hi link javaScriptExpression   javaScript
hi link htmlCssStyleComment    Comment
hi link htmlCssDefinition      Special
" }}}
" Xml: {{{

hi! link xmlTag GruvboxBlue
hi! link xmlEndTag GruvboxBlue
hi! link xmlTagName GruvboxBlue
hi! link xmlEqual GruvboxBlue
hi! link docbkKeyword Keyword

hi! link xmlDocTypeDecl GruvboxGray
hi! link xmlDocTypeKeyword Keyword
hi! link xmlCdataStart GruvboxGray
hi! link xmlCdataCdata GruvboxPurple
hi! link dtdFunction GruvboxGray
hi! link dtdTagName GruvboxPurple

hi! link xmlAttrib Directory
hi! link xmlProcessingDelim GruvboxGray
hi! link dtdParamEntityPunct GruvboxGray
hi! link dtdParamEntityDPunct GruvboxGray
hi! link xmlAttribPunct GruvboxGray

hi! link xmlEntity GruvboxOrange
hi! link xmlEntityPunct GruvboxOrange
" }}}
" Sh: {{{
hi link bashAdminStatement	shStatement
hi link bashSpecialVariables	shShellVariables
hi link bashStatement		shStatement
hi link shAlias		Identifier
hi link shArithRegion	shShellVariables
hi link shArithmetic		Special
hi link shAstQuote	shDoubleQuote
hi link shAtExpr	shSetList
hi link shBQComment	shComment
hi link shBeginHere	shRedir
hi link shBkslshDblQuote	shDoubleQuote
hi link shBkslshSnglQuote	shSingleQuote
hi link shCase             Question
hi link shCaseBar	shConditional
hi link shCaseCommandSub	shCommandSub
hi link shCaseDoubleQuote	shDoubleQuote
hi link shCaseError		Error
hi link shCaseEsac         Question
hi link shCaseEsacSync     Question
hi link shCaseExSingleQuote Question
hi link shCaseIn	shConditional
hi link shCaseLabel        Question
hi link shCaseRange        Question
hi link shCaseSingleQuote	shSingleQuote
hi link shCaseStart	shConditional
hi link shCharClass		Identifier
hi link shCmdParenRegion   Question
hi link shCmdSubRegion	shShellVariables
hi link shColon	shComment
hi link shComma            Question
hi link shCommandSub		Special
hi link shCommandSubBQ		shCommandSub
hi link shComment		Comment
hi link shCondError		Error
hi link shConditional		Conditional
hi link shCtrlSeq		Special
hi link shCurlyError		Error
hi link shCurlyIn          Question
hi link shDblBrace         Question
hi link shDblParen         Question
hi link shDeref	shShellVariables
hi link shDerefDelim	shOperator
hi link shDerefEscape      Question
hi link shDerefLen		shDerefOff
hi link shDerefOff		shDerefOp
hi link shDerefOp	shOperator
hi link shDerefOpError		Error
hi link shDerefPOL	shDerefOp
hi link shDerefPPS	shDerefOp
hi link shDerefPPSleft     Question
hi link shDerefPPSright    Question
hi link shDerefPSR	shDerefOp
hi link shDerefPSRleft     Question
hi link shDerefPSRright    Question
hi link shDerefPattern     Question
hi link shDerefSimple	shDeref
hi link shDerefSpecial	shDeref
hi link shDerefString	shDoubleQuote
hi link shDerefVar	shDeref
hi link shDerefVarArray    Question
hi link shDerefWordError		Error
hi link shDo               Question
hi link shDoError		Error
hi link shDoSync           Question
hi link shDoubleQuote	shString
hi link shEcho	shString
hi link shEchoDelim	shOperator
hi link shEchoQuote	shString
hi link shEmbeddedEcho	shString
hi link shEsacError		Error
hi link shEscape	shCommandSub
hi link shExDoubleQuote	shDoubleQuote
hi link shExSingleQuote	shSingleQuote
hi link shExpr             Question
hi link shExprRegion		Delimiter
hi link shFor              Question
hi link shForPP	shLoop
hi link shForSync          Question
hi link shFunction	Function
hi link shFunctionFour     Question
hi link shFunctionKey		Keyword
hi link shFunctionName		Function
hi link shFunctionOne      Identifier
hi link shFunctionStart    Question
hi link shFunctionThree    Question
hi link shFunctionTwo      Question
hi link shHereDoc	shString
hi link shHereDoc01		shRedir
hi link shHereDoc02		shRedir
hi link shHereDoc03		shRedir
hi link shHereDoc04		shRedir
hi link shHereDoc05		shRedir
hi link shHereDoc06		shRedir
hi link shHereDoc07		shRedir
hi link shHereDoc08		shRedir
hi link shHereDoc09		shRedir
hi link shHereDoc10		shRedir
hi link shHereDoc11		shRedir
hi link shHereDoc12		shRedir
hi link shHereDoc13		shRedir
hi link shHereDoc14		shRedir
hi link shHereDoc15		shRedir
hi link shHereDoc16        Question
hi link shHerePayload	shHereDoc
hi link shHereString	shRedir
hi link shIf               Identifier
hi link shIfSync           Question
hi link shInError		Error
hi link shLoop	shStatement
hi link shNoQuote	shDoubleQuote
hi link shNumber		Number
hi link shOK               Question
hi link shOperator		Operator
hi link shOption	shCommandSub
hi link shParen	shArithmetic
hi link shParenError		Error
hi link shPattern	shString
hi link shPosnParm	shShellVariables
hi link shQuickComment	shComment
hi link shQuote	shOperator
hi link shRange	shOperator
hi link shRedir	shOperator
hi link shRepeat		Repeat
hi link shSet		Statement
hi link shSetList		Identifier
hi link shSetListDelim	shOperator
hi link shSetOption	shOption
hi link shShellVariables		PreProc
hi link shSingleQuote	shString
hi link shSnglCase		Statement
hi link shSource	shOperator
hi link shSource	shOperator
hi link shSpecial		Special
hi link shSpecialDQ		Special
hi link shSpecialNoZS		shSpecial
hi link shSpecialNxt	shSpecial
hi link shSpecialSQ		Special
hi link shSpecialStart	shSpecial
hi link shSpecialVar       Question
hi link shStatement		Statement
hi link shString		String
hi link shStringSpecial	shSpecial
hi link shSubSh            Question
hi link shSubShRegion	shOperator
hi link shTest             Question
hi link shTestDoubleQuote	shString
hi link shTestError		Error
hi link shTestOpr	shConditional
hi link shTestPattern	shString
hi link shTestSingleQuote	shString
hi link shTodo		Todo
hi link shTouch            Question
hi link shTouchCmd	shStatement
hi link shUntilSync        Question
hi link shVarAssign        Question
hi link shVariable	shSetList
hi link shWhileSync        Question
hi link shWrapLineOperator	shOperator

" }}}
if has('nvim')  " {{{
	" How does a nice light blue sound?
	hi! NvimInternalError guibg=NONE ctermfg=108 ctermbg=234 gui=reverse guifg=#8ec0e1 guisp=NONE
	hi link nvimAutoEvent	vimAutoEvent
	hi link nvimHLGroup	vimHLGroup
  hi link NvimIdentifierKey IdentifierBold
	hi link nvimInvalid Exception
	hi link nvimMap	vimMap
	hi link nvimUnmap	vimUnmap

	hi link TermCursor Cursor
	hi TermCursorNC ctermfg=237 ctermbg=223 guifg=#3c3836 guibg=#ebdbb2 guisp=NONE cterm=NONE gui=NONE

	" *hl-NormalFloat* NormalFloat	Normal text in floating windows.
	hi NormalFloat ctermfg=223 ctermbg=234 guifg=#ebdbb2 guibg=#1d2021 guisp=NONE gui=undercurl cterm=undercurl

	" *hl-IncSearch*
	" IncSearch	'incsearch' highlighting; also used for the text replaced with ':s///c'
	hi IncSearch cterm=reverse ctermfg=208 ctermbg=234 gui=reverse guifg=#fe8019 guibg=#1d2021 guisp=NONE

	" From he nvim-terminal-emulator
	hi debugPC term=reverse ctermbg=darkblue guibg=darkblue
	hi debugBreakpoint term=reverse ctermbg=red guibg=red
endif

" }}}
" Python: {{{
hi link pythonAsync			Statement
hi link pythonAttribute TypeDef
hi link pythonBoolean Boolean
hi! link pythonBoolean Purple
hi! link pythonBuiltin Orange
hi! link pythonBuiltinFunc Orange
hi! link pythonBuiltinObj Orange
hi link pythonComment		Comment
hi! link pythonCoding Blue
hi! link pythonConditional Red
hi! link pythonDecorator Red
hi link pythonComment		Comment
hi! link pythonDot Grey
hi! link pythonDottedName GreenBold
hi link pythonEscape		Special
hi! link pythonException Red
hi! link pythonExceptions Purple
hi! link pythonFunction Aqua
hi! link pythonImport Blue
hi! link pythonInclude Blue
hi link pythonMatrixMultiply Number
hi link pythonNumber Number
hi! link pythonOperator Orange
hi link pythonQuotes		String
hi link pythonRawString		String
hi! link pythonRepeat Red
hi! link pythonRun Blue
hi link pythonSpaceError		Error
hi link pythonStatement		Statement
hi link pythonString		String
hi link pythonSync IdentifierBold
hi link pythonTodo			Todo
hi link pythonTripleQuotes		pythonQuotes

" }}}
" Vim: {{{
" Defined In Syntax File: {{{
hi! link vimAbb	vimCommand
hi! link vimAddress	vimMark
hi! link vimAuHighlight	vimHighlight
hi! link vimAugroupError	Error
hi! link vimAugroupKey	Keyword
hi! link vimAutoCmd	vimCommand
hi! link vimAutoCmdOpt	vimOption
hi! link vimAutoEvent	Type
hi! link vimAutoSet	vimCommand
hi! link vimBehave	vimCommand
hi! link vimBehaveModel	vimBehave
hi! link vimBracket	Delimiter
hi! link vimCmplxRepeat	SpecialChar
hi! link vimCommand	Statement
hi! link vimComment	Comment
hi! link vimCommentString	vimString
hi! link vimCommentTitle	PreProc
hi! link vimCondHL	vimCommand
hi! link vimContinue	Special
hi! link vimCtrlChar	SpecialChar
hi! link vimEchoHL	vimCommand
hi! link vimEchoHLNone	vimGroup
hi! link vimElseIfErr	Error
hi! link vimElseif	vimCondHL
hi! link vimEnvvar	PreProc
hi! link vimError	Error
hi! link vimFBVar	vimVar
hi! link vimFTCmd	vimCommand
hi! link vimFTOption	vimSynType
hi! link vimFgBgAttrib	vimHiAttrib
hi! link vimFold	Folded
hi! link vimFunc Function
hi! link vimFuncKey	vimCommand
hi! link vimFuncName	Function
hi! link vimFuncSID	Special
hi! link vimFuncVar	Identifier
hi! link vimFunction Function
hi! link vimGroup	Type
hi! link vimGroupAdd	vimSynOption
hi! link vimGroupName	vimGroup
hi! link vimGroupRem	vimSynOption
hi! link vimGroupSpecial	Special
hi! link vimHLGroup	vimGroup
hi! link vimHLMod	PreProc
hi! link vimHiAttrib	PreProc
hi! link vimHiBang vimHighlight
hi! link vimHiCTerm	vimHiTerm
hi! link vimHiClear	vimHighlight
hi! link vimHiCtermFgBg	vimHiTerm
hi! link vimHiGroup	vimGroupName
hi! link vimHiGui	vimHiTerm
hi! link vimHiGuiFgBg	vimHiTerm
hi! link vimHiGuiFont	vimHiTerm
hi! link vimHiGuiRgb	vimNumber
hi! link vimHiNmbr	Number
hi! link vimHiStartStop	vimHiTerm
hi! link vimHiTerm	Type
hi! link vimHighlight	Operator
hi! link vimInsert	vimString

" vimIsCommand is a terrible regex honestly don't match it with anything
" Output of `syn list vimIsCommand
" --- Syntax items ---
" vimIsCommand   xxx match /\<\h\w*\>/  contains=vimCommand
"                    match /<Bar>\s*\a\+/  transparent contains=vimCommand,vimNotation
" \h is any upper case letter. \w is any letter. wtf? that contains SO many false positives

" hi! link vimIsCommand       vimOption
hi! link vimIskSep	Delimiter
hi! link vimKeyCode	vimSpecFile
hi! link vimKeyword	Statement
hi! link vimLet	vimCommand
hi! link vimLineComment	vimComment
hi! link vimMap	vimCommand
hi! link vimMapBang	vimCommand
hi! link vimMapMod	vimBracket
hi! link vimMapModKey	vimFuncSID
hi! link vimMark	Number
hi! link vimMarkNumber	vimNumber
hi! link vimMenuMod	vimMapMod
hi! link vimMenuName	PreProc
hi! link vimMenuNameMore	vimMenuName
hi! link vimMtchComment	vimComment
hi! link vimNorm	vimCommand
hi! link vimNotFunc	vimCommand
hi! link vimNotPatSep	vimString
hi! link vimNotation	Special
hi! link vimNumber GruvboxRed
hi! link vimOper	Operator
hi! link vimOperError	Error
hi! link vimOption	PreProc
hi! link vimParenSep	Delimiter
hi! link vimPatSep	SpecialChar
hi! link vimPatSepErr	vimError
hi! link vimPatSepR	vimPatSep
hi! link vimPatSepZ	vimPatSep
hi! link vimPatSepZone	vimString
hi! link vimPattern	Type
hi! link vimPlainMark	vimMark
hi! link vimPlainRegister	vimRegister
hi! link vimRegister	SpecialChar
hi! link vimScriptDelim	Comment
hi! link vimSearch	vimString
hi! link vimSearchDelim	Statement
hi! link vimSep	Delimiter
hi! link vimSetMod	vimOption
hi! link vimSetSep	Statement
hi! link vimSetString	vimString
hi! link vimSpecFile	Identifier
hi! link vimSpecFileMod	vimSpecFile
hi! link vimSpecial	Type
hi! link vimStatement	Statement
hi! link vimStdPlugin       Function
hi! link vimString	String
hi! link vimStringCont	vimString
hi! link vimStringEnd	vimString
hi! link vimSubst	vimCommand
hi! link vimSubst1	vimSubst
hi! link vimSubstDelim	Delimiter
hi! link vimSubstFlags	Special
hi! link vimSubstSubstr	SpecialChar
hi! link vimSubstTwoBS	vimString
hi! link vimSynCase	Type
hi! link vimSynCaseError	Error
hi! link vimSynContains	vimSynOption
hi! link vimSynError	Error
hi! link vimSynKeyContainedin	vimSynContains
hi! link vimSynKeyOpt	vimSynOption
hi! link vimSynMtchGrp	vimSynOption
hi! link vimSynMtchOpt	vimSynOption
hi! link vimSynNextgroup	vimSynOption
hi! link vimSynNotPatRange	vimSynRegPat
hi! link vimSynOption	Special
hi! link vimSynPatRange	vimString
hi! link vimSynReg	Type
hi! link vimSynRegOpt	vimSynOption
hi! link vimSynRegPat	vimString
hi! link vimSynType	vimSpecial
hi! link vimSyncC	Type
hi! link vimSyncError	Error
hi! link vimSyncGroup	vimGroupName
hi! link vimSyncGroupName	vimGroupName
hi! link vimSyncKey	Type
hi! link vimSyncNone	Type
hi! link vimSyntax	vimCommand
hi! link vimTodo	Todo
hi! link vimUnmap	vimMap
hi! link vimUserAttrb	vimSpecial
hi! link vimUserAttrbCmplt	vimSpecial
hi! link vimUserAttrbCmpltFunc	Special
hi! link vimUserAttrbError	Error
hi! link vimUserAttrbKey	vimOption
hi! link vimUserCmd vimUserCommand
hi! link vimUserCmdError	Error
hi! link vimUserCommand	vimCommand
hi! link vimVar	Identifier
hi! link vimWarn	WarningMsg

" }}}
" Vim Errors: {{{
hi link vimBehaveError	vimError
hi link vimBufnrWarn	vimWarn
hi link vimCollClassErr	vimError
hi link vimEmbedError	vimError
hi link vimErrSetting	vimError
hi link vimFTError	vimError
hi link vimFunc         	vimError
hi link vimFuncBody Function
hi link vimFunctionError	vimError
hi link vimHiAttribList	vimError
hi link vimHiCtermError	vimError
hi link vimHiKeyError	vimError
hi link vimKeyCodeError	vimError
hi link vimMapModErr	vimError
hi link vimSubstFlagErr	vimError
hi link vimSynCaseError	vimError
hi link vimSynError Exception
hi! link vimNotation Orange
hi! link vimBracket Orange
hi! link vimMapModKey Purple
hi! link vimMapMod Purple
hi! link vimFuncSID LightGrey
hi! link vimSetSep LightGrey
hi! link vimSep LightGrey
hi! link vimContinue LightGrey
hi! link vimLet Orange
hi! link vimAutoCmd Orange

" Vim etc: {{{
" Here's every highlighting group I've ran into and a note with what it represents
" The last letter of an autocmd like wth
hi link vimAugroup	vimAugroupKey

" Lmao the comma between BufEnter,BufReadPre
hi link vimAutoEventList vimAutoEvent

" Don't link to WildMenu it's the space in between the word cluster and the
" cluster group
" hi link vimClusterName WildMenu
hi link vimClusterName NONE
hi link vimCmdSep vimCommand
hi link vimCommentTitleLeader	vimCommentTitle
hi link vimEcho	String

" the spaces between words in an execute statement like wth
hi link vimExecute Label

hi link vimHiAttribList Underlined
hi link vimHiCtermColor Underlined
hi link vimHiFontname Underlined
hi link vimHiKeyList Keyword

hi link vimIskSep Keyword
hi link vimMapModErr Exception

hi link vimMapLhs vimNotation
hi link vimMapRhs vimNotation
hi link vimMapRhsExtend	vimNotation
hi link vimOnlyHLGroup VisualNOS
hi link vimOnlyCommand vimCommand
hi link vimOnlyOption GruvboxGreen
hi link vimSet vimSetEqual

" There's a highlighting group for the equals sign in a set option statement...
hi link vimSetEqual	Operator
hi link vimSynKeyRegion Keyword
hi link vimHiAttribList vimHighlight

" This syntax group is literally whitespace...
hi link vimSynRegion Nontext
hi link vimSyncLines Number

" Here are a few more xxx cleared syn groups
hi link vimUserFunc Function

hi link vimPythonRegion Identifier

" }}}

" }}}
"
" }}}

" }}}

" }}}

" Original: {{{
" Filetypes: {{{
hi! link markdownH5 Yellow
hi! link markdownH6 Yellow
hi! link markdownCode Green
hi! link markdownCodeBlock Aqua
hi! link markdownCodeDelimiter Aqua
hi! link markdownBlockquote Grey
hi! link markdownListMarker Red
hi! link markdownOrderedListMarker Grey
hi! link markdownRule Grey
hi! link markdownHeadingRule Grey
hi! link markdownUrlDelimiter Grey
hi! link markdownLinkDelimiter Grey
hi! link markdownLinkTextDelimiter Grey
hi! link markdownHeadingDelimiter Orange
hi! link markdownLinkText Aqua
hi! link markdownUrlTitleDelimiter Green
hi! link markdownIdDeclaration markdownLinkText
hi! link markdownBoldDelimiter Grey
hi! link cOperator Purple
hi! link cStructure Orange
hi! link cppOperator Purple
hi! link docbkKeyword AquaBold
hi! link dtdFunction Grey
hi! link dtdParamEntityDPunct Grey
hi! link dtdParamEntityPunct Grey
hi! link dtdTagName Purple
hi! link htmlArg Orange
hi! link htmlEndTag AquaBold
hi! link htmlScriptTag Purple
hi! link htmlSpecialChar Red
hi! link htmlSpecialTagName Blue
hi! link htmlTag AquaBold
hi! link htmlTagN White
hi! link htmlTagName Blue
hi! link mkdBold Grey
hi! link mkdCodeDelimiter Aqua
hi! link mkdDelimiter Grey
hi! link mkdHeading Orange
hi! link mkdId Yellow
hi! link mkdLink Aqua
hi! link mkdListItem Red
hi! link objcDirective Blue
hi! link objcTypeModifier Red
hi! link xmlAttrib Orange
hi! link xmlAttribPunct Grey
hi! link xmlCdataCdata Purple
hi! link xmlCdataStart Grey
hi! link xmlDocTypeDecl Grey
hi! link xmlDocTypeKeyword Purple
hi! link xmlEndTag AquaBold
hi! link xmlEntity Red
hi! link xmlEntityPunct Red
hi! link xmlEqual Blue
hi! link xmlProcessingDelim Grey
hi! link xmlTag AquaBold
hi! link xmlTagName AquaBold

hi! link cssBraces White
hi! link cssFunctionName Yellow
hi! link cssIdentifier Orange
hi! link cssClassName Green
hi! link cssColor Blue
hi! link cssSelectorOp Blue
hi! link cssSelectorOp2 Blue
hi! link cssImportant Green
hi! link cssTextProp Aqua
hi! link cssAnimationProp Aqua
hi! link cssUIProp Yellow
hi! link cssTransformProp Aqua
hi! link cssTransitionProp Aqua
hi! link cssPrintProp Aqua
hi! link cssPositioningProp Yellow
hi! link cssBoxProp Aqua
hi! link cssFontDescriptorProp Aqua
hi! link cssFlexibleBoxProp Aqua
hi! link cssBorderOutlineProp Aqua
hi! link cssBackgroundProp Aqua
hi! link cssMarginProp Aqua
hi! link cssListProp Aqua
hi! link cssTableProp Aqua
hi! link cssFontProp Aqua
hi! link cssPaddingProp Aqua
hi! link cssDimensionProp Aqua
hi! link cssRenderProp Aqua
hi! link cssColorProp Aqua
hi! link cssGeneratedContentProp Aqua
hi! link cssVendor White
hi! link javaScriptFunction Aqua
hi! link javaScriptIdentifier Red
hi! link javaScriptMember Blue
hi! link javaScriptNumber Purple
hi! link javaScriptNull Purple
hi! link javaScriptParens Blue
hi! link javaScriptBraces Blue
hi! link javascriptImport Aqua
hi! link javascriptExport Aqua
hi! link javascriptClassKeyword Aqua
hi! link javascriptClassExtends Aqua
hi! link javascriptDefault Aqua
hi! link javascriptClassName Yellow
hi! link javascriptClassSuperName Yellow
hi! link javascriptGlobal Yellow
hi! link javascriptEndColons Blue
hi! link javascriptFuncArg Blue
hi! link javascriptGlobalMethod Blue
hi! link javascriptNodeGlobal Blue
hi! link javascriptBOMWindowProp Blue
hi! link javascriptArrayMethod Blue
hi! link javascriptArrayStaticMethod Blue
hi! link javascriptCacheMethod Blue
hi! link javascriptDateMethod Blue
hi! link javascriptMathStaticMethod Blue
hi! link javascriptURLUtilsProp Blue
hi! link javascriptBOMNavigatorProp Blue
hi! link javascriptDOMDocMethod Blue
hi! link javascriptDOMDocProp Blue
hi! link javascriptBOMLocationMethod Blue
hi! link javascriptBOMWindowMethod Blue
hi! link javascriptStringMethod Blue
hi! link javascriptVariable Orange
hi! link javascriptIdentifier Orange
hi! link javascriptClassSuper Orange
hi! link javascriptFuncKeyword Aqua
hi! link javascriptAsyncFunc Aqua
hi! link javascriptClassStatic Orange
hi! link javascriptOperator Red
hi! link javascriptForOperator Red
hi! link javascriptYield Red
hi! link javascriptExceptions Red
hi! link javascriptMessage Red
hi! link javascriptTemplateSB Aqua
hi! link javascriptTemplateSubstitution Blue
hi! link javascriptLabel Blue
hi! link javascriptObjectLabel Blue
hi! link javascriptPropertyName Blue
hi! link javascriptLogicSymbols Purple
hi! link javascriptArrowFunc Yellow
hi! link javascriptDocParamName LightGrey
hi! link javascriptDocTags LightGrey
hi! link javascriptDocNotation LightGrey
hi! link javascriptDocParamType LightGrey
hi! link javascriptDocNamedParamType LightGrey
hi! link javascriptBrackets Blue
hi! link javascriptDOMElemAttrs Blue
hi! link javascriptDOMEventMethod Blue
hi! link javascriptDOMNodeMethod Blue
hi! link javascriptDOMStorageMethod Blue
hi! link javascriptHeadersMethod Blue
hi! link javascriptAsyncFuncKeyword Red
hi! link javascriptAwaitFuncKeyword Red
hi! link jsPrototype Yellow
hi! link jsOperator Orange
hi! link jsOperatorKeyword Red
hi! link jsClassKeyword Aqua
hi! link jsExtendsKeyword Aqua
hi! link jsExportDefault Aqua
hi! link jsTemplateBraces Blue
hi! link jsGlobalNodeObjects Blue
hi! link jsGlobalObjects Blue
hi! link jsFunction Aqua
hi! link jsFuncCall Blue
hi! link jsFuncParens Blue
hi! link jsParens Blue
hi! link jsNull Purple
hi! link jsUndefined Purple
hi! link jsClassDefinition Yellow
hi! link jsObjectKey GreenBold
hi! link typescriptReserved Aqua
hi! link typescriptLabel Aqua
hi! link typescriptFuncKeyword Aqua
hi! link typescriptIdentifier Orange
hi! link typescriptBraces Blue
hi! link typescriptEndColons Blue
hi! link typescriptDOMObjects Blue
hi! link typescriptAjaxMethods Blue
hi! link typescriptGlobalObjects Blue
hi! link typescriptParens Blue
hi! link typescriptOpSymbols Green
hi! link typescriptLogicSymbols Purple
hi! link typescriptInterpolation Aqua
hi! link typescriptHtmlElemProperties Blue
hi! link typescriptNull Purple
hi! link typescriptInterpolationDelimiter Aqua
hi! link typescriptDocSeeTag Comment
hi! link typescriptDocParam Comment
hi! link typescriptDocTags vimCommentTitle
hi! link jsxTagName Aqua
hi! link jsxComponentName Green
hi! link jsxCloseString LightGrey
hi! link jsxAttrib Yellow
hi! link jsxEqual Aqua
hi! link purescriptModuleKeyword Aqua
hi! link purescriptModuleName Blue
hi! link purescriptWhere Aqua
hi! link purescriptDelimiter White
hi! link purescriptType White
hi! link purescriptImportKeyword Aqua
hi! link purescriptHidingKeyword Aqua
hi! link purescriptAsKeyword Aqua
hi! link purescriptStructure Aqua
hi! link purescriptOperator Orange
hi! link purescriptTypeVar White
hi! link purescriptConstructor White
hi! link purescriptFunction White
hi! link purescriptConditional Orange
hi! link purescriptBacktick Orange
hi! link coffeeExtendedOp Orange
hi! link coffeeSpecialOp White
hi! link coffeeDotAccess Grey
hi! link coffeeCurly Orange
hi! link coffeeParen White
hi! link coffeeBracket Orange
hi! link javaAnnotation Blue
hi! link javaDocTags Aqua
hi! link javaParen White
hi! link javaParen1 White
hi! link javaParen2 White
hi! link javaParen3 White
hi! link javaParen4 White
hi! link javaParen5 White
hi! link javaOperator Orange
hi! link javaVarArg Green
hi! link javaCommentTitle vimCommentTitle
hi! link goBuiltins Orange
hi! link goConstants Purple
hi! link goDeclType Blue
hi! link goDeclaration Red
hi! link goDirective Aqua

hi! link rustDefault Aqua
hi! link rustEnum Aqua
hi! link rustEscape Aqua
hi! link rustModPathSep Grey
hi! link rustSigil Orange
hi! link rustStringContinuation Aqua
hi! link rustStructure Aqua
hi! link rustCommentLineDoc Comment

hi! link rubyStringDelimiter Green
hi! link rubyInterpolationDelimiter Aqua

hi! link luaIn Red
hi! link luaFunction Aqua
hi! link luaTable Orange

hi! link moonSpecialOp White
hi! link moonExtendedOp Orange
hi! link moonFunction White
hi! link moonObject Yellow

hi! link elixirDocString Comment
hi! link elixirInterpolationDelimiter Aqua
hi! link elixirModuleDeclaration Yellow
hi! link elixirStringDelimiter Green

hi! link clojureAnonArg Yellow
hi! link clojureCharacter Aqua
hi! link clojureCond Orange
hi! link clojureDefine Orange
hi! link clojureDeref Yellow
hi! link clojureException Red
hi! link clojureFunc Yellow
hi! link clojureKeyword Blue
hi! link clojureMacro Orange
hi! link clojureMeta Yellow
hi! link clojureParen White
hi! link clojureQuote Yellow
hi! link clojureRegexp Aqua
hi! link clojureRegexpCharClass GreyBold
hi! link clojureRegexpEscape Aqua
hi! link clojureRegexpMod clojureRegexpCharClass
hi! link clojureRegexpQuantifier clojureRegexpCharClass
hi! link clojureRepeat Yellow
hi! link clojureSpecial Orange
hi! link clojureStringEscape Aqua
hi! link clojureUnquote Yellow
hi! link clojureVariable Blue
hi! link scalaNameDefinition White
hi! link scalaCaseFollowing White
hi! link scalaCapitalWord White
hi! link scalaTypeExtension White
hi! link scalaKeyword Red
hi! link scalaKeywordModifier Red
hi! link scalaSpecial Aqua
hi! link scalaOperator Orange
hi! link scalaTypeDeclaration Yellow
hi! link scalaTypeTypePostDeclaration Yellow
hi! link scalaInstanceDeclaration White
hi! link scalaInterpolation Aqua
hi! link haskellType Blue
hi! link haskellIdentifier Aqua
hi! link haskellSeparator LightGrey
hi! link haskellDelimiter White
hi! link haskellOperators Green
hi! link haskellBacktick Orange
hi! link haskellStatement Purple
hi! link haskellConditional Purple
hi! link haskellLet Red
hi! link haskellDefault Red
hi! link haskellWhere Red
hi! link haskellDeclKeyword Orange
hi! link haskellDecl Orange
hi! link haskellDeriving Purple
hi! link haskellAssocType Aqua
hi! link haskellNumber Aqua
hi! link haskellForeignKeywords Green
hi! link haskellKeyword Red
hi! link haskellFloat Aqua
hi! link haskellInfix Purple
hi! link haskellRecursiveDo Purlpe
hi! link haskellQuotedType Red
hi! link haskellPreProc LightGrey
hi! link haskellTypeForall Red
hi! link haskellPatternKeyword Blue
hi! link haskellBottom RedBold
hi! link haskellTH AquaBold
hi! link haskellImportKeywords PurpleBold
hi! link haskellPragma RedBold
hi! link haskellQuote GreenBold
hi! link haskellShebang YellowBold
hi! link haskellLiquid PurpleBold
hi! link haskellQuasiQuoted BlueBold
hi! link haskellTypeRoles RedBold
hi! link perlStatementPackage PreProc
hi! link perlStatementInclude PreProc
hi! link perlStatementStorage StorageClass
hi! link perlStatementList StorageClass
hi! link perlVarSimpleMemberName Type
hi! link perlMethod Function
hi! link podCommand StorageClass
hi! link podCmdText Macro
hi! link podVerbatimLine String
hi! link jsonKeyword Green
hi! link jsonQuote Green
hi! link jsonBraces White
hi! link jsonString White
hi! link yamlKey Aqua
hi! link yamlConstant Purple
hi! link tomlTable Orange
hi! link tomlTableArray Orange
hi! link tomlKey White
hi! link mailHeader Blue
hi! link mailHeaderKey Blue
hi! link mailHeaderEmail Blue
hi! link mailSubject Blue
hi! link mailQuoted1 Aqua
hi! link mailQuoted2 Purple
hi! link mailQuoted3 Yellow
hi! link mailQuoted4 Green
hi! link mailQuoted5 Red
hi! link mailQuoted6 Orange
hi! link mailQuotedExp1 Aqua
hi! link mailQuotedExp2 Purple
hi! link mailQuotedExp3 Yellow
hi! link mailQuotedExp4 Green
hi! link mailQuotedExp5 Red
hi! link mailQuotedExp6 Orange
hi! link mailSignature White
hi! link mailURL Orange
hi! link mailEmail Orange
hi! link csBraces White
hi! link csEndColon White
hi! link csLogicSymbols Purple
hi! link csParens White
hi! link csOpSymbols Orange
hi! link csInterpolationDelimiter Aqua
hi! link csInterpolationFormat Aqua
hi! link csInterpolationAlignDel AquaBold
hi! link csInterpolationFormatDel AquaBold
hi! link shRange White
hi! link shTestOpr Purple
hi! link shOption Purple
hi! link bashStatement Orange
hi! link shOperator Orange
hi! link shQuote Green
hi! link shSet Orange
hi! link shSetList Blue
hi! link shSnglCase Orange
hi! link shVariable Blue
hi! link shCmdSubRegion Green
hi! link zshVariableDef Blue
hi! link zshSubst Orange
hi! link zshOptStart Orange
hi! link zshOption Aqua
hi! link zshFunction Green

hi! link diffAdded Green
hi! link diffRemoved Red
hi! link diffChanged Yellow
hi! link diffOldFile Purple
hi! link diffNewFile Blue
hi! link diffFile Orange
hi! link diffLine Grey
hi! link diffIndexLine Aqua
hi! link helpHyperTextEntry Red
hi! link helpHyperTextJump Blue
hi! link helpSectionDelim Grey
hi! link helpExample Green
hi! link helpCommand Orange
hi! link helpHeadline Title
hi! link helpHeader Aqua
hi! link helpSpecial Yellow

" }}}
" Plugins: {{{
hi! link plug2 Green
hi! link plugBracket Grey
hi! link plugName Aqua
hi! link plugDash Orange
hi! link plugError Red
hi! link plugNotLoaded Grey
hi! link plugRelDate Grey
hi! link plugH2 Orange
hi! link plugMessage Orange
hi! link plugStar Red
hi! link plugUpdate Blue
hi! link plugDeleted Grey
hi! link plugEdge Yellow
hi! link plugSha Green
hi! link EasyMotionTarget Search
hi! link EasyMotionShade Comment
hi! link Sneak Search
hi! link SneakLabel Search
hi! link gitcommitSelectedFile Green
hi! link gitcommitDiscardedFile Red
hi! link SignifySignAdd GitGutterAdd
hi! link SignifySignChange GitGutterChange
hi! link SignifySignDelete GitGutterDelete
hi! link SignifySignChangeDelete GitGutterChangeDelete
hi! link CtrlPNoEntries Red
hi! link CtrlPPrtCursor Blue
if !exists('g:Lf_StlColorscheme')
  let g:Lf_StlColorscheme = 'gruvbox_material'
endif
hi! link StartifyBracket Grey
hi! link StartifyFile White
hi! link StartifyNumber Red
hi! link StartifyPath Green
hi! link StartifySlash Aqua
hi! link StartifySection Blue
hi! link StartifyHeader Orange
hi! link StartifySpecial Grey
hi! link StartifyFooter Grey
hi! link BufTabLineCurrent TabLineSel
hi! link BufTabLineActive TabLine
hi! link BufTabLineHidden TabLineFill
hi! link BufTabLineFill TabLineFill
hi! link DirvishPathTail Aqua
hi! link DirvishArg Yellow
hi! link netrwDir Green
hi! link netrwClassify Green
hi! link netrwLink Grey
hi! link netrwSymLink White
hi! link netrwExe Yellow
hi! link netrwComment Grey
hi! link netrwList Aqua
hi! link netrwHelpCmd Blue
hi! link netrwCmdSep LightGrey
hi! link netrwVersion Orange
hi! link NERDTreeBookmarksLeader Conceal
hi! link NERDTreeDir Green
hi! link NERDTreeDirSlash Aqua
hi! link NERDTreeOpenable Orange
hi! link NERDTreeClosable Orange
hi! link NERDTreeFile White
hi! link NERDTreeExecFile Yellow
hi! link NERDTreeUp Grey
hi! link NERDTreeCWD Aqua
hi! link NERDTreeHelp LightGrey
hi! link NERDTreeToggleOn Green
hi! link NERDTreeToggleOff Red
hi! link NERDTreeFlags Orange
hi! link NERDTreeLinkFile Grey
hi! link NERDTreeLinkTarget Green
hi! link TagbarFoldIcon Green
hi! link TagbarSignature Green
hi! link TagbarKind Red
hi! link TagbarScope Orange
hi! link TagbarNestedKind Aqua
hi! link TagbarVisibilityPrivate Red
hi! link TagbarVisibilityPublic Blue
hi! link SyntasticError ALEError
hi! link SyntasticWarning ALEWarning
hi! link SyntasticErrorSign ALEErrorSign
hi! link SyntasticWarningSign ALEWarningSign
hi! link ALEVirtualTextError Grey
hi! link ALEVirtualTextWarning Grey
hi! link ALEVirtualTextInfo Grey
hi! link ALEVirtualTextStyleError ALEVirtualTextError
hi! link ALEVirtualTextStyleWarning ALEVirtualTextWarning

" Coc: {{{
hi! link CocErrorSign ALEErrorSign
hi! link CocWarningSign ALEWarningSign
hi! link CocInfoSign ALEInfoSign
hi! link CocErrorHighlight ALEError
hi! link CocWarningHighlight ALEWarning
hi! link CocInfoHighlight ALEInfo
hi! link CocWarningVirtualText ALEVirtualTextWarning
hi! link CocErrorVirtualText ALEVirtualTextError
hi! link CocInfoVirtualText ALEVirtualTextInfo
hi! link CocHintVirtualText ALEVirtualTextInfo
hi! link CocCodeLens ALEVirtualTextInfo
hi! link CocGitAddedSign GitGutterAdd
hi! link CocGitChangeRemovedSign GitGutterChangeDelete
hi! link CocGitChangedSign GitGutterChange
hi! link CocGitRemovedSign GitGutterDelete
hi! link CocGitTopRemovedSign GitGutterDelete
hi! link CocExplorerBufferRoot Orange
hi! link CocExplorerBufferExpandIcon Aqua
hi! link CocExplorerBufferBufnr Purple
hi! link CocExplorerBufferModified Red
hi! link CocExplorerBufferBufname Grey
hi! link CocExplorerFileRoot Orange
hi! link CocExplorerFileExpandIcon Aqua
hi! link CocExplorerFileFullpath Aqua
hi! link CocExplorerFileDirectory Green
hi! link CocExplorerFileGitStage Purple
hi! link CocExplorerFileGitUnstage Yellow
hi! link CocExplorerFileSize Blue
hi! link CocExplorerTimeAccessed Aqua
hi! link CocExplorerTimeCreated Aqua
hi! link CocExplorerTimeModified Aqua
" Which element do you have selected. Nope it's every element.
hi! link CocListsLine Blue
" }}}

hi! link QuickmenuOption Green
hi! link QuickmenuNumber Red
hi! link QuickmenuBracket Grey
hi! link QuickmenuHelp Green
hi! link QuickmenuSpecial Purple
hi! link QuickmenuHeader Orange
hi! link UndotreeNode Orange
hi! link UndotreeNodeCurrent Red
hi! link UndotreeSeq Green
hi! link UndotreeNext Blue
hi! link UndotreeTimeStamp Grey
hi! link UndotreeHead Yellow
hi! link UndotreeBranch Yellow
hi! link UndotreeCurrent Aqua
hi! link UndotreeSavedSmall Purple

" }}}
if (has('termguicolors') && &termguicolors) || has('gui_running')  " {{{
  if &background ==# 'dark'
    let g:terminal_ansi_colors = ['#665c54', '#ea6962', '#a9b665', '#e78a4e',
          \ '#7daea3', '#d3869b', '#89b482', '#dfbf8e', '#928374', '#ea6962',
          \ '#a9b665', '#e3a84e', '#7daea3', '#d3869b', '#89b482', '#dfbf8e']
    if has('nvim')
      let g:terminal_color_0 = '#665c54'
      let g:terminal_color_1 = '#ea6962'
      let g:terminal_color_2 = '#a9b665'
      let g:terminal_color_3 = '#e78a4e'
      let g:terminal_color_4 = '#7daea3'
      let g:terminal_color_5 = '#d3869b'
      let g:terminal_color_6 = '#89b482'
      let g:terminal_color_7 = '#dfbf8e'
      let g:terminal_color_8 = '#928374'
      let g:terminal_color_9 = '#ea6962'
      let g:terminal_color_10 = '#a9b665'
      let g:terminal_color_11 = '#e3a84e'
      let g:terminal_color_12 = '#7daea3'
      let g:terminal_color_13 = '#d3869b'
      let g:terminal_color_14 = '#89b482'
      let g:terminal_color_15 = '#dfbf8e'
    endif
    hi White guifg=#dfbf8e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi LightGrey guifg=#a89984 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Grey guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Red guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Orange guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Yellow guifg=#e3a84e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Green guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Aqua guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Blue guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Purple guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
    if get(g:, 'gruvbox_material_enable_bold', 0)
      hi WhiteBold guifg=#dfbf8e guibg=NONE guisp=NONE gui=bold cterm=bold
      hi LightGreyBold guifg=#a89984 guibg=NONE guisp=NONE gui=bold cterm=bold
      hi GreyBold guifg=#928374 guibg=NONE guisp=NONE gui=bold cterm=bold
      hi RedBold guifg=#ea6962 guibg=NONE guisp=NONE gui=bold cterm=bold
      hi OrangeBold guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
      hi YellowBold guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
      hi GreenBold guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
      hi AquaBold guifg=#89b482 guibg=NONE guisp=NONE gui=bold cterm=bold
      hi BlueBold guifg=#7daea3 guibg=NONE guisp=NONE gui=bold cterm=bold
      hi PurpleBold guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold
    else
      hi WhiteBold guifg=#dfbf8e guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi LightGreyBold guifg=#a89984 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi GreyBold guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi RedBold guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi OrangeBold guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi YellowBold guifg=#e3a84e guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi GreenBold guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi AquaBold guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi BlueBold guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi PurpleBold guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
    endif
    if get(g:, 'gruvbox_material_transparent_background', 0) && !has('gui_running')
      hi Normal guifg=#dfbf8e guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi Terminal guifg=#dfbf8e guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi DiffText guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
      hi VertSplit guifg=#665c54 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi QuickFixLine guifg=#e3a84e guibg=NONE guisp=NONE gui=reverse cterm=reverse
      hi EndOfBuffer guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi FoldColumn guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi Folded guifg=#928374 guibg=NONE guisp=NONE gui=bold cterm=bold
      hi CursorColumn guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
      hi CursorLine guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
      hi CursorLineNr guifg=#a89984 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi MatchParen guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
    else
      if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
        hi Normal guifg=#dfbf8e guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE font='FuraMono Nerd Font Mono:h12'
        hi Terminal guifg=#dfbf8e guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE
        hi DiffText guifg=NONE guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
        hi EndOfBuffer guifg=#1d2021 guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE
        hi VertSplit guifg=#665c54 guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE
        hi QuickFixLine guifg=#e3a84e guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
        hi MatchParen guifg=NONE guibg=#32302f guisp=NONE gui=bold cterm=bold
        hi FoldColumn guifg=#928374 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi Folded guifg=#928374 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi CursorColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi CursorLine guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi CursorLineNr guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
        hi Normal guifg=#dfbf8e guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi Terminal guifg=#dfbf8e guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi DiffText guifg=NONE guibg=#282828 guisp=NONE gui=reverse cterm=reverse
        hi EndOfBuffer guifg=#282828 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi VertSplit guifg=#665c54 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi QuickFixLine guifg=#e3a84e guibg=#282828 guisp=NONE gui=reverse cterm=reverse
        hi MatchParen guifg=NONE guibg=#3c3836 guisp=NONE gui=bold cterm=bold
        hi FoldColumn guifg=#928374 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi Folded guifg=#928374 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi CursorColumn guifg=NONE guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi CursorLine guifg=NONE guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi CursorLineNr guifg=#a89984 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
        hi Normal guifg=#dfbf8e guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi Terminal guifg=#dfbf8e guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi DiffText guifg=NONE guibg=#32302f guisp=NONE gui=reverse cterm=reverse
        hi EndOfBuffer guifg=#32302f guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi VertSplit guifg=#665c54 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi QuickFixLine guifg=#e3a84e guibg=#32302f guisp=NONE gui=reverse cterm=reverse
        hi MatchParen guifg=NONE guibg=#504945 guisp=NONE gui=bold cterm=bold
        hi FoldColumn guifg=#928374 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi Folded guifg=#928374 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi CursorColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi CursorLine guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi CursorLineNr guifg=#a89984 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      endif
    endif
    if &background ==#'light'  " {{{
      hi PmenuSel guifg=#3c3836 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
      hi TabLineSel guifg=#3c3836 guibg=#a89984 guisp=NONE gui=bold cterm=bold
      hi WildMenu guifg=#3c3836 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
      if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
        hi Pmenu guifg=#dfbf8e guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi StatusLine guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTerm guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi TabLine guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi TabLineFill guifg=#dfbf8e guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi ColorColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi! SignColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineNC guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTermNC guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
        hi Pmenu guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi StatusLine guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTerm guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi TabLine guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi TabLineFill guifg=#dfbf8e guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi ColorColumn guifg=NONE guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi SignColumn guifg=NONE guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi StatusLineNC guifg=#a89984 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTermNC guifg=#a89984 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
        hi Pmenu guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi StatusLine guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTerm guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi TabLine guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi TabLineFill guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi ColorColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi SignColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineNC guifg=#a89984 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTermNC guifg=#a89984 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      endif  " }}}
    else  " {{{
      " Got this from `:he 'pumblend'
      hi PmenuSel guifg=#282828 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE blend=0
      " Yeah. Blend is 0
      " Yo tablinesel sets this way is pretty awful
      " hi TabLineSel guifg=#282828 guibg=#a89984 guisp=NONE gui=bold cterm=bold
      " Actually the lightbg one is pretty solid
      hi TabLineSel guifg=#ebdbb2 guibg=#7c6f64 guisp=NONE gui=bold cterm=bold
      hi WildMenu guifg=#282828 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
      if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
        hi Pmenu guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi StatusLine guifg=#dfbf8e guibg=#504945 guisp=NONE gui=bold cterm=bold
        " nah too noisy
        " hi Statusline cterm=bold,underline,reverse ctermfg=161 ctermbg=238 gui=bold,underline,reverse guifg=#7daea3 guibg=#565656
        hi StatusLineTerm guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi TabLine guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi TabLineFill guifg=#dfbf8e guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi ColorColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi SignColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineNC guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTermNC guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
        hi Pmenu guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi StatusLine guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTerm guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi TabLine guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi TabLineFill guifg=#dfbf8e guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi ColorColumn guifg=NONE guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi SignColumn guifg=NONE guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi StatusLineNC guifg=#a89984 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTermNC guifg=#a89984 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
        hi Pmenu guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
        hi StatusLine guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTerm guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi TabLine guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
        hi TabLineFill guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi ColorColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi SignColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineNC guifg=#a89984 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        hi StatusLineTermNC guifg=#a89984 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      endif
    endif  "  }}}

    hi Conceal guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi lCursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi LineNr guifg=#7c6f64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Directory guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi ErrorMsg guifg=#ea6962 guibg=NONE guisp=NONE gui=bold,underline cterm=bold,underline
    hi WarningMsg guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi ModeMsg guifg=#dfbf8e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi MoreMsg guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi IncSearch guifg=NONE guibg=NONE guisp=NONE gui=bold,reverse ctermfg=NONE ctermbg=NONE cterm=bold,reverse
    hi Search guifg=NONE guibg=NONE guisp=NONE gui=reverse,underline ctermfg=NONE ctermbg=NONE cterm=reverse,underline
    hi NonText guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi PmenuSbar guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE
    hi PmenuThumb guifg=NONE guibg=#7c6f64 guisp=NONE gui=NONE cterm=NONE
    hi Question guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi SpellBad guifg=#ea6962 guibg=NONE guisp=#ea6962 gui=italic,undercurl cterm=italic,undercurl
    hi SpellCap guifg=#7daea3 guibg=NONE guisp=#7daea3 gui=italic,undercurl cterm=italic,undercurl
    hi SpellLocal guifg=#89b482 guibg=NONE guisp=#89b482 gui=italic,undercurl cterm=italic,undercurl
    hi SpellRare guifg=#d3869b guibg=NONE guisp=#d3869b gui=italic,undercurl cterm=italic,undercurl
    hi Visual guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi VisualNOS guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi Todo guifg=#928374 guibg=NONE guisp=NONE gui=bold,italic,underline cterm=bold,italic,underline
    hi CursorIM guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi ToolbarLine guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
    hi ToolbarButton guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=bold cterm=bold
    hi Debug guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Title guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Conditional guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Repeat guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Label guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Exception guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Keyword guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Statement guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Typedef guifg=#e3a84e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Type guifg=#e3a84e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi StorageClass guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    " Nah this is impossible to notice
    " hi Delimiter guifg=#dfbf8e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi! link Delimiter BlueBold
    hi Special guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Tag guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Operator guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi SpecialChar guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi String guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi PreProc guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Macro guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Define guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Include guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi PreCondit guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Structure guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Identifier guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Underlined guifg=#7daea3 guibg=NONE guisp=NONE gui=underline cterm=underline
    hi Constant guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Boolean guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Character guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Number guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Float guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi SpecialKey guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    " hi Ignore guifg=#dfbf8e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi link Ignore Bg1
    if !s:italics
      hi SpellBad gui=undercurl cterm=undercurl
      hi SpellCap gui=undercurl cterm=undercurl
      hi SpellLocal gui=undercurl cterm=undercurl
      hi SpellRare gui=undercurl cterm=undercurl
      hi Todo gui=bold cterm=bold
    endif
    if get(g:, 'gruvbox_material_disable_italic_comment', 0)
      hi Comment guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
      hi SpecialComment guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    else
      hi Comment guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
      hi SpecialComment guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
      if !s:italics
        hi Comment gui=NONE cterm=NONE
        hi SpecialComment gui=NONE cterm=NONE
      endif
    endif
    if get(g:, 'gruvbox_material_enable_bold', 0)
      hi Function guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    else
      hi Function guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi DiffAdd guifg=NONE guibg=#32361a guisp=NONE gui=NONE cterm=NONE
      hi DiffChange guifg=NONE guibg=#0d3138 guisp=NONE gui=NONE cterm=NONE
      hi DiffDelete guifg=NONE guibg=#3c1f1e guisp=NONE gui=NONE cterm=NONE
      hi Error guifg=NONE guibg=#3c1f1e guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi DiffAdd guifg=NONE guibg=#3d4220 guisp=NONE gui=NONE cterm=NONE
      hi DiffChange guifg=NONE guibg=#0f3a42 guisp=NONE gui=NONE cterm=NONE
      hi DiffDelete guifg=NONE guibg=#472322 guisp=NONE gui=NONE cterm=NONE
      hi Error guifg=NONE guibg=#472322 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi DiffAdd guifg=NONE guibg=#34381b guisp=NONE gui=NONE cterm=NONE
      hi DiffChange guifg=NONE guibg=#0e363e guisp=NONE gui=NONE cterm=NONE
      hi DiffDelete guifg=NONE guibg=#402120 guisp=NONE gui=NONE cterm=NONE
      hi Error guifg=NONE guibg=#402120 guisp=NONE gui=NONE cterm=NONE
    endif
    hi markdownH1 guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi markdownH2 guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi markdownH3 guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi markdownH4 guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi markdownUrl guifg=#d3869b guibg=NONE guisp=NONE gui=underline cterm=underline
    hi markdownItalic guifg=NONE guibg=NONE guisp=NONE gui=italic ctermfg=NONE ctermbg=NONE cterm=italic
    hi markdownBold guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
    hi markdownItalicDelimiter guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
    hi mkdURL guifg=#d3869b guibg=NONE guisp=NONE gui=underline cterm=underline
    hi mkdInlineURL guifg=#d3869b guibg=NONE guisp=NONE gui=underline cterm=underline
    hi mkdItalic guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
    hi htmlLink guifg=#a89984 guibg=NONE guisp=NONE gui=underline cterm=underline
    hi htmlBold guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
    hi htmlBoldUnderline guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
    hi htmlBoldItalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic ctermfg=NONE ctermbg=NONE cterm=bold,italic
    hi htmlBoldUnderlineItalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic,underline ctermfg=NONE ctermbg=NONE cterm=bold,italic,underline
    hi htmlUnderline guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
    hi htmlUnderlineItalic guifg=NONE guibg=NONE guisp=NONE gui=italic,underline ctermfg=NONE ctermbg=NONE cterm=italic,underline
    hi htmlItalic guifg=NONE guibg=NONE guisp=NONE gui=italic ctermfg=NONE ctermbg=NONE cterm=italic
    hi vimCommentTitle guifg=#a89984 guibg=NONE guisp=NONE gui=bold,italic cterm=bold,italic
    hi helpURL guifg=#89b482 guibg=NONE guisp=NONE gui=underline cterm=underline
    hi helpNote guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold
    hi plug1 guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi plugNumber guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
    if !s:italics
      hi markdownItalic gui=NONE cterm=NONE
      hi markdownItalicDelimiter gui=NONE cterm=NONE
      hi mkdItalic gui=NONE cterm=NONE
      hi htmlBoldItalic gui=bold cterm=bold
      hi htmlBoldUnderlineItalic gui=bold,underline cterm=bold,underline
      hi htmlUnderlineItalic gui=underline cterm=underline
      hi htmlItalic gui=NONE cterm=NONE
      hi vimCommentTitle gui=bold cterm=bold
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      if get(g:, 'indent_guides_auto_colors', 0)
        if get(g:, 'gruvbox_material_invert_indent_guides', 0)
          hi IndentGuidesOdd guifg=#1d2021 guibg=#504945 guisp=NONE gui=reverse cterm=reverse
          hi IndentGuidesEven guifg=#1d2021 guibg=#3c3836 guisp=NONE gui=reverse cterm=reverse
        else
          hi IndentGuidesOdd guifg=#1d2021 guibg=#504945 guisp=NONE gui=NONE cterm=NONE
          hi IndentGuidesEven guifg=#1d2021 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        endif
      endif
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      if get(g:, 'indent_guides_auto_colors', 0)
        if get(g:, 'gruvbox_material_invert_indent_guides', 0)
          hi IndentGuidesOdd guifg=#32302f guibg=#504945 guisp=NONE gui=reverse cterm=reverse
          hi IndentGuidesEven guifg=#32302f guibg=#3c3836 guisp=NONE gui=reverse cterm=reverse
        else
          hi IndentGuidesOdd guifg=#32302f guibg=#504945 guisp=NONE gui=NONE cterm=NONE
          hi IndentGuidesEven guifg=#32302f guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        endif
      endif
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      if get(g:, 'indent_guides_auto_colors', 0)
        if get(g:, 'gruvbox_material_invert_indent_guides', 0)
          hi IndentGuidesOdd guifg=#282828 guibg=#504945 guisp=NONE gui=reverse cterm=reverse
          hi IndentGuidesEven guifg=#282828 guibg=#3c3836 guisp=NONE gui=reverse cterm=reverse
        else
          hi IndentGuidesOdd guifg=#282828 guibg=#504945 guisp=NONE gui=NONE cterm=NONE
          hi IndentGuidesEven guifg=#282828 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
        endif
      endif
    endif
    if !exists('g:indentLine_color_term')
      let g:indentLine_color_term = 239
    endif
    if !exists('g:indentLine_color_gui')
      let g:indentLine_color_gui = '#504945'
    endif
    " Rainbow Parentheses
    if !exists('g:rbpt_colorpairs')
      let g:rbpt_colorpairs = [['blue', '#7daea3'], ['magenta', '#d3869b'],
            \ ['red', '#ea6962'], ['208', '#e78a4e']]
    endif

    let g:rainbow_guifgs = [ '#e78a4e', '#ea6962', '#d3869b', '#7daea3' ]
    let g:rainbow_ctermfgs = [ '208', 'red', 'magenta', 'blue' ]

    if !exists('g:rainbow_conf')
      let g:rainbow_conf = {}
    endif
    if !has_key(g:rainbow_conf, 'guifgs')
      let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
    endif
    if !has_key(g:rainbow_conf, 'ctermfgs')
      let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
    endif

    let g:niji_dark_colours = g:rbpt_colorpairs
    let g:niji_light_colours = g:rbpt_colorpairs
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi GitGutterAdd guifg=#a9b665 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi GitGutterChange guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi GitGutterDelete guifg=#ea6962 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi GitGutterChangeDelete guifg=#d3869b guibg=#282828 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi GitGutterAdd guifg=#a9b665 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi GitGutterChange guifg=#7daea3 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi GitGutterDelete guifg=#ea6962 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi GitGutterChangeDelete guifg=#d3869b guibg=#32302f guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi GitGutterAdd guifg=#a9b665 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi GitGutterChange guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi GitGutterDelete guifg=#ea6962 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi GitGutterChangeDelete guifg=#d3869b guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi SignatureMarkText guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi SignatureMarkerText guifg=#d3869b guibg=#282828 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi SignatureMarkText guifg=#7daea3 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi SignatureMarkerText guifg=#d3869b guibg=#32302f guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi SignatureMarkText guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi SignatureMarkerText guifg=#d3869b guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi ShowMarksHLl guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLu guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLo guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLm guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi ShowMarksHLl guifg=#7daea3 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLu guifg=#7daea3 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLo guifg=#7daea3 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLm guifg=#7daea3 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi ShowMarksHLl guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLu guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLo guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi ShowMarksHLm guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
    endif
    hi CtrlPMatch guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi CtrlPPrtBase guifg=#504945 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi CtrlPLinePre guifg=#504945 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi CtrlPMode1 guifg=#7daea3 guibg=#504945 guisp=NONE gui=bold cterm=bold
    hi CtrlPMode2 guifg=#282828 guibg=#7daea3 guisp=NONE gui=bold cterm=bold
    hi CtrlPStats guifg=#a89984 guibg=#504945 guisp=NONE gui=bold cterm=bold
    hi Lf_hl_match guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Lf_hl_match0 guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Lf_hl_match1 guifg=#89b482 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Lf_hl_match2 guifg=#7daea3 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Lf_hl_match3 guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Lf_hl_match4 guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Lf_hl_matchRefine guifg=#ea6962 guibg=NONE guisp=NONE gui=bold cterm=bold
    let g:vimshell_escape_colors = [
          \ '#7c6f64', '#ea6962', '#a9b665', '#e3a84e',
          \ '#7daea3', '#d3869b', '#89b482', '#a89984',
          \ '#282828', '#ea6962', '#a9b665', '#e78a4e',
          \ '#7daea3', '#d3869b', '#89b482', '#dfbf8e'
          \ ]
    hi ALEError guifg=NONE guibg=NONE guisp=#ea6962 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
    hi ALEWarning guifg=NONE guibg=NONE guisp=#e3a84e gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
    hi ALEInfo guifg=NONE guibg=NONE guisp=#7daea3 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi ALEErrorSign guifg=#ea6962 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi ALEWarningSign guifg=#e3a84e guibg=#282828 guisp=NONE gui=NONE cterm=NONE
      hi ALEInfoSign guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi ALEErrorSign guifg=#ea6962 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi ALEWarningSign guifg=#e3a84e guibg=#32302f guisp=NONE gui=NONE cterm=NONE
      hi ALEInfoSign guifg=#7daea3 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi ALEErrorSign guifg=#ea6962 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi ALEWarningSign guifg=#e3a84e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
      hi ALEInfoSign guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
    endif
    hi multiple_cursors_cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi multiple_cursors_visual guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE
    hi CocHighlightText guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
    hi CocHoverRange guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi CocHintSign guifg=#89b482 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi CocHintSign guifg=#89b482 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi CocHintSign guifg=#89b482 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
    endif
    hi MatchParenCur guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
    hi MatchWord guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
    hi MatchWordCur guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
    hi UndotreeSavedBig guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold
    unlet s:t_Co s:italics
    finish
  endif
  " Light background
  let g:terminal_ansi_colors = ['#bdae93', '#c74545', '#6c782e', '#c55b03',
        \ '#47747e', '#945e80', '#4c7a5d', '#764e37', '#928374', '#c74545',
        \ '#6c782e', '#b47109', '#47747e', '#945e80', '#4c7a5d', '#764e37']
  if has('nvim')
    let g:terminal_color_0 = '#bdae93'
    let g:terminal_color_1 = '#c74545'
    let g:terminal_color_2 = '#6c782e'
    let g:terminal_color_3 = '#c55b03'
    let g:terminal_color_4 = '#47747e'
    let g:terminal_color_5 = '#945e80'
    let g:terminal_color_6 = '#4c7a5d'
    let g:terminal_color_7 = '#764e37'
    let g:terminal_color_8 = '#928374'
    let g:terminal_color_9 = '#c74545'
    let g:terminal_color_10 = '#6c782e'
    let g:terminal_color_11 = '#b47109'
    let g:terminal_color_12 = '#47747e'
    let g:terminal_color_13 = '#945e80'
    let g:terminal_color_14 = '#4c7a5d'
    let g:terminal_color_15 = '#764e37'
  endif
  hi White guifg=#764e37 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi LightGrey guifg=#7c6f64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Grey guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Red guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Orange guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Yellow guifg=#b47109 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Green guifg=#6c782e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Aqua guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Blue guifg=#47747e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Purple guifg=#945e80 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  if get(g:, 'gruvbox_material_enable_bold', 0)
    hi WhiteBold guifg=#764e37 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi LightGreyBold guifg=#7c6f64 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi GreyBold guifg=#928374 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi RedBold guifg=#c74545 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi OrangeBold guifg=#c55b03 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi YellowBold guifg=#b47109 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi GreenBold guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi AquaBold guifg=#4c7a5d guibg=NONE guisp=NONE gui=bold cterm=bold
    hi BlueBold guifg=#47747e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi PurpleBold guifg=#945e80 guibg=NONE guisp=NONE gui=bold cterm=bold
  else
    hi WhiteBold guifg=#764e37 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi LightGreyBold guifg=#7c6f64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi GreyBold guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi RedBold guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi OrangeBold guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi YellowBold guifg=#b47109 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi GreenBold guifg=#6c782e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi AquaBold guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi BlueBold guifg=#47747e guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi PurpleBold guifg=#945e80 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  endif
  if get(g:, 'gruvbox_material_transparent_background', 0) && !has('gui_running')
    hi Normal guifg=#764e37 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Terminal guifg=#764e37 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi DiffText guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi VertSplit guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi QuickFixLine guifg=#b47109 guibg=NONE guisp=NONE gui=reverse cterm=reverse
    hi EndOfBuffer guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi FoldColumn guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Folded guifg=#928374 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi CursorColumn guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorLine guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorLineNr guifg=#7c6f64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi MatchParen guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
  else
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi Normal guifg=#764e37 guibg=#f9f5d7 guisp=NONE gui=NONE cterm=NONE
      hi Terminal guifg=#764e37 guibg=#f9f5d7 guisp=NONE gui=NONE cterm=NONE
      hi DiffText guifg=NONE guibg=#f9f5d7 guisp=NONE gui=reverse cterm=reverse
      hi EndOfBuffer guifg=#f9f5d7 guibg=#f9f5d7 guisp=NONE gui=NONE cterm=NONE
      hi VertSplit guifg=#bdae93 guibg=#f9f5d7 guisp=NONE gui=NONE cterm=NONE
      hi QuickFixLine guifg=#b47109 guibg=#f9f5d7 guisp=NONE gui=reverse cterm=reverse
      hi MatchParen guifg=NONE guibg=#f2e5bc guisp=NONE gui=bold cterm=bold
      hi FoldColumn guifg=#928374 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi Folded guifg=#928374 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi CursorColumn guifg=NONE guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi CursorLine guifg=NONE guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi CursorLineNr guifg=#7c6f64 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi Normal guifg=#764e37 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi Terminal guifg=#764e37 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi DiffText guifg=NONE guibg=#fbf1c7 guisp=NONE gui=reverse cterm=reverse
      hi EndOfBuffer guifg=#fbf1c7 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi VertSplit guifg=#bdae93 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi QuickFixLine guifg=#b47109 guibg=#fbf1c7 guisp=NONE gui=reverse cterm=reverse
      hi MatchParen guifg=NONE guibg=#ebdbb2 guisp=NONE gui=bold cterm=bold
      hi FoldColumn guifg=#928374 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi Folded guifg=#928374 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi CursorColumn guifg=NONE guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi CursorLine guifg=NONE guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi CursorLineNr guifg=#7c6f64 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi Normal guifg=#764e37 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi Terminal guifg=#764e37 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi DiffText guifg=NONE guibg=#f2e5bc guisp=NONE gui=reverse cterm=reverse
      hi EndOfBuffer guifg=#f2e5bc guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi VertSplit guifg=#bdae93 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi QuickFixLine guifg=#b47109 guibg=#f2e5bc guisp=NONE gui=reverse cterm=reverse
      hi MatchParen guifg=NONE guibg=#d5c4a1 guisp=NONE gui=bold cterm=bold
      hi FoldColumn guifg=#928374 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi Folded guifg=#928374 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi CursorColumn guifg=NONE guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi CursorLine guifg=NONE guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi CursorLineNr guifg=#7c6f64 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    endif
  endif
  if &background ==#'light'
    hi PmenuSel guifg=#ebdbb2 guibg=#7c6f64 guisp=NONE gui=NONE cterm=NONE
    hi TabLineSel guifg=#ebdbb2 guibg=#7c6f64 guisp=NONE gui=bold cterm=bold
    hi WildMenu guifg=#ebdbb2 guibg=#7c6f64 guisp=NONE gui=NONE cterm=NONE
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi Pmenu guifg=#504945 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi StatusLine guifg=#504945 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTerm guifg=#504945 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi TabLine guifg=#504945 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi TabLineFill guifg=#504945 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi ColorColumn guifg=NONE guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi SignColumn guifg=NONE guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineNC guifg=#7c6f64 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTermNC guifg=#7c6f64 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi Pmenu guifg=#504945 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi StatusLine guifg=#504945 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTerm guifg=#504945 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi TabLine guifg=#504945 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi TabLineFill guifg=#504945 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi ColorColumn guifg=NONE guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi SignColumn guifg=NONE guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi StatusLineNC guifg=#7c6f64 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTermNC guifg=#7c6f64 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi Pmenu guifg=#504945 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi StatusLine guifg=#504945 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTerm guifg=#504945 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi TabLine guifg=#504945 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi TabLineFill guifg=#504945 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi ColorColumn guifg=NONE guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi SignColumn guifg=NONE guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineNC guifg=#7c6f64 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTermNC guifg=#7c6f64 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    endif
  else
    hi PmenuSel guifg=#fbf1c7 guibg=#7c6f64 guisp=NONE gui=NONE cterm=NONE
    " hi TabLineSel guifg=#fbf1c7 guibg=#7c6f64 guisp=NONE gui=bold cterm=bold
    hi TabLineSel guifg=#ebdbb2 guibg=#7c6f64 guisp=NONE gui=bold cterm=bold
    hi WildMenu guifg=#fbf1c7 guibg=#7c6f64 guisp=NONE gui=NONE cterm=NONE
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi Pmenu guifg=#764e37 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi StatusLine guifg=#764e37 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTerm guifg=#764e37 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi TabLine guifg=#764e37 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi TabLineFill guifg=#764e37 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi ColorColumn guifg=NONE guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi SignColumn guifg=NONE guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineNC guifg=#7c6f64 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTermNC guifg=#7c6f64 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi Pmenu guifg=#764e37 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi StatusLine guifg=#764e37 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTerm guifg=#764e37 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi TabLine guifg=#764e37 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi TabLineFill guifg=#764e37 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi ColorColumn guifg=NONE guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi SignColumn guifg=NONE guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi StatusLineNC guifg=#7c6f64 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTermNC guifg=#7c6f64 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi Pmenu guifg=#764e37 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
      hi StatusLine guifg=#764e37 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTerm guifg=#764e37 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi TabLine guifg=#764e37 guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
      hi TabLineFill guifg=#764e37 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi ColorColumn guifg=NONE guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi SignColumn guifg=NONE guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineNC guifg=#7c6f64 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      hi StatusLineTermNC guifg=#7c6f64 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    endif
  endif
  hi Conceal guifg=#47747e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi lCursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi LineNr guifg=#a89984 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Directory guifg=#6c782e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi ErrorMsg guifg=#c74545 guibg=NONE guisp=NONE gui=bold,underline cterm=bold,underline
  hi WarningMsg guifg=#b47109 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi ModeMsg guifg=#764e37 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi MoreMsg guifg=#b47109 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi IncSearch guifg=NONE guibg=NONE guisp=NONE gui=bold,reverse ctermfg=NONE ctermbg=NONE cterm=bold,reverse
  hi Search guifg=NONE guibg=NONE guisp=NONE gui=reverse,underline ctermfg=NONE ctermbg=NONE cterm=reverse,underline
  hi NonText guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi PmenuSbar guifg=NONE guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
  hi PmenuThumb guifg=NONE guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
  hi Question guifg=#c55b03 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi SpellBad guifg=#c74545 guibg=NONE guisp=#c74545 gui=italic,undercurl cterm=italic,undercurl
  hi SpellCap guifg=#47747e guibg=NONE guisp=#47747e gui=italic,undercurl cterm=italic,undercurl
  hi SpellLocal guifg=#4c7a5d guibg=NONE guisp=#4c7a5d gui=italic,undercurl cterm=italic,undercurl
  hi SpellRare guifg=#945e80 guibg=NONE guisp=#945e80 gui=italic,undercurl cterm=italic,undercurl
  hi Visual guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi VisualNOS guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi Todo guifg=#928374 guibg=NONE guisp=NONE gui=bold,italic,reverse cterm=bold,italic,reverse
  hi CursorIM guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi ToolbarLine guifg=NONE guibg=#bdae93 guisp=NONE gui=NONE cterm=NONE
  hi ToolbarButton guifg=#764e37 guibg=#bdae93 guisp=NONE gui=bold cterm=bold
  hi Debug guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Title guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Conditional guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Repeat guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Label guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Exception guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Keyword guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Statement guifg=#c74545 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Typedef guifg=#b47109 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Type guifg=#b47109 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi StorageClass guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Delimiter guifg=#764e37 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Special guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Tag guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Operator guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpecialChar guifg=#c55b03 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi String guifg=#6c782e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi PreProc guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Macro guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Define guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Include guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi PreCondit guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Structure guifg=#4c7a5d guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Identifier guifg=#47747e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Underlined guifg=#47747e guibg=NONE guisp=NONE gui=underline cterm=underline
  hi Constant guifg=#945e80 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Boolean guifg=#945e80 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Character guifg=#945e80 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Number guifg=#945e80 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Float guifg=#945e80 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpecialKey guifg=#47747e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Ignore guifg=#764e37 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  if !s:italics
    hi SpellBad gui=undercurl cterm=undercurl
    hi SpellCap gui=undercurl cterm=undercurl
    hi SpellLocal gui=undercurl cterm=undercurl
    hi SpellRare gui=undercurl cterm=undercurl
    hi Todo gui=bold cterm=bold
  endif
  if get(g:, 'gruvbox_material_disable_italic_comment', 0)
    hi Comment guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi SpecialComment guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  else
    hi Comment guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
    hi SpecialComment guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
    if !s:italics
      hi Comment gui=NONE cterm=NONE
      hi SpecialComment gui=NONE cterm=NONE
    endif
  endif
  if get(g:, 'gruvbox_material_enable_bold', 0)
    hi Function guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
  else
    hi Function guifg=#6c782e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi DiffAdd guifg=NONE guibg=#e3f6b4 guisp=NONE gui=NONE cterm=NONE
    hi DiffChange guifg=NONE guibg=#cff1f6 guisp=NONE gui=NONE cterm=NONE
    hi DiffDelete guifg=NONE guibg=#ffdbcc guisp=NONE gui=NONE cterm=NONE
    hi Error guifg=NONE guibg=#ffdbcc guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi DiffAdd guifg=NONE guibg=#d1ea9b guisp=NONE gui=NONE cterm=NONE
    hi DiffChange guifg=NONE guibg=#bee4ea guisp=NONE gui=NONE cterm=NONE
    hi DiffDelete guifg=NONE guibg=#fbcab5 guisp=NONE gui=NONE cterm=NONE
    hi Error guifg=NONE guibg=#fbcab5 guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi DiffAdd guifg=NONE guibg=#daf0a7 guisp=NONE gui=NONE cterm=NONE
    hi DiffChange guifg=NONE guibg=#c6eaf0 guisp=NONE gui=NONE cterm=NONE
    hi DiffDelete guifg=NONE guibg=#fbcdb9 guisp=NONE gui=NONE cterm=NONE
    hi Error guifg=NONE guibg=#fbcdb9 guisp=NONE gui=NONE cterm=NONE
  endif
  hi markdownH1 guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi markdownH2 guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi markdownH3 guifg=#b47109 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi markdownH4 guifg=#b47109 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi markdownUrl guifg=#945e80 guibg=NONE guisp=NONE gui=underline cterm=underline
  hi markdownItalic guifg=NONE guibg=NONE guisp=NONE gui=italic ctermfg=NONE ctermbg=NONE cterm=italic
  hi markdownBold guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
  hi markdownItalicDelimiter guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
  hi mkdURL guifg=#945e80 guibg=NONE guisp=NONE gui=underline cterm=underline
  hi mkdInlineURL guifg=#945e80 guibg=NONE guisp=NONE gui=underline cterm=underline
  hi mkdItalic guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
  hi htmlLink guifg=#7c6f64 guibg=NONE guisp=NONE gui=underline cterm=underline
  hi htmlBold guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
  hi htmlBoldUnderline guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
  hi htmlBoldItalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic ctermfg=NONE ctermbg=NONE cterm=bold,italic
  hi htmlBoldUnderlineItalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic,underline ctermfg=NONE ctermbg=NONE cterm=bold,italic,underline
  hi htmlUnderline guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
  hi htmlUnderlineItalic guifg=NONE guibg=NONE guisp=NONE gui=italic,underline ctermfg=NONE ctermbg=NONE cterm=italic,underline
  hi htmlItalic guifg=NONE guibg=NONE guisp=NONE gui=italic ctermfg=NONE ctermbg=NONE cterm=italic
  hi vimCommentTitle guifg=#7c6f64 guibg=NONE guisp=NONE gui=bold,italic cterm=bold,italic
  hi helpURL guifg=#4c7a5d guibg=NONE guisp=NONE gui=underline cterm=underline
  hi helpNote guifg=#945e80 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi plug1 guifg=#c55b03 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi plugNumber guifg=#b47109 guibg=NONE guisp=NONE gui=bold cterm=bold
  if !s:italics
    hi markdownItalic gui=NONE cterm=NONE
    hi markdownItalicDelimiter gui=NONE cterm=NONE
    hi mkdItalic gui=NONE cterm=NONE
    hi htmlBoldItalic gui=bold cterm=bold
    hi htmlBoldUnderlineItalic gui=bold,underline cterm=bold,underline
    hi htmlUnderlineItalic gui=underline cterm=underline
    hi htmlItalic gui=NONE cterm=NONE
    hi vimCommentTitle gui=bold cterm=bold
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    if get(g:, 'indent_guides_auto_colors', 0)
      if get(g:, 'gruvbox_material_invert_indent_guides', 0)
        hi IndentGuidesOdd guifg=#f9f5d7 guibg=#d5c4a1 guisp=NONE gui=reverse cterm=reverse
        hi IndentGuidesEven guifg=#f9f5d7 guibg=#ebdbb2 guisp=NONE gui=reverse cterm=reverse
      else
        hi IndentGuidesOdd guifg=#f9f5d7 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
        hi IndentGuidesEven guifg=#f9f5d7 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      endif
    endif
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    if get(g:, 'indent_guides_auto_colors', 0)
      if get(g:, 'gruvbox_material_invert_indent_guides', 0)
        hi IndentGuidesOdd guifg=#f2e5bc guibg=#d5c4a1 guisp=NONE gui=reverse cterm=reverse
        hi IndentGuidesEven guifg=#f2e5bc guibg=#ebdbb2 guisp=NONE gui=reverse cterm=reverse
      else
        hi IndentGuidesOdd guifg=#f2e5bc guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
        hi IndentGuidesEven guifg=#f2e5bc guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      endif
    endif
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    if get(g:, 'indent_guides_auto_colors', 0)
      if get(g:, 'gruvbox_material_invert_indent_guides', 0)
        hi IndentGuidesOdd guifg=#fbf1c7 guibg=#d5c4a1 guisp=NONE gui=reverse cterm=reverse
        hi IndentGuidesEven guifg=#fbf1c7 guibg=#ebdbb2 guisp=NONE gui=reverse cterm=reverse
      else
        hi IndentGuidesOdd guifg=#fbf1c7 guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
        hi IndentGuidesEven guifg=#fbf1c7 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
      endif
    endif
  endif
  if !exists('g:indentLine_color_term')
    let g:indentLine_color_term = 250
  endif
  if !exists('g:indentLine_color_gui')
    let g:indentLine_color_gui = '#d5c4a1'
  endif
  " Rainbow Parentheses
  if !exists('g:rbpt_colorpairs')
    let g:rbpt_colorpairs = [['blue', '#47747e'], ['magenta', '#945e80'],
          \ ['red', '#c74545'], ['130', '#c55b03']]
  endif

  let g:rainbow_guifgs = [ '#c55b03', '#c74545', '#945e80', '#47747e' ]
  let g:rainbow_ctermfgs = [ '130', 'red', 'magenta', 'blue' ]

  if !exists('g:rainbow_conf')
    let g:rainbow_conf = {}
  endif
  if !has_key(g:rainbow_conf, 'guifgs')
    let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
  endif
  if !has_key(g:rainbow_conf, 'ctermfgs')
    let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
  endif

  let g:niji_dark_colours = g:rbpt_colorpairs
  let g:niji_light_colours = g:rbpt_colorpairs
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi GitGutterAdd guifg=#6c782e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi GitGutterChange guifg=#47747e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi GitGutterDelete guifg=#c74545 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi GitGutterChangeDelete guifg=#945e80 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi GitGutterAdd guifg=#6c782e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi GitGutterChange guifg=#47747e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi GitGutterDelete guifg=#c74545 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi GitGutterChangeDelete guifg=#945e80 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi GitGutterAdd guifg=#6c782e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi GitGutterChange guifg=#47747e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi GitGutterDelete guifg=#c74545 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi GitGutterChangeDelete guifg=#945e80 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi SignatureMarkText guifg=#47747e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi SignatureMarkerText guifg=#945e80 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi SignatureMarkText guifg=#47747e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi SignatureMarkerText guifg=#945e80 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi SignatureMarkText guifg=#47747e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi SignatureMarkerText guifg=#945e80 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi ShowMarksHLl guifg=#47747e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLu guifg=#47747e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLo guifg=#47747e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLm guifg=#47747e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi ShowMarksHLl guifg=#47747e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLu guifg=#47747e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLo guifg=#47747e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLm guifg=#47747e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi ShowMarksHLl guifg=#47747e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLu guifg=#47747e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLo guifg=#47747e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi ShowMarksHLm guifg=#47747e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
  endif
  hi CtrlPMatch guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi CtrlPPrtBase guifg=#d5c4a1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi CtrlPLinePre guifg=#d5c4a1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi CtrlPMode1 guifg=#47747e guibg=#d5c4a1 guisp=NONE gui=bold cterm=bold
  hi CtrlPMode2 guifg=#fbf1c7 guibg=#47747e guisp=NONE gui=bold cterm=bold
  hi CtrlPStats guifg=#7c6f64 guibg=#d5c4a1 guisp=NONE gui=bold cterm=bold
  hi Lf_hl_match guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Lf_hl_match0 guifg=#6c782e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Lf_hl_match1 guifg=#4c7a5d guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Lf_hl_match2 guifg=#47747e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Lf_hl_match3 guifg=#945e80 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Lf_hl_match4 guifg=#c55b03 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Lf_hl_matchRefine guifg=#c74545 guibg=NONE guisp=NONE gui=bold cterm=bold
  let g:vimshell_escape_colors = [
        \ '#a89984', '#c74545', '#6c782e', '#b47109',
        \ '#47747e', '#945e80', '#4c7a5d', '#7c6f64',
        \ '#fbf1c7', '#c74545', '#6c782e', '#c55b03',
        \ '#47747e', '#945e80', '#4c7a5d', '#764e37'
        \ ]
  hi ALEError guifg=NONE guibg=NONE guisp=#c74545 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
  hi ALEWarning guifg=NONE guibg=NONE guisp=#b47109 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
  hi ALEInfo guifg=NONE guibg=NONE guisp=#47747e gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi ALEErrorSign guifg=#c74545 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi ALEWarningSign guifg=#b47109 guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
    hi ALEInfoSign guifg=#47747e guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi ALEErrorSign guifg=#c74545 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi ALEWarningSign guifg=#b47109 guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
    hi ALEInfoSign guifg=#47747e guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi ALEErrorSign guifg=#c74545 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi ALEWarningSign guifg=#b47109 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
    hi ALEInfoSign guifg=#47747e guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
  endif
  hi multiple_cursors_cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi multiple_cursors_visual guifg=NONE guibg=#d5c4a1 guisp=NONE gui=NONE cterm=NONE
  hi CocHighlightText guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
  hi CocHoverRange guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi CocHintSign guifg=#4c7a5d guibg=#fbf1c7 guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi CocHintSign guifg=#4c7a5d guibg=#f2e5bc guisp=NONE gui=NONE cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi CocHintSign guifg=#4c7a5d guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
  endif
  hi MatchParenCur guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
  hi MatchWord guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
  hi MatchWordCur guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
  hi UndotreeSavedBig guifg=#945e80 guibg=NONE guisp=NONE gui=bold cterm=bold
  unlet s:t_Co s:italics
  finish
endif  " }}}
if s:t_Co >= 256  "  {{{
  if &background ==# 'dark'
    hi White ctermfg=223 ctermbg=NONE cterm=NONE
    hi LightGrey ctermfg=246 ctermbg=NONE cterm=NONE
    hi Grey ctermfg=245 ctermbg=NONE cterm=NONE
    hi Red ctermfg=167 ctermbg=NONE cterm=NONE
    hi Orange ctermfg=208 ctermbg=NONE cterm=NONE
    hi Yellow ctermfg=214 ctermbg=NONE cterm=NONE
    hi Green ctermfg=142 ctermbg=NONE cterm=NONE
    hi Aqua ctermfg=108 ctermbg=NONE cterm=NONE
    hi Blue ctermfg=109 ctermbg=NONE cterm=NONE
    hi Purple ctermfg=175 ctermbg=NONE cterm=NONE
    if get(g:, 'gruvbox_material_enable_bold', 0)
      hi WhiteBold ctermfg=223 ctermbg=NONE cterm=bold
      hi LightGreyBold ctermfg=246 ctermbg=NONE cterm=bold
      hi GreyBold ctermfg=245 ctermbg=NONE cterm=bold
      hi RedBold ctermfg=167 ctermbg=NONE cterm=bold
      hi OrangeBold ctermfg=208 ctermbg=NONE cterm=bold
      hi YellowBold ctermfg=214 ctermbg=NONE cterm=bold
      hi GreenBold ctermfg=142 ctermbg=NONE cterm=bold
      hi AquaBold ctermfg=108 ctermbg=NONE cterm=bold
      hi BlueBold ctermfg=109 ctermbg=NONE cterm=bold
      hi PurpleBold ctermfg=175 ctermbg=NONE cterm=bold
    else
      hi WhiteBold ctermfg=223 ctermbg=NONE cterm=NONE
      hi LightGreyBold ctermfg=246 ctermbg=NONE cterm=NONE
      hi GreyBold ctermfg=245 ctermbg=NONE cterm=NONE
      hi RedBold ctermfg=167 ctermbg=NONE cterm=NONE
      hi OrangeBold ctermfg=208 ctermbg=NONE cterm=NONE
      hi YellowBold ctermfg=214 ctermbg=NONE cterm=NONE
      hi GreenBold ctermfg=142 ctermbg=NONE cterm=NONE
      hi AquaBold ctermfg=108 ctermbg=NONE cterm=NONE
      hi BlueBold ctermfg=109 ctermbg=NONE cterm=NONE
      hi PurpleBold ctermfg=175 ctermbg=NONE cterm=NONE
    endif
    if get(g:, 'gruvbox_material_transparent_background', 0)
      hi Normal ctermfg=223 ctermbg=NONE cterm=NONE
      hi Terminal ctermfg=223 ctermbg=NONE cterm=NONE
      hi DiffText ctermfg=NONE ctermbg=NONE cterm=reverse
      hi VertSplit ctermfg=241 ctermbg=NONE cterm=NONE
      hi QuickFixLine ctermfg=214 ctermbg=NONE cterm=reverse
      hi EndOfBuffer ctermfg=245 ctermbg=NONE cterm=NONE
      hi FoldColumn ctermfg=245 ctermbg=NONE cterm=NONE
      hi Folded ctermfg=245 ctermbg=NONE cterm=bold
      hi CursorColumn ctermfg=NONE ctermbg=NONE cterm=NONE
      hi CursorLine ctermfg=NONE ctermbg=NONE cterm=NONE
      hi CursorLineNr ctermfg=246 ctermbg=NONE cterm=NONE
      hi MatchParen ctermfg=NONE ctermbg=NONE cterm=bold
    else
      if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
        hi Normal ctermfg=223 ctermbg=234 cterm=NONE
        if !has('patch-8.0.0616') && !has('nvim') " Fix for Vim bug
          set background=dark
        endif
        hi Terminal ctermfg=223 ctermbg=234 cterm=NONE
        hi DiffText ctermfg=NONE ctermbg=234 cterm=reverse
        hi EndOfBuffer ctermfg=234 ctermbg=234 cterm=NONE
        hi VertSplit ctermfg=241 ctermbg=234 cterm=NONE
        hi QuickFixLine ctermfg=214 ctermbg=234 cterm=reverse
        hi MatchParen ctermfg=NONE ctermbg=236 cterm=bold
        hi FoldColumn ctermfg=245 ctermbg=235 cterm=NONE
        hi Folded ctermfg=245 ctermbg=235 cterm=NONE
        hi CursorColumn ctermfg=NONE ctermbg=235 cterm=NONE
        hi CursorLine ctermfg=NONE ctermbg=235 cterm=NONE
        hi CursorLineNr ctermfg=246 ctermbg=235 cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
        hi Normal ctermfg=223 ctermbg=235 cterm=NONE
        if !has('patch-8.0.0616') && !has('nvim') " Fix for Vim bug
          set background=dark
        endif
        hi Terminal ctermfg=223 ctermbg=235 cterm=NONE
        hi DiffText ctermfg=NONE ctermbg=235 cterm=reverse
        hi EndOfBuffer ctermfg=235 ctermbg=235 cterm=NONE
        hi VertSplit ctermfg=241 ctermbg=235 cterm=NONE
        hi QuickFixLine ctermfg=214 ctermbg=235 cterm=reverse
        hi MatchParen ctermfg=NONE ctermbg=237 cterm=bold
        hi FoldColumn ctermfg=245 ctermbg=236 cterm=NONE
        hi Folded ctermfg=245 ctermbg=236 cterm=NONE
        hi CursorColumn ctermfg=NONE ctermbg=236 cterm=NONE
        hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE
        hi CursorLineNr ctermfg=246 ctermbg=236 cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
        hi Normal ctermfg=223 ctermbg=236 cterm=NONE
        if !has('patch-8.0.0616') && !has('nvim') " Fix for Vim bug
          set background=dark
        endif
        hi Terminal ctermfg=223 ctermbg=236 cterm=NONE
        hi DiffText ctermfg=NONE ctermbg=236 cterm=reverse
        hi EndOfBuffer ctermfg=236 ctermbg=236 cterm=NONE
        hi VertSplit ctermfg=241 ctermbg=236 cterm=NONE
        hi QuickFixLine ctermfg=214 ctermbg=236 cterm=reverse
        hi MatchParen ctermfg=NONE ctermbg=239 cterm=bold
        hi FoldColumn ctermfg=245 ctermbg=237 cterm=NONE
        hi Folded ctermfg=245 ctermbg=237 cterm=NONE
        hi CursorColumn ctermfg=NONE ctermbg=237 cterm=NONE
        hi CursorLine ctermfg=NONE ctermbg=237 cterm=NONE
        hi CursorLineNr ctermfg=246 ctermbg=237 cterm=NONE
      endif
    endif
    if &background ==#'light'
      hi PmenuSel ctermfg=237 ctermbg=246 cterm=NONE
      hi TabLineSel ctermfg=237 ctermbg=246 cterm=bold
      hi WildMenu ctermfg=237 ctermbg=246 cterm=NONE
      if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
        hi Pmenu ctermfg=223 ctermbg=236 cterm=NONE
        hi StatusLine ctermfg=223 ctermbg=237 cterm=NONE
        hi StatusLineTerm ctermfg=223 ctermbg=237 cterm=NONE
        hi TabLine ctermfg=223 ctermbg=237 cterm=NONE
        hi TabLineFill ctermfg=223 ctermbg=235 cterm=NONE
        hi ColorColumn ctermfg=NONE ctermbg=235 cterm=NONE
        hi SignColumn ctermfg=NONE ctermbg=235 cterm=NONE
        hi StatusLineNC ctermfg=246 ctermbg=235 cterm=NONE
        hi StatusLineTermNC ctermfg=246 ctermbg=235 cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
        hi Pmenu ctermfg=223 ctermbg=237 cterm=NONE
        hi StatusLine ctermfg=223 ctermbg=239 cterm=NONE
        hi StatusLineTerm ctermfg=223 ctermbg=239 cterm=NONE
        hi TabLine ctermfg=223 ctermbg=239 cterm=NONE
        hi TabLineFill ctermfg=223 ctermbg=236 cterm=NONE
        hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE
        hi SignColumn ctermfg=NONE ctermbg=236 cterm=NONE
        hi StatusLineNC ctermfg=246 ctermbg=236 cterm=NONE
        hi StatusLineTermNC ctermfg=246 ctermbg=236 cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
        hi Pmenu ctermfg=223 ctermbg=239 cterm=NONE
        hi StatusLine ctermfg=223 ctermbg=241 cterm=NONE
        hi StatusLineTerm ctermfg=223 ctermbg=241 cterm=NONE
        hi TabLine ctermfg=223 ctermbg=241 cterm=NONE
        hi TabLineFill ctermfg=223 ctermbg=237 cterm=NONE
        hi ColorColumn ctermfg=NONE ctermbg=237 cterm=NONE
        hi SignColumn ctermfg=NONE ctermbg=237 cterm=NONE
        hi StatusLineNC ctermfg=246 ctermbg=237 cterm=NONE
        hi StatusLineTermNC ctermfg=246 ctermbg=237 cterm=NONE
      endif
    else
      hi PmenuSel ctermfg=235 ctermbg=246 cterm=NONE
      " hi TabLineSel ctermfg=235 ctermbg=246 cterm=bold
      hi TabLineSel ctermfg=237 ctermbg=246 cterm=bold
      hi WildMenu ctermfg=235 ctermbg=246 cterm=NONE
      if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
        hi Pmenu ctermfg=223 ctermbg=237 cterm=NONE
        hi StatusLine ctermfg=223 ctermbg=239 cterm=NONE
        hi StatusLineTerm ctermfg=223 ctermbg=239 cterm=NONE
        hi TabLine ctermfg=223 ctermbg=239 cterm=NONE
        hi TabLineFill ctermfg=223 ctermbg=235 cterm=NONE
        hi ColorColumn ctermfg=NONE ctermbg=235 cterm=NONE
        hi SignColumn ctermfg=NONE ctermbg=235 cterm=NONE
        hi StatusLineNC ctermfg=246 ctermbg=235 cterm=NONE
        hi StatusLineTermNC ctermfg=246 ctermbg=235 cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
        hi Pmenu ctermfg=223 ctermbg=239 cterm=NONE
        hi StatusLine ctermfg=223 ctermbg=241 cterm=NONE
        hi StatusLineTerm ctermfg=223 ctermbg=241 cterm=NONE
        hi TabLine ctermfg=223 ctermbg=241 cterm=NONE
        hi TabLineFill ctermfg=223 ctermbg=236 cterm=NONE
        hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE
        hi SignColumn ctermfg=NONE ctermbg=236 cterm=NONE
        hi StatusLineNC ctermfg=246 ctermbg=236 cterm=NONE
        hi StatusLineTermNC ctermfg=246 ctermbg=236 cterm=NONE
      elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
        hi Pmenu ctermfg=223 ctermbg=239 cterm=NONE
        hi StatusLine ctermfg=223 ctermbg=241 cterm=NONE
        hi StatusLineTerm ctermfg=223 ctermbg=241 cterm=NONE
        hi TabLine ctermfg=223 ctermbg=241 cterm=NONE
        hi TabLineFill ctermfg=223 ctermbg=237 cterm=NONE
        hi ColorColumn ctermfg=NONE ctermbg=237 cterm=NONE
        hi SignColumn ctermfg=NONE ctermbg=237 cterm=NONE
        hi StatusLineNC ctermfg=246 ctermbg=237 cterm=NONE
        hi StatusLineTermNC ctermfg=246 ctermbg=237 cterm=NONE
      endif
    endif
    hi Conceal ctermfg=109 ctermbg=NONE cterm=NONE
    hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
    hi lCursor ctermfg=NONE ctermbg=NONE cterm=reverse
    hi LineNr ctermfg=243 ctermbg=NONE cterm=NONE
    hi Directory ctermfg=142 ctermbg=NONE cterm=NONE
    hi ErrorMsg ctermfg=167 ctermbg=NONE cterm=bold,underline
    hi WarningMsg ctermfg=214 ctermbg=NONE cterm=bold
    hi ModeMsg ctermfg=223 ctermbg=NONE cterm=bold
    hi MoreMsg ctermfg=214 ctermbg=NONE cterm=bold
    hi IncSearch ctermfg=NONE ctermbg=NONE cterm=bold,reverse
    hi Search ctermfg=NONE ctermbg=NONE cterm=reverse,underline
    hi NonText ctermfg=245 ctermbg=NONE cterm=NONE
    hi PmenuSbar ctermfg=NONE ctermbg=239 cterm=NONE
    hi PmenuThumb ctermfg=NONE ctermbg=243 cterm=NONE
    hi Question ctermfg=208 ctermbg=NONE cterm=bold
    hi SpellBad ctermfg=167 ctermbg=NONE cterm=italic,underline
    hi SpellCap ctermfg=109 ctermbg=NONE cterm=italic,underline
    hi SpellLocal ctermfg=108 ctermbg=NONE cterm=italic,underline
    hi SpellRare ctermfg=175 ctermbg=NONE cterm=italic,underline
    hi Visual ctermfg=NONE ctermbg=NONE cterm=reverse
    hi VisualNOS ctermfg=NONE ctermbg=NONE cterm=reverse
    hi Todo ctermfg=245 ctermbg=NONE cterm=bold,italic,underline
    hi CursorIM ctermfg=NONE ctermbg=NONE cterm=reverse
    hi ToolbarLine ctermfg=NONE ctermbg=241 cterm=NONE
    hi ToolbarButton ctermfg=223 ctermbg=241 cterm=bold
    hi Debug ctermfg=208 ctermbg=NONE cterm=NONE
    hi Title ctermfg=142 ctermbg=NONE cterm=bold
    hi Conditional ctermfg=167 ctermbg=NONE cterm=NONE
    hi Repeat ctermfg=167 ctermbg=NONE cterm=NONE
    hi Label ctermfg=167 ctermbg=NONE cterm=NONE
    hi Exception ctermfg=167 ctermbg=NONE cterm=NONE
    hi Keyword ctermfg=167 ctermbg=NONE cterm=NONE
    hi Statement ctermfg=167 ctermbg=NONE cterm=NONE
    hi Typedef ctermfg=214 ctermbg=NONE cterm=NONE
    hi Type ctermfg=214 ctermbg=NONE cterm=NONE
    hi StorageClass ctermfg=208 ctermbg=NONE cterm=NONE
    hi Delimiter ctermfg=223 ctermbg=NONE cterm=NONE
    hi Special ctermfg=208 ctermbg=NONE cterm=NONE
    hi Tag ctermfg=208 ctermbg=NONE cterm=NONE
    hi Operator ctermfg=208 ctermbg=NONE cterm=NONE
    hi SpecialChar ctermfg=208 ctermbg=NONE cterm=NONE
    hi String ctermfg=142 ctermbg=NONE cterm=NONE
    hi PreProc ctermfg=108 ctermbg=NONE cterm=NONE
    hi Macro ctermfg=108 ctermbg=NONE cterm=NONE
    hi Define ctermfg=108 ctermbg=NONE cterm=NONE
    hi Include ctermfg=108 ctermbg=NONE cterm=NONE
    hi PreCondit ctermfg=108 ctermbg=NONE cterm=NONE
    hi Structure ctermfg=108 ctermbg=NONE cterm=NONE
    hi Identifier ctermfg=109 ctermbg=NONE cterm=NONE
    hi Underlined ctermfg=109 ctermbg=NONE cterm=underline
    hi Constant ctermfg=175 ctermbg=NONE cterm=NONE
    hi Boolean ctermfg=175 ctermbg=NONE cterm=NONE
    hi Character ctermfg=175 ctermbg=NONE cterm=NONE
    hi Number ctermfg=175 ctermbg=NONE cterm=NONE
    hi Float ctermfg=175 ctermbg=NONE cterm=NONE
    hi SpecialKey ctermfg=109 ctermbg=NONE cterm=NONE
    hi Ignore ctermfg=223 ctermbg=NONE cterm=NONE
    if !s:italics
      hi SpellBad cterm=underline
      hi SpellCap cterm=underline
      hi SpellLocal cterm=underline
      hi SpellRare cterm=underline
      hi Todo cterm=bold
    endif
    if get(g:, 'gruvbox_material_disable_italic_comment', 0)
      hi Comment ctermfg=245 ctermbg=NONE cterm=NONE
      hi SpecialComment ctermfg=245 ctermbg=NONE cterm=NONE
    else
      hi Comment ctermfg=245 ctermbg=NONE cterm=italic
      hi SpecialComment ctermfg=245 ctermbg=NONE cterm=italic
      if !s:italics
        hi Comment cterm=NONE
        hi SpecialComment cterm=NONE
      endif
    endif
    if get(g:, 'gruvbox_material_enable_bold', 0)
      hi Function ctermfg=142 ctermbg=NONE cterm=bold
    else
      hi Function ctermfg=142 ctermbg=NONE cterm=NONE
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi DiffAdd ctermfg=NONE ctermbg=22 cterm=NONE
      hi DiffChange ctermfg=NONE ctermbg=17 cterm=NONE
      hi DiffDelete ctermfg=NONE ctermbg=52 cterm=NONE
      hi Error ctermfg=NONE ctermbg=52 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi DiffAdd ctermfg=NONE ctermbg=22 cterm=NONE
      hi DiffChange ctermfg=NONE ctermbg=17 cterm=NONE
      hi DiffDelete ctermfg=NONE ctermbg=52 cterm=NONE
      hi Error ctermfg=NONE ctermbg=52 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi DiffAdd ctermfg=NONE ctermbg=22 cterm=NONE
      hi DiffChange ctermfg=NONE ctermbg=17 cterm=NONE
      hi DiffDelete ctermfg=NONE ctermbg=52 cterm=NONE
      hi Error ctermfg=NONE ctermbg=52 cterm=NONE
    endif
    hi markdownH1 ctermfg=142 ctermbg=NONE cterm=bold
    hi markdownH2 ctermfg=142 ctermbg=NONE cterm=bold
    hi markdownH3 ctermfg=214 ctermbg=NONE cterm=bold
    hi markdownH4 ctermfg=214 ctermbg=NONE cterm=bold
    hi markdownUrl ctermfg=175 ctermbg=NONE cterm=underline
    hi markdownItalic ctermfg=NONE ctermbg=NONE cterm=italic
    hi markdownBold ctermfg=NONE ctermbg=NONE cterm=bold
    hi markdownItalicDelimiter ctermfg=245 ctermbg=NONE cterm=italic
    hi mkdURL ctermfg=175 ctermbg=NONE cterm=underline
    hi mkdInlineURL ctermfg=175 ctermbg=NONE cterm=underline
    hi mkdItalic ctermfg=245 ctermbg=NONE cterm=italic
    hi htmlLink ctermfg=246 ctermbg=NONE cterm=underline
    hi htmlBold ctermfg=NONE ctermbg=NONE cterm=bold
    hi htmlBoldUnderline ctermfg=NONE ctermbg=NONE cterm=bold,underline
    hi htmlBoldItalic ctermfg=NONE ctermbg=NONE cterm=bold,italic
    hi htmlBoldUnderlineItalic ctermfg=NONE ctermbg=NONE cterm=bold,italic,underline
    hi htmlUnderline ctermfg=NONE ctermbg=NONE cterm=underline
    hi htmlUnderlineItalic ctermfg=NONE ctermbg=NONE cterm=italic,underline
    hi htmlItalic ctermfg=NONE ctermbg=NONE cterm=italic
    hi vimCommentTitle ctermfg=246 ctermbg=NONE cterm=bold,italic
    hi helpURL ctermfg=108 ctermbg=NONE cterm=underline
    hi helpNote ctermfg=175 ctermbg=NONE cterm=bold
    hi plug1 ctermfg=208 ctermbg=NONE cterm=bold
    hi plugNumber ctermfg=214 ctermbg=NONE cterm=bold
    if !s:italics
      hi markdownItalic cterm=NONE
      hi markdownItalicDelimiter cterm=NONE
      hi mkdItalic cterm=NONE
      hi htmlBoldItalic cterm=bold
      hi htmlBoldUnderlineItalic cterm=bold,underline
      hi htmlUnderlineItalic cterm=underline
      hi htmlItalic cterm=NONE
      hi vimCommentTitle cterm=bold
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      if get(g:, 'indent_guides_auto_colors', 0)
        if get(g:, 'gruvbox_material_invert_indent_guides', 0)
          hi IndentGuidesOdd ctermfg=234 ctermbg=239 cterm=reverse
          hi IndentGuidesEven ctermfg=234 ctermbg=237 cterm=reverse
        else
          hi IndentGuidesOdd ctermfg=234 ctermbg=239 cterm=NONE
          hi IndentGuidesEven ctermfg=234 ctermbg=237 cterm=NONE
        endif
      endif
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      if get(g:, 'indent_guides_auto_colors', 0)
        if get(g:, 'gruvbox_material_invert_indent_guides', 0)
          hi IndentGuidesOdd ctermfg=236 ctermbg=239 cterm=reverse
          hi IndentGuidesEven ctermfg=236 ctermbg=237 cterm=reverse
        else
          hi IndentGuidesOdd ctermfg=236 ctermbg=239 cterm=NONE
          hi IndentGuidesEven ctermfg=236 ctermbg=237 cterm=NONE
        endif
      endif
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      if get(g:, 'indent_guides_auto_colors', 0)
        if get(g:, 'gruvbox_material_invert_indent_guides', 0)
          hi IndentGuidesOdd ctermfg=235 ctermbg=239 cterm=reverse
          hi IndentGuidesEven ctermfg=235 ctermbg=237 cterm=reverse
        else
          hi IndentGuidesOdd ctermfg=235 ctermbg=239 cterm=NONE
          hi IndentGuidesEven ctermfg=235 ctermbg=237 cterm=NONE
        endif
      endif
    endif
    if !exists('g:indentLine_color_term')
      let g:indentLine_color_term = 239
    endif
    if !exists('g:indentLine_color_gui')
      let g:indentLine_color_gui = '#504945'
    endif
    " Rainbow Parentheses
    if !exists('g:rbpt_colorpairs')
      let g:rbpt_colorpairs = [['blue', '#7daea3'], ['magenta', '#d3869b'],
            \ ['red', '#ea6962'], ['208', '#e78a4e']]
    endif

    let g:rainbow_guifgs = [ '#e78a4e', '#ea6962', '#d3869b', '#7daea3' ]
    let g:rainbow_ctermfgs = [ '208', 'red', 'magenta', 'blue' ]

    if !exists('g:rainbow_conf')
      let g:rainbow_conf = {}
    endif
    if !has_key(g:rainbow_conf, 'guifgs')
      let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
    endif
    if !has_key(g:rainbow_conf, 'ctermfgs')
      let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
    endif

    let g:niji_dark_colours = g:rbpt_colorpairs
    let g:niji_light_colours = g:rbpt_colorpairs
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi GitGutterAdd ctermfg=142 ctermbg=235 cterm=NONE
      hi GitGutterChange ctermfg=109 ctermbg=235 cterm=NONE
      hi GitGutterDelete ctermfg=167 ctermbg=235 cterm=NONE
      hi GitGutterChangeDelete ctermfg=175 ctermbg=235 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi GitGutterAdd ctermfg=142 ctermbg=236 cterm=NONE
      hi GitGutterChange ctermfg=109 ctermbg=236 cterm=NONE
      hi GitGutterDelete ctermfg=167 ctermbg=236 cterm=NONE
      hi GitGutterChangeDelete ctermfg=175 ctermbg=236 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi GitGutterAdd ctermfg=142 ctermbg=237 cterm=NONE
      hi GitGutterChange ctermfg=109 ctermbg=237 cterm=NONE
      hi GitGutterDelete ctermfg=167 ctermbg=237 cterm=NONE
      hi GitGutterChangeDelete ctermfg=175 ctermbg=237 cterm=NONE
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi SignatureMarkText ctermfg=109 ctermbg=235 cterm=NONE
      hi SignatureMarkerText ctermfg=175 ctermbg=235 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi SignatureMarkText ctermfg=109 ctermbg=236 cterm=NONE
      hi SignatureMarkerText ctermfg=175 ctermbg=236 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi SignatureMarkText ctermfg=109 ctermbg=237 cterm=NONE
      hi SignatureMarkerText ctermfg=175 ctermbg=237 cterm=NONE
    endif
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi ShowMarksHLl ctermfg=109 ctermbg=235 cterm=NONE
      hi ShowMarksHLu ctermfg=109 ctermbg=235 cterm=NONE
      hi ShowMarksHLo ctermfg=109 ctermbg=235 cterm=NONE
      hi ShowMarksHLm ctermfg=109 ctermbg=235 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi ShowMarksHLl ctermfg=109 ctermbg=236 cterm=NONE
      hi ShowMarksHLu ctermfg=109 ctermbg=236 cterm=NONE
      hi ShowMarksHLo ctermfg=109 ctermbg=236 cterm=NONE
      hi ShowMarksHLm ctermfg=109 ctermbg=236 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi ShowMarksHLl ctermfg=109 ctermbg=237 cterm=NONE
      hi ShowMarksHLu ctermfg=109 ctermbg=237 cterm=NONE
      hi ShowMarksHLo ctermfg=109 ctermbg=237 cterm=NONE
      hi ShowMarksHLm ctermfg=109 ctermbg=237 cterm=NONE
    endif
    hi CtrlPMatch ctermfg=142 ctermbg=NONE cterm=bold
    hi CtrlPPrtBase ctermfg=239 ctermbg=NONE cterm=NONE
    hi CtrlPLinePre ctermfg=239 ctermbg=NONE cterm=NONE
    hi CtrlPMode1 ctermfg=109 ctermbg=239 cterm=bold
    hi CtrlPMode2 ctermfg=235 ctermbg=109 cterm=bold
    hi CtrlPStats ctermfg=246 ctermbg=239 cterm=bold
    hi Lf_hl_match ctermfg=142 ctermbg=NONE cterm=bold
    hi Lf_hl_match0 ctermfg=142 ctermbg=NONE cterm=bold
    hi Lf_hl_match1 ctermfg=108 ctermbg=NONE cterm=bold
    hi Lf_hl_match2 ctermfg=109 ctermbg=NONE cterm=bold
    hi Lf_hl_match3 ctermfg=175 ctermbg=NONE cterm=bold
    hi Lf_hl_match4 ctermfg=208 ctermbg=NONE cterm=bold
    hi Lf_hl_matchRefine ctermfg=167 ctermbg=NONE cterm=bold
    let g:vimshell_escape_colors = [
          \ '#7c6f64', '#ea6962', '#a9b665', '#e3a84e',
          \ '#7daea3', '#d3869b', '#89b482', '#a89984',
          \ '#282828', '#ea6962', '#a9b665', '#e78a4e',
          \ '#7daea3', '#d3869b', '#89b482', '#dfbf8e'
          \ ]
    hi ALEError ctermfg=NONE ctermbg=NONE cterm=underline
    hi ALEWarning ctermfg=NONE ctermbg=NONE cterm=underline
    hi ALEInfo ctermfg=NONE ctermbg=NONE cterm=underline
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi ALEErrorSign ctermfg=167 ctermbg=235 cterm=NONE
      hi ALEWarningSign ctermfg=214 ctermbg=235 cterm=NONE
      hi ALEInfoSign ctermfg=109 ctermbg=235 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi ALEErrorSign ctermfg=167 ctermbg=236 cterm=NONE
      hi ALEWarningSign ctermfg=214 ctermbg=236 cterm=NONE
      hi ALEInfoSign ctermfg=109 ctermbg=236 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi ALEErrorSign ctermfg=167 ctermbg=237 cterm=NONE
      hi ALEWarningSign ctermfg=214 ctermbg=237 cterm=NONE
      hi ALEInfoSign ctermfg=109 ctermbg=237 cterm=NONE
    endif
    hi multiple_cursors_cursor ctermfg=NONE ctermbg=NONE cterm=reverse
    hi multiple_cursors_visual ctermfg=NONE ctermbg=239 cterm=NONE
    hi CocHighlightText ctermfg=NONE ctermbg=NONE cterm=bold
    hi CocHoverRange ctermfg=NONE ctermbg=NONE cterm=bold,underline
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi CocHintSign ctermfg=108 ctermbg=235 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi CocHintSign ctermfg=108 ctermbg=236 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi CocHintSign ctermfg=108 ctermbg=237 cterm=NONE
    endif
    hi MatchParenCur ctermfg=NONE ctermbg=NONE cterm=bold
    hi MatchWord ctermfg=NONE ctermbg=NONE cterm=underline
    hi MatchWordCur ctermfg=NONE ctermbg=NONE cterm=underline
    hi UndotreeSavedBig ctermfg=175 ctermbg=NONE cterm=bold
    unlet s:t_Co s:italics
    finish
  endif
  " Light background
  hi White ctermfg=237 ctermbg=NONE cterm=NONE
  hi LightGrey ctermfg=243 ctermbg=NONE cterm=NONE
  hi Grey ctermfg=245 ctermbg=NONE cterm=NONE
  hi Red ctermfg=88 ctermbg=NONE cterm=NONE
  hi Orange ctermfg=130 ctermbg=NONE cterm=NONE
  hi Yellow ctermfg=136 ctermbg=NONE cterm=NONE
  hi Green ctermfg=100 ctermbg=NONE cterm=NONE
  hi Aqua ctermfg=165 ctermbg=NONE cterm=NONE
  hi Blue ctermfg=24 ctermbg=NONE cterm=NONE
  hi Purple ctermfg=96 ctermbg=NONE cterm=NONE
  if get(g:, 'gruvbox_material_enable_bold', 0)
    hi WhiteBold ctermfg=237 ctermbg=NONE cterm=bold
    hi LightGreyBold ctermfg=243 ctermbg=NONE cterm=bold
    hi GreyBold ctermfg=245 ctermbg=NONE cterm=bold
    hi RedBold ctermfg=88 ctermbg=NONE cterm=bold
    hi OrangeBold ctermfg=130 ctermbg=NONE cterm=bold
    hi YellowBold ctermfg=136 ctermbg=NONE cterm=bold
    hi GreenBold ctermfg=100 ctermbg=NONE cterm=bold
    hi AquaBold ctermfg=165 ctermbg=NONE cterm=bold
    hi BlueBold ctermfg=24 ctermbg=NONE cterm=bold
    hi PurpleBold ctermfg=96 ctermbg=NONE cterm=bold
  else
    hi WhiteBold ctermfg=237 ctermbg=NONE cterm=NONE
    hi LightGreyBold ctermfg=243 ctermbg=NONE cterm=NONE
    hi GreyBold ctermfg=245 ctermbg=NONE cterm=NONE
    hi RedBold ctermfg=88 ctermbg=NONE cterm=NONE
    hi OrangeBold ctermfg=130 ctermbg=NONE cterm=NONE
    hi YellowBold ctermfg=136 ctermbg=NONE cterm=NONE
    hi GreenBold ctermfg=100 ctermbg=NONE cterm=NONE
    hi AquaBold ctermfg=165 ctermbg=NONE cterm=NONE
    hi BlueBold ctermfg=24 ctermbg=NONE cterm=NONE
    hi PurpleBold ctermfg=96 ctermbg=NONE cterm=NONE
  endif
  if get(g:, 'gruvbox_material_transparent_background', 0)
    hi Normal ctermfg=237 ctermbg=NONE cterm=NONE
    hi Terminal ctermfg=237 ctermbg=NONE cterm=NONE
    hi DiffText ctermfg=NONE ctermbg=NONE cterm=reverse
    hi VertSplit ctermfg=248 ctermbg=NONE cterm=NONE
    hi QuickFixLine ctermfg=136 ctermbg=NONE cterm=reverse
    hi EndOfBuffer ctermfg=245 ctermbg=NONE cterm=NONE
    hi FoldColumn ctermfg=245 ctermbg=NONE cterm=NONE
    hi Folded ctermfg=245 ctermbg=NONE cterm=bold
    hi CursorColumn ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorLine ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorLineNr ctermfg=243 ctermbg=NONE cterm=NONE
    hi MatchParen ctermfg=NONE ctermbg=NONE cterm=bold
  else
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi Normal ctermfg=237 ctermbg=230 cterm=NONE
      hi Terminal ctermfg=237 ctermbg=230 cterm=NONE
      hi DiffText ctermfg=NONE ctermbg=230 cterm=reverse
      hi EndOfBuffer ctermfg=230 ctermbg=230 cterm=NONE
      hi VertSplit ctermfg=248 ctermbg=230 cterm=NONE
      hi QuickFixLine ctermfg=136 ctermbg=230 cterm=reverse
      hi MatchParen ctermfg=NONE ctermbg=228 cterm=bold
      hi FoldColumn ctermfg=245 ctermbg=229 cterm=NONE
      hi Folded ctermfg=245 ctermbg=229 cterm=NONE
      hi CursorColumn ctermfg=NONE ctermbg=229 cterm=NONE
      hi CursorLine ctermfg=NONE ctermbg=229 cterm=NONE
      hi CursorLineNr ctermfg=243 ctermbg=229 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi Normal ctermfg=237 ctermbg=229 cterm=NONE
      hi Terminal ctermfg=237 ctermbg=229 cterm=NONE
      hi DiffText ctermfg=NONE ctermbg=229 cterm=reverse
      hi EndOfBuffer ctermfg=229 ctermbg=229 cterm=NONE
      hi VertSplit ctermfg=248 ctermbg=229 cterm=NONE
      hi QuickFixLine ctermfg=136 ctermbg=229 cterm=reverse
      hi MatchParen ctermfg=NONE ctermbg=223 cterm=bold
      hi FoldColumn ctermfg=245 ctermbg=228 cterm=NONE
      hi Folded ctermfg=245 ctermbg=228 cterm=NONE
      hi CursorColumn ctermfg=NONE ctermbg=228 cterm=NONE
      hi CursorLine ctermfg=NONE ctermbg=228 cterm=NONE
      hi CursorLineNr ctermfg=243 ctermbg=228 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi Normal ctermfg=237 ctermbg=228 cterm=NONE
      hi Terminal ctermfg=237 ctermbg=228 cterm=NONE
      hi DiffText ctermfg=NONE ctermbg=228 cterm=reverse
      hi EndOfBuffer ctermfg=228 ctermbg=228 cterm=NONE
      hi VertSplit ctermfg=248 ctermbg=228 cterm=NONE
      hi QuickFixLine ctermfg=136 ctermbg=228 cterm=reverse
      hi MatchParen ctermfg=NONE ctermbg=250 cterm=bold
      hi FoldColumn ctermfg=245 ctermbg=223 cterm=NONE
      hi Folded ctermfg=245 ctermbg=223 cterm=NONE
      hi CursorColumn ctermfg=NONE ctermbg=223 cterm=NONE
      hi CursorLine ctermfg=NONE ctermbg=223 cterm=NONE
      hi CursorLineNr ctermfg=243 ctermbg=223 cterm=NONE
    endif
  endif
  if &background ==#'light'
    hi PmenuSel ctermfg=223 ctermbg=243 cterm=NONE
    hi TabLineSel ctermfg=223 ctermbg=243 cterm=bold
    hi WildMenu ctermfg=223 ctermbg=243 cterm=NONE
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi Pmenu ctermfg=239 ctermbg=228 cterm=NONE
      hi StatusLine ctermfg=239 ctermbg=223 cterm=NONE
      hi StatusLineTerm ctermfg=239 ctermbg=223 cterm=NONE
      hi TabLine ctermfg=239 ctermbg=223 cterm=NONE
      hi TabLineFill ctermfg=239 ctermbg=229 cterm=NONE
      hi ColorColumn ctermfg=NONE ctermbg=229 cterm=NONE
      hi SignColumn ctermfg=NONE ctermbg=229 cterm=NONE
      hi StatusLineNC ctermfg=243 ctermbg=229 cterm=NONE
      hi StatusLineTermNC ctermfg=243 ctermbg=229 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi Pmenu ctermfg=239 ctermbg=223 cterm=NONE
      hi StatusLine ctermfg=239 ctermbg=250 cterm=NONE
      hi StatusLineTerm ctermfg=239 ctermbg=250 cterm=NONE
      hi TabLine ctermfg=239 ctermbg=250 cterm=NONE
      hi TabLineFill ctermfg=239 ctermbg=228 cterm=NONE
      hi ColorColumn ctermfg=NONE ctermbg=228 cterm=NONE
      hi SignColumn ctermfg=NONE ctermbg=228 cterm=NONE
      hi StatusLineNC ctermfg=243 ctermbg=228 cterm=NONE
      hi StatusLineTermNC ctermfg=243 ctermbg=228 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi Pmenu ctermfg=239 ctermbg=250 cterm=NONE
      hi StatusLine ctermfg=239 ctermbg=248 cterm=NONE
      hi StatusLineTerm ctermfg=239 ctermbg=248 cterm=NONE
      hi TabLine ctermfg=239 ctermbg=248 cterm=NONE
      hi TabLineFill ctermfg=239 ctermbg=223 cterm=NONE
      hi ColorColumn ctermfg=NONE ctermbg=223 cterm=NONE
      hi SignColumn ctermfg=NONE ctermbg=223 cterm=NONE
      hi StatusLineNC ctermfg=243 ctermbg=223 cterm=NONE
      hi StatusLineTermNC ctermfg=243 ctermbg=223 cterm=NONE
    endif
  else
    hi PmenuSel ctermfg=229 ctermbg=243 cterm=NONE
    " hi TabLineSel ctermfg=229 ctermbg=243 cterm=bold
      hi TabLineSel ctermfg=237 ctermbg=246 cterm=bold
    hi WildMenu ctermfg=229 ctermbg=243 cterm=NONE
    if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
      hi Pmenu ctermfg=237 ctermbg=223 cterm=NONE
      hi StatusLine ctermfg=237 ctermbg=250 cterm=NONE
      hi StatusLineTerm ctermfg=237 ctermbg=250 cterm=NONE
      hi TabLine ctermfg=237 ctermbg=250 cterm=NONE
      hi TabLineFill ctermfg=237 ctermbg=229 cterm=NONE
      hi ColorColumn ctermfg=NONE ctermbg=229 cterm=NONE
      hi SignColumn ctermfg=NONE ctermbg=229 cterm=NONE
      hi StatusLineNC ctermfg=243 ctermbg=229 cterm=NONE
      hi StatusLineTermNC ctermfg=243 ctermbg=229 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
      hi Pmenu ctermfg=237 ctermbg=250 cterm=NONE
      hi StatusLine ctermfg=237 ctermbg=248 cterm=NONE
      hi StatusLineTerm ctermfg=237 ctermbg=248 cterm=NONE
      hi TabLine ctermfg=237 ctermbg=248 cterm=NONE
      hi TabLineFill ctermfg=237 ctermbg=228 cterm=NONE
      hi ColorColumn ctermfg=NONE ctermbg=228 cterm=NONE
      hi SignColumn ctermfg=NONE ctermbg=228 cterm=NONE
      hi StatusLineNC ctermfg=243 ctermbg=228 cterm=NONE
      hi StatusLineTermNC ctermfg=243 ctermbg=228 cterm=NONE
    elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
      hi Pmenu ctermfg=237 ctermbg=250 cterm=NONE
      hi StatusLine ctermfg=237 ctermbg=248 cterm=NONE
      hi StatusLineTerm ctermfg=237 ctermbg=248 cterm=NONE
      hi TabLine ctermfg=237 ctermbg=248 cterm=NONE
      hi TabLineFill ctermfg=237 ctermbg=223 cterm=NONE
      hi ColorColumn ctermfg=NONE ctermbg=223 cterm=NONE
      hi SignColumn ctermfg=NONE ctermbg=223 cterm=NONE
      hi StatusLineNC ctermfg=243 ctermbg=223 cterm=NONE
      hi StatusLineTermNC ctermfg=243 ctermbg=223 cterm=NONE
    endif
  endif
  hi Conceal ctermfg=24 ctermbg=NONE cterm=NONE
  hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
  hi lCursor ctermfg=NONE ctermbg=NONE cterm=reverse
  hi LineNr ctermfg=246 ctermbg=NONE cterm=NONE
  hi Directory ctermfg=100 ctermbg=NONE cterm=NONE
  hi ErrorMsg ctermfg=88 ctermbg=NONE cterm=bold,underline
  hi WarningMsg ctermfg=136 ctermbg=NONE cterm=bold
  hi ModeMsg ctermfg=237 ctermbg=NONE cterm=bold
  hi MoreMsg ctermfg=136 ctermbg=NONE cterm=bold
  hi IncSearch ctermfg=NONE ctermbg=NONE cterm=bold,reverse
  hi Search ctermfg=NONE ctermbg=NONE cterm=reverse,underline
  hi NonText ctermfg=245 ctermbg=NONE cterm=NONE
  hi PmenuSbar ctermfg=NONE ctermbg=250 cterm=NONE
  hi PmenuThumb ctermfg=NONE ctermbg=246 cterm=NONE
  hi Question ctermfg=130 ctermbg=NONE cterm=bold
  hi SpellBad ctermfg=88 ctermbg=NONE cterm=italic,underline
  hi SpellCap ctermfg=24 ctermbg=NONE cterm=italic,underline
  hi SpellLocal ctermfg=165 ctermbg=NONE cterm=italic,underline
  hi SpellRare ctermfg=96 ctermbg=NONE cterm=italic,underline
  hi Visual ctermfg=NONE ctermbg=NONE cterm=reverse
  hi VisualNOS ctermfg=NONE ctermbg=NONE cterm=reverse
  hi Todo ctermfg=245 ctermbg=NONE cterm=bold,italic,underline
  hi CursorIM ctermfg=NONE ctermbg=NONE cterm=reverse
  hi ToolbarLine ctermfg=NONE ctermbg=248 cterm=NONE
  hi ToolbarButton ctermfg=237 ctermbg=248 cterm=bold
  hi Debug ctermfg=130 ctermbg=NONE cterm=NONE
  hi Title ctermfg=100 ctermbg=NONE cterm=bold
  hi Conditional ctermfg=88 ctermbg=NONE cterm=NONE
  hi Repeat ctermfg=88 ctermbg=NONE cterm=NONE
  hi Label ctermfg=88 ctermbg=NONE cterm=NONE
  hi Exception ctermfg=88 ctermbg=NONE cterm=NONE
  hi Keyword ctermfg=88 ctermbg=NONE cterm=NONE
  hi Statement ctermfg=88 ctermbg=NONE cterm=NONE
  hi Typedef ctermfg=136 ctermbg=NONE cterm=NONE
  hi Type ctermfg=136 ctermbg=NONE cterm=NONE
  hi StorageClass ctermfg=130 ctermbg=NONE cterm=NONE
  hi Delimiter ctermfg=237 ctermbg=NONE cterm=NONE
  hi Special ctermfg=130 ctermbg=NONE cterm=NONE
  hi Tag ctermfg=130 ctermbg=NONE cterm=NONE
  hi Operator ctermfg=130 ctermbg=NONE cterm=NONE
  hi SpecialChar ctermfg=130 ctermbg=NONE cterm=NONE
  hi String ctermfg=100 ctermbg=NONE cterm=NONE
  hi PreProc ctermfg=165 ctermbg=NONE cterm=NONE
  hi Macro ctermfg=165 ctermbg=NONE cterm=NONE
  hi Define ctermfg=165 ctermbg=NONE cterm=NONE
  hi Include ctermfg=165 ctermbg=NONE cterm=NONE
  hi PreCondit ctermfg=165 ctermbg=NONE cterm=NONE
  hi Structure ctermfg=165 ctermbg=NONE cterm=NONE
  hi Identifier ctermfg=24 ctermbg=NONE cterm=NONE
  hi Underlined ctermfg=24 ctermbg=NONE cterm=underline
  hi Constant ctermfg=96 ctermbg=NONE cterm=NONE
  hi Boolean ctermfg=96 ctermbg=NONE cterm=NONE
  hi Character ctermfg=96 ctermbg=NONE cterm=NONE
  hi Number ctermfg=96 ctermbg=NONE cterm=NONE
  hi Float ctermfg=96 ctermbg=NONE cterm=NONE
  hi SpecialKey ctermfg=24 ctermbg=NONE cterm=NONE
  hi Ignore ctermfg=237 ctermbg=NONE cterm=NONE
  if !s:italics
    hi SpellBad cterm=underline
    hi SpellCap cterm=underline
    hi SpellLocal cterm=underline
    hi SpellRare cterm=underline
    hi Todo cterm=bold
  endif
  if get(g:, 'gruvbox_material_disable_italic_comment', 0)
    hi Comment ctermfg=245 ctermbg=NONE cterm=NONE
    hi SpecialComment ctermfg=245 ctermbg=NONE cterm=NONE
  else
    hi Comment ctermfg=245 ctermbg=NONE cterm=italic
    hi SpecialComment ctermfg=245 ctermbg=NONE cterm=italic
    if !s:italics
      hi Comment cterm=NONE
      hi SpecialComment cterm=NONE
    endif
  endif
  if get(g:, 'gruvbox_material_enable_bold', 0)
    hi Function ctermfg=100 ctermbg=NONE cterm=bold
  else
    hi Function ctermfg=100 ctermbg=NONE cterm=NONE
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi DiffAdd ctermfg=NONE ctermbg=193 cterm=NONE
    hi DiffChange ctermfg=NONE ctermbg=195 cterm=NONE
    hi DiffDelete ctermfg=NONE ctermbg=224 cterm=NONE
    hi Error ctermfg=NONE ctermbg=224 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi DiffAdd ctermfg=NONE ctermbg=193 cterm=NONE
    hi DiffChange ctermfg=NONE ctermbg=152 cterm=NONE
    hi DiffDelete ctermfg=NONE ctermbg=223 cterm=NONE
    hi Error ctermfg=NONE ctermbg=223 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi DiffAdd ctermfg=NONE ctermbg=193 cterm=NONE
    hi DiffChange ctermfg=NONE ctermbg=195 cterm=NONE
    hi DiffDelete ctermfg=NONE ctermbg=223 cterm=NONE
    hi Error ctermfg=NONE ctermbg=223 cterm=NONE
  endif
  hi markdownH1 ctermfg=100 ctermbg=NONE cterm=bold
  hi markdownH2 ctermfg=100 ctermbg=NONE cterm=bold
  hi markdownH3 ctermfg=136 ctermbg=NONE cterm=bold
  hi markdownH4 ctermfg=136 ctermbg=NONE cterm=bold
  hi markdownUrl ctermfg=96 ctermbg=NONE cterm=underline
  hi markdownItalic ctermfg=NONE ctermbg=NONE cterm=italic
  hi markdownBold ctermfg=NONE ctermbg=NONE cterm=bold
  hi markdownItalicDelimiter ctermfg=245 ctermbg=NONE cterm=italic
  hi mkdURL ctermfg=96 ctermbg=NONE cterm=underline
  hi mkdInlineURL ctermfg=96 ctermbg=NONE cterm=underline
  hi mkdItalic ctermfg=245 ctermbg=NONE cterm=italic
  hi htmlLink ctermfg=243 ctermbg=NONE cterm=underline
  hi htmlBold ctermfg=NONE ctermbg=NONE cterm=bold
  hi htmlBoldUnderline ctermfg=NONE ctermbg=NONE cterm=bold,underline
  hi htmlBoldItalic ctermfg=NONE ctermbg=NONE cterm=bold,italic
  hi htmlBoldUnderlineItalic ctermfg=NONE ctermbg=NONE cterm=bold,italic,underline
  hi htmlUnderline ctermfg=NONE ctermbg=NONE cterm=underline
  hi htmlUnderlineItalic ctermfg=NONE ctermbg=NONE cterm=italic,underline
  hi htmlItalic ctermfg=NONE ctermbg=NONE cterm=italic
  hi vimCommentTitle ctermfg=243 ctermbg=NONE cterm=bold,italic
  hi helpURL ctermfg=165 ctermbg=NONE cterm=underline
  hi helpNote ctermfg=96 ctermbg=NONE cterm=bold
  hi plug1 ctermfg=130 ctermbg=NONE cterm=bold
  hi plugNumber ctermfg=136 ctermbg=NONE cterm=bold
  if !s:italics
    hi markdownItalic cterm=NONE
    hi markdownItalicDelimiter cterm=NONE
    hi mkdItalic cterm=NONE
    hi htmlBoldItalic cterm=bold
    hi htmlBoldUnderlineItalic cterm=bold,underline
    hi htmlUnderlineItalic cterm=underline
    hi htmlItalic cterm=NONE
    hi vimCommentTitle cterm=bold
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    if get(g:, 'indent_guides_auto_colors', 0)
      if get(g:, 'gruvbox_material_invert_indent_guides', 0)
        hi IndentGuidesOdd ctermfg=230 ctermbg=250 cterm=reverse
        hi IndentGuidesEven ctermfg=230 ctermbg=223 cterm=reverse
      else
        hi IndentGuidesOdd ctermfg=230 ctermbg=250 cterm=NONE
        hi IndentGuidesEven ctermfg=230 ctermbg=223 cterm=NONE
      endif
    endif
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    if get(g:, 'indent_guides_auto_colors', 0)
      if get(g:, 'gruvbox_material_invert_indent_guides', 0)
        hi IndentGuidesOdd ctermfg=228 ctermbg=250 cterm=reverse
        hi IndentGuidesEven ctermfg=228 ctermbg=223 cterm=reverse
      else
        hi IndentGuidesOdd ctermfg=228 ctermbg=250 cterm=NONE
        hi IndentGuidesEven ctermfg=228 ctermbg=223 cterm=NONE
      endif
    endif
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    if get(g:, 'indent_guides_auto_colors', 0)
      if get(g:, 'gruvbox_material_invert_indent_guides', 0)
        hi IndentGuidesOdd ctermfg=229 ctermbg=250 cterm=reverse
        hi IndentGuidesEven ctermfg=229 ctermbg=223 cterm=reverse
      else
        hi IndentGuidesOdd ctermfg=229 ctermbg=250 cterm=NONE
        hi IndentGuidesEven ctermfg=229 ctermbg=223 cterm=NONE
      endif
    endif
  endif
  if !exists('g:indentLine_color_term')
    let g:indentLine_color_term = 250
  endif
  if !exists('g:indentLine_color_gui')
    let g:indentLine_color_gui = '#d5c4a1'
  endif
  " Rainbow Parentheses
  if !exists('g:rbpt_colorpairs')
    let g:rbpt_colorpairs = [['blue', '#47747e'], ['magenta', '#945e80'],
          \ ['red', '#c74545'], ['130', '#c55b03']]
  endif

  let g:rainbow_guifgs = [ '#c55b03', '#c74545', '#945e80', '#47747e' ]
  let g:rainbow_ctermfgs = [ '130', 'red', 'magenta', 'blue' ]

  if !exists('g:rainbow_conf')
    let g:rainbow_conf = {}
  endif
  if !has_key(g:rainbow_conf, 'guifgs')
    let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
  endif
  if !has_key(g:rainbow_conf, 'ctermfgs')
    let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
  endif

  let g:niji_dark_colours = g:rbpt_colorpairs
  let g:niji_light_colours = g:rbpt_colorpairs
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi GitGutterAdd ctermfg=100 ctermbg=229 cterm=NONE
    hi GitGutterChange ctermfg=24 ctermbg=229 cterm=NONE
    hi GitGutterDelete ctermfg=88 ctermbg=229 cterm=NONE
    hi GitGutterChangeDelete ctermfg=96 ctermbg=229 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi GitGutterAdd ctermfg=100 ctermbg=228 cterm=NONE
    hi GitGutterChange ctermfg=24 ctermbg=228 cterm=NONE
    hi GitGutterDelete ctermfg=88 ctermbg=228 cterm=NONE
    hi GitGutterChangeDelete ctermfg=96 ctermbg=228 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi GitGutterAdd ctermfg=100 ctermbg=223 cterm=NONE
    hi GitGutterChange ctermfg=24 ctermbg=223 cterm=NONE
    hi GitGutterDelete ctermfg=88 ctermbg=223 cterm=NONE
    hi GitGutterChangeDelete ctermfg=96 ctermbg=223 cterm=NONE
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi SignatureMarkText ctermfg=24 ctermbg=229 cterm=NONE
    hi SignatureMarkerText ctermfg=96 ctermbg=229 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi SignatureMarkText ctermfg=24 ctermbg=228 cterm=NONE
    hi SignatureMarkerText ctermfg=96 ctermbg=228 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi SignatureMarkText ctermfg=24 ctermbg=223 cterm=NONE
    hi SignatureMarkerText ctermfg=96 ctermbg=223 cterm=NONE
  endif
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi ShowMarksHLl ctermfg=24 ctermbg=229 cterm=NONE
    hi ShowMarksHLu ctermfg=24 ctermbg=229 cterm=NONE
    hi ShowMarksHLo ctermfg=24 ctermbg=229 cterm=NONE
    hi ShowMarksHLm ctermfg=24 ctermbg=229 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi ShowMarksHLl ctermfg=24 ctermbg=228 cterm=NONE
    hi ShowMarksHLu ctermfg=24 ctermbg=228 cterm=NONE
    hi ShowMarksHLo ctermfg=24 ctermbg=228 cterm=NONE
    hi ShowMarksHLm ctermfg=24 ctermbg=228 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi ShowMarksHLl ctermfg=24 ctermbg=223 cterm=NONE
    hi ShowMarksHLu ctermfg=24 ctermbg=223 cterm=NONE
    hi ShowMarksHLo ctermfg=24 ctermbg=223 cterm=NONE
    hi ShowMarksHLm ctermfg=24 ctermbg=223 cterm=NONE
  endif
  hi CtrlPMatch ctermfg=100 ctermbg=NONE cterm=bold
  hi CtrlPPrtBase ctermfg=250 ctermbg=NONE cterm=NONE
  hi CtrlPLinePre ctermfg=250 ctermbg=NONE cterm=NONE
  hi CtrlPMode1 ctermfg=24 ctermbg=250 cterm=bold
  hi CtrlPMode2 ctermfg=229 ctermbg=24 cterm=bold
  hi CtrlPStats ctermfg=243 ctermbg=250 cterm=bold
  hi Lf_hl_match ctermfg=100 ctermbg=NONE cterm=bold
  hi Lf_hl_match0 ctermfg=100 ctermbg=NONE cterm=bold
  hi Lf_hl_match1 ctermfg=165 ctermbg=NONE cterm=bold
  hi Lf_hl_match2 ctermfg=24 ctermbg=NONE cterm=bold
  hi Lf_hl_match3 ctermfg=96 ctermbg=NONE cterm=bold
  hi Lf_hl_match4 ctermfg=130 ctermbg=NONE cterm=bold
  hi Lf_hl_matchRefine ctermfg=88 ctermbg=NONE cterm=bold
  let g:vimshell_escape_colors = [
        \ '#a89984', '#c74545', '#6c782e', '#b47109',
        \ '#47747e', '#945e80', '#4c7a5d', '#7c6f64',
        \ '#fbf1c7', '#c74545', '#6c782e', '#c55b03',
        \ '#47747e', '#945e80', '#4c7a5d', '#764e37'
        \ ]
  hi ALEError ctermfg=NONE ctermbg=NONE cterm=underline
  hi ALEWarning ctermfg=NONE ctermbg=NONE cterm=underline
  hi ALEInfo ctermfg=NONE ctermbg=NONE cterm=underline
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi ALEErrorSign ctermfg=88 ctermbg=229 cterm=NONE
    hi ALEWarningSign ctermfg=136 ctermbg=229 cterm=NONE
    hi ALEInfoSign ctermfg=24 ctermbg=229 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi ALEErrorSign ctermfg=88 ctermbg=228 cterm=NONE
    hi ALEWarningSign ctermfg=136 ctermbg=228 cterm=NONE
    hi ALEInfoSign ctermfg=24 ctermbg=228 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi ALEErrorSign ctermfg=88 ctermbg=223 cterm=NONE
    hi ALEWarningSign ctermfg=136 ctermbg=223 cterm=NONE
    hi ALEInfoSign ctermfg=24 ctermbg=223 cterm=NONE
  endif
  hi multiple_cursors_cursor ctermfg=NONE ctermbg=NONE cterm=reverse
  hi multiple_cursors_visual ctermfg=NONE ctermbg=250 cterm=NONE
  hi CocHighlightText ctermfg=NONE ctermbg=NONE cterm=bold
  hi CocHoverRange ctermfg=NONE ctermbg=NONE cterm=bold,underline
  if get(g:, 'gruvbox_material_background', 'medium') ==# 'hard'
    hi CocHintSign ctermfg=165 ctermbg=229 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'medium'
    hi CocHintSign ctermfg=165 ctermbg=228 cterm=NONE
  elseif get(g:, 'gruvbox_material_background', 'medium') ==# 'soft'
    hi CocHintSign ctermfg=165 ctermbg=223 cterm=NONE
  endif
  hi MatchParenCur ctermfg=NONE ctermbg=NONE cterm=bold
  hi MatchWord ctermfg=NONE ctermbg=NONE cterm=underline
  hi MatchWordCur ctermfg=NONE ctermbg=NONE cterm=underline
  hi UndotreeSavedBig ctermfg=96 ctermbg=NONE cterm=bold
  unlet s:t_Co s:italics
  finish
endif

" }}}
" Vim: set fdls=0 fdm=marker:
" }}}
