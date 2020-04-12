" Name:         Gruvbox Material
" Maintainer:   Faris Chugthai
" NOTE: On line 1378 is a font bound to `Normal`. Change that before copy
" pasting!
" Last Author:  Sainnhepark <sainnhe@gmail.com>
" Last Updated: Dec 10, 2019

scriptencoding utf8  " {{{
if exists('g:loaded_gruvbox_material_vim') || &compatible || v:version < 700
    finish
endif
let g:loaded_gruvbox_material_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C
hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'gruvbox-material'

" }}}

" My Additions: {{{

" DUDE DON'T SET THIS TO 1!
let g:gruvbox_material_transparent_background = 0
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
hi! link manEmail Directory
hi! link manHeaderFile Statement
" hi link manHighlight
" hi link NormalNC Ignore
hi! link VisualNC Visual
" }}}

if has('nvim')  " {{{
  " How does a nice light blue sound?
  hi! NvimInternalError guibg=NONE ctermfg=108 ctermbg=234 gui=reverse guifg=#8ec0e1 guisp=NONE
  hi! link nvimAutoEvent   vimAutoEvent
  hi! link nvimHLGroup     vimHLGroup
  hi! link NvimIdentifierKey Identifier
  hi! link nvimInvalid Exception
  hi! link nvimMap vimMap
  hi! link nvimUnmap       vimUnmap

  hi! link TermCursor Cursor
  hi TermCursorNC ctermfg=237 ctermbg=223 guifg=#3c3836 guibg=#ebdbb2 guisp=NONE cterm=NONE gui=NONE

  " *hl-NormalFloat* NormalFloat  Normal text in floating windows.
  hi NormalFloat ctermfg=223 ctermbg=234 guifg=#ebdbb2 guibg=#1d2021 guisp=NONE gui=undercurl cterm=undercurl

  " *hl-IncSearch*
  " IncSearch     'incsearch' highlighting; also used for the text replaced with ':s///c'
  hi IncSearch cterm=reverse ctermfg=208 ctermbg=234 gui=reverse guifg=#fe8019 guibg=#1d2021 guisp=NONE

  " From he nvim-terminal-emulator
  hi debugPC term=reverse ctermbg=darkblue guibg=darkblue
  hi debugBreakpoint term=reverse ctermbg=red guibg=red
endif

" }}}

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

hi! link ALEErrorSign Error
hi! link ALEWarningSign QuickFixLine
hi! link ALEInfoSign Directory
hi! link ALEError Error
hi! link ALEWarning QuickFixLine
hi! link ALEInfo Macro
" }}}

" GitGutter: {{{
hi! link GitGutterAdd Green
hi! link GitGutterChange Macro
hi! link GitGutterDelete Red
hi! link GitGutterChangeDelete Macro
" }}}

