" ============================================================================
    " File: tagbar.vim
    " Author: Faris Chugthai
    " Description: Tagbar configuration
    " Last Modified: Sep 14, 2019
" ============================================================================

if exists('g:did_tagbar') || &compatible || v:version < 700
  finish
endif
let g:did_tagbar = 1

scriptencoding utf-8

" Tagbar Options: {{{

" I want the spacebar back
let g:tagbar_map_showproto = '?'
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_sort = 0
let g:tagbar_singleclick = 1
let g:tagbar_hide_nonpublic = 0
let g:tagbar_autoshowtag = 1

" Literally ruins my ability to see any other messages i might care about
let g:tagbar_silent = 1

" If you set this option the Tagbar window will automatically close when you
" jump to a tag. This implies |g:tagbar_autofocus|. If enabled the "C" flag will
" be shown in the statusline of the Tagbar window.
" Actually I like having it open
let g:tagbar_autoclose = 1

" -1: Use the global line number settings.
" Well that just feels like the courteous thing to do right?
let g:tagbar_show_linenumbers = -1

" Actually let's fold this a bit more.
" Default is 99 btw
let g:tagbar_foldlevel = 1

" If this variable is set to 1 then moving the cursor in the Tagbar window will
" automatically show the current tag in the preview window.
" Dude it takes up a crazy amount of room on termux and is generally quite annoying
" Don't know why we only went with windows only. that setting is annoying
" everywhere.
let g:tagbar_autopreview = 0

let g:tagbar_map_zoomwin = 'Z'

" }}}

" Platform Specific Options: {{{
if !has('unix')

  " let g:tagbar_autopreview = 1
  " Find the ctags executable: {{{
  if filereadable(expand('$HOME/src/ctags/ctags.exe'))
    let g:tagbar_ctags_bin = expand('$HOME/src/ctags/ctags.exe')
  elseif executable(exepath('ctags'))
    let g:tagbar_ctags_bin = exepath('ctags')
  endif  " }}}

  if filereadable(expand('$HOME/.ctags.d/new_universal.ctags'))
    let g:tagbar_ctags_options = [expand('~/.ctags.d/new_universal.ctags')]
  endif
  " Icon Chars
        " let g:tagbar_iconchars = ['▸', '▾']
        " let g:tagbar_iconchars = ['▷', '◢']
        " let g:tagbar_iconchars = ['+', '-']  (default on Windows)
  " Uh so all of these displayed correctly even on windows so give me some
  " cooler ones
  let g:tagbar_iconchars = ['▶', '▼']
else
  let g:tagbar_iconchars = ['▷', '◢']

endif

" Setting this option will result in Tagbar omitting the short help at the
" top of the window and the blank lines in between top-level scopes in order to
" save screen real estate.
" Termux needs this
if exists($ANDROID_ROOT) | let g:tagbar_compact = 1 | endif
" }}}

" Tagbar Types: {{{
let g:tagbar_type_ansible = {
	\ 'ctagstype' : 'ansible',
	\ 'kinds' : [
	\ 't:tasks'
	\ ],
	\ 'sort' : 0
  \ }

let g:tagbar_type_css = {
    \ 'ctagstype' : 'Css',
    \ 'kinds'     : [
    \ 'c:classes',
    \ 's:selectors',
    \ 'i:identities'
    \ ]
    \ }

let g:tagbar_type_make = {
            \ 'kinds':[
            \ 'm:macros',
            \ 't:targets'
            \ ]
            \ }

let g:tagbar_type_javascript = {
      \ 'ctagstype': 'javascript',
      \ 'kinds': [
      \ 'A:arrays',
      \ 'P:properties',
      \ 'T:tags',
      \ 'O:objects',
      \ 'G:generator functions',
      \ 'F:functions',
      \ 'C:constructors/classes',
      \ 'M:methods',
      \ 'V:variables',
      \ 'I:imports',
      \ 'E:exports',
      \ 'S:styled components',
      \ ]}

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
\ }

let g:tagbar_type_ps1 = {
    \ 'ctagstype' : 'powershell',
    \ 'kinds'     : [
        \ 'f:function',
        \ 'i:filter',
        \ 'a:alias'
    \ ]
\ }


let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : expand('$HOME/src/rst2ctags/rst2ctags.py'),
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

  " \ 'ctagsargs' : ['-f', 'tags', '--encoding="utf-8"',
  "                \ '--sort=yes', '--sro="»"'],

let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
  \ 'c:classes',
  \ 'n:modules',
  \ 'f:functions',
  \ 'v:variables',
  \ 'v:varlambdas',
  \ 'm:members',
  \ 'i:interfaces',
  \ 'e:enums',
  \ ]
  \ }

let g:tagbar_type_snippets = {
      \ 'ctagstype' : 'snippets',
      \ 'kinds' : [
      \ 's:snippets',
      \ ]
\ }

" }}}
