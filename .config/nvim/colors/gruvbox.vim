" -----------------------------------------------------------------------------
" File: gruvbox.vim
" Description: Retro groove color scheme for Vim
" Maintainer: Faris Chugthai
" Previous Maintainer: morhetz <morhetz@gmail.com>
" Original Source: https://github.com/morhetz/gruvbox
" Last Modified: Jul 13, 2019
" -----------------------------------------------------------------------------

" Go to line 475 for where it starts
" Guards: {{{
if exists('g:did_gruvbox_colors') || &compatible || v:version < 700
    finish
endif
" let g:did_gruvbox_colors = 1

scriptencoding utf8

let s:cpo_save = &cpoptions
set cpoptions-=C
" }}}

" Supporting Code: -------------------------------------------------------- {{{
" Initialisation: {{{

if v:version > 580
  hi clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name='gruvbox'

" }}}
" Global Settings: {{{

if !exists('g:gruvbox_bold')
  let g:gruvbox_bold = 1
endif

if !exists('g:gruvbox_italic')
  if has('gui_running') || $TERM_ITALICS ==? 'true'
    let g:gruvbox_italic = 1
  else
    let g:gruvbox_italic = 0
  endif
endif

if !exists('g:gruvbox_undercurl')
  let g:gruvbox_undercurl=1
endif

if !exists('g:gruvbox_underline')
  let g:gruvbox_underline=1
endif

if !exists('g:gruvbox_inverse')
  let g:gruvbox_inverse=1
endif

if !exists('g:gruvbox_guisp_fallback') || index(['fg', 'bg'], g:gruvbox_guisp_fallback) == -1
  let g:gruvbox_guisp_fallback='NONE'
endif

if !exists('g:gruvbox_termcolors')
  let g:gruvbox_termcolors=256
endif

if !exists('g:gruvbox_invert_indent_guides')
  let g:gruvbox_invert_indent_guides=0
endif

if exists('g:gruvbox_contrast')
  echo 'g:gruvbox_contrast is deprecated; use g:gruvbox_contrast_light and g:gruvbox_contrast_dark instead'
endif

if !exists('g:gruvbox_contrast_dark')
  let g:gruvbox_contrast_dark='medium'
elseif !exists('g:gruvbox_contrast_light')
  let g:gruvbox_contrast_light='medium'
endif

let s:is_dark=(&background ==? 'dark')

" }}}
" The actual color pallette: {{{

" setup palette dictionary
let s:gb = {}

" fill it with absolute colors
let s:gb.dark0_hard  = ['#1d2021', 234]     " 29-32-33
let s:gb.dark0       = ['#1d2021', 234]     " 40-40-40
let s:gb.dark0_soft  = ['#32302f', 236]     " 50-48-47
let s:gb.dark1       = ['#3c3836', 237]     " 60-56-54
let s:gb.dark2       = ['#504945', 239]     " 80-73-69
let s:gb.dark3       = ['#665c54', 241]     " 102-92-84
let s:gb.dark4       = ['#7c6f64', 243]     " 124-111-100
let s:gb.dark4_256   = ['#7c6f64', 243]     " 124-111-100

" These 2 are comment string colors. If you wanna see a variation
" on how bright or dark that colors is go here and check it out
" http://www.0to255.com/928374
let s:gb.gray_245    = ['#928374', 245]     " 146-131-116
let s:gb.gray_244    = ['#928374', 244]     " 146-131-116

let s:gb.light0_hard = ['#f9f5d7', 230]     " 249-245-215
let s:gb.light0      = ['#fbf1c7', 229]     " 253-244-193
let s:gb.light0_soft = ['#f2e5bc', 228]     " 242-229-188
let s:gb.light1      = ['#ebdbb2', 223]     " 235-219-178
let s:gb.light2      = ['#d5c4a1', 250]     " 213-196-161
let s:gb.light3      = ['#bdae93', 248]     " 189-174-147
let s:gb.light4      = ['#a89984', 246]     " 168-153-132
let s:gb.light4_256  = ['#a89984', 246]     " 168-153-132

let s:gb.bright_red     = ['#fb4934', 167]     " 251-73-52
let s:gb.bright_green   = ['#b8bb26', 142]     " 184-187-38
let s:gb.bright_yellow  = ['#fabd2f', 214]     " 250-189-47
let s:gb.bright_blue    = ['#83a598', 109]     " 131-165-152
let s:gb.bright_purple  = ['#d3869b', 175]     " 211-134-155
" let s:gb.bright_aqua    = ['#8ec07c', 108]     " 142-192-124
" Yo but honestly the bright aqua is green. 142-192-224 is way more aqua
" Sorry i don't know how to figure out what the corresponding 0-255 value is
let s:gb.bright_aqua    = ['#8ec0e1', 108]     " 142-192-224
let s:gb.bright_orange  = ['#fe8019', 208]     " 254-128-25

let s:gb.neutral_red    = ['#cc241d', 124]     " 204-36-29
let s:gb.neutral_green  = ['#98971a', 106]     " 152-151-26
let s:gb.neutral_yellow = ['#d79921', 172]     " 215-153-33
let s:gb.neutral_blue   = ['#458588', 66]      " 69-133-136
let s:gb.neutral_purple = ['#b16286', 132]     " 177-98-134
let s:gb.neutral_aqua   = ['#689d6a', 72]      " 104-157-106
let s:gb.neutral_orange = ['#d65d0e', 166]     " 214-93-14

let s:gb.faded_red      = ['#9d0006', 88]      " 157-0-6
let s:gb.faded_green    = ['#79740e', 100]     " 121-116-14
let s:gb.faded_yellow   = ['#b57614', 136]     " 181-118-20
let s:gb.faded_blue     = ['#076678', 24]      " 7-102-120
let s:gb.faded_purple   = ['#8f3f71', 96]      " 143-63-113
let s:gb.faded_aqua     = ['#427b58', 66]      " 66-123-88
let s:gb.faded_orange   = ['#af3a03', 130]     " 175-58-3

" }}}
" Setup Emphasis Options: {{{

let s:bold = 'bold,'
if g:gruvbox_bold == 0
  let s:bold = ''
endif

let s:italic = 'italic,'
if g:gruvbox_italic == 0
  let s:italic = ''
endif

let s:underline = 'underline,'
if g:gruvbox_underline == 0
  let s:underline = ''
endif

let s:undercurl = 'undercurl,'
if g:gruvbox_undercurl == 0
  let s:undercurl = ''
endif

let s:inverse = 'inverse,'
if g:gruvbox_inverse == 0
  let s:inverse = ''
endif

" }}}
" Map s:vars to s:vars: {{{

let s:vim_bg = ['bg', 'bg']
let s:vim_fg = ['fg', 'fg']
let s:none = ['NONE', 'NONE']

" determine relative colors
if s:is_dark
  let s:bg0  = s:gb.dark0
  if g:gruvbox_contrast_dark ==? 'soft'
    let s:bg0  = s:gb.dark0_soft
  elseif g:gruvbox_contrast_dark ==? 'hard'
    let s:bg0  = s:gb.dark0_hard
  endif

  let s:bg1  = s:gb.dark1
  let s:bg2  = s:gb.dark2
  let s:bg3  = s:gb.dark3
  let s:bg4  = s:gb.dark4

  let s:gray = s:gb.gray_245

  let s:fg0 = s:gb.light0
  let s:fg1 = s:gb.light1
  let s:fg2 = s:gb.light2
  let s:fg3 = s:gb.light3
  let s:fg4 = s:gb.light4

  let s:fg4_256 = s:gb.light4_256

  let s:red    = s:gb.bright_red
  let s:green  = s:gb.bright_green
  let s:yellow = s:gb.bright_yellow
  let s:blue   = s:gb.bright_blue
  let s:purple = s:gb.bright_purple
  let s:aqua   = s:gb.bright_aqua
  let s:orange = s:gb.bright_orange
else
  let s:bg0  = s:gb.light0
  if g:gruvbox_contrast_light ==? 'soft'
    let s:bg0  = s:gb.light0_soft
  elseif g:gruvbox_contrast_light ==? 'hard'
    let s:bg0  = s:gb.light0_hard
  endif

  let s:bg1  = s:gb.light1
  let s:bg2  = s:gb.light2
  let s:bg3  = s:gb.light3
  let s:bg4  = s:gb.light4

  let s:gray = s:gb.gray_244

  let s:fg0 = s:gb.dark0
  let s:fg1 = s:gb.dark1
  let s:fg2 = s:gb.dark2
  let s:fg3 = s:gb.dark3
  let s:fg4 = s:gb.dark4

  let s:fg4_256 = s:gb.dark4_256

  let s:red    = s:gb.faded_red
  " 06/08/2019: This is showing up white on WSL...?
  " GruvboxGreenBold xxx cterm=bold ctermfg=142 gui=bold guifg=#b8bb26

  let s:green  = s:gb.faded_green
  let s:yellow = s:gb.faded_yellow
  let s:blue   = s:gb.faded_blue
  let s:purple = s:gb.faded_purple
  let s:aqua   = s:gb.faded_aqua
  let s:orange = s:gb.faded_orange
endif

" reset to 16 colors fallback
if g:gruvbox_termcolors == 16
  let s:bg0[1]    = 0
  let s:fg4[1]    = 7
  let s:gray[1]   = 8
  let s:red[1]    = 9
  let s:green[1]  = 10
  let s:yellow[1] = 11
  let s:blue[1]   = 12
  let s:purple[1] = 13
  let s:aqua[1]   = 14
  let s:fg1[1]    = 15
endif

" save current relative colors back to palette dictionary
let s:gb.bg0 = s:bg0
let s:gb.bg1 = s:bg1
let s:gb.bg2 = s:bg2
let s:gb.bg3 = s:bg3
let s:gb.bg4 = s:bg4

let s:gb.gray = s:gray

let s:gb.fg0 = s:fg0
let s:gb.fg1 = s:fg1
let s:gb.fg2 = s:fg2
let s:gb.fg3 = s:fg3
let s:gb.fg4 = s:fg4

let s:gb.fg4_256 = s:fg4_256

let s:gb.red    = s:red
let s:gb.green  = s:green
let s:gb.yellow = s:yellow
let s:gb.blue   = s:blue
let s:gb.purple = s:purple
let s:gb.aqua   = s:aqua
let s:gb.orange = s:orange

" }}}
" Setup Terminal Colors For Neovim: {{{

let g:terminal_ansi_colors = ['#1d2021', '#cc241d', '#98971a', '#d79921',
      \ '#458588', '#b16286', '#689d6a', '#a89984', '#928374', '#fb4934',
      \ '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#ebdbb2']
