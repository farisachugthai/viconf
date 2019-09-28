" ============================================================================
  " File: json.vim
  " Author: Faris Chugthai
  " Description: JSON ftplugin
  " Last Modified: June 23, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=C

" Original Implementation: {{{1

" This is all they have for the ftplugin for json...
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1


setlocal formatoptions-=t

" JSON has no comments.
setlocal comments=
" setlocal commentstring=
" sometimes it does fuck you
let &commentstring='\\ %s'

" Let's add in a few more options though. Enforce 2 space tabs
setlocal expandtab softtabstop=2 shiftwidth=2

set suffixesadd=.json
" Got this from the syntax file
let g:vim_json_warnings = 1

" ALE: {{{1
" If this got sourced for some other filetype like md or javascript stop now

if &filetype!=#'json'
  finish
endif

if has_key(plugs, 'ale')
  " Load my configs
  call ftplugins#ALE_JSON_Conf()
else
  " JSON is the only filetype where i always want ALE enabled
  let b:ale_enabled = 1
  " And i seriously doubt this is a very smart way of doing this but whatever
  call plug#load('ale')
  call ale#toggle#EnableBuffer('%')
  call ftplugins#ALE_JSON_Conf()
endif

" Commands: {{{1
" TODO: Could pretty easily make a command that runs python -m json.fix('%')
" on a buffer
" Unfortunately I can't get the right invocation down :/
" r!python3 -m json.tool --sort-keys %
" I hate that I can't get it right from inside the interpreter though.
" oh shit it's a separate module!!!
" :py3 from json import tool

" Highlighting: {{{1
" hi match jsonComment

" Atexit: {{{1
let b:undo_ftplugin = 'setlocal fo< com< cms< et< sts< sw< sua<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
