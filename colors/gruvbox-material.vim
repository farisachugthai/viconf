" Name:         Gruvbox Material
" Maintainer:   Faris Chugthai
" Previous Maintainer:  Sainnhepark <sainnhe@gmail.com>
" Last Updated: Apr 12, 2020

scriptencoding utf8

" If we're re-sourcing we probably meant to do ya know.
" if exists('g:loaded_gruvbox_material_vim')
  " finish
" endif
"llet g:loaded_gruvbox_material_vim = 1

if exists('syntax_on')
  silent! unlet! g:colors_name
  syntax reset
  syntax on
endif
let g:colors_name = 'gruvbox-material'

" Meat And Potatoes: The ColorScheme:
  let g:terminal_ansi_colors = [
                  \ '#665c54', '#ea6962', '#a9b665', '#e78a4e',
                  \ '#7daea3', '#d3869b', '#89b482', '#dfbf8e',
                  \ '#928374', '#ea6962', '#a9b665', '#e3a84e',
                  \ '#7daea3', '#d3869b', '#89b482', '#dfbf8e',
                  \ ]

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

" Base Colors:
  hi LightGrey guifg=#a89984 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Grey guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Red guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Orange guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Yellow guifg=#e3a84e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Green guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Aqua guifg=#89b482 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Blue guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Purple guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi WhiteBold guifg=#ffffff guibg=NONE guisp=NONE gui=bold cterm=bold
  hi LightGreyBold guifg=#a89984 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi GreyBold guifg=#928374 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi RedBold guifg=#ea6962 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi OrangeBold guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi YellowBold guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi GreenBold guifg=#a9b665 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi AquaBold guifg=#89b482 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi BlueBold guifg=#7daea3 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi PurpleBold guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold

" Base HL Groups:
  hi Normal guifg=#dfbf8e guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE ctermbg=234
  hi DiffText guifg=NONE guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermbg=234
  hi EndOfBuffer guifg=#282828 guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE ctermbg=234
  hi VertSplit guifg=#665c54 guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE ctermbg=234
  hi QuickFixLine guifg=#e3a84e guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermbg=234
  hi MatchParen guifg=NONE guibg=#32302f guisp=NONE gui=bold cterm=bold
  hi FoldColumn guifg=#928374 guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi Folded guifg=#928374 guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi CursorColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi CursorLine guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi CursorLineNr guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi PmenuSel guifg=#282828 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
  hi TabLineSel guifg=#ebdbb2 guibg=#7c6f64 guisp=NONE gui=bold cterm=bold ctermfg=223
  hi WildMenu guifg=#282828 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi Pmenu guifg=#dfbf8e guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
  hi StatusLine guifg=#dfbf8e guibg=#504945 guisp=NONE gui=bold cterm=bold
  hi StatusLineTerm guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
  hi TabLine guifg=#dfbf8e guibg=#504945 guisp=NONE gui=NONE cterm=NONE
  hi TabLineFill guifg=#dfbf8e guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi ColorColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi SignColumn guifg=NONE guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi StatusLineNC guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
  hi StatusLineTermNC guifg=#a89984 guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242

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
  hi ToolbarLine guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE guibg=#282828 ctermbg=242
  hi ToolbarButton guifg=#dfbf8e guibg=#665c54 guisp=NONE gui=bold cterm=bold
  hi Debug guifg=#e78a4e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=undercurl cterm=undercurl
  hi Title guifg=#a9b665 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=bold cterm=bold
  hi Conditional guifg=#ea6962 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Repeat guifg=#ea6962 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Label guifg=#ea6962 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Exception guifg=#ea6962 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Keyword guifg=#ea6962 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Statement guifg=#ea6962 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Typedef guifg=#e3a84e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Type guifg=#e3a84e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi StorageClass guifg=#e78a4e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi! link Delimiter BlueBold
  hi Special guifg=#e78a4e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Tag guifg=#e78a4e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Operator guifg=#e78a4e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpecialChar guifg=#e78a4e guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi String guifg=#a9b665 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi PreProc guifg=#89b482 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Macro guifg=#89b482 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Define guifg=#89b482 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Include guifg=#89b482 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi PreCondit guifg=#89b482 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Structure guifg=#89b482 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Identifier guifg=#7daea3 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Underlined guifg=#7daea3 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=underline cterm=underline
  hi Constant guifg=#d3869b guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Boolean guifg=#d3869b guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Character guifg=#d3869b guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Number guifg=#d3869b guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Float guifg=#d3869b guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpecialKey guifg=#7daea3 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=NONE cterm=NONE
  hi Comment guifg=#928374 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=italic cterm=italic
  hi Function guifg=#a9b665 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=bold cterm=bold
  hi DiffAdd guifg=NONE guibg=#32361a guisp=NONE gui=NONE cterm=NONE
  hi DiffChange guifg=NONE guibg=#0d3138 guisp=NONE gui=NONE cterm=NONE
  hi DiffDelete guifg=NONE guibg=#3c1f1e guisp=NONE gui=NONE cterm=NONE
  " hi Error guisp=NONE term=NONE guibg=#4e4e4e cterm=bold ctermbg=239 gui=bold
  hi Error guifg=#ea6962 guibg=#1d2021 ctermbg=234 term=NONE guisp=NONE gui=bold,underline cterm=bold,underline

" Standard Highlights:
  let g:gruvbox_material_transparent_background = 0
  let g:gruvbox_material_enable_bold = 1
  let g:gruvbox_material_background = 'hard'
  " From ned batchelder.
  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

  " Screen line that the cursor is
  hi! CursorLine ctermbg=237 guibg=#3c3836 guifg=NONE ctermfg=NONE cterm=NONE gui=NONE guisp=NONE
  " Line number of CursorLine
  hi! CursorLineNr guifg=#fabd2f guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE ctermbg=237
  " Screen column that the cursor is
  hi! link CursorColumn CursorLine
  " Additional Links
  hi! link VisualNC Visual
  " This is an exciting way to live life but jesus does it hurt your eyes
  " hi! link MsgArea WarningMsg
  hi! link MsgArea Normal
  hi! link NormalNC Normal
  hi! link Noise Tag

  " I saw this at `:he group-name` so idk man
  hi! link SpecialComment SpecialChar

  if has('nvim')
    " How does a nice light blue sound?
    hi! NvimInternalError guibg=#1d2021 ctermfg=108 ctermbg=234 gui=reverse guifg=#8ec0e1 guisp=NONE
    hi! link nvimAutoEvent   vimAutoEvent
    hi! link nvimHLGroup     vimHLGroup
    hi! link NvimIdentifierKey Identifier
    hi! link nvimInvalid     Exception
    hi! link nvimMap         vimMap
    hi! link nvimUnmap       vimUnmap
    hi! link NvimIdentifier  Identifier
    hi! link NvimString      BlueBold

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