if has('nvim')
  let g:terminal_color_0 = '#1d2021'
  let g:terminal_color_1 = '#cc241d'
  let g:terminal_color_2 = '#98971a'
  let g:terminal_color_3 = '#d79921'
  let g:terminal_color_4 = '#458588'
  let g:terminal_color_5 = '#b16286'
  let g:terminal_color_6 = '#689d6a'
  let g:terminal_color_7 = '#a89984'
  let g:terminal_color_8 = '#928374'
  let g:terminal_color_9 = '#fb4934'
  let g:terminal_color_10 = '#b8bb26'
  let g:terminal_color_11 = '#fabd2f'
  let g:terminal_color_12 = '#83a598'
  let g:terminal_color_13 = '#d3869b'
  let g:terminal_color_14 = '#8ec07c'
  let g:terminal_color_15 = '#ebdbb2'
endif

" }}}
" Override Default Settings: {{{

let s:hls_cursor = s:orange
if exists('g:gruvbox_hls_cursor')
  let s:hls_cursor = get(s:gb, g:gruvbox_hls_cursor)
endif

let s:number_column = s:none
if exists('g:gruvbox_number_column')
  let s:number_column = get(s:gb, g:gruvbox_number_column)
endif

let s:sign_column = s:bg1

if exists('g:gitgutter_override_sign_column_highlight') &&
      \ g:gitgutter_override_sign_column_highlight == 1
  let s:sign_column = s:number_column
else
  let g:gitgutter_override_sign_column_highlight = 0

  if exists('g:gruvbox_sign_column')
    let s:sign_column = get(s:gb, g:gruvbox_sign_column)
  endif
endif

let s:color_column = s:bg1
if exists('g:gruvbox_color_column')
  let s:color_column = get(s:gb, g:gruvbox_color_column)
endif

let s:vert_split = s:bg0
if exists('g:gruvbox_vert_split')
  let s:vert_split = get(s:gb, g:gruvbox_vert_split)
endif

let s:invert_signs = ''
if exists('g:gruvbox_invert_signs')
  if g:gruvbox_invert_signs == 1
    let s:invert_signs = s:inverse
  endif
endif

let s:invert_selection = s:inverse
if exists('g:gruvbox_invert_selection')
  if g:gruvbox_invert_selection == 0
    let s:invert_selection = ''
  endif
endif

let s:invert_tabline = ''
if exists('g:gruvbox_invert_tabline')
  if g:gruvbox_invert_tabline == 1
    let s:invert_tabline = s:inverse
  endif
endif

let s:italicize_comments = s:italic
if exists('g:gruvbox_italicize_comments')
  if g:gruvbox_italicize_comments == 0
    let s:italicize_comments = ''
  endif
endif

let s:italicize_strings = ''
if exists('g:gruvbox_italicize_strings')
  if g:gruvbox_italicize_strings == 1
    let s:italicize_strings = s:italic
  endif
endif

" }}}
" Highlighting Function: {{{

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  " foreground
  let fg = a:fg

  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:none
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'NONE,'
  endif

  " special fallback
  if a:0 >= 3
    if g:gruvbox_guisp_fallback !=? 'NONE'
      let fg = a:3
    endif

    " bg fallback mode should invert higlighting
    if g:gruvbox_guisp_fallback ==? 'bg'
      let emstr .= 'inverse,'
    endif
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
        \ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
        \ 'gui=' . emstr[:-2], 'cterm=' . emstr[:-2]
        \ ]

  " special
  if a:0 >= 3
    call add(histring, 'guisp=' . a:3[0])
  endif

  execute join(histring, ' ')
endfunction

" }}}
" Gruvbox Hi Groups: {{{

" memoize common hi groups
" call s:HL('GruvboxFg0', s:fg0)
hi GruvboxFg0 ctermfg=229 guifg=#fbf1c7 gui=NONE cterm=NONE guisp=NONE ctermbg=NONE guibg=NONE
call s:HL('GruvboxFg1', s:fg1)
call s:HL('GruvboxFg2', s:fg2)
call s:HL('GruvboxFg3', s:fg3)
call s:HL('GruvboxFg4', s:fg4)
call s:HL('GruvboxGray', s:gray)
call s:HL('GruvboxBg0', s:bg0)
call s:HL('GruvboxBg1', s:bg1)
call s:HL('GruvboxBg2', s:bg2)
call s:HL('GruvboxBg3', s:bg3)
call s:HL('GruvboxBg4', s:bg4)

call s:HL('GruvboxRed', s:red)
call s:HL('GruvboxRedBold', s:red, s:none, s:bold)
call s:HL('GruvboxGreen', s:green)
call s:HL('GruvboxGreenBold', s:green, s:none, s:bold)
call s:HL('GruvboxYellow', s:yellow)
call s:HL('GruvboxYellowBold', s:yellow, s:none, s:bold)
" call s:HL('GruvboxBlue', s:blue)
hi GruvboxBlue ctermfg=109 guifg=#83a598 guibg=NONE ctermbg=NONE guisp=NONE gui=NONE cterm=NONE
" call s:HL('GruvboxBlue', s:blue)
" Mostly green?
" call s:HL('GruvboxBlue', s:blue)
call s:HL('GruvboxBlueBold', s:blue, s:none, s:bold)
call s:HL('GruvboxPurple', s:purple)
call s:HL('GruvboxPurpleBold', s:purple, s:none, s:bold)
" Aqua is the real blue
" call s:HL('GruvboxAqua', s:aqua)
hi GruvboxAqua ctermfg=108 guifg=#8ec0e1 cterm=bold gui=bold ctermfg=108 guifg=#8ec0e1
" call s:HL('GruvboxAquaBold', s:aqua, s:none, s:bold)
call s:HL('GruvboxOrange', s:orange)
call s:HL('GruvboxOrangeBold', s:orange, s:none, s:bold)

call s:HL('GruvboxRedSign', s:red, s:sign_column, s:invert_signs)
call s:HL('GruvboxGreenSign', s:green, s:sign_column, s:invert_signs)
call s:HL('GruvboxYellowSign', s:yellow, s:sign_column, s:invert_signs)
call s:HL('GruvboxBlueSign', s:blue, s:sign_column, s:invert_signs)
call s:HL('GruvboxPurpleSign', s:purple, s:sign_column, s:invert_signs)
call s:HL('GruvboxAquaSign', s:aqua, s:sign_column, s:invert_signs)

" }}}
" }}}
" Vanilla colorscheme ------------------------------------------------------ {{{

" General UI: {{{

if s:is_dark
  set background=dark
else
  set background=light
endif

if v:version >= 700
" }}}
" Completions: {{{
    hi Pmenu guifg=#ebdbb2 guibg=#504945 guisp=NONE gui=NONE cterm=NONE ctermfg=237 ctermbg=187
    hi PmenuSbar guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=187
    hi PmenuSel guifg=#504945 guibg=#83a598 guisp=NONE gui=bold cterm=bold ctermfg=187 ctermbg=23
    hi PmenuThumb guifg=NONE guibg=#7c6f64 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=137
  " }}}
" Cursorline And Tabline: {{{
  " Screen line that the cursor is
  " call s:HL('CursorLine',   s:none, s:bg1)
  hi CursorLine ctermbg=237 guibg=#3c3836 guifg=NONE ctermfg=NONE cterm=NONE gui=NONE guisp=NONE

  " Line number of CursorLine
  " call s:HL('CursorLineNr', s:yellow, s:bg1)
  hi CursorLineNr guifg=#fabd2f guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE ctermbg=237

  " Screen column that the cursor is
  hi! link CursorColumn CursorLine

  " Tab pages line filler
  " call s:HL('TabLineFill', s:bg4, s:bg1, s:invert_tabline)
  hi TablineFill ctermfg=243 ctermbg=237 guifg=#7c6f64 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE

  " Active tab page label
  " call s:HL('TabLineSel', s:green, s:bg1, s:invert_tabline)
  hi TabLineSel ctermfg=142 ctermbg=237 guifg=#b8bb26 guibg=#3c3836 cterm=NONE gui=NONE guisp=NONE

  " Not active tab page label. Can you add stuff after the fact?
  hi! link TabLine TabLineFill

  " Match paired bracket under the cursor
  " call s:HL('MatchParen', s:none, s:bg3, s:bold)
  hi MatchParen cterm=bold ctermbg=241 gui=bold guibg=#665c54 
endif

" Moved cursor things up to be with the cursorlines:

" Character under cursor
hi Cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
" call s:HL('Cursor', s:none, s:none, s:inverse)

" Visual mode cursor, selection
hi! link vCursor Cursor

" Input moder cursor
hi! link iCursor Cursor

" Language mapping cursor
hi! link lCursor Cursor

if v:version >= 703

  " Highlighted screen columns
  " call s:HL('ColorColumn',  s:none, s:color_column)
  hi ColorColumn ctermbg=237 guibg=#3c3836 ctermfg=NONE guifg=NONE cterm=NONE gui=NONE guisp=None

  " Concealed element: \lambda → λ
  " call s:HL('Conceal', s:blue, s:none)
  hi Conceal guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermbg=NONE
  " ALTERNATIVE:
  " hi Conceal guifg=#076678 guibg=NONE guisp=NONE gui=NONE cterm=NONE

endif

" }}}
" Unsorted highlight groups: {{{
" Normal text
hi Normal ctermfg=223 ctermbg=234 guifg=#ebdbb2 guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE
hi NormalNC ctermfg=223 ctermbg=234 guifg=#ebdbb2 guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE

" hi! link NonText GruvboxBg2
hi NonText guifg=#d5c4a1 guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=239 ctermbg=NONE

" call s:HL('Visual',    s:none,  s:bg3, s:invert_selection)
hi Visual cterm=reverse gui=reverse guisp=NONE ctermbg=241 ctermfg=NONE guibg=#665c54 guifg=NONE

hi default link VisualNOS Visual
hi default link VisualNC Visual

" call s:HL('Search',    s:yellow, s:bg0, s:inverse)
hi Search cterm=reverse ctermfg=214 ctermbg=234 gui=reverse guifg=#fabd2f guibg=#1d2021

" call s:HL('IncSearch', s:hls_cursor, s:bg0, s:inverse)
hi IncSearch cterm=reverse ctermfg=208 ctermbg=234 gui=reverse guifg=#fe8019 guibg=#1d2021

" call s:HL('Underlined', s:blue, s:none, s:underline)
" hi Underlined cterm=underline ctermfg=109 gui=underline guifg=#83a598
" ALTERNATIVE:
hi Underlined cterm=underline ctermfg=23 gui=underline guifg=#83a598 ctermbg=NONE guisp=NONE guibg=NONE

" call s:HL('StatusLine',   s:bg2, s:fg1, s:inverse)
hi StatusLine guifg=#504945 guibg=#ebdbb2 guisp=NONE gui=reverse cterm=reverse ctermfg=239 ctermbg=223

" call s:HL('StatusLineNC', s:bg1, s:fg4, s:inverse)
hi StatusLineNC guifg=#3c3836 guibg=#a89984 guisp=NONE gui=reverse cterm=reverse ctermfg=237 ctermbg=246
hi! link StatusLineTerm StatusLine

" The column separating vertically split windows
" call s:HL('VertSplit', s:bg3, s:vert_split)
" TODO: cterms?
hi VertSplit guifg=#665c54 guibg=#1d2021 guisp=NONE gui=NONE cterm=NONE

" Current match in wildmenu completion
" call s:HL('WildMenu', s:blue, s:bg2, s:bold)
hi WildMenu guifg=#83a598 guibg=#504945 guisp=NONE gui=bold cterm=bold

" Titles for output from :set all, :autocmd, etc.
" hi! link Title GruvboxGreenBold
" DUDE DON"T UNDERLINE ITS SO HARD TO READ IN RST
hi Title guifg=#b8bb26 guibg=NONE guisp=NONE gui=bold cterm=bold ctermfg=100 ctermbg=NONE

hi Directory guifg=#79740e guibg=NONE guisp=NONE gui=bold cterm=bold

" Error messages on the command line
" call s:HL('rrror', s:aqua, s:vim_bg, s:inverse)
hi Error guibg=NONE ctermfg=108 ctermbg=234 gui=reverse,bold,italic cterm=bold,italic,reverse guifg=#8ec0e1

" call s:HL('ErrorMsg',   s:bg0, s:red, s:bold)
hi ErrorMsg cterm=bold,italic,reverse ctermfg=234 ctermbg=167 gui=bold,italic,reverse guifg=#1d2021 guibg=#fb4934

" try, catch, throw
" hi! link Exception GruvboxRed
hi Exception ctermfg=167 guifg=#fb4934 ctermbg=NONE guibg=NONE gui=BOLD cterm=BOLD
" hi ModeMsg guifg=#b57614 guibg=NONE guisp=NONE gui=bold cterm=bold
" hi MoreMsg guifg=#b57614 guibg=NONE guisp=NONE gui=bold cterm=bold

" I have GruvboxYellowBold as  cterm=bold ctermfg=214 gui=bold guifg=#fabd2f 
" More prompt: -- More --
hi! link MoreMsg GruvboxYellowBold
" Current mode message: -- INSERT --
hi! link ModeMsg GruvboxYellowBold
" 'Press enter' prompt and yes/no questions
hi! link Question GruvboxOrangeBold
" Warning messages
hi! link WarningMsg GruvboxRedBold

hi! link Quote              Question
hi! link Noise              Question
" }}}
" Missing Highlight Groups: {{{

" Sep 23, 2019: Realized allllll these were missing
hi SpecialChar guifg=#fb4934 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi SpecialComment guifg=#fb4934 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi SpecialKey ctermfg=81 guifg=#504945 ctermbg=NONE guibg=NONE gui=NONE cterm=NONE guisp=NONE

hi Ignore guifg=fg guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi CursorIM guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
hi ToolbarLine guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
hi ToolbarButton guifg=#fbf1c7 guibg=#665c54 guisp=NONE gui=bold cterm=bold
hi NormalMode guifg=#a89984 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
hi InsertMode guifg=#83a598 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
hi ReplaceMode guifg=#8ec07c guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
hi VisualMode guifg=#fe8019 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
hi CommandMode guifg=#d3869b guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
hi Warnings guifg=#fe8019 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse
" Damn where did delimiter go?
hi Delimiter guifg=#fe8019 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi EndOfBuffer guifg=#f9f5d7 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi IncSearch guifg=#af3a03 guibg=#f9f5d7 guisp=NONE gui=reverse cterm=reverse

" }}}
" Gutter: {{{

" Line number for :number and :# commands
" call s:HL('LineNr', s:bg4, s:number_column)
" hi LineNr guifg=#a89984 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi LineNr guifg=#7c6f64 guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermbg=NONE ctermfg=137

" Column where signs are displayed
" call s:HL('SignColumn', s:none, s:sign_column)
hi SignColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE ctermfg=NONE ctermbg=237

" Line used for closed folds
" call s:HL('Folded', s:gray, s:bg1, s:italic)
hi Folded cterm=italic ctermfg=245 ctermbg=237 gui=italic guifg=#928374 guibg=#3c3836

" Column where folds are displayed
" call s:HL('FoldColumn', s:gray, s:bg1)
hi FoldColumn  guibg=NONE guisp=NONE gui=NONE ctermfg=245 ctermbg=237 guibg=#3c3836 guifg=#928374

" Preprocessor #define
" hi! link Define GruvboxAqua
hi Define guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=108 ctermbg=NONE

hi Debug guifg=#fb4934 guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermbg=NONE ctermfg=124
" }}}
" Syntax Highlighting: {{{

" call s:HL('Special', s:orange, s:none, s:italicize_strings)
hi Special cterm=italic ctermfg=208 ctermbg=bg gui=italic guifg=#fe8019 guibg=bg
hi! link Tag Special

hi Comment cterm=italic ctermfg=245 gui=italic guifg=#928374 ctermbg=NONE guibg=NONE
" call s:HL('Comment', s:gray, s:none, s:italicize_comments)

" call s:HL('Todo', s:vim_fg, s:vim_bg, s:bold . s:italic)
hi Todo cterm=bold,italic ctermfg=NONE ctermbg=NONE gui=bold,italic guifg=NONE guibg=NONE

" Generic statement
" hi! link Statement GruvboxRed
hi Statement  ctermfg=167 guifg=#fb4934 ctermbg=NONE guibg=NONE

" if, then, else, endif, switch, etc.
" hi! link Conditional GruvboxRed
hi Conditional ctermfg=167 guifg=#fb4934 ctermbg=NONE guibg=NONE

" for, do, while, etc.
" hi! link Repeat GruvboxRed
hi Repeat ctermfg=167 guifg=#fb4934 ctermbg=NONE guibg=NONE

" case, default, etc.
" hi! link Label GruvboxRed
hi Label ctermfg=167 guifg=#fb4934 ctermbg=NONE guibg=NONE

" sizeof, "+", "*", etc.
" hi! link Operator GruvboxRed
hi Operator ctermfg=167 guifg=#fb4934 ctermbg=NONE guibg=NONE

" Any other keyword
" hi! link Keyword GruvboxRed
hi Keyword ctermfg=167 guifg=#fb4934 ctermbg=NONE guibg=NONE

" Variable name
" hi! link Identifier GruvboxBlue
hi Identifier ctermfg=172 ctermbg=229 guifg=#83a598

" hi! link IdentifierBold GruvboxBlueBold
hi IdentifierBold ctermfg=172 ctermbg=229 cterm=bold gui=bold guisp=NONE guifg=#83a598

" Function name
" hi! link Function GruvboxGreenBold
hi Function cterm=bold ctermfg=142 gui=bold guifg=#b8bb26 ctermbg=NONE guibg=NONE

" Generic preprocessor
" hi! link PreProc GruvboxAqua
hi PreProc guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=108 ctermbg=NONE

" Preprocessor #include
" hi! link Include GruvboxAqua
hi Include guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=108 ctermbg=NONE

" Same as Define
" hi! link Macro GruvboxAqua
hi Macro guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=108 ctermbg=NONE

" Preprocessor #if, #else, #endif, etc.
" hi! link PreCondit GruvboxAqua
hi PreCondit guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=108 ctermbg=NONE

" Generic constant
" hi! link Constant GruvboxPurple
hi Constant ctermfg=13 ctermbg=NONE guifg=#ffa0a0 guibg=NONE guisp=NONE gui=NONE cterm=NONE

" Character constant: 'c', '/n'
" hi! link Character GruvboxPurple
hi Character ctermfg=13 ctermbg=NONE guifg=#ffa0a0 guibg=NONE guisp=NONE gui=NONE cterm=NONE

" String constant: "this is a string"
" call s:HL('String',  s:green, s:none, s:italicize_strings)
" actually looks weird as shit don't do that
" hi String ctermfg=13 ctermbg=NONE guifg=#ffa0a0 guibg=NONE
hi String ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE gui=italic

hi Boolean ctermfg=13 ctermbg=NONE guifg=#ffa0a0 guibg=NONE guisp=NONE gui=NONE cterm=NONE
" hi! link Boolean GruvboxPurple
hi Number ctermfg=13 ctermbg=NONE guifg=#ffa0a0 guibg=NONE guisp=NONE gui=NONE cterm=NONE
" Number constant: 234, 0xff
" hi! link Number GruvboxPurple
hi Float ctermfg=13 ctermbg=NONE guifg=#ffa0a0 guibg=NONE guisp=NONE gui=NONE cterm=NONE
" Floating point constant: 2.3e10
" hi! link Float GruvboxPurple

" Generic type
" hi! link Type GruvboxYellow
" uhhh that's a great brigt neon green but horrible for TYPE...btw apparently
" that's like our most used color lol
" hi Type ctermbg=NONE guibg=NONE guisp=NONE ctermfg=121 gui=bold guifg=#60ff60    
hi Type guifg=#fabd2f guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=214 ctermbg=NONE

" static, register, volatile, etc
" let's make them natch types
" hi! link StorageClass GruvboxOrange
hi StorageClass ctermfg=214 guifg=#fabd2f guisp=NONE gui=NONE cterm=NONE

" struct, union, enum, etc.
" hi! link Structure GruvboxAqua
hi Structure guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=29 ctermbg=NONE

" typedef
" hi! link Typedef GruvboxYellow
hi Typedef guifg=#fabd2f guibg=NONE guisp=NONE gui=NONE cterm=NONE ctermfg=172

" }}}
" Diffs: {{{

hi DiffAdd guifg=#b8bb26 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=100 ctermbg=229
hi DiffChange guifg=#8ec07c guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=29 ctermbg=229
hi DiffDelete guifg=#fb4934 guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=124 ctermbg=229
hi DiffText guifg=#fabd2f guibg=#1d2021 guisp=NONE gui=reverse cterm=reverse ctermfg=172 ctermbg=229
" }}}
" Other: {{{
" What the hell are these?
" RedrawDebugClear xxx ctermbg=11 guibg=Yellow
" RedrawDebugComposed xxx ctermbg=10 guibg=Green 
" RedrawDebugNormal xxx cterm=reverse gui=reverse        
" RedrawDebugRecompose xxx ctermbg=9 guibg=Red 

" Spelling: {{{
" Don't add guisp=blue that shit looks weird and confusing
" call s:HL('SpellCap',   s:none, s:none, s:undercurl, s:red)
" call s:HL('SpellCap',   s:green, s:none, s:bold . s:italic)
hi SpellCap cterm=underline,italic ctermfg=109 gui=undercurl,italic guifg=NONE ctermbg=NONE guisp=NONE

" Not recognized word
" Let's go with GruvboxBlueSign
hi SpellBad gui=undercurl cterm=undercurl ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836

" call s:HL('SpellBad',   s:none, s:none, s:undercurl, s:blue)
hi SpellBad gui=undercurl cterm=undercurl ctermfg=109 ctermbg=237 guibg=#3c3836 guifg=#fb4934

" Wrong spelling for selected region
" call s:HL('SpellLocal', s:none, s:none, s:undercurl, s:aqua)
hi SpellLocal guifg=#8ec07c guibg=NONE guisp=#8ec07c gui=italic,undercurl cterm=italic,undercurl

" Rare word
" call s:HL('SpellRare',  s:none, s:none, s:undercurl, s:purple)
hi SpellRare guifg=#d3869b guibg=NONE guisp=#d3869b gui=italic,undercurl cterm=italic,undercurl


" }}}
" }}}
" }}}
" Plugin specific -------------------------------------------------------- {{{
" AKA Plugins You Don't Have: {{{

if 0
  " EasyMotion: {{{

  hi! link EasyMotionTarget Search
  hi! link EasyMotionShade Comment

  " }}}
  " Sneak: {{{

  hi! link Sneak Search
  hi! link SneakLabel Search

  " }}}
  " Indent Guides: {{{

  if !exists('g:indent_guides_auto_colors')
    let g:indent_guides_auto_colors = 0
  endif

  if g:indent_guides_auto_colors == 0
    if g:gruvbox_invert_indent_guides == 0
      call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2)
      call s:HL('IndentGuidesEven', s:vim_bg, s:bg1)
    else
      call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2, s:inverse)
      call s:HL('IndentGuidesEven', s:vim_bg, s:bg3, s:inverse)
    endif
  endif

  " }}}
  " IndentLine: {{{

  if !exists('g:indentLine_color_term')
    let g:indentLine_color_term = s:bg2[1]
  endif
  if !exists('g:indentLine_color_gui')
    let g:indentLine_color_gui = s:bg2[0]
  endif

  " }}}
  " Rainbow Parentheses: {{{

  if !exists('g:rbpt_colorpairs')
    let g:rbpt_colorpairs =
      \ [
        \ ['blue', '#458588'], ['magenta', '#b16286'],
        \ ['red',  '#cc241d'], ['166',     '#d65d0e']
      \ ]
  endif

  let g:rainbow_guifgs = [ '#d65d0e', '#cc241d', '#b16286', '#458588' ]
  let g:rainbow_ctermfgs = [ '166', 'red', 'magenta', 'blue' ]

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

  "}}}
  " Syntastic: {{{

  call s:HL('SyntasticError', s:none, s:none, s:undercurl, s:red)
  call s:HL('SyntasticWarning', s:none, s:none, s:undercurl, s:yellow)

  hi! link SyntasticErrorSign GruvboxRedSign
  hi! link SyntasticWarningSign GruvboxYellowSign

  " }}}
  " Signature: {{{
  hi! link SignatureMarkText   GruvboxBlueSign
  hi! link SignatureMarkerText GruvboxPurpleSign

  " }}}
  " ShowMarks: {{{

  hi! link ShowMarksHLl GruvboxBlueSign
  hi! link ShowMarksHLu GruvboxBlueSign
  hi! link ShowMarksHLo GruvboxBlueSign
  hi! link ShowMarksHLm GruvboxBlueSign

  " }}}
  " CtrlP: {{{

  hi! link CtrlPMatch GruvboxYellow
  hi! link CtrlPNoEntries GruvboxRed
  hi! link CtrlPPrtBase GruvboxBg2
  hi! link CtrlPPrtCursor GruvboxBlue
  hi! link CtrlPLinePre GruvboxBg2

  call s:HL('CtrlPMode1', s:blue, s:bg2, s:bold)
  call s:HL('CtrlPMode2', s:bg0, s:blue, s:bold)
  call s:HL('CtrlPStats', s:fg4, s:bg2, s:bold)

  " }}}
  " Vimshell: {{{

  let g:vimshell_escape_colors = [
    \ s:bg4[0], s:red[0], s:green[0], s:yellow[0],
    \ s:blue[0], s:purple[0], s:aqua[0], s:fg4[0],
    \ s:bg0[0], s:red[0], s:green[0], s:orange[0],
    \ s:blue[0], s:purple[0], s:aqua[0], s:fg0[0]
    \ ]

  " }}}
  " BufTabLine: {{{

  call s:HL('BufTabLineCurrent', s:bg0, s:fg4)
  call s:HL('BufTabLineActive', s:fg4, s:bg2)
  call s:HL('BufTabLineHidden', s:bg4, s:bg1)
  call s:HL('BufTabLineFill', s:bg0, s:bg0)

  " }}}
  " Dirvish: {{{

  hi! link DirvishPathTail GruvboxAqua
  hi! link DirvishArg GruvboxYellow

  " }}}
" Vim Multiple Cursors: {{{

call s:HL('multiple_cursors_cursor', s:none, s:none, s:inverse)
call s:HL('multiple_cursors_visual', s:none, s:bg2)

" }}}
endif
" }}}
" Plugins You Have: {{{

" Jesus. Here are the plugins you currently have. We'll figure out a smarter way
" to check if the plugin actually exists another time.

" Aug 10, 2019: Well now we need to define a few more

" Coc: {{{

" CocListBlackBlack	CocListBlackBlack
" CocListBlackBlue	CocListBlackBlue
" CocListBlackGreen	CocListBlackGreen
" CocListBlackGrey	CocListBlackGrey
" CocListBlackWhite	CocListBlackWhite
" CocListBlackCyan	CocListBlackCyan
" CocListBlackYellow	CocListBlackYellow
" CocListBlackMagenta	CocListBlackMagenta
" CocListBlackRed	CocListBlackRed
" CocListFgBlack	CocListFgBlack
" CocListBgBlack	CocListBgBlack
" CocListBlueBlack	CocListBlueBlack
" CocListBlueBlue	CocListBlueBlue
" CocListBlueGreen	CocListBlueGreen
" CocListBlueGrey	CocListBlueGrey
" CocListBlueWhite	CocListBlueWhite
" CocListBlueCyan	CocListBlueCyan
" CocListBlueYellow	CocListBlueYellow
" CocListBlueMagenta	CocListBlueMagenta
" CocListBlueRed	CocListBlueRed
" CocListFgBlue	CocListFgBlue
" CocListBgBlue	CocListBgBlue
" CocListGreenBlack	CocListGreenBlack
" CocListGreenBlue	CocListGreenBlue
" CocListGreenGreen	CocListGreenGreen
" CocListGreenGrey	CocListGreenGrey
" CocListGreenWhite	CocListGreenWhite
" CocListGreenCyan	CocListGreenCyan
" CocListGreenYellow	CocListGreenYellow
" CocListGreenMagenta	CocListGreenMagenta
" CocListGreenRed	CocListGreenRed
" CocListFgGreen	CocListFgGreen
" CocListBgGreen	CocListBgGreen
" CocListGreyBlack	CocListGreyBlack
" CocListGreyBlue	CocListGreyBlue
" CocListGreyGreen	CocListGreyGreen
" CocListGreyGrey	CocListGreyGrey
" CocListGreyWhite	CocListGreyWhite
" CocListGreyCyan	CocListGreyCyan
" CocListGreyYellow	CocListGreyYellow
" CocListGreyMagenta	CocListGreyMagenta
" CocListGreyRed	CocListGreyRed
" CocListFgGrey	CocListFgGrey
" CocListBgGrey	CocListBgGrey
" CocListWhiteBlack	CocListWhiteBlack
" CocListWhiteBlue	CocListWhiteBlue
" CocListWhiteGreen	CocListWhiteGreen
" CocListWhiteGrey	CocListWhiteGrey
" CocListWhiteWhite	CocListWhiteWhite
" CocListWhiteCyan	CocListWhiteCyan
" CocListWhiteYellow	CocListWhiteYellow
" CocListWhiteMagenta	CocListWhiteMagenta
" CocListWhiteRed	CocListWhiteRed
" CocListFgWhite	CocListFgWhite
" CocListBgWhite	CocListBgWhite
" CocListCyanBlack	CocListCyanBlack
" CocListCyanBlue	CocListCyanBlue
" CocListCyanGreen	CocListCyanGreen
" CocListCyanGrey	CocListCyanGrey
" CocListCyanWhite	CocListCyanWhite
" CocListCyanCyan	CocListCyanCyan
" CocListCyanYellow	CocListCyanYellow
" CocListCyanMagenta	CocListCyanMagenta
" CocListCyanRed	CocListCyanRed
" CocListFgCyan	CocListFgCyan
" CocListBgCyan	CocListBgCyan
" CocListYellowBlack	CocListYellowBlack
" CocListYellowBlue	CocListYellowBlue
" CocListYellowGreen	CocListYellowGreen
" CocListYellowGrey	CocListYellowGrey
" CocListYellowWhite	CocListYellowWhite
" CocListYellowCyan	CocListYellowCyan
" CocListYellowYellow	CocListYellowYellow
" CocListYellowMagenta	CocListYellowMagenta
" CocListYellowRed	CocListYellowRed
" CocListFgYellow	CocListFgYellow
" CocListBgYellow	CocListBgYellow
" CocListMagentaBlack	CocListMagentaBlack
" CocListMagentaBlue	CocListMagentaBlue
" CocListMagentaGreen	CocListMagentaGreen
" CocListMagentaGrey	CocListMagentaGrey
" CocListMagentaWhite	CocListMagentaWhite
" CocListMagentaCyan	CocListMagentaCyan
" CocListMagentaYellow	CocListMagentaYellow
" CocListMagentaMagenta	CocListMagentaMagenta
" CocListMagentaRed	CocListMagentaRed
" CocListFgMagenta	CocListFgMagenta
" CocListBgMagenta	CocListBgMagenta
" CocListRedBlack	CocListRedBlack
" CocListRedBlue	CocListRedBlue
" CocListRedGreen	CocListRedGreen
" CocListRedGrey	CocListRedGrey
" CocListRedWhite	CocListRedWhite
" CocListRedCyan	CocListRedCyan
" CocListRedYellow	CocListRedYellow
" CocListRedMagenta	CocListRedMagenta
" CocListRedRed	CocListRedRed
" CocListFgRed	CocListFgRed
" CocListBgRed	CocListBgRed
"CocCodeLens
" CocCursorRange 
" CocErrorFloat                                          
" CocErrorSign                                         
" CocErrorVirtualText                                
" CocGitAddedSign                              
" CocGitChangeRemovedSign                      
" CocGitChangedSign                            
" CocGitRemovedSign                            
" CocGitTopRemovedSign
" CocHighlightRead                             
" CocHighlightText                             
" CocHighlightWrite                            
" CocHintFloat                                 
" CocHintHighlight                             
" CocHintSign                                   
" CocHintVirtualText
" CocInfoFloat                                 
" CocInfoHighlight
" CocInfoVirtualText
hi default link CocErrorLine Exception
hi default link CocWarningLine WarningMsg
hi default link CocInfoLine GruvboxBlueSign
hi default link CocHintLine GruvboxGreenSign
hi default link CocSelectedLine Visual

" Override one of his...actually now a few
hi! link CocInfoSign GruvboxPurpleSign
hi! link CocErrorHighlight GruvboxRedSign
hi! link CocWarningHighlight GruvboxOrangeBold
hi! link CocInfoHighlight GruvboxBlueSign
hi! link CocHintHighlight GruvboxGreenSign
hi! link CocGitAddedSign GruvboxYellowBold
hi! link CocCodeLens GruvboxAquaSign
hi! link CocErrorSign GruvboxRedSign
hi! link CocWarningSign GruvboxGreenSign
hi! link CocHintFloat Float
hi! link CocHintSign GruvboxAquaSign
hi! link CocSelectedText Search
hi! link CocUnderline Underlined
hi! link CocListFgYellow GruvboxYellow
hi! link CocListFgBlue GruvboxBlue
hi! link CocListFgGreen GruvboxGreen
hi! link CocListFgGrey GruvboxBg4
hi! link CocListBgGrey GruvboxBg0

hi! link CocListFgRed GruvboxRed
hi! link CocListFgYellow GruvboxYellow
hi! link CocListFgCyan GruvboxAqua

" Ooo its a good idea to define the pum
" CocFloating

" }}}

  " Signify: {{{

  hi! link SignifySignAdd GruvboxGreenSign
  hi! link SignifySignChange GruvboxAquaSign
  hi! link SignifySignDelete GruvboxRedSign

  " }}}
" Startify: {{{

hi! link StartifyBracket GruvboxFg3
hi! link StartifyFile GruvboxFg1
hi! link StartifyNumber GruvboxBlue
hi! link StartifyPath GruvboxGray
hi! link StartifySlash GruvboxGray
hi! link StartifySection GruvboxYellow
hi! link StartifySpecial GruvboxBlue
hi! link StartifyHeader GruvboxOrange
hi! link StartifyFooter GruvboxBg2

" }}}
" NERDTree: {{{

hi NERDTreeCWD guifg=#b8bb26 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeClosable guifg=#fe8019 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeDir guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeDirSlash guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeExecFile guifg=#fabd2f guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeFile guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeHelp guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeOpenable guifg=#fe8019 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeToggleOff guifg=#fb4934 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeToggleOn guifg=#b8bb26 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi NERDTreeUp guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE

" }}}
" Asynchronous Lint Engine: {{{

" call s:HL('ALEError', s:none, s:none, s:undercurl, s:red)
" call s:HL('ALEWarning', s:none, s:none, s:undercurl, s:yellow)
" call s:HL('ALEInfo', s:none, s:none, s:undercurl, s:blue)

hi! link ALEErrorSign GruvboxRedSign
hi! link ALEWarningSign GruvboxYellowSign
hi! link ALEInfoSign GruvboxBlueSign
hi! link ALEError GruvboxOrangeBold
hi! link ALEWarning GruvboxYellowBold
hi! link ALEInfo GruvboxBlueBold
" }}}
" GitGutter: {{{

hi! link GitGutterAdd GruvboxGreenSign
hi! link GitGutterChange GruvboxAquaSign
hi! link GitGutterDelete GruvboxRedSign
hi! link GitGutterChangeDelete GruvboxAquaSign

" }}}
" GitCommit: "{{{
" Do I have this plugin? Is this a fugitive thing?
hi! link gitcommitSelectedFile GruvboxGreen
hi! link gitcommitDiscardedFile GruvboxRed

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
" }}}" }}}}
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
hi! link manCError GruvboxRed
hi! link manEmail GruvboxAqua
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

hi! link netrwDir GruvboxAqua
hi! link netrwClassify GruvboxAqua
hi! link netrwLink GruvboxGray
hi! link netrwSymLink GruvboxAqua
hi! link netrwExe GruvboxYellow
hi! link netrwComment GruvboxGray
hi! link netrwList GruvboxBlue
hi! link netrwHelpCmd GruvboxAqua
hi! link netrwCmdSep GruvboxFg3
hi! link netrwVersion GruvboxGreen

" }}}
" Rst: {{{ TODO
" Ugh this hasn't been implemented at all and riv keeps overtaking random syn groups

hi! link rstDirectivesh     Question
hi! link rstDirectivepython Question
hi! link rstInlineLiteral Identifier

" Well heres the built in syntax file
hi def link rstCitation                     String
hi def link rstCitationReference            Identifier
hi def link rstCodeBlock                    String
hi def link rstComment                      Comment
hi def link rstDelimiter                    Delimiter
hi def link rstDirective                    Keyword
hi def link rstDoctestBlock                 PreProc
hi def link rstExDirective                  String
hi def link rstExplicitMarkup               rstDirective
hi def link rstFileLink rstHyperlinkReference
hi def link rstFootnote                     String
hi def link rstFootnoteReference            Identifier
hi def link rstHyperLinkReference           Identifier
hi def link rstHyperlinkTarget              String
hi def link rstInlineInternalTargets        Identifier
hi def link rstInlineLiteral                String
hi def link rstInterpretedTextOrHyperlinkReference  Identifier
hi def link rstLiteralBlock                 String
hi def link rstQuotedLiteralBlock           String
hi def link rstSections                     Title
hi def link rstSimpleTableLines             rstTableLines
hi def link rstStandaloneHyperlink          Identifier
hi def link rstSubstitutionDefinition       rstDirective
hi def link rstSubstitutionReference        PreProc
hi def link rstTableLines                   rstDelimiter
hi def link rstTodo                         Todo
hi def link rstTransition                   rstSections
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

" }}}
" Diff: {{{

hi! link diffAdded GruvboxGreen
hi! link diffRemoved GruvboxRed
hi! link diffChanged GruvboxAqua

hi! link diffFile GruvboxOrange
hi! link diffNewFile GruvboxYellow

hi! link diffLine GruvboxBlue

" }}}
" Html: {{{

hi! link htmlTag GruvboxBlue
hi! link htmlEndTag GruvboxBlue

hi! link htmlTagName GruvboxAquaBold
hi! link htmlArg GruvboxAqua

hi! link htmlScriptTag GruvboxPurple
" Literally why is this Fg1. Filepaths inside of <> change colors randomly
hi! link htmlTagN GruvboxBlue
hi! link htmlSpecialTagName GruvboxAquaBold

call s:HL('htmlLink', s:fg4, s:none, s:underline)

hi! link htmlSpecialChar GruvboxOrange

call s:HL('htmlBold', s:vim_fg, s:vim_bg, s:bold)
call s:HL('htmlBoldUnderline', s:vim_fg, s:vim_bg, s:bold . s:underline)
call s:HL('htmlBoldItalic', s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('htmlBoldUnderlineItalic', s:vim_fg, s:vim_bg, s:bold . s:underline . s:italic)

call s:HL('htmlUnderline', s:vim_fg, s:vim_bg, s:underline)
call s:HL('htmlUnderlineItalic', s:vim_fg, s:vim_bg, s:underline . s:italic)
call s:HL('htmlItalic', s:vim_fg, s:vim_bg, s:italic)

" }}}
" Xml: {{{

hi! link xmlTag GruvboxBlue
hi! link xmlEndTag GruvboxBlue
hi! link xmlTagName GruvboxBlue
hi! link xmlEqual GruvboxBlue
hi! link docbkKeyword GruvboxAquaBold

hi! link xmlDocTypeDecl GruvboxGray
hi! link xmlDocTypeKeyword GruvboxPurple
hi! link xmlCdataStart GruvboxGray
hi! link xmlCdataCdata GruvboxPurple
hi! link dtdFunction GruvboxGray
hi! link dtdTagName GruvboxPurple

hi! link xmlAttrib GruvboxAqua
hi! link xmlProcessingDelim GruvboxGray
hi! link dtdParamEntityPunct GruvboxGray
hi! link dtdParamEntityDPunct GruvboxGray
hi! link xmlAttribPunct GruvboxGray

hi! link xmlEntity GruvboxOrange
hi! link xmlEntityPunct GruvboxOrange
" }}}
" Vim: {{{ TODO
" Defined In Syntax File: {{{
hi! link vimAbb	vimCommand
hi! link vimAddress	vimMark
hi! link vimAuHighlight	vimHighlight
hi! link vimAugroupError	vimError
hi! link vimAugroupKey	vimCommand
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
hi! link vimUserFunc	Normal
hi! link vimVar	Identifier
hi! link vimWarn	WarningMsg

" }}}
" And yours: {{{
" Vim Errors: {{{
hi def link vimBehaveError	vimError
hi def link vimBufnrWarn	vimWarn
hi def link vimCollClassErr	vimError
hi def link vimEmbedError	vimError
hi def link vimErrSetting	vimError
hi def link vimFTError	vimError
hi def link vimFunc         	vimError
hi def link vimFuncBody Function
hi def link vimFunctionError	vimError
hi def link vimHiAttribList	vimError
hi def link vimHiCtermError	vimError
hi def link vimHiKeyError	vimError
hi def link vimKeyCodeError	vimError
hi def link vimMapModErr	vimError
hi def link vimSubstFlagErr	vimError
hi def link vimSynCaseError	vimError
hi link vimSynError Exception

" }}}
" Nvim Specific: {{{

if has('nvim')
  " How does a nice light blue sound?
  hi! NvimInternalError guibg=NONE ctermfg=108 ctermbg=234 gui=reverse guifg=#8ec0e1 guibg=bg             
  hi def link nvimAutoEvent	vimAutoEvent
  hi def link nvimHLGroup	vimHLGroup
  hi link nvimInvalid Exception
  hi def link nvimMap	vimMap
  hi def link nvimUnmap	vimUnmap

  hi! link TermCursor Cursor
  hi TermCursorNC ctermfg=237 ctermbg=187 guifg=#3c3836 guibg=#ebdbb2 guisp=NONE cterm=NONE gui=NONE
endif


" }}}

" Here's everything from VIMRUNTIME/syntax/vim.vim:
" vimAuSyntax	vimAuSyntax

" The last letter of an autocmd like wth
highlight default link vimAugroup	vimAugroupKey
" vimAutoCmdSfxList	vimAutoCmdSfxList
" vimAutoCmdSpace	vimAutoCmdSpace
" Lmao the comma between BufEnter,BufReadPre
hi default link vimAutoEventList vimAutoEvent
" vimClusterName	vimClusterName
hi default link vimCmdSep vimCommand
" vimCollClass	vimCollClass
" vimCollClassErr	vimCollClassErr
" vimCollection	vimCollection
hi default link vimCommentTitleLeader	vimCommentTitle
hi default link vimEcho	String
" vimErrSetting	vimErrSetting
" vimEscapeBrace	vimEscapeBrace
" vimExecute	vimExecute
" hi def link vimExecute 
" vimExtCmd	vimExtCmd
" vimFiletype	vimFiletype
" vimFilter	vimFilter
" vimFuncBlank	vimFuncBlank
" vimGlobal	vimGlobal
" vimGroupList	vimGroupList
" vimHiAttribList	vimHiAttribList
" vimHiCtermColor	vimHiCtermColor
" vimHiFontname	vimHiFontname
" vimHiGuiFontname	vimHiGuiFontname
" vimHiKeyList	vimHiKeyList
" vimHiLink	vimHiLink
" vimHiTermcap	vimHiTermcap
" vimIskList	vimIskList
" vimLuaRegion	vimLuaRegion
" vimMapModErr	vimMapModErr

" Vim notation was the only reason that mappings were getting highlighted
" Randomly they wouldn't
hi default link vimMapLhs vimNotation
hi default link vimMapRhs vimNotation
hi default link vimMapRhsExtend	vimNotation
" vimMenuBang	vimMenuBang
" vimMenuMap	vimMenuMap
" vimMenuPriority	vimMenuPriority
" vimMenuRhs	vimMenuRhs
" vimNormCmds	vimNormCmds
" vimOnlyHLGroup	vimOnlyHLGroup
hi default link vimOnlyCommand vimCommand
hi default link vimOnlyOption GruvboxGreen
" vimOperParen	vimOperParen
" vimPatRegion	vimPatRegion
" vimRegion	vimRegion
hi default link vimSet vimSetEqual

" There's a highlighting group for the equals sign in a set option statement...
hi default link vimSetEqual	Operator
" vimSubst2	vimSubst2
" vimSubstFlagErr	vimSubstFlagErr
" vimSubstPat	vimSubstPat
" vimSubstRange	vimSubstRange
" vimSubstRep	vimSubstRep
" vimSubstRep4	vimSubstRep4
" vimSynKeyRegion	vimSynKeyRegion
" vimSynLine	vimSynLine
" vimSynMatchRegion	vimSynMatchRegion
hi def link vimHiAttribList vimHighlight
" vimSynMtchCchar	vimSynMtchCchar
" vimSynMtchGroup	vimSynMtchGroup
" vimSynPatMod	vimSynPatMod
hi def link vimSynRegion Visual
" vimSynRegion	vimSynRegion
" vimSyncLinebreak	vimSyncLinebreak
" vimSyncLinecont	vimSyncLinecont
" vimSyncLines	vimSyncLines
hi def link vimSyncLines Number
" vimSyncMatch	vimSyncMatch
" vimSyncRegion	vimSyncRegion
" vimTermOption	vimTermOption
" Here are a few more xxx cleared syn groups

hi def link vimPythonRegion Identifier
" }}}
" }}}
" Clojure: {{{

hi! link clojureKeyword GruvboxBlue
hi! link clojureCond GruvboxOrange
hi! link clojureSpecial GruvboxOrange
hi! link clojureDefine GruvboxOrange

hi! link clojureFunc GruvboxYellow
hi! link clojureRepeat GruvboxYellow
hi! link clojureCharacter GruvboxAqua
hi! link clojureStringEscape GruvboxAqua
hi! link clojureException GruvboxRed

hi! link clojureRegexp GruvboxAqua
hi! link clojureRegexpEscape GruvboxAqua
call s:HL('clojureRegexpCharClass', s:fg3, s:none, s:bold)
hi! link clojureRegexpMod clojureRegexpCharClass
hi! link clojureRegexpQuantifier clojureRegexpCharClass

hi! link clojureParen GruvboxFg3
hi! link clojureAnonArg GruvboxYellow
hi! link clojureVariable GruvboxBlue
hi! link clojureMacro GruvboxOrange

hi! link clojureMeta GruvboxYellow
hi! link clojureDeref GruvboxYellow
hi! link clojureQuote GruvboxYellow
hi! link clojureUnquote GruvboxYellow

" }}}
" C: {{{

hi! link cOperator GruvboxPurple
hi! link cStructure GruvboxOrange

" }}}
" Python: {{{
" Idk why it seems so many aren't linked anymore.
hi default link pythonMatrixMultiply Number
hi def link pythonAttribute Identifier
hi def link pythonComment Comment
hi def link pythonAsync Statement
hi def link pythonNumber Number

hi! link pythonBoolean GruvboxPurple
hi! link pythonBuiltin GruvboxOrange
hi! link pythonBuiltinFunc GruvboxOrange
hi! link pythonBuiltinObj GruvboxOrange
hi! link pythonCoding Identifier
hi! link pythonConditional GruvboxRed
hi! link pythonDecorator GruvboxRed
hi! link pythonDot GruvboxFg3
hi! link pythonDottedName GruvboxGreenBold
hi! link pythonException GruvboxRedBold
hi! link pythonExceptions GruvboxPurple
hi! link pythonFunction GruvboxAqua
hi! link pythonImport Identifier
hi! link pythonInclude Identifier
hi! link pythonOperator GruvboxRed
hi! link pythonRepeat GruvboxRed
hi! link pythonRun Identifier
hi! link pythonSync IdentifierBold

" }}}
" CSS: {{{

" Literally why the hell is everything aqua
hi! link cssAnimationProp GruvboxAqua
hi! link cssBackgroundProp GruvboxAqua
hi! link cssBorderOutlineProp GruvboxAqua
hi! link cssBoxProp GruvboxAqua
hi! link cssBraces GruvboxBlue
hi! link cssClassName GruvboxGreen
hi! link cssColor GruvboxBlue
hi! link cssColorProp GruvboxAqua
hi! link cssDimensionProp GruvboxAqua
hi! link cssFlexibleBoxProp GruvboxAqua
hi! link cssFontDescriptorProp GruvboxAqua
hi! link cssFontProp GruvboxAqua
hi! link cssFunctionName GruvboxYellow
hi! link cssGeneratedContentProp GruvboxAqua
hi! link cssIdentifier GruvboxOrange
hi! link cssImportant GruvboxGreen
hi! link cssListProp GruvboxAqua
hi! link cssMarginProp GruvboxAqua
hi! link cssPaddingProp GruvboxAqua
hi! link cssPositioningProp GruvboxYellow
hi! link cssPrintProp GruvboxAqua
hi! link cssRenderProp GruvboxAqua
hi link cssSelectorOp Tag
" hi! link cssSelectorOp GruvboxBlue
hi! link cssSelectorOp2 GruvboxBlue
hi! link cssTableProp GruvboxAqua
hi! link cssTextProp GruvboxAqua
hi! link cssTransformProp GruvboxAqua
hi! link cssTransitionProp GruvboxAqua
hi! link cssUIProp GruvboxYellow
hi! link cssVendor GruvboxFg1

" }}}
" JavaScript: {{{

hi! link javaScriptBraces GruvboxFg0
hi! link javaScriptFunction GruvboxAqua
hi! link javaScriptIdentifier GruvboxRed
hi! link javaScriptMember GruvboxBlue
hi! link javaScriptNull GruvboxPurple
hi! link javaScriptNumber GruvboxPurple
hi! link javaScriptParens GruvboxFg3


" Wait who fucked up the casing here???
hi! link javascriptArrayMethod GruvboxFg2
hi! link javascriptArrayStaticMethod GruvboxFg2
hi! link javascriptArrowFunc GruvboxYellow
hi! link javascriptAsyncFunc GruvboxAqua
hi! link javascriptAsyncFuncKeyword GruvboxRed
hi! link javascriptAwaitFuncKeyword GruvboxRed
hi! link javascriptBOMLocationMethod GruvboxFg2
hi! link javascriptBOMNavigatorProp GruvboxFg2
hi! link javascriptBOMWindowMethod GruvboxFg2
hi! link javascriptBOMWindowProp GruvboxFg2
hi! link javascriptBrackets GruvboxFg0
hi! link javascriptCacheMethod GruvboxFg2
hi! link javascriptClassExtends GruvboxAqua
hi! link javascriptClassKeyword GruvboxAqua
hi! link javascriptClassName GruvboxYellow
hi! link javascriptClassStatic GruvboxOrange
hi! link javascriptClassSuper GruvboxOrange
hi! link javascriptClassSuperName GruvboxYellow
hi! link javascriptDOMDocMethod GruvboxFg2
hi! link javascriptDOMDocProp GruvboxFg2
hi! link javascriptDOMElemAttrs GruvboxFg0
hi! link javascriptDOMEventMethod GruvboxFg0
hi! link javascriptDOMNodeMethod GruvboxFg0
hi! link javascriptDOMStorageMethod GruvboxFg0
hi! link javascriptDateMethod GruvboxFg2
hi! link javascriptDefault GruvboxAqua
hi! link javascriptDocNamedParamType GruvboxFg4
hi! link javascriptDocNotation GruvboxFg4
hi! link javascriptDocParamName GruvboxFg4
hi! link javascriptDocTags GruvboxFg4
hi! link javascriptEndColons GruvboxFg2
hi! link javascriptExceptions GruvboxRed
hi! link javascriptExport GruvboxAqua
hi! link javascriptForOperator GruvboxRed
hi! link javascriptFuncArg GruvboxFg2
hi! link javascriptFuncKeyword GruvboxAqua
hi! link javascriptGlobal GruvboxYellow
hi! link javascriptGlobalMethod GruvboxFg2
hi! link javascriptHeadersMethod GruvboxFg0
hi! link javascriptIdentifier GruvboxOrange
hi! link javascriptImport GruvboxAqua
hi! link javascriptLabel GruvboxBlue
hi! link javascriptLogicSymbols GruvboxFg0
hi! link javascriptMathStaticMethod GruvboxFg2
hi! link javascriptMessage GruvboxRed
hi! link javascriptNodeGlobal GruvboxFg2
hi! link javascriptObjectLabel GruvboxBlue
hi! link javascriptOperator GruvboxRed
hi! link javascriptProp GruvboxFg2
hi! link javascriptPropertyName GruvboxBlue
hi! link javascriptStringMethod GruvboxFg2
hi! link javascriptTemplateSB GruvboxAqua
hi! link javascriptTemplateSubstitution GruvboxFg0
hi! link javascriptURLUtilsProp GruvboxFg2
hi! link javascriptVariable GruvboxRed
hi! link javascriptYield GruvboxRed

" From the vim syn file

hi def link javaScriptComment		Comment
hi def link javaScriptLineComment		Comment
hi def link javaScriptCommentTodo		Todo
hi def link javaScriptSpecial		Special
hi def link javaScriptStringS		String
hi def link javaScriptStringD		String
hi def link javaScriptStringT		String
hi def link javaScriptCharacter		Character
hi def link javaScriptSpecialCharacter	javaScriptSpecial
hi def link javaScriptNumber		javaScriptValue
hi def link javaScriptConditional		Conditional
hi def link javaScriptRepeat		Repeat
hi def link javaScriptBranch		Conditional
hi def link javaScriptOperator		Operator
hi def link javaScriptType			Type
hi def link javaScriptStatement		Statement
hi def link javaScriptFunction		Function
hi def link javaScriptBraces		Function
hi def link javaScriptError		Error
hi def link javaScrParenError		javaScriptError
hi def link javaScriptNull			Keyword
hi def link javaScriptBoolean		Boolean
hi def link javaScriptRegexpString		String

hi def link javaScriptIdentifier		Identifier
hi def link javaScriptLabel		Label
hi def link javaScriptException		Exception
hi def link javaScriptMessage		Keyword
hi def link javaScriptGlobal		Keyword
hi def link javaScriptMember		Keyword
hi def link javaScriptDeprecated		Exception 
hi def link javaScriptReserved		Keyword
hi def link javaScriptDebug		Debug
hi def link javaScriptConstant		Label
hi def link javaScriptEmbed		Special

" }}}
" PanglossJS: {{{

hi! link jsClassKeyword GruvboxAqua
hi! link jsExtendsKeyword GruvboxAqua
hi! link jsExportDefault GruvboxAqua
hi! link jsTemplateBraces GruvboxAqua
hi! link jsGlobalNodeObjects GruvboxFg1
hi! link jsGlobalObjects GruvboxFg1
hi! link jsFunction GruvboxAqua
hi! link jsFuncParens GruvboxFg3
hi! link jsParens GruvboxFg3
hi! link jsNull GruvboxPurple
hi! link jsUndefined GruvboxPurple
hi! link jsClassDefinition GruvboxYellow

" }}}
" TypeScript: {{{

hi! link typeScriptReserved GruvboxAqua
hi! link typeScriptLabel GruvboxAqua
hi! link typeScriptFuncKeyword GruvboxAqua
hi! link typeScriptIdentifier GruvboxOrange
hi! link typeScriptBraces GruvboxFg1
hi! link typeScriptEndColons GruvboxFg1
hi! link typeScriptDOMObjects GruvboxFg1
hi! link typeScriptAjaxMethods GruvboxFg1
hi! link typeScriptLogicSymbols GruvboxFg1
hi! link typeScriptDocSeeTag Comment
hi! link typeScriptDocParam Comment
hi! link typeScriptDocTags vimCommentTitle
hi! link typeScriptGlobalObjects GruvboxFg1
hi! link typeScriptParens GruvboxFg3
hi! link typeScriptOpSymbols GruvboxFg3
hi! link typeScriptHtmlElemProperties GruvboxFg1
hi! link typeScriptNull GruvboxPurple
hi! link typeScriptInterpolationDelimiter GruvboxAqua

" }}}
" PureScript: {{{

hi! link purescriptModuleKeyword GruvboxAqua
hi! link purescriptModuleName GruvboxFg1
hi! link purescriptWhere GruvboxAqua
hi! link purescriptDelimiter GruvboxFg4
hi! link purescriptType GruvboxFg1
hi! link purescriptImportKeyword GruvboxAqua
hi! link purescriptHidingKeyword GruvboxAqua
hi! link purescriptAsKeyword GruvboxAqua
hi! link purescriptStructure GruvboxAqua
hi! link purescriptOperator GruvboxBlue

hi! link purescriptTypeVar GruvboxFg1
hi! link purescriptConstructor GruvboxFg1
hi! link purescriptFunction GruvboxFg1
hi! link purescriptConditional GruvboxOrange
hi! link purescriptBacktick GruvboxOrange

" }}}
" CoffeeScript: {{{

hi! link coffeeExtendedOp GruvboxFg3
hi! link coffeeSpecialOp GruvboxFg3
hi! link coffeeCurly GruvboxOrange
hi! link coffeeParen GruvboxFg3
hi! link coffeeBracket GruvboxOrange

" }}}
" React: {{{
"
hi jsxRegion guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxTagName guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxComponentName guifg=#fabd2f guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxEndComponentName guifg=#fabd2f guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxEscapeJsAttributes guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxEscapeJsContent guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxAttrib guifg=#fabd2f guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxAttributeBraces guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxEqual guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxString guifg=#b8bb26 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxCloseTag guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxEndTag guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxEndString guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxCloseString guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxIfOperator guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxElseOperator guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxDot guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxNamespace guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxPunct guifg=#8ec07c guibg=NONE guisp=NONE gui=NONE cterm=NONE
hi jsxRegion ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxTagName ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxComponentName ctermfg=172 ctermbg=NONE cterm=NONE
hi jsxEndComponentName ctermfg=172 ctermbg=NONE cterm=NONE
hi jsxEscapeJsAttributes ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxEscapeJsContent ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxAttrib ctermfg=172 ctermbg=NONE cterm=NONE
hi jsxAttributeBraces ctermfg=237 ctermbg=NONE cterm=NONE
hi jsxEqual ctermfg=29 ctermbg=NONE cterm=NONE
hi jsxString ctermfg=100 ctermbg=NONE cterm=NONE
hi jsxCloseTag ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxEndTag ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxEndString ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxCloseString ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxIfOperator ctermfg=29 ctermbg=NONE cterm=NONE
hi jsxElseOperator ctermfg=29 ctermbg=NONE cterm=NONE
hi jsxDot ctermfg=237 ctermbg=NONE cterm=NONE
hi jsxNamespace ctermfg=23 ctermbg=NONE cterm=NONE
hi jsxPunct ctermfg=29 ctermbg=NONE cterm=NONE

" }}}
" Ruby: {{{

hi! link rubyStringDelimiter GruvboxGreen
hi! link rubyInterpolationDelimiter GruvboxAqua
" So TPope defined all of these but they got wiped in the hi clear. So copy
" paste it is?
hi def link rubyASCIICode		Character
hi def link rubyBoolean			Boolean
hi def link rubyClass			rubyDefine
hi def link rubyConditional		Conditional
hi def link rubyConditionalModifier	rubyConditional
hi def link rubyControl			Statement
hi def link rubyDefine			Define
hi def link rubyException		Exception
hi def link rubyExceptional		rubyConditional
hi def link rubyFloat			Float
hi def link rubyFunction		Function
hi def link rubyInclude			Include
hi def link rubyInteger			Number
hi def link rubyMethodExceptional	rubyDefine
hi def link rubyModule			rubyDefine
hi def link rubyOptionalDo		rubyRepeat
hi def link rubyRepeat			Repeat
hi def link rubyRepeatModifier		rubyRepeat

if !exists('ruby_no_identifiers')
  hi def link rubyIdentifier		Identifier
else
  hi def link rubyIdentifier		NONE
endif

" hi def link rubyInterpolationDelimiter	Delimiter
" hi def link rubyStringDelimiter		Delimiter
hi def link rubyAccess			Statement
hi def link rubyAttribute		Statement
hi def link rubyBeginEnd		Statement
hi def link rubyBlockParameter		rubyIdentifier
hi def link rubyCapitalizedMethod	rubyLocalVariableOrMethod
hi def link rubyClassVariable		rubyIdentifier
hi def link rubyComment			Comment
hi def link rubyConstant		Type
hi def link rubyData			Comment
hi def link rubyDataDirective		Delimiter
hi def link rubyDocumentation		Comment
hi def link rubyError			Error
hi def link rubyEval			Statement
hi def link rubyGlobalVariable		rubyIdentifier
hi def link rubyHeredoc			rubyString
hi def link rubyInstanceVariable	rubyIdentifier
hi def link rubyInvalidVariable		Error
hi def link rubyKeyword			Keyword
hi def link rubyNoInterpolation		rubyString
hi def link rubyOperator		Operator
hi def link rubyPredefinedConstant	rubyPredefinedIdentifier
hi def link rubyPredefinedIdentifier	rubyIdentifier
hi def link rubyPredefinedVariable	rubyPredefinedIdentifier
hi def link rubyPseudoVariable		Constant
hi def link rubyQuoteEscape		rubyStringEscape
hi def link rubyRegexp			rubyString
hi def link rubyRegexpAnchor		rubyRegexpSpecial
hi def link rubyRegexpCharClass		rubyRegexpSpecial
hi def link rubyRegexpComment		Comment
hi def link rubyRegexpDelimiter		rubyStringDelimiter
hi def link rubyRegexpDot		rubyRegexpCharClass
hi def link rubyRegexpEscape		rubyRegexpSpecial
hi def link rubyRegexpQuantifier	rubyRegexpSpecial
hi def link rubyRegexpSpecial		Special
hi def link rubySharpBang		PreProc
hi def link rubySpaceError		rubyError
hi def link rubyString			String
hi def link rubyStringEscape		Special
hi def link rubySymbol			Constant
hi def link rubySymbolDelimiter		rubySymbol
hi def link rubyTodo			Todo

" }}}
" ObjectiveC: {{{

hi! link objcTypeModifier GruvboxRed
hi! link objcDirective GruvboxBlue

" }}}
" Go: {{{

hi! link goDirective GruvboxAqua
hi! link goConstants GruvboxPurple
hi! link goDeclaration GruvboxRed
hi! link goDeclType GruvboxBlue
hi! link goBuiltins GruvboxOrange

" }}}
" Lua: {{{

hi def link luaStatement		Statement
hi def link luaRepeat		Repeat
hi def link luaFor			Repeat
hi def link luaString		String
hi def link luaString2		String
hi def link luaNumber		Number
hi def link luaOperator		Operator
hi def link luaIn			Operator
hi def link luaConstant		Constant
hi def link luaCond		Conditional
hi def link luaElse		Conditional
hi def link luaFunction		Function
hi def link luaComment		Comment
hi def link luaTodo		Todo
hi def link luaTable		Structure
hi def link luaError		Error
hi def link luaParenError		Error
hi def link luaBraceError		Error
hi def link luaSpecial		SpecialChar
hi def link luaFunc		Identifier

" }}}
" MoonScript: {{{

hi! link moonSpecialOp GruvboxFg3
hi! link moonExtendedOp GruvboxFg3
hi! link moonFunction GruvboxFg3
hi! link moonObject GruvboxYellow

" }}}
" Java: {{{

hi! link javaAnnotation GruvboxBlue
hi! link javaDocTags GruvboxAqua
hi! link javaCommentTitle vimCommentTitle
hi! link javaParen GruvboxFg3
hi! link javaParen1 GruvboxFg3
hi! link javaParen2 GruvboxFg3
hi! link javaParen3 GruvboxFg3
hi! link javaParen4 GruvboxFg3
hi! link javaParen5 GruvboxFg3
hi! link javaOperator GruvboxOrange
hi! link javaVarArg GruvboxGreen

" }}}
" Elixir: {{{

hi! link elixirDocString Comment
hi! link elixirStringDelimiter GruvboxGreen
hi! link elixirInterpolationDelimiter GruvboxAqua
hi! link elixirModuleDeclaration GruvboxYellow

" }}}
" Scala: {{{

" NB: scala vim syntax file is kinda horrible
hi! link scalaNameDefinition GruvboxFg1
hi! link scalaCaseFollowing GruvboxFg1
hi! link scalaCapitalWord GruvboxFg1
hi! link scalaTypeExtension GruvboxFg1

hi! link scalaKeyword GruvboxRed
hi! link scalaKeywordModifier GruvboxRed

hi! link scalaSpecial GruvboxAqua
hi! link scalaOperator GruvboxFg1

hi! link scalaTypeDeclaration GruvboxYellow
hi! link scalaTypeTypePostDeclaration GruvboxYellow

hi! link scalaInstanceDeclaration GruvboxFg1
hi! link scalaInterpolation GruvboxAqua

" }}}
" Markdown: {{{

call s:HL('markdownItalic', s:fg3, s:none, s:italic)
hi! link markdownText Normal
hi! link markdownH1 GruvboxGreenBold
hi! link markdownH2 GruvboxGreenBold
hi! link markdownH3 GruvboxYellowBold
hi! link markdownH4 GruvboxYellowBold
hi! link markdownH5 GruvboxYellow
hi! link markdownH6 GruvboxYellow

hi! link markdownCode GruvboxAqua
hi! link markdownCodeBlock GruvboxAqua
hi! link markdownCodeDelimiter GruvboxAqua

hi! link markdownBlockquote GruvboxGray
hi! link markdownListMarker GruvboxGray
hi! link markdownOrderedListMarker GruvboxGray
hi! link markdownRule GruvboxGray
hi! link markdownHeadingRule GruvboxGray

hi! link markdownUrlDelimiter GruvboxFg3
hi! link markdownLinkDelimiter GruvboxFg3
hi! link markdownLinkTextDelimiter GruvboxFg3

hi! link markdownHeadingDelimiter GruvboxOrange
hi! link markdownUrl GruvboxPurple
hi! link markdownUrlTitleDelimiter GruvboxGreen

call s:HL('markdownLinkText', s:gray, s:none, s:underline)
hi! link markdownIdDeclaration markdownLinkText

" I hate the built-in definition of a markdown error so sorry
hi! link markdownError markdownText
" }}}
" Haskell: {{{

" hi! link haskellType GruvboxYellow
" hi! link haskellOperators GruvboxOrange
" hi! link haskellConditional GruvboxAqua
" hi! link haskellLet GruvboxOrange
hi! link haskellAssocType GruvboxAqua
hi! link haskellBacktick GruvboxOrange
hi! link haskellBlockKeywords GruvboxAqua
hi! link haskellBottom GruvboxAqua
hi! link haskellChar GruvboxGreen
hi! link haskellConditional GruvboxOrange
hi! link haskellDeclKeyword GruvboxAqua
hi! link haskellDefault GruvboxAqua
hi! link haskellDelimiter GruvboxFg4
hi! link haskellDeriving GruvboxAqua
hi! link haskellIdentifier GruvboxFg1
hi! link haskellImportKeywords GruvboxAqua
hi! link haskellLet GruvboxAqua
hi! link haskellNumber GruvboxPurple
hi! link haskellOperators GruvboxBlue
hi! link haskellPragma GruvboxPurple
hi! link haskellSeparator GruvboxFg1
hi! link haskellStatement GruvboxOrange
hi! link haskellString GruvboxGreen
hi! link haskellType GruvboxFg1
hi! link haskellWhere GruvboxAqua

" }}}
" Json: {{{

hi! link jsonBraces         Operator
hi! link jsonCommentError   NONE
hi! link jsonFold           Folded
hi! link jsonKeyword        Label
hi! link jsonKeywordMatch   Question
hi! link jsonQuote          GruvboxGreen
hi! link jsonString         String
hi! link jsonStringMatch    Question

" }}}
" Sh: {{{
hi def link bashAdminStatement	shStatement
hi def link bashSpecialVariables	shShellVariables
hi def link bashStatement		shStatement
hi def link shAlias		Identifier
hi def link shArithRegion	shShellVariables
hi def link shArithmetic		Special
hi def link shAstQuote	shDoubleQuote
hi def link shAtExpr	shSetList
hi def link shBQComment	shComment
hi def link shBeginHere	shRedir
hi def link shBkslshDblQuote	shDOubleQuote
hi def link shBkslshSnglQuote	shSingleQuote
hi def link shCaseBar	shConditional
hi def link shCaseCommandSub	shCommandSub
hi def link shCaseDoubleQuote	shDoubleQuote
hi def link shCaseError		Error
hi def link shCaseIn	shConditional
hi def link shCaseSingleQuote	shSingleQuote
hi def link shCaseStart	shConditional
hi def link shCharClass		Identifier
hi def link shCmdSubRegion	shShellVariables
hi def link shColon	shComment
hi def link shCommandSub		Special
hi def link shCommandSubBQ		shCommandSub
hi def link shComment		Comment
hi def link shCondError		Error
hi def link shConditional		Conditional
hi def link shCtrlSeq		Special
hi def link shCurlyError		Error
hi def link shDeref	shShellVariables
hi def link shDerefDelim	shOperator
hi def link shDerefLen		shDerefOff
hi def link shDerefOff		shDerefOp
hi def link shDerefOp	shOperator
hi def link shDerefOpError		Error
hi def link shDerefPOL	shDerefOp
hi def link shDerefPPS	shDerefOp
hi def link shDerefPSR	shDerefOp
hi def link shDerefSimple	shDeref
hi def link shDerefSpecial	shDeref
hi def link shDerefString	shDoubleQuote
hi def link shDerefVar	shDeref
hi def link shDerefWordError		Error
hi def link shDoError		Error
hi def link shDoubleQuote	shString
hi def link shEcho	shString
hi def link shEchoDelim	shOperator
hi def link shEchoQuote	shString
hi def link shEmbeddedEcho	shString
hi def link shEsacError		Error
hi def link shEscape	shCommandSub
hi def link shExDoubleQuote	shDoubleQuote
hi def link shExSingleQuote	shSingleQuote
hi def link shExprRegion		Delimiter
hi def link shForPP	shLoop
hi def link shFunction	Function
hi def link shFunctionKey		Function
hi def link shFunctionName		Function
hi def link shHereDoc	shString
hi def link shHereDoc01		shRedir
hi def link shHereDoc02		shRedir
hi def link shHereDoc03		shRedir
hi def link shHereDoc04		shRedir
hi def link shHereDoc05		shRedir
hi def link shHereDoc06		shRedir
hi def link shHereDoc07		shRedir
hi def link shHereDoc08		shRedir
hi def link shHereDoc09		shRedir
hi def link shHereDoc10		shRedir
hi def link shHereDoc11		shRedir
hi def link shHereDoc12		shRedir
hi def link shHereDoc13		shRedir
hi def link shHereDoc14		shRedir
hi def link shHereDoc15		shRedir
hi def link shHerePayload	shHereDoc
hi def link shHereString	shRedir
hi def link shInError		Error
hi def link shLoop	shStatement
hi def link shNoQuote	shDoubleQuote
hi def link shNumber		Number
hi def link shOperator		Operator
hi def link shOption	shCommandSub
hi def link shParen	shArithmetic
hi def link shParenError		Error
hi def link shPattern	shString
hi def link shPosnParm	shShellVariables
hi def link shQuickComment	shComment
hi def link shQuote	shOperator
hi def link shRange	shOperator
hi def link shRedir	shOperator
hi def link shRepeat		Repeat
hi def link shSet		Statement
hi def link shSetList		Identifier
hi def link shSetListDelim	shOperator
hi def link shSetOption	shOption
hi def link shShellVariables		PreProc
hi def link shSingleQuote	shString
hi def link shSnglCase		Statement
hi def link shSource	shOperator
hi def link shSource	shOperator
hi def link shSpecial		Special
hi def link shSpecialDQ		Special
hi def link shSpecialNoZS		shSpecial
hi def link shSpecialNxt	shSpecial
hi def link shSpecialSQ		Special
hi def link shSpecialStart	shSpecial
hi def link shStatement		Statement
hi def link shString		String
hi def link shStringSpecial	shSpecial
hi def link shSubShRegion	shOperator
hi def link shTestDoubleQuote	shString
hi def link shTestError		Error
hi def link shTestOpr	shConditional
hi def link shTestPattern	shString
hi def link shTestSingleQuote	shString
hi def link shTodo		Todo
hi def link shTouchCmd	shStatement
hi def link shVariable	shSetList
hi def link shWrapLineOperator	shOperator
hi! link shCase             Question
hi! link shCaseEsac         Question
hi! link shCaseEsacSync     Question
hi! link shCaseExSingleQuote Question
hi! link shCaseLabel        Question
hi! link shCaseRange        Question
hi! link shCmdParenRegion   Question
hi! link shComma            Question
hi! link shCurlyIn          Question
hi! link shDblBrace         Question
hi! link shDblParen         Question
hi! link shDerefEscape      Question
hi! link shDerefPPSleft     Question
hi! link shDerefPPSright    Question
hi! link shDerefPSRleft     Question
hi! link shDerefPSRright    Question
hi! link shDerefPattern     Question
hi! link shDerefVarArray    Question
hi! link shDo               Question
hi! link shDoSync           Question
hi! link shExpr             Question
hi! link shFor              Question
hi! link shForSync          Question
hi! link shFunctionFour     Question
hi! link shFunctionOne      Identifier
hi! link shFunctionStart    Question
hi! link shFunctionThree    Question
hi! link shFunctionTwo      Question
hi! link shHereDoc16        Question
hi! link shIf               Identifier
hi! link shIfSync           Question
hi! link shOK               Question
hi! link shSpecialVar       Question
hi! link shSubSh            Question
hi! link shTest             Question
hi! link shTouch            Question
hi! link shUntilSync        Question
hi! link shVarAssign        Question
hi! link shWhileSync        Question

" }}}
" QF: {{{
hi def link qfFileName	Directory
hi def link qfLineNr	LineNr
hi def link qfError	Error

" }}}
" Django: {{{
hi def link djangoTagBlock PreProc
hi def link djangoVarBlock PreProc
hi def link djangoStatement Statement
hi def link djangoFilter Identifier
hi def link djangoArgument Constant
hi def link djangoTagError Error
hi def link djangoVarError Error
hi def link djangoError Error
hi def link djangoComment Comment
hi def link djangoComBlock Comment
hi def link djangoTodo Todo

" }}}
" Tutor: {{{ 
hi! tutorLink cterm=underline gui=underline ctermfg=lightblue guifg=#0088ff
hi! link tutorLinkBands Delimiter
hi! link tutorLinkAnchor Underlined
hi! link tutorInternalAnchor Underlined
hi! link tutorURL tutorLink
hi! link tutorEmail tutorLink
hi! link tutorSection Title
hi! link tutorSectionBullet Delimiter
hi! link tutorTOC Directory
hi! tutorMarks cterm=bold gui=bold
hi! tutorEmphasis gui=italic cterm=italic
hi! tutorBold gui=bold cterm=bold
hi! link tutorExpect Special
hi! tutorOK ctermfg=green guifg=#00ff88 cterm=bold gui=bold
hi! tutorX ctermfg=red guifg=#ff2000  cterm=bold gui=bold
hi! link tutorInlineOK tutorOK
hi! link tutorInlineX tutorX
hi! link tutorShellPrompt Delimiter

" }}}
" }}}

" vim: set sw=2 ts=2 sts=2 et fdm=marker fdls=1 fdl=1:
