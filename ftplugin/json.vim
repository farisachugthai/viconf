" ============================================================================
  " File: json.vim
  " Author: Faris Chugthai
  " Description: JSON ftplugin
  " Last Modified: Oct 20, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

" Got this from the syntax file
let g:vim_json_warnings = 1
" Always set the globals first

" If this got sourced for some other filetype like md or javascript stop now

if &filetype!=#'json'
  finish
endif

syntax match jsonComment +\/\/.\+$+

highlight link jsonComment Comment

setlocal formatoptions-=t

" The original ftplugin states that JSON has no comments.
" Well sometimes it does fuck you
let &commentstring='// %s'
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

" Let's add in a few more options though. Enforce 2 space tabs
setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
setlocal suffixesadd=.json,.js,.jsx
setlocal foldmethod=syntax

" Set up ALE correctly
call ftplugins#ALE_JSON_Conf()

" These mappings are particularly nice in JSON files.:
inoremap <buffer> ( ()<C-G>U<Left>
inoremap <buffer> [ []<C-G>U<Left>
inoremap <buffer> { {}<C-G>U<Left>
inoremap <buffer> " ""<C-G>U<Left>
" Also can we auto fix single quotes?
inoremap <buffer> ' "<C-G>U<Left>

" Set up matchit:
let b:match_ignorecase = 1
let b:match_words = '<:>,{:},"",(:),[:]'

" And set up a formatter.
" For more see ../python3/_vim
command! -buffer -bang -bar -range=% -nargs=0 Pjson :w<bang> <bar> <line1>,<line2>python3 import _vim; _vim.pretty_it('json')

" TODO: Check that this worked
setlocal formatprg=:Pjson

let b:undo_ftplugin = 'setlocal fo< com< cms< et< sts< sw< ts< sua< fdm< fp< '
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:ale_fixers'
      \ . '|unlet! b:ale_linters'
      \ . '|unlet! b:ale_linters_explicit'