" Plugins:
  " NERDTree:
    hi! link NERDTreeBookmark Typedef
    hi! link NERDTreeBookmarksLeader Keyword
    hi! link NERDTreeCWD Special
    hi! link NERDTreeClosable Orange
    hi! link NERDTreeDir Directory
    hi! link NERDTreeDirSlash Delimiter
    hi! link NERDTreeExecFile Yellow
    hi! link NERDTreeFile Structure
    hi! link NERDTreeFlags Orange
    hi! link NERDTreeHelp Tag
    " hi! link NERDTreeLinkFile Aqua
    hi! link NERDTreeLinkTarget Green
    hi! link NERDTreeNodeDelimeters Delimiter
    hi! link NERDTreeOpenable Orange
    hi! link NERDTreeToggleOff Red
    hi! link NERDTreeToggleOn Green
    hi! link NERDTreeUp Comment
    hi! link hideBracketsInNERDTree Conceal

  " Asynchronous Lint Engine:
    hi ALEError guifg=NONE guibg=NONE guisp=#ea6962 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
    hi ALEWarning guifg=NONE guibg=NONE guisp=#e3a84e gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
    hi ALEInfo guifg=NONE guibg=NONE guisp=#7daea3 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
    hi ALEErrorSign guifg=#ea6962 guibg=#282828 guisp=NONE gui=NONE cterm=NONE term=NONE ctermbg=242
    hi ALEWarningSign guifg=#e3a84e guibg=#282828 guisp=NONE gui=NONE cterm=NONE term=NONE ctermbg=242
    hi ALEInfoSign guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE term=NONE ctermbg=242
    hi! link ALEErrorSign Error
    hi! link ALEWarningSign QuickFixLine
    hi! link ALEInfoSign Directory
    hi! link ALEError Error
    hi! link ALEWarning QuickFixLine
    hi! link ALEInfo Macro
    hi def link aleFixerComment Comment
    hi def link aleFixerName GreenBold
    hi def link aleFixerHelp Statement
    hi def link alePreviewSelectionFilename Aqua
    hi def link alePreviewNumber Number
    " ALESignColumnWithoutErrors xxx ctermfg=14 ctermbg=242 guibg=#282828
    " ALEErrorLine   xxx cleared
    " ALEWarningLine xxx cleared
    " ALEInfoLine    xxx cleared
    hi! link ALEVirtualTextError Grey
    hi! link ALEVirtualTextWarning Grey
    hi! link ALEVirtualTextInfo Grey
    hi! link ALEVirtualTextStyleError ALEVirtualTextError
    hi! link ALEVirtualTextStyleWarning ALEVirtualTextWarning
    hi! link SyntasticError ALEError
    hi! link SyntasticWarning ALEWarning
    hi! link SyntasticErrorSign ALEErrorSign
    hi! link SyntasticWarningSign ALEWarningSign

  " GitGutter:
    hi GitGutterAdd guifg=#a9b665 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
    hi GitGutterChange guifg=#7daea3 guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
    hi GitGutterDelete guifg=#ea6962 guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242
    hi GitGutterChangeDelete guifg=#d3869b guibg=#282828 guisp=NONE gui=NONE cterm=NONE ctermbg=242

  " GitCommit:
    " Do I have this plugin? Is this a fugitive thing?
    hi! link gitcommitSelectedFile Green
    hi! link gitcommitDiscardedFile Red

  " Tagbar:
    hi! link TagbarFoldIcon Green
    hi! link TagbarHelp Define
    hi! link TagbarKind Red
    hi! link TagbarNestedKind Aqua
    hi! link TagbarScope Orange
    hi! link TagbarSignature Question
    hi! link TagbarTitle Title
    hi! link TagbarVisibilityPrivate Red
    hi! link TagbarVisibilityPublic Blue

  " Coc:
    hi CocHintSign guifg=#89b482 guibg=#282828 guisp=NONE gui=NONE cterm=NONE
    hi CocHoverRange guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
    hi! link CocCodeLens ALEVirtualTextInfo
    hi! link CocDiagnosticsError Red
    hi! link CocDiagnosticsHint Blue
    hi! link CocDiagnosticsInfo Yellow
    hi! link CocDiagnosticsWarning Orange
    hi! link CocErrorFloat Red
    hi! link CocErrorHighlight ALEError
    hi! link CocErrorSign ALEErrorSign
    hi! link CocErrorVirtualText ALEVirtualTextError
    hi! link CocExplorerBufferBufname Grey
    hi! link CocExplorerBufferBufnr Purple
    hi! link CocExplorerBufferExpandIcon Aqua
    hi! link CocExplorerBufferModified Red
    hi! link CocExplorerBufferRoot Orange
    hi! link CocExplorerFileDirectory Green
    hi! link CocExplorerFileExpandIcon Aqua
    hi! link CocExplorerFileFullpath Aqua
    hi! link CocExplorerFileGitStage Purple
    hi! link CocExplorerFileGitUnstage Yellow
    hi! link CocExplorerFileRoot Orange
    hi! link CocExplorerFileSize Blue

    hi! link CocExplorerTimeAccessed Aqua
    hi! link CocExplorerTimeCreated Aqua
    hi! link CocExplorerTimeModified Aqua
    hi! link CocGitAddedSign GitGutterAdd
    hi! link CocGitChangeRemovedSign GitGutterChangeDelete
    hi! link CocGitChangedSign GitGutterChange
    hi! link CocGitRemovedSign GitGutterDelete
    hi! link CocGitTopRemovedSign GitGutterDelete
    hi! link CocHighlightText LightGreyBold
    hi! link CocHintFloat Blue
    hi! link CocHintVirtualText ALEVirtualTextInfo
    hi! link CocInfoFloat Yellow
    hi! link CocInfoHighlight ALEInfo
    hi! link CocInfoSign ALEInfoSign
    hi! link CocInfoVirtualText ALEVirtualTextInfo
    hi! link CocListsLine Blue
    hi! link CocSelectedText OrangeBold
    hi! link CocWarningFloat Orange
    hi! link CocWarningHighlight ALEWarning
    hi! link CocWarningSign ALEWarningSign
    hi! link CocWarningVirtualText ALEVirtualTextWarning

    " UndoTree:

    hi! link UndotreeNode Orange
    hi! link UndotreeNodeCurrent Red
    hi! link UndotreeSeq Green
    hi! link UndotreeNext Blue
    hi! link UndotreeTimeStamp Grey
    hi! link UndotreeHead Yellow
    hi! link UndotreeBranch Yellow
    hi! link UndotreeCurrent Aqua
    hi! link UndotreeSavedSmall Purple
    hi UndotreeSavedBig guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold

    " QuickMenu:
    hi! link QuickmenuOption Green
    hi! link QuickmenuNumber Red
    hi! link QuickmenuBracket Grey
    hi! link QuickmenuHelp Green
    hi! link QuickmenuSpecial Purple
    hi! link QuickmenuHeader Orange
    " TagbarAccessPublic xxx ctermfg=10 guifg=Green
    " TagbarAccessProtected xxx
    " ctermfg=12 guifg=Blue

  " FZF:
    hi! fzf1 ctermfg=161 ctermbg=238 guifg=#E12672 guibg=#565656 cterm=bold,underline term=NONE gui=bold,underline guisp=NONE
    hi! fzf2 ctermfg=151 ctermbg=238 guifg=#BCDDBD guibg=#565656 cterm=bold,underline term=NONE gui=bold,underline guisp=NONE
    hi! fzf3 ctermfg=252 ctermbg=238 guifg=#D9D9D9 guibg=#565656 cterm=bold,underline term=NONE gui=bold,underline guisp=NONE

  " Vim Plug:
    hi plug1 guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi plugNumber guifg=#e3a84e guibg=NONE guisp=NONE gui=bold cterm=bold
    hi! link plug2 Green
    hi! link plugBracket Grey
    hi! link plugDash Orange
    hi! link plugDeleted Grey
    hi! link plugEdge Yellow
    hi! link plugError Red
    hi! link plugH2 Orange
    hi! link plugMessage Orange
    hi! link plugName Aqua
    hi! link plugNotLoaded Folded
    hi! link plugRelDate Grey
    hi! link plugSha Green
    hi! link plugStar Red
    hi! link plugUpdate Blue


  " Signature:
    " hi! link SignatureMarkLine Normal
    hi! link SignatureMarkText WarningMsg
    hi! link SignatureMarkerText SignColumn

  " Misc Plugins:
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
    hi! link StartifyFile Structure
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

    hi multiple_cursors_cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi multiple_cursors_visual guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE

    hi MatchParenCur guifg=NONE guibg=NONE guisp=NONE gui=bold,reverse ctermfg=NONE ctermbg=NONE cterm=bold,reverse

" Filetype Specific: ---------------------------------------------------
  " Snippets:
    hi! link snipSnippets Normal
    " Holy shit this was make my eyes so much happier
    hi! link snipLeadingSpaces Normal
    hi! link snipSnippet Keyword

  " Jinja:
    hi! link jinjaOperator Operator

  " Django:
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

  " CSS:
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
    hi! link cssBoxProp cssProp
    hi! link cssBraceError Error
    hi! link cssBraces Function
    hi! link cssCascadeAttr cssAttr
    hi! link cssCascadeProp cssProp
    hi! link cssClassName Function
    hi! link cssClassNameDot Function
    hi! link cssColor Constant
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
    " I have no idea what this is
    hi! link cssNoise cssAttr
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
    hi! link cssStyle cssImportant
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
    hi! link cssVendor WhiteBold

  " Man:
    hi! link manBold           htmlBold
    hi! link manCError         Exception
    hi! link manEmail          Directory
    hi! link manEnvVar         Identifier
    hi! link manEnvVarFile     Identifier
    hi! link manErrors         Errors
    " hi! link manExample
    hi! link manFile           Yellow
    hi! link manFiles Yellow
    hi! link manFooter Purple
    hi! link manHeaderFile Statement
    hi! link manHighlight Yellow
    hi! link manHistory Yellow
    hi! link manItalic         htmlItalic
    hi! link manOptionDesc     Constant
    hi! link manReference      PreProc
    hi! link manSectionHeading OrangeBold
    hi! link manSentence htmlItalic
    hi! link manSignal Purple
    hi! link manSubHeading     Function
    hi! link manTitle          Title
    hi! link manURL            Include
    hi! link manUnderline Underlined

  " Help:
    hi helpURL guifg=#89b482 guibg=NONE guisp=NONE gui=underline cterm=underline
    hi helpNote guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold
    hi! link helpCommand Orange
    hi! link helpExample Green
    hi! link helpHeader Aqua
    hi! link helpHeadline Title
    hi! link helpHyperTextEntry Red
    hi! link helpHyperTextJump Blue
    hi! link helpSectionDelim Grey
    hi! link helpSpecial Yellow
    hi! link helpWarning Error

  " Netrw:
    hi! link netrwCmdNote Directory
    hi! link netrwComment Comment
    if has('nvim')
      hi! link netrwCopyTgt IncSearch
    else
      " Is this canoniccal vim?
      hi! link netrwCopyTgt StorageClass
    endif

   " !syntax highlighting (see :he g:netrw_special_syntax)
    hi! link netrwBak      netrwGray
    hi! link netrwCmdSep   Delimiter
    hi! link netrwComma    netrwComment
    hi! link netrwCompress netrwGray
    hi! link netrwCoreDump WarningMsg
    hi! link netrwData     DiffChange
    hi! link netrwDateSep  Delimiter
    hi! link netrwDir      Directory
    hi! link netrwExe      PreProc
    hi! link netrwGray     Folded
    hi! link netrwHdr      netrwPlain
    hi! link netrwHelpCmd  Delimiter
    hi! link netrwHide     netrwComment
    hi! link netrwHidePat Folded
    hi! link netrwHideSep  netrwComment
    hi! link netrwLex      netrwPlain
    hi! link netrwLib      DiffChange
    hi! link netrwLink     Special
    hi! link netrwList     PreCondit
    hi! link netrwMakefile DiffChange
    hi! link netrwMarkFile TabLineSel
    hi! link netrwObj      netrwGray
    hi! link netrwPix      Special
    hi! link netrwPlain    String
    hi! link netrwQHTopic  Number
    hi! link netrwQuickHelp netrwHelpCmd
    hi! link netrwSizeDate Delimiter
    hi! link netrwSlash    Delimiter
    hi! link netrwSortBy   Title
    hi! link netrwSortSeq  netrwList
    hi! link netrwSpecFile netrwGray
    hi! link netrwSpecial  Special
    hi! link netrwSymLink  Special
    hi! link netrwTags     netrwGray
    hi! link netrwTilde    netrwGray
    hi! link netrwTime     Delimiter
    hi! link netrwTimeSep  Delimiter
    hi! link netrwTmp      netrwGray
    hi! link netrwTreeBar  Special
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

    hi! link netrwGray Grey
    hi! link netrwBak      netrwGray
    hi! link netrwCompress netrwGray
    hi! link netrwSpecFile netrwGray
    hi! link netrwObj      netrwGray
    hi! link netrwTags     netrwGray
    hi! link netrwTilde    netrwGray
    hi! link netrwTmp      netrwGray

  " Rst:
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

  " Tmux:
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

  " Diff:
    hi! link diffAdded Green
    hi! link diffRemoved Red
    hi! link diffChanged Directory
    hi! link diffFile Orange
    hi! link diffLine Blue
    hi! link diffOldFile Purple
    hi! link diffNewFile Blue
    hi! link diffFile Orange
    hi! link diffIndexLine Aqua

  " Html:
    if v:version > 800 || v:version == 800 && has('patch1038')
      hi! htmlStrike              term=strikethrough,undercurl,bold cterm=strikethrough,undercurl,bold gui=strikethrough,undercurl,bold
    else
      hi! htmlStrike              term=underline cterm=underline gui=underline
    endif

    hi htmlLink guifg=#a89984 guibg=NONE guisp=NONE gui=underline cterm=underline
    hi htmlBold guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
    hi htmlBoldUnderline guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
    hi htmlBoldItalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic ctermfg=NONE ctermbg=NONE cterm=bold,italic
    hi htmlBoldUnderlineItalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic,underline ctermfg=NONE ctermbg=NONE cterm=bold,italic,underline
    hi htmlUnderline guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
    hi htmlUnderlineItalic guifg=NONE guibg=NONE guisp=NONE gui=italic,underline ctermfg=NONE ctermbg=NONE cterm=italic,underline
    hi htmlItalic guifg=NONE guibg=NONE guisp=NONE gui=italic ctermfg=NONE ctermbg=NONE cterm=italic


    hi! link htmlArg                     Type
    hi! link htmlBoldItalicUnderline     htmlBoldUnderlineItalic
    hi! link htmlComment            Comment
    hi! link htmlCommentError       htmlError
    hi! link htmlCommentPart        Comment
    hi! link htmlCssDefinition      Special
    hi! link htmlCssStyleComment    Comment
    hi! link htmlEndTag                  Identifier
    hi! link htmlError              Error
    hi! link htmlEvent              javaScript
    hi! link htmlH1                      Title
    hi! link htmlH2                      htmlH1
    hi! link htmlH3                      htmlH2
    hi! link htmlH4                      htmlH3
    hi! link htmlH5                      htmlH4
    hi! link htmlH6                      htmlH5
    hi! link htmlHead                    PreProc
    hi! link htmlItalicBold              htmlBoldItalic
    hi! link htmlItalicBoldUnderline     htmlBoldUnderlineItalic
    hi! link htmlItalicUnderline         htmlUnderlineItalic
    hi! link htmlItalicUnderlineBold     htmlBoldUnderlineItalic
    hi! link htmlLeadingSpace            None
    hi! link htmlPreAttr            String
    hi! link htmlPreError           Error
    hi! link htmlPreProc            PreProc
    hi! link htmlPreProcAttrError   Error
    hi! link htmlPreProcAttrName    PreProc
    hi! link htmlPreStmt            PreProc
    hi! link htmlScriptTag Purple
    hi! link htmlScriptTag htmlTag
    hi! link htmlSpecial            Special
    hi! link htmlSpecialChar        Special
    hi! link htmlSpecialTagName          Exception
    hi! link htmlStatement          Statement
    hi! link htmlString             String
    hi! link htmlTag                Tag
    hi! link htmlTagError           htmlError
    hi! link htmlTagN               Tag
    hi! link htmlTagName                 htmlStatement
    hi! link htmlTitle                   Title
    hi! link htmlUnderlineBold           htmlBoldUnderline
    hi! link htmlUnderlineBoldItalic     htmlBoldUnderlineItalic
    hi! link htmlUnderlineItalicBold     htmlBoldUnderlineItalic
    hi! link htmlValue                     String
    hi! link htmlValue              String


  " Xml:
    hi! link docbkKeyword Keyword
    hi! link dtdFunction Function
    hi! link dtdParamEntityDPunct Delimeter
    hi! link dtdParamEntityPunct  Delimeter
    hi! link dtdTagName Purple
    hi! link dtdTagName Purple
    hi! link xmlAttrib Directory
    hi! link xmlAttribPunct Grey
    hi! link xmlCdataCdata Purple
    hi! link xmlCdataStart Grey
    hi! link xmlDocTypeDecl Grey
    hi! link xmlDocTypeKeyword Keyword
    hi! link xmlEndTag Tag
    hi! link xmlEntity Orange
    hi! link xmlEntityPunct Orange
    hi! link xmlEqual Blue
    hi! link xmlProcessingDelim Grey
    hi! link xmlTag   Tag
    hi! link xmlTagName Tag

  " Python:
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

  " Vim:
    " hi! link vimTermOption
    " vimExtCmd
    " vimFilter
    " vimFiletype
    " vimOperParen
    " vimSynLine
    " vimFuncBlank
    " vimEscapeBrace
    " vimAutoCmdSfxList
    " vimMenuBang
    " vimMenuPriority
    " vimMenuMap
    " vimMenuRhs
    " vimNormCmds
    " vimGroupList
    " vimSynMatchRegion xxx
    " vimSynMtchGroup
    " vimSyncRegion  xxx

    hi! link vimAugroup     vimAugroupKey
    hi! link vimAuSyntax vimAugroup
    hi! link vimAugroupSyncA vimAugroup
    " Lmao the comma between BufEnter,BufReadPre
    hi! link vimAutoEventList vimAutoEvent
    hi! link vimAbb vimCommand
    hi! link vimAddress     vimMark
    hi! link vimAuHighlight vimHighlight
    hi! link vimAugroupKey  Keyword
    hi! link vimAutoCmd     vimCommand
    hi! link vimAutoCmdOpt  vimOption
    hi! link vimAutoCmdSpace vimAutoCmd
    hi! link vimAutoEvent   Type
    hi! link vimAutoSet     vimCommand
    hi! link vimBehave      vimCommand
    hi! link vimBehaveModel vimBehave
    hi! link vimBracket     Delimiter
    hi! link vimCmplxRepeat SpecialChar
    " Don't link to WildMenu it's the space in between the word cluster and the cluster group
    " hi link vimClusterName WildMenu
    hi! link vimClusterName Normal
    hi! link vimCmdSep vimCommand
    hi vimCommentTitle guifg=#a89984 guibg=NONE guisp=NONE gui=bold,italic cterm=bold,italic
    hi! link vimCommentTitleLeader  vimCommentTitle
    hi! link vimCollClass   StorageClass
    hi! link vimCollection PreCondit
    hi! link vimCommand     Statement
    hi! link vimComment     Comment
    hi! link vimCommentString       vimString
    hi! link vimCommentTitle        PreProc
    hi! link vimCondHL      vimCommand
    hi! link vimContinue    Special
    hi! link vimCtrlChar    SpecialChar
    hi! link vimEchoHL      vimCommand
    hi! link vimEchoHLNone  vimGroup
    hi! link vimElseif      vimCondHL
    hi! link vimEnvvar      PreProc
    hi! link vimEcho        String
    " the spaces between words in an execute statement like wth
    hi! link vimExecute Label
    hi! link vimFBVar       vimVar
    hi! link vimFTCmd       vimCommand
    hi! link vimFTOption    vimSynType
    hi! link vimFgBgAttrib  vimHiAttrib
    hi! link vimFold        Folded
    hi! link vimFunc        Function
    hi! link vimFuncBody    Normal
    hi! link vimFuncKey     vimCommand
    hi! link vimFuncName    Function
    hi! link vimFuncSID     Special
    hi! link vimFuncVar     Identifier
    hi! link vimFunction Function
    hi! link vimGlobal      vimFuncSID
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
    hi! link vimHiGuiFontname vimHiGui
    hi! link vimHiLink vimHiBang
    hi! link vimHiTermCap vimHiCTerm
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

    hi! link vimIsCommand       vimVar
    hi! link vimIskSep      Delimiter
    hi! link vimIskList      Delimiter
    hi! link vimKeyCode     vimSpecFile
    hi! link vimKeyword     Statement
    hi! link vimLet vimCommand
    hi! link vimLineComment vimComment
    hi! link vimMap vimCommand
    hi! link vimMapBang     vimCommand
    hi! link vimMapLhs      vimSyncMatch
    hi! link vimMapMod      vimBracket
    hi! link vimMapModKey   Macro
    hi! link vimMapRhs vimNotation
    hi! link vimMapRhsExtend        vimNotation
    hi! link vimMark        Number
    hi! link vimMarkNumber  vimNumber
    hi! link vimMenuMod     vimMapMod
    hi! link vimMenuName    PreProc
    hi! link vimMenuNameMore        vimMenuName
    hi! link vimMtchComment vimComment
    hi! link vimNorm        vimCommand
    hi! link vimNotFunc     vimCommand
    hi! link vimNotPatSep   vimString

    " This ends up being the RHS for all mappings so choose carefully!
    hi! link vimNotation    Special
    hi! link vimNumber Red
    hi! link vimOper        Operator
    hi! link vimOption      PreCondit
    hi! link vimParenSep    Delimiter
    hi! link vimPatRegion vimRegion
    hi! link vimPatSep      SpecialChar
    hi! link vimPatSepR     vimPatSep
    hi! link vimPatSepZ     vimPatSep
    hi! link vimPatSepZone  vimString
    hi! link vimPattern     Type
    hi! link vimPlainMark   vimMark
    hi! link vimPlainRegister       vimRegister
    hi! link vimRange vimSynPatRange
    hi! link vimRegion vimVar
    hi! link vimRegister    SpecialChar
    hi! link vimScriptDelim Comment
    hi! link vimSearch      vimString
    hi! link vimSearchDelim Statement
    hi! link vimSep Delimiter
    hi! link vimSet vimSetEqual
    " There's a highlighting group for the equals sign in a set option statement...
    hi! link vimSetEqual    Operator
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
    hi! link vimSubst2      vimSubst
    hi! link vimSubstDelim  Delimiter
    hi! link vimSubstFlags  Special
    hi! link vimSubstPat      vimSubst
    hi! link vimSubstRange      vimSubst
    hi! link vimSubstRep      vimSubst
    hi! link vimSubstRep4      vimSubst
    hi! link vimSubstSubstr SpecialChar
    hi! link vimSubstTwoBS  vimString
    hi! link vimSynCase     Type
    hi! link vimSynMtchCchar String
    hi! link vimSynPatMod vimSynOption
    hi! link vimSyncMatch htmlBoldUnderline
    hi! link vimSyncLinebreak vimSynOption
    hi! link vimSyncLinecont vimSynOption
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
    hi! link vimSynKeyRegion Keyword
    " This syntax group is literally whitespace...
    hi! link vimSynRegion Nontext
    hi! link vimSyncLines Number
    hi! link vimSyncC       Type
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
    hi! link vimUserAttrbKey        vimOption
    hi! link vimUserCmd vimUserCommand
    hi! link vimUserCommand vimCommand
    " Here are a few more xxx cleared syn groups
    hi! link vimUserFunc Function
    hi! link vimVar Identifier
    hi! link vimWarn        WarningMsg
    hi! link vimHiAttribList Underlined
    hi! link vimHiCtermColor Underlined
    hi! link vimHiFontname Underlined
    hi! link vimHiKeyList Keyword
    hi! link vimIskSep Keyword
    hi! link vimOnlyCommand vimCommand
    hi! link vimOnlyHLGroup VisualNOS
    hi! link vimOnlyOption Green
    hi! link vimPythonRegion Identifier

    " Errors:
    hi! link vimAugroupError        Error
    hi! link vimBehaveError vimError
    hi! link vimBufnrWarn   vimWarn
    hi! link vimCollClassErr        vimError
    hi! link vimElseIfErr   Error
    hi! link vimEmbedError  vimError
    hi! link vimErrSetting  vimError
    hi! link vimError       Error
    hi! link vimFunctionError vimError
    hi! link vimFTError     vimError
    hi! link vimHiAttribList        vimError
    hi! link vimHiCtermError        vimError
    hi! link vimHiKeyError  vimError
    hi! link vimKeyCodeError        vimError
    hi! link vimMapModErr   vimError
    hi! link vimOperError   Error
    hi! link vimPatSepErr   vimError
    hi! link vimSubstFlagErr        vimError
    hi! link vimSynCaseError        vimError
    hi! link vimSynError Exception
    hi! link vimSyncError   Error
    hi! link vimUserAttrbError      Error
    hi! link vimUserCmdError        Error

  " JSON:
    hi! link jsonCommentError Normal
    hi! link jsonFold Folded
    hi! link jsoncComment Comment
    hi! link jsoncLineComment Comment
    hi! link jsonKeywordMatch Tag
    hi! link jsonKeyword Identifier
    hi! link jsonQuote Statement
    hi! link jsonBraces Operator
    hi! link jsonString String
    hi! link jsonStringMatch MatchParen

  " Tex:
    hi! link initexCharacter                     Character
    hi! link initexNumber                        Number
    hi! link initexIdentifier                    Identifier
    hi! link initexStatement                     Statement
    hi! link initexConditional                   Conditional
    hi! link initexPreProc                       PreProc
    hi! link initexMacro                         Macro
    hi! link initexType                          Type
    hi! link initexDebug                         Debug
    hi! link initexTodo                          Todo
    hi! link initexComment                       Comment
    hi! link initexDimension                     initexNumber

  " Bash:
    hi! link bashAdminStatement	shStatement
    hi! link bashSpecialVariables	shShellVariables
    hi! link bashStatement		shStatement


    hi! link shAlias		Identifier
    hi! link shArithRegion	shShellVariables
    hi! link shArithmetic		Special
    hi! link shAstQuote	shDoubleQuote
    hi! link shAtExpr	shSetList
    hi! link shAtExpr	shSetList
    hi! link shBQComment	shComment
    hi! link shBeginHere	shRedir
    hi! link shBkslshDblQuote	shDOubleQuote
    hi! link shBkslshSnglQuote	shSingleQuote
    hi! link shCase             Question
    hi! link shCaseBar	shConditional
    hi! link shCaseCommandSub	shCommandSub
    hi! link shCaseDoubleQuote	shDoubleQuote
    hi! link shCaseError		Error
    hi! link shCaseEsac         Question
    hi! link shCaseEsacSync     Question
    hi! link shCaseExSingleQuote Question
    hi! link shCaseIn	shConditional
    hi! link shCaseLabel        Question
    hi! link shCaseRange        Question
    hi! link shCaseSingleQuote	shSingleQuote
    hi! link shCaseStart	shConditional
    hi! link shCharClass		Identifier
    hi! link shCmdParenRegion   Question
    hi! link shCmdSubRegion	shShellVariables
    hi! link shCmdSubRegion Green
    hi! link shColon	shComment
    hi! link shComma            Question
    hi! link shCommandSub		Special
    hi! link shCommandSubBQ		shCommandSub
    hi! link shComment		Comment
    hi! link shCondError		Error
    hi! link shConditional		Conditional
    hi! link shCtrlSeq		Special
    hi! link shCurlyError		Error
    hi! link shCurlyIn          Question
    hi! link shDblParen         Question
    hi! link shDeref	shShellVariables
    hi! link shDerefDelim	shOperator
    hi! link shDerefEscape      Question
    hi! link shDerefLen		shDerefOff
    hi! link shDerefOff		shDerefOp
    hi! link shDerefOp	shOperator
    hi! link shDerefOpError		Error
    hi! link shDerefPOL	shDerefOp
    hi! link shDerefPPS	shDerefOp
    hi! link shDerefPPSleft     Question
    hi! link shDerefPSR	shDerefOp
    hi! link shDerefPSRleft     Question
    hi! link shDerefPSRright    Question
    hi! link shDerefPattern     Question
    hi! link shDerefSimple	shDeref
    hi! link shDerefSpecial	shDeref
    hi! link shDerefString	shDoubleQuote
    hi! link shDerefVar	shDeref
    hi! link shDerefVarArray    Question
    hi! link shDerefWordError		Error
    hi! link shDo               Question
    hi! link shDoError		Error
    hi! link shDoSync           Question
    hi! link shDoubleQuote	shString
    hi! link shEcho	shString
    hi! link shEchoDelim	shOperator
    hi! link shEchoQuote	shString
    hi! link shEmbeddedEcho	shString
    hi! link shEsacError		Error
    hi! link shEscape	shCommandSub
    hi! link shExDoubleQuote	shDoubleQuote
    hi! link shExSingleQuote	shSingleQuote
    hi! link shExpr             Question
    hi! link shExprRegion		Delimiter
    hi! link shFor              Question
    hi! link shForPP	shLoop
    hi! link shForSync          Question
    hi! link shFunction	Function
    hi! link shFunctionFour     Question
    hi! link shFunctionKey		Keyword
    hi! link shFunctionName		Function
    hi! link shFunctionOne      Identifier
    hi! link shFunctionStart    Question
    hi! link shFunctionThree    Question
    hi! link shFunctionTwo      Question
    hi! link shHereDoc	shString
    hi! link shHereDoc01		shRedir
    hi! link shHereDoc02		shRedir
    hi! link shHereDoc03		shRedir
    hi! link shHereDoc04		shRedir
    hi! link shHereDoc05		shRedir
    hi! link shHereDoc06		shRedir
    hi! link shHereDoc07		shRedir
    hi! link shHereDoc08		shRedir
    hi! link shHereDoc09		shRedir
    hi! link shHereDoc10		shRedir
    hi! link shHereDoc11		shRedir
    hi! link shHereDoc12		shRedir
    hi! link shHereDoc13		shRedir
    hi! link shHereDoc14		shRedir
    hi! link shHereDoc15		shRedir
    hi! link shHereDoc16        Question
    hi! link shHerePayload	shHereDoc
    hi! link shHereString	shRedir
    hi! link shIf               Identifier
    hi! link shIfSync           Question
    hi! link shInError		Error
    hi! link shLoop	shStatement
    hi! link shNoQuote	shDoubleQuote
    hi! link shNumber		Number
    hi! link shOK               Question
    hi! link shOperator		Operator
    hi! link shOption	shCommandSub
    hi! link shOption Purple
    hi! link shParen	shArithmetic
    hi! link shParenError		Error
    hi! link shPattern	shString
    hi! link shPattern	shString
    hi! link shPosnParm	shShellVariables
    hi! link shQuickComment	shComment
    hi! link shQuote	shOperator
    hi! link shRange	shOperator
    hi! link shRedir	shOperator
    hi! link shRepeat		Repeat
    hi! link shSet		Statement
    hi! link shSetList		Identifier
    hi! link shSetListDelim	shOperator
    hi! link shSetOption	shOption
    hi! link shShellVariables		PreProc
    hi! link shSingleQuote	shString
    hi! link shSnglCase		Statement
    hi! link shSource	shOperator
    hi! link shSpecial		Special
    hi! link shSpecialDQ		Special
    hi! link shSpecialNoZS		shSpecial
    hi! link shSpecialNxt	shSpecial
    hi! link shSpecialSQ		Special
    hi! link shSpecialStart	shSpecial
    hi! link shSpecialVar       Question
    hi! link shStatement		Statement
    hi! link shString		String
    hi! link shStringSpecial	shSpecial
    hi! link shSubSh            Question
    hi! link shSubShRegion	shOperator
    hi! link shTest             Question
    hi! link shTestDoubleQuote	shString
    hi! link shTestError		Error
    hi! link shTestOpr	shConditional
    hi! link shTestOpr Purple
    hi! link shTestPattern	shString
    hi! link shTestSingleQuote	shString
    hi! link shTestSingleQuote	shString
    hi! link shTodo		Todo
    hi! link shTouch            Question
    hi! link shTouchCmd	shStatement
    hi! link shUntilSync        Question
    hi! link shVar                Character
    hi! link shVarAssign        Question
    hi! link shVariable	shSetList
    hi! link shWhileSync        Question
    hi! link shWrapLineOperator	shOperator

  " QF:
    hi link qfFileName	Directory
    hi link qfLineNr	LineNr
    hi link qfError	Error

  " SQL:
    hi! link Quote		Special
    hi! link sqlComment		Comment
    hi! link sqlFold Folded
    hi! link sqlFunction		Function
    hi! link sqlKeyword		sqlSpecial
    hi! link sqlNumber		Number
    hi! link sqlOperator		sqlStatement
    hi! link sqlSpecial		Special
    hi! link sqlStatement	Statement
    hi! link sqlString		String
    hi! link sqlType		Type
    hi! link sqlTodo		Todo

  " M4:
    hi link m4Command  PreCondit
    hi link m4Paren Delimiter

  " Markdown:
    hi! link markdownBlockquote Include
    hi! link markdownBoldDelimiter Delimiter
    hi! link markdownCode Include
    hi! link markdownCodeBlock Directory
    hi! link markdownCodeDelimiter Delimiter
    hi! link markdownError markdownText
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

    hi! link markdownH1 GreenBold
    hi! link markdownH2 GreenBold
    hi! link markdownH3 Title
    hi! link markdownH4 Title
    hi! link markdownH5 Yellow
    hi! link markdownH6 Yellow
    hi! link markdownHeadingDelimiter markdownH1
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
    hi! link mkdHeading       markdownH1
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

  " C:
    hi! link cOperator Purple
    hi! link cStructure Orange
    hi! link cppOperator Purple

  " Other:
    hi! link docbkKeyword AquaBold
  " JavaScript:
    hi! link javaScript             Special
    hi! link javaScriptExpression   javaScript
    hi! link javaScrParenError		javaScriptError
    hi! link javaScriptArrayMethod Blue
    hi! link javaScriptArrayStaticMethod Blue
    hi! link javaScriptArrowFunc Yellow
    hi! link javaScriptAsyncFunc Aqua
    hi! link javaScriptAsyncFuncKeyword Red
    hi! link javaScriptAwaitFuncKeyword Red
    hi! link javaScriptBOMLocationMethod Blue
    hi! link javaScriptBOMNavigatorProp Blue
    hi! link javaScriptBOMWindowMethod Blue
    hi! link javaScriptBOMWindowProp Blue
    hi! link javaScriptBoolean		Boolean
    hi! link javaScriptBraces		Function
    hi! link javaScriptBrackets Blue
    hi! link javaScriptBranch		Conditional
    hi! link javaScriptCacheMethod Blue
    hi! link javaScriptCharacter		Character
    hi! link javaScriptClassExtends Aqua
    hi! link javaScriptClassKeyword Aqua
    hi! link javaScriptClassName Yellow
    hi! link javaScriptClassStatic Orange
    hi! link javaScriptClassSuper Orange
    hi! link javaScriptClassSuperName Yellow
    hi! link javaScriptComment		Comment
    hi! link javaScriptCommentSkip Comment
    hi! link javaScriptCommentTodo		Todo
    hi! link javaScriptConditional		Conditional
    hi! link javaScriptConstant		Label
    hi! link javaScriptDOMDocMethod Blue
    hi! link javaScriptDOMDocProp Blue
    hi! link javaScriptDOMElemAttrs Blue
    hi! link javaScriptDOMEventMethod Blue
    hi! link javaScriptDOMNodeMethod Blue
    hi! link javaScriptDOMStorageMethod Blue
    hi! link javaScriptDateMethod Blue
    hi! link javaScriptDebug		Debug
    hi! link javaScriptDefault Aqua
    hi! link javaScriptDeprecated		Exception
    hi! link javaScriptDocNamedParamType LightGrey
    hi! link javaScriptDocNotation LightGrey
    hi! link javaScriptDocParamName LightGrey
    hi! link javaScriptDocParamType LightGrey
    hi! link javaScriptDocTags LightGrey
    hi! link javaScriptEmbed		Special
    hi! link javaScriptEndColons Blue
    hi! link javaScriptError		Error
    hi! link javaScriptException		Exception
    hi! link javaScriptExceptions Red
    hi! link javaScriptExport Aqua
    hi! link javaScriptForOperator Red
    hi! link javaScriptFuncArg Blue
    hi! link javaScriptFuncKeyword Aqua
    hi! link javaScriptFunction		Function
    hi! link javaScriptGlobal		Keyword
    hi! link javaScriptGlobalMethod Blue
    hi! link javaScriptHeadersMethod Blue
    hi! link javaScriptIdentifier		Identifier
    hi! link javaScriptImport Aqua
    hi! link javaScriptLabel		Label
    hi! link javaScriptLineComment		Comment
    hi! link javaScriptLogicSymbols Purple
    hi! link javaScriptMathStaticMethod Blue
    hi! link javaScriptMember		Keyword
    hi! link javaScriptMember Blue
    hi! link javaScriptMessage		Keyword
    hi! link javaScriptNodeGlobal Blue
    hi! link javaScriptNull			Keyword
    hi! link javaScriptNumber		Float
    hi! link javaScriptObjectLabel Blue
    hi! link javaScriptOperator		Operator
    hi! link javaScriptParens Blue
    hi! link javaScriptPropertyName Blue
    hi! link javaScriptRegexpString		String
    hi! link javaScriptRepeat		Repeat
    hi! link javaScriptReserved		Keyword
    hi! link javaScriptSpecial		Special
    hi! link javaScriptSpecialCharacter	javaScriptSpecial
    hi! link javaScriptStatement		Statement
    hi! link javaScriptStringD		String
    hi! link javaScriptStringMethod Blue
    hi! link javaScriptStringS		String
    hi! link javaScriptStringT		String
    hi! link javaScriptTemplateSB Aqua
    hi! link javaScriptTemplateSubstitution Blue
    hi! link javaScriptType			Type
    hi! link javaScriptURLUtilsProp Blue
    hi! link javaScriptVariable Orange
    hi! link javaScriptValue javaScriptVariable
    hi! link javaScriptYield Red
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

  " TypeScript:
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

  " React:
    hi! link jsxTagName Aqua
    hi! link jsxComponentName Green
    hi! link jsxCloseString LightGrey
    hi! link jsxAttrib Yellow
    hi! link jsxEqual Aqua

    hi! link purescriptModuleKeyword Aqua
    hi! link purescriptModuleName Blue
    hi! link purescriptWhere Aqua
    hi! link purescriptDelimiter WhiteBold
    hi! link purescriptType WhiteBold
    hi! link purescriptImportKeyword Aqua
    hi! link purescriptHidingKeyword Aqua
    hi! link purescriptAsKeyword Aqua
    hi! link purescriptStructure Aqua
    hi! link purescriptOperator Orange
    hi! link purescriptTypeVar WhiteBold
    hi! link purescriptConstructor WhiteBold
    hi! link purescriptFunction WhiteBold
    hi! link purescriptConditional Orange
    hi! link purescriptBacktick Orange

    hi! link coffeeExtendedOp Orange
    hi! link coffeeSpecialOp WhiteBold
    hi! link coffeeDotAccess Grey
    hi! link coffeeCurly Orange
    hi! link coffeeParen WhiteBold
    hi! link coffeeBracket Orange

    hi! link javaAnnotation Blue
    hi! link javaDocTags Aqua
    hi! link javaParen SpecialComment
    hi! link javaParen1 javaParen
    hi! link javaParen2 javaParen
    hi! link javaParen3 javaParen
    hi! link javaParen4 javaParen
    hi! link javaParen5 javaParen
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

  " Lua:
    hi! link luaBlock Green
    hi! link luaElseifThen Orange
    hi! link luaFunction Aqua
    hi! link luaIfThen Green
    hi! link luaIn Red
    hi! link luaLoopBlock Blue
    hi! link luaParen Operator
    hi! link luaStatement Aqua
    hi! link luaTable Orange
    hi! link luaTableBlock Delimiter
    hi! link luaThenEnd Purple

    hi! link moonExtendedOp Orange
    hi! link moonFunction WhiteBold
    hi! link moonObject Yellow
    hi! link moonSpecialOp WhiteBold

  " Other:
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
    hi! link clojureParen WhiteBold
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

    hi! link scalaNameDefinition WhiteBold
    hi! link scalaCaseFollowing WhiteBold
    hi! link scalaCapitalWord WhiteBold
    hi! link scalaTypeExtension WhiteBold
    hi! link scalaKeyword Red
    hi! link scalaKeywordModifier Red
    hi! link scalaSpecial Aqua
    hi! link scalaOperator Orange
    hi! link scalaTypeDeclaration Yellow
    hi! link scalaTypeTypePostDeclaration Yellow
    hi! link scalaInstanceDeclaration WhiteBold
    hi! link scalaInterpolation Aqua

    hi! link haskellType Blue
    hi! link haskellIdentifier Aqua
    hi! link haskellSeparator LightGrey
    hi! link haskellDelimiter WhiteBold
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
    hi! link haskellRecursiveDo Purple
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

    hi! link yamlKey Aqua
    hi! link yamlConstant Purple

    hi! link tomlTable Orange
    hi! link tomlTableArray Orange
    hi! link tomlKey WhiteBold

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
    hi! link mailSignature WhiteBold
    hi! link mailURL Orange
    hi! link mailEmail Orange

    hi! link csBraces WhiteBold
    hi! link csEndColon WhiteBold
    hi! link csLogicSymbols Purple
    hi! link csParens WhiteBold
    hi! link csOpSymbols Orange
    hi! link csInterpolationDelimiter Aqua
    hi! link csInterpolationFormat Aqua
    hi! link csInterpolationAlignDel AquaBold
    hi! link csInterpolationFormatDel AquaBold

    hi! link zshVariableDef Blue
    hi! link zshSubst Orange
    hi! link zshOptStart Orange
    hi! link zshOption Aqua
    hi! link zshFunction Green

    hi! link objcDirective Blue
    hi! link objcTypeModifier Red

" Vim: set fdls=0 fdm=indent:
