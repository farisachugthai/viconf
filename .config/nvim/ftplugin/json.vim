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

" My Additions: {{{1
" Let's add in a few more options though. Enforce 2 space tabs
setlocal expandtab softtabstop=2 shiftwidth=2

setlocal suffixesadd=.json
" Got this from the syntax file
let g:vim_json_warnings = 1

setlocal foldmethod=indent

" ALE: {{{1
" If this got sourced for some other filetype like md or javascript stop now

if &filetype!=#'json'
  finish
endif

" JSON is the only filetype where i always want ALE enabled
if empty('g:loaded_ale')
  if exists('*plug#load')
    call plug#load('ale')
    echomsg 'ftplugin/json: Calling plug#load(ale)'
  endif
endif

" Still check if that worked though
if !empty('g:loaded_ale')
  if exists('*ale#toggle#Enable')
    call ale#toggle#Enable()
  else
    echoerr 'Vim-plug loaded ale but ale#toggle#Enable still didnt work'
  endif
  " Load my configs
  call ftplugins#ALE_JSON_Conf()
else
  echoerr 'ftplugin/json: Vim-Plug did not load ale'
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
let b:undo_ftplugin = 'setlocal fo< com< cms< et< sts< sw< sua< fdm<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