" GitCommit: "{{{
" Do I have this plugin? Is this a fugitive thing?
hi! link gitcommitSelectedFile Green
hi! link gitcommitDiscardedFile Red
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

" Vim Plug: {{{
hi! link plugNotLoaded Folded
" }}}
" }}}

" Filetype specific --------------------------------------------------- {{{

" Snippets: {{{
" Huh its weird to me that no snippets were done!
hi! link snipSnippets Normal
" Holy shit this was make my eyes so much happier
hi! link snipLeadingSpaces Normal
hi! link snipSnippet Keyword
" }}}

" Jinja: {{{

hi! link jinjaOperator Operator
" }}}

" Django: {{{
hi! link djangoTagBlock PreProc
hi! link djangoVarBlock PreProc
hi! link djangoStatement Statement
hi! link djangoFilter Identifier
hi! link djangoArgument Constant
hi! link djangoTagError Error
hi! link djangoVarError Error
hi! link djangoError Error
hi! link djangoComment Comment
hi! link djangoComBlock Comment
hi! link djangoTodo Todo
" }}}

" CSS: {{{
hi! link cssAnimationProp cssProp
hi! link cssAtKeyword PreProc
hi! link cssAtRule Include
hi! link cssAtRuleLogical Statement
hi! link cssAttr Constant
hi! link cssAttrComma Special
hi! link cssAttributeSelector String
hi! link cssAuralAttr cssAttr
hi! link cssAuralProp cssProp
hi! link cssBackgroundAttr cssAttr
hi! link cssBackgroundProp Aqua
hi! link cssBorderAttr cssAttr
hi! link cssBorderOutlineProp Directory
hi! link cssBorderProp cssProp
hi! link cssBoxAttr cssAttr
hi! link cssBoxProp Aqua
hi! link cssBoxProp cssProp
hi! link cssBraceError Error
hi! link cssBraces Function
hi! link cssCascadeAttr cssAttr
hi! link cssCascadeProp cssProp
hi! link cssClassName Function
hi! link cssClassName Green
hi! link cssClassNameDot Function
hi! link cssColor Blue
hi! link cssColor Constant
hi! link cssColorProp Aqua
hi! link cssColorProp cssProp
hi! link cssComment Comment
hi! link cssCommonAttr cssAttr
hi! link cssContentForPagedMediaAttr cssAttr
hi! link cssContentForPagedMediaProp cssProp
hi! link cssCustomProp Special
hi! link cssDeprecated Error
hi! link cssDimensionAttr cssAttr
hi! link cssDimensionProp Aqua
hi! link cssDimensionProp cssProp
hi! link cssError Error
hi! link cssFlexibleBoxAttr cssAttr
hi! link cssFlexibleBoxProp Aqua
hi! link cssFlexibleBoxProp cssProp
hi! link cssFontAttr cssAttr
hi! link cssFontDescriptor Special
hi! link cssFontDescriptorAttr cssAttr
hi! link cssFontDescriptorProp cssProp
hi! link cssFontProp cssProp
hi! link cssFunction Constant
hi! link cssFunctionComma Function
hi! link cssFunctionName Function
hi! link cssGeneratedContentAttr cssAttr
hi! link cssGeneratedContentProp cssProp
hi! link cssGradientAttr cssAttr
hi! link cssGridAttr cssAttr
hi! link cssGridProp cssProp
hi! link cssHacks Comment
hi! link cssHyerlinkAttr cssAttr
hi! link cssHyerlinkProp cssProp
hi! link cssIEUIAttr cssAttr
hi! link cssIEUIProp cssProp
hi! link cssIdentifier Function
hi! link cssImportant Special
hi! link cssInteractAttr cssAttr
hi! link cssInteractProp cssProp
hi! link cssKeyFrameProp Constant
hi! link cssLineboxAttr cssAttr
hi! link cssLineboxProp cssProp
hi! link cssListAttr cssAttr
hi! link cssListProp Aqua
hi! link cssListProp cssProp
hi! link cssMarginAttr cssAttr
hi! link cssMarginProp Aqua
hi! link cssMarqueeAttr cssAttr
hi! link cssMarqueeProp cssProp
hi! link cssMediaAttr cssAttr
hi! link cssMediaComma Normal
hi! link cssMediaProp cssProp
hi! link cssMediaType Special
hi! link cssMobileTextProp cssProp
hi! link cssMultiColumnAttr cssAttr
hi! link cssMultiColumnProp cssProp
hi! link cssNoise Noise
hi! link cssPaddingAttr cssAttr
hi! link cssPaddingProp Aqua
hi! link cssPaddingProp Directory
hi! link cssPageMarginProp cssAtKeyword
hi! link cssPageProp cssProp
hi! link cssPagePseudo PreProc
hi! link cssPagedMediaAttr cssAttr
hi! link cssPagedMediaProp cssProp
hi! link cssPositioningAttr cssAttr
hi! link cssPositioningProp Yellow
hi! link cssPositioningProp cssProp
hi! link cssPrintAttr cssAttr
hi! link cssPrintProp Aqua
hi! link cssPrintProp cssProp
hi! link cssProp StorageClass
hi! link cssPseudoClassId PreProc
hi! link cssPseudoClassLang Constant
hi! link cssRenderAttr cssAttr
hi! link cssRenderProp Aqua
hi! link cssRenderProp cssProp
hi! link cssRubyAttr cssAttr
hi! link cssRubyProp cssProp
hi! link cssSelectorOp Blue
hi! link cssSelectorOp Special
hi! link cssSelectorOp2 Blue
hi! link cssSelectorOp2 Special
hi! link cssSpeechAttr cssAttr
hi! link cssSpeechProp cssProp
hi! link cssTableAttr cssAttr
hi! link cssTableProp Aqua
hi! link cssTableProp cssProp
hi! link cssTagName Statement
hi! link cssTextAttr cssAttr
hi! link cssTextProp Aqua
hi! link cssTextProp cssProp
hi! link cssTransformAttr cssAttr
hi! link cssTransformProp Aqua
hi! link cssTransformProp cssProp
hi! link cssTransitionAttr cssAttr
hi! link cssTransitionProp Aqua
hi! link cssTransitionProp cssProp
hi! link cssUIAttr cssAttr
hi! link cssUIProp Yellow
hi! link cssUIProp cssProp
hi! link cssURL String
hi! link cssUnicodeEscape Special
hi! link cssUnicodeRange Constant
hi! link cssUnitDecorators Number
hi! link cssValueAngle Number
hi! link cssValueFrequency Number
hi! link cssValueInteger Number
hi! link cssValueLength Number
hi! link cssValueNumber Number
hi! link cssValueTime Number
hi! link cssVendor Comment
hi! link cssVendor White
" }}}

" Man.vim: {{{

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

highlight! link manTitle          Title
highlight! link manSectionHeading Statement
highlight! link manOptionDesc     Constant
highlight! link manReference      PreProc
highlight! link manSubHeading     Function

highlight! link manUnderline Underlined
highlight! link manBold YellowBold
highlight! link manItalic htmlItalic

" And the rest
hi! link manCError Error
hi! link manEmail Directory
hi! link manEnvVar Identifier
hi! link manEnvVarFile Identifier
hi! link manEnvVarFile Identifier
hi! link manFile Yellow
hi! link manFiles Yellow
hi! link manFooter Purple
hi! link manHighlight Yellow
hi! link manHistory Yellow
hi! link manHeaderFile Yellow
hi! link manSectionHeading OrangeBold
hi! link manSentence Fg2
hi! link manSignal Purple
hi! link manURL Green
" }}}

" Netrw: {{{
" Hate to be that guy but Netrw is considered an ftplugin

hi! link netrwCmdNote Directory
hi! link netrwComment Comment
if has('nvim')
  hi! link netrwCopyTgt IncSearch
else
  " Is this canoniccal vim?
  hi! link netrwCopyTgt StorageClass
endif

hi! link netrwDateSep Delimiter
hi! link netrwDir Directory
hi! link netrwExe Macro
hi! link netrwGray Folded
hi! link netrwHelpCmd Delimiter
hi! link netrwHide Conceal
hi! link netrwHidePat Folded
hi! link netrwLib Directory
hi! link netrwLink Underlined
hi! link netrwList PreCondit
hi! link netrwPlain String
hi! link netrwQHTopic Number
hi! link netrwQuickHelp netrwHelpCmd
hi! link netrwSizeDate Delimiter
hi! link netrwSlash Delimiter
hi! link netrwSortBy Title
hi! link netrwSortSeq netrwList
hi! link netrwSpecial netrwClassify
hi! link netrwSymLink Special
hi! link netrwTime Delimiter
hi! link netrwTimeSep Delimiter
hi! link netrwTreeBar Special
hi! link netrwTreeBarSpace Special
hi! link netrwVersion Float

 hi! link netrwCmdSep   Delimiter
 hi! link netrwDir      Directory
 hi! link netrwHelpCmd  Function
 hi! link netrwQHTopic  Number
 hi! link netrwHidePat  Statement
 hi! link netrwHideSep  netrwComment
 hi! link netrwList     Statement
 hi! link netrwVersion  Identifier
 hi! link netrwSymLink  Question
 hi! link netrwExe      PreProc
 hi! link netrwDateSep  Delimiter

 hi! link netrwTreeBar  Special
 hi! link netrwTimeSep  netrwDateSep
 hi! link netrwComma    netrwComment
 hi! link netrwHide     netrwComment
 hi! link netrwMarkFile TabLineSel
 hi! link netrwLink     Special

 " !syntax highlighting (see :he g:netrw_special_syntax)
 hi! link netrwCoreDump WarningMsg
 hi! link netrwData     DiffChange
 hi! link netrwHdr      netrwPlain
 hi! link netrwLex      netrwPlain
 hi! link netrwLib      DiffChange
 hi! link netrwMakefile DiffChange
 hi! link netrwYacc     netrwPlain
 hi! link netrwPix      Special

 hi! link netrwBak      netrwGray
 hi! link netrwCompress netrwGray
 hi! link netrwSpecFile netrwGray
 hi! link netrwObj      netrwGray
 hi! link netrwTags     netrwGray
 hi! link netrwTilde    netrwGray
 hi! link netrwTmp      netrwGray
" }}}

" Rst: {{{
hi! link rstCitation                     String
hi! link rstCitationReference            Identifier
hi! link rstCodeBlock                    String
hi! link rstComment                      Comment
hi! link rstDelimiter                    Delimiter
hi! link rstDirective                    Keyword
hi! link rstDoctestBlock                 PreProc

" Python code blocks with func(*args) break highlighting fkr the whole file.
hi! link rstEmphasis Normal
" hi link rstExDirective                  String
" Blends in with the rest of the string
hi! link rstExDirective                  Identifier
hi! link rstExplicitMarkup               rstDirective
hi! link rstFileLink                     rstHyperlinkReference
hi! link rstFootnote                     String
hi! link rstFootnoteReference            Identifier
hi! link rstHyperLinkReference           Identifier
hi! link rstHyperlinkTarget              String
hi! link rstInlineInternalTargets        Identifier
hi! link rstInlineLiteral                String
hi! link rstInterpretedTextOrHyperlinkReference  Identifier
hi! link rstLiteralBlock                 String
hi! link rstQuotedLiteralBlock           String
hi! link rstSections                     Title
hi! link rstSimpleTable                 Orange
hi! link rstSimpleTableLines            OrangeBold
hi! link rstStandaloneHyperlink          Identifier
hi! link rstSubstitutionDefinition       rstDirective
hi! link rstSubstitutionReference        PreProc
hi! link rstTable                       Orange
hi! link rstTableLines                   Orange
hi! link rstTodo                         Todo
hi! link rstTransition                   rstSections
hi! link rstDirectivesh     Question
hi! link rstDirectivepython Question
hi! link rstInlineLiteral   Identifier
" }}}

" Tmux: {{{
hi! link tmuxFormatString      Identifier
hi! link tmuxAction            Boolean
hi! link tmuxBoolean           Boolean
hi! link tmuxCommands          Keyword
hi! link tmuxComment           Comment
hi! link tmuxKey               Special
hi! link tmuxNumber            Number
hi! link tmuxFlags             Identifier
hi! link tmuxOptions           Function
hi! link tmuxString            String
hi! link tmuxTodo              Todo
hi! link tmuxVariable          Identifier
hi! link tmuxVariableExpansion Identifier
hi! link tmuxColor SpecialKey
" }}}

" Diff: {{{
hi! link diffAdded Green
hi! link diffRemoved Red
hi! link diffChanged Directory
hi! link diffFile Orange
hi! link diffLine Blue
hi! link diffOldFile Purple
hi! link diffNewFile Blue
hi! link diffFile Orange
hi! link diffIndexLine Aqua
" }}}

" Html: {{{
hi! link htmlScriptTag Tag

" Default syntax
hi! link htmlTag                     Function
hi! link htmlEndTag                  Identifier
hi! link htmlArg                     Type
hi! link htmlTagName                 htmlStatement
hi! link htmlSpecialTagName          Exception
hi! link htmlValue                     String
hi! link htmlSpecialChar             Special

hi htmlBold                cterm=bold gui=bold
hi htmlBoldUnderline       cterm=bold,underline gui=bold,underline
hi htmlBoldItalic          cterm=bold,italic gui=bold,italic
hi htmlBoldUnderlineItalic  cterm=bold,italic,underline gui=bold,italic,underline
hi htmlUnderline           cterm=underline gui=underline
hi htmlUnderlineItalic     cterm=italic,underline gui=italic,underline
hi htmlItalic              cterm=italic gui=italic
hi! link htmlH1                      Title
hi! link htmlH2                      htmlH1
hi! link htmlH3                      htmlH2
hi! link htmlH4                      htmlH3
hi! link htmlH5                      htmlH4
hi! link htmlH6                      htmlH5
hi! link htmlHead                    PreProc
hi! link htmlTitle                   Title
hi! link htmlBoldItalicUnderline     htmlBoldUnderlineItalic
hi! link htmlUnderlineBold           htmlBoldUnderline
hi! link htmlUnderlineItalicBold     htmlBoldUnderlineItalic
hi! link htmlUnderlineBoldItalic     htmlBoldUnderlineItalic
hi! link htmlItalicUnderline         htmlUnderlineItalic
hi! link htmlItalicBold              htmlBoldItalic
hi! link htmlItalicBoldUnderline     htmlBoldUnderlineItalic
hi! link htmlItalicUnderlineBold     htmlBoldUnderlineItalic
hi! link htmlLink                    Underlined
hi! link htmlLeadingSpace            None

if v:version > 800 || v:version == 800 && has("patch1038")
  hi def htmlStrike              term=strikethrough cterm=strikethrough gui=strikethrough
else
  hi def htmlStrike              term=underline cterm=underline gui=underline
endif

hi! link htmlPreStmt            PreProc
hi! link htmlPreError           Error
hi! link htmlPreProc            PreProc
hi! link htmlPreAttr            String
hi! link htmlPreProcAttrName    PreProc
hi! link htmlPreProcAttrError   Error
hi! link htmlSpecial            Special
hi! link htmlSpecialChar        Special
hi! link htmlString             String
hi! link htmlStatement          Statement
hi! link htmlComment            Comment
hi! link htmlCommentPart        Comment
hi! link htmlValue              String
hi! link htmlCommentError       htmlError
hi! link htmlTagError           htmlError
hi! link htmlEvent              javaScript
hi! link htmlError              Error

hi! link javaScript             Special
hi! link javaScriptExpression   javaScript
hi! link htmlCssStyleComment    Comment
hi! link htmlCssDefinition      Special
" }}}

" Xml: {{{

hi! link xmlTag Blue
hi! link xmlEndTag Blue
hi! link xmlTagName Blue
hi! link xmlEqual Blue
hi! link docbkKeyword Keyword

hi! link xmlDocTypeDecl Gray
hi! link xmlDocTypeKeyword Keyword
hi! link xmlCdataStart Gray
hi! link xmlCdataCdata Purple
hi! link dtdFunction Gray
hi! link dtdTagName Purple

hi! link xmlAttrib Directory
hi! link xmlProcessingDelim Gray
hi! link dtdParamEntityPunct Gray
hi! link dtdParamEntityDPunct Gray
hi! link xmlAttribPunct Gray

hi! link xmlEntity Orange
hi! link xmlEntityPunct Orange
" }}}

" Python: {{{
hi! link pythonAsync                     Statement
hi! link pythonAttribute TypeDef
hi! link pythonBoolean Boolean
hi! link pythonBoolean Purple
hi! link pythonBuiltin Orange
hi! link pythonBuiltinFunc Orange
hi! link pythonBuiltinObj Orange
hi! link pythonComment           Comment
hi! link pythonCoding Blue
hi! link pythonConditional Red
hi! link pythonDecorator Red
hi! link pythonComment           Comment
hi! link pythonDot Grey
hi! link pythonDottedName GreenBold
hi! link pythonEscape            Special
hi! link pythonException Red
hi! link pythonExceptions Purple
hi! link pythonFunction Aqua
hi! link pythonImport Blue
hi! link pythonInclude Blue
hi! link pythonMatrixMultiply Number
hi! link pythonNumber Number
hi! link pythonOperator Orange
hi! link pythonQuotes            String
hi! link pythonRawString         String
hi! link pythonRepeat Red
hi! link pythonRun Blue
hi! link pythonSpaceError                Error
hi! link pythonStatement         Statement
hi! link pythonString            String
hi! link pythonSync Identifier
hi! link pythonTodo                      Todo
hi! link pythonTripleQuotes              pythonQuotes
" }}}

" Vim: {{{
" General: {{{
hi! link vimAbb vimCommand
hi! link vimAddress     vimMark
hi! link vimAuHighlight vimHighlight
hi! link vimAugroupError        Error
hi! link vimAugroupKey  Keyword
hi! link vimAutoCmd     vimCommand
hi! link vimAutoCmdOpt  vimOption
hi! link vimAutoEvent   Type
hi! link vimAutoSet     vimCommand
hi! link vimBehave      vimCommand
hi! link vimBehaveModel vimBehave
hi! link vimBracket     Delimiter
hi! link vimCmplxRepeat SpecialChar
hi! link vimCommand     Statement
hi! link vimComment     Comment
hi! link vimCommentString       vimString
hi! link vimCommentTitle        PreProc
hi! link vimCondHL      vimCommand
hi! link vimContinue    Special
hi! link vimCtrlChar    SpecialChar
hi! link vimEchoHL      vimCommand
hi! link vimEchoHLNone  vimGroup
hi! link vimElseIfErr   Error
hi! link vimElseif      vimCondHL
hi! link vimEnvvar      PreProc
hi! link vimError       Error
hi! link vimFBVar       vimVar
hi! link vimFTCmd       vimCommand
hi! link vimFTOption    vimSynType
hi! link vimFgBgAttrib  vimHiAttrib
hi! link vimFold        Folded
hi! link vimFunc        Function
hi! link vimFuncKey     vimCommand
hi! link vimFuncName    Function
hi! link vimFuncSID     Special
hi! link vimFuncVar     Identifier
hi! link vimFunction Function
hi! link vimGroup       Type
hi! link vimGroupAdd    vimSynOption
hi! link vimGroupName   vimGroup
hi! link vimGroupRem    vimSynOption
hi! link vimGroupSpecial        Special
hi! link vimHLGroup     vimGroup
hi! link vimHLMod       PreProc
hi! link vimHiAttrib    PreProc
hi! link vimHiBang vimHighlight
hi! link vimHiCTerm     vimHiTerm
hi! link vimHiClear     vimHighlight
hi! link vimHiCtermFgBg vimHiTerm
hi! link vimHiGroup     vimGroupName
hi! link vimHiGui       vimHiTerm
hi! link vimHiGuiFgBg   vimHiTerm
hi! link vimHiGuiFont   vimHiTerm
hi! link vimHiGuiRgb    vimNumber
hi! link vimHiNmbr      Number
hi! link vimHiStartStop vimHiTerm
hi! link vimHiTerm      Type
hi! link vimHighlight   Operator
hi! link vimInsert      vimString

" vimIsCommand is a terrible regex honestly don't match it with anything
" Output of `syn list vimIsCommand
" --- Syntax items ---
" vimIsCommand   xxx match /\<\h\w*\>/  contains=vimCommand
"                    match /<Bar>\s*\a\+/  transparent contains=vimCommand,vimNotation
" \h is any upper case letter. \w is any letter. wtf? that contains SO many false positives

" hi link vimIsCommand       vimOption
hi! link vimIskSep      Delimiter
hi! link vimKeyCode     vimSpecFile
hi! link vimKeyword     Statement
hi! link vimLet vimCommand
hi! link vimLineComment vimComment
hi! link vimMap vimCommand
hi! link vimMapBang     vimCommand
hi! link vimMapMod      vimBracket
hi! link vimMapModKey   vimFuncSID
hi! link vimMark        Number
hi! link vimMarkNumber  vimNumber
hi! link vimMenuMod     vimMapMod
hi! link vimMenuName    PreProc
hi! link vimMenuNameMore        vimMenuName
hi! link vimMtchComment vimComment
hi! link vimNorm        vimCommand
hi! link vimNotFunc     vimCommand
hi! link vimNotPatSep   vimString
hi! link vimNotation    Special
hi! link vimNumber Red
hi! link vimOper        Operator
hi! link vimOperError   Error
hi! link vimOption      PreProc
hi! link vimParenSep    Delimiter
hi! link vimPatSep      SpecialChar
hi! link vimPatSepErr   vimError
hi! link vimPatSepR     vimPatSep
hi! link vimPatSepZ     vimPatSep
hi! link vimPatSepZone  vimString
hi! link vimPattern     Type
hi! link vimPlainMark   vimMark
hi! link vimPlainRegister       vimRegister
hi! link vimRegister    SpecialChar
hi! link vimScriptDelim Comment
hi! link vimSearch      vimString
hi! link vimSearchDelim Statement
hi! link vimSep Delimiter
hi! link vimSetMod      vimOption
hi! link vimSetSep      Statement
hi! link vimSetString   vimString
hi! link vimSpecFile    Identifier
hi! link vimSpecFileMod vimSpecFile
hi! link vimSpecial     Type
hi! link vimStatement   Statement
hi! link vimStdPlugin       Function
hi! link vimString      String
hi! link vimStringCont  vimString
hi! link vimStringEnd   vimString
hi! link vimSubst       vimCommand
hi! link vimSubst1      vimSubst
hi! link vimSubstDelim  Delimiter
hi! link vimSubstFlags  Special
hi! link vimSubstSubstr SpecialChar
hi! link vimSubstTwoBS  vimString
hi! link vimSynCase     Type
hi! link vimSynContains vimSynOption
hi! link vimSynKeyContainedin   vimSynContains
hi! link vimSynKeyOpt   vimSynOption
hi! link vimSynMtchGrp  vimSynOption
hi! link vimSynMtchOpt  vimSynOption
hi! link vimSynNextgroup        vimSynOption
hi! link vimSynNotPatRange      vimSynRegPat
hi! link vimSynOption   Special
hi! link vimSynPatRange vimString
hi! link vimSynReg      Type
hi! link vimSynRegOpt   vimSynOption
hi! link vimSynRegPat   vimString
hi! link vimSynType     vimSynOption
hi! link vimSyncC       Type
hi! link vimSyncError   Error
hi! link vimSyncGroup   vimGroupName
hi! link vimSyncGroupName       vimGroupName
hi! link vimSyncKey     Type
hi! link vimSyncNone    Type
hi! link vimSyntax      vimCommand
hi! link vimTodo        Todo
hi! link vimUnmap       vimMap
hi! link vimUserAttrb   vimSpecial
hi! link vimUserAttrbCmplt      vimSpecial
hi! link vimUserAttrbCmpltFunc  Special
hi! link vimUserAttrbError      Error
hi! link vimUserAttrbKey        vimOption
hi! link vimUserCmd vimUserCommand
hi! link vimUserCmdError        Error
hi! link vimUserCommand vimCommand
hi! link vimVar Identifier
hi! link vimWarn        WarningMsg

" }}}

" Vim Errors: {{{
hi! link vimBehaveError vimError
hi! link vimBufnrWarn   vimWarn
hi! link vimCollClassErr        vimError
hi! link vimEmbedError  vimError
hi! link vimErrSetting  vimError
hi! link vimFTError     vimError
hi! link vimHiAttribList        vimError
hi! link vimHiCtermError        vimError
hi! link vimHiKeyError  vimError
hi! link vimKeyCodeError        vimError
hi! link vimMapModErr   vimError
hi! link vimSubstFlagErr        vimError
hi! link vimSynCaseError        vimError
hi! link vimSynError Exception
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
hi! link vimAugroup     vimAugroupKey

" Lmao the comma between BufEnter,BufReadPre
hi! link vimAutoEventList vimAutoEvent
" Don't link to WildMenu it's the space in between the word cluster and the
" cluster group
" hi link vimClusterName WildMenu
hi! link vimClusterName NONE

hi! link vimCmdSep vimCommand
hi! link vimCommentTitleLeader  vimCommentTitle
hi! link vimEcho        String
" the spaces between words in an execute statement like wth
hi! link vimExecute Label
hi! link vimHiAttribList Underlined
hi! link vimHiCtermColor Underlined
hi! link vimHiFontname Underlined
hi! link vimHiKeyList Keyword
hi! link vimIskSep Keyword
hi! link vimMapLhs vimNotation
hi! link vimMapRhs vimNotation
hi! link vimMapRhsExtend        vimNotation
hi! link vimOnlyHLGroup VisualNOS
hi! link vimOnlyCommand vimCommand
hi! link vimOnlyOption Green
hi! link vimSet vimSetEqual

" There's a highlighting group for the equals sign in a set option statement...
hi! link vimSetEqual    Operator
hi! link vimSynKeyRegion Keyword
hi! link vimHiAttribList vimHighlight

" This syntax group is literally whitespace...
hi! link vimSynRegion Nontext
hi! link vimSyncLines Number

" Here are a few more xxx cleared syn groups
hi! link vimUserFunc Function

hi! link vimPythonRegion Identifier

" }}}

" }}}

" More: {{{
" hi link vimSynMatchRegion 
hi! link vimSynMtchCchar String 
" vimSynMtchGroup xxx cleared
hi! link vimSynPatMod vimSynOption
hi! link vimSyncMatch MatchWord
hi! link vimSyncLinebreak vimSynOption
hi! link vimSyncLinecont vimSynOption
" vimSyncRegion  xxx cleared
" }}}
" }}}

" JSON: {{{
hi! link jsonCommentError Normal
" }}}

" }}}

" Original: {{{

" Filetypes: {{{

" Markdown: {{{
hi! link markdownBlockquote Include
hi! link markdownBoldDelimiter Delimiter
hi! link markdownCode Include
hi! link markdownCodeBlock Directory
hi! link markdownCodeDelimiter Delimiter
hi! link markdownError markdownText
hi! link markdownH1 GreenBold
hi! link markdownH2 GreenBold
hi! link markdownH3 Title
hi! link markdownH4 Title
hi! link markdownH5 Yellow
hi! link markdownH6 Yellow
hi! link markdownHeadingDelimiter Delimiter
hi! link markdownHeadingRule Yellow
hi! link markdownIdDeclaration markdownLinkText
hi! link markdownLinkDelimiter Delimiter
hi! link markdownLinkText Aqua
hi! link markdownLinkTextDelimiter Delimiter
hi! link markdownListMarker Red
hi! link markdownOrderedListMarker Red
hi! link markdownRule Grey
hi! link markdownText Normal
hi! link markdownUrl Underlined
hi! link markdownUrlDelimiter Delimiter
hi! link markdownUrlTitleDelimiter Green
hi! link mkdBlockquote    Comment
hi! link mkdBold          PmenuSel
hi! link mkdCode          String
hi! link mkdCodeDelimiter ColorColumn
hi! link mkdCodeEnd       String
hi! link mkdCodeStart     String
hi! link mkdDelimiter     Delimiter
hi! link mkdFootnote      TablineSel
hi! link mkdFootnotes     Underlined
hi! link mkdHeading       Tag
hi! link mkdID            Identifier
hi! link mkdInlineURL     Underlined
hi! link mkdLineBreak     Whitespace
hi! link mkdLink          Underlined
hi! link mkdLinkDef       mkdID
hi! link mkdLinkDefTarget mkdURL
hi! link mkdLinkTitle     htmlString
hi! link mkdListItem      Identifier
hi! link mkdNonListItemBlock Normal
hi! link mkdRule          Identifier
hi! link mkdSnippetVIM    Label
hi! link mkdString        String
hi! link mkdURL           Underlined
hi! markdownItalic cterm=italic gui=italic

hi! link mkdBold Grey
hi! link mkdCodeDelimiter Aqua
hi! link mkdDelimiter Grey
hi! link mkdHeading Orange
hi! link mkdId Yellow
hi! link mkdLink Aqua
hi! link mkdListItem Red
" }}}

" c: {{{
hi! link cOperator Purple
hi! link cStructure Orange
hi! link cppOperator Purple
" }}}

" Other: {{{
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
" }}}

" JavaScript: {{{
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
" }}}

" TypeScript: {{{
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
" }}}

" React; {{{
hi! link jsxTagName Aqua
hi! link jsxComponentName Green
hi! link jsxCloseString LightGrey
hi! link jsxAttrib Yellow
hi! link jsxEqual Aqua
" }}}

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

hi! link luaIfThen Green
hi! link luaElseifThen Orange
hi! link luaThenEnd Purple
hi! link luaBlock Green
hi! link luaLoopBlock Blue
hi! link luaStatement Aqua
hi! link luaParen Operator
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

" {{{
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
        hi Normal guifg=#dfbf8e guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE
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
      " {{{
      " Got this from `:he 'pumblend'
      hi PmenuSel guifg=#282828 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
      " Yeah. Blend is 0
      " Yo tablinesel sets this way is pretty awful
      " hi TabLineSel guifg=#282828 guibg=#a89984 guisp=NONE gui=bold cterm=bold
      " Actually the lightbg one is pretty solid
      hi TabLineSel guifg=#ebdbb2 guibg=#7c6f64 guisp=NONE gui=bold cterm=bold
      hi WildMenu guifg=#282828 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
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
      hi SpellBad gui=undercurl cterm=undercurl
      hi SpellCap gui=undercurl cterm=undercurl
      hi SpellLocal gui=undercurl cterm=undercurl
      hi SpellRare gui=undercurl cterm=undercurl
      hi Todo gui=bold cterm=bold
      hi Comment guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
      hi SpecialComment guifg=#928374 guibg=NONE guisp=NONE gui=italic cterm=italic
    if get(g:, 'gruvbox_material_enable_bold', 0)
      hi Function guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
    else
      hi Function guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    endif
      hi DiffAdd guifg=NONE guibg=#32361a guisp=NONE gui=NONE cterm=NONE
      hi DiffChange guifg=NONE guibg=#0d3138 guisp=NONE gui=NONE cterm=NONE
      hi DiffDelete guifg=NONE guibg=#3c1f1e guisp=NONE gui=NONE cterm=NONE
      hi Error guifg=NONE guibg=#3c1f1e guisp=NONE gui=NONE cterm=NONE
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
" }}}

" }}}

" Vim: set fdls=0 fdm=marker et sw=4 ts=4 sts=4:
