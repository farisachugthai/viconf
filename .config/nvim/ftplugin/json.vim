" ============================================================================
  " File: json.vim
  " Author: Faris Chugthai
  " Description: JSON
  " Last Modified: June 23, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions&vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" Original Implementation: {{{1

" This is all they have for the ftplugin for json...
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1


setlocal formatoptions-=t

" JSON has no comments.
setlocal comments=
setlocal commentstring=

" Like what the literal fuck
setlocal expandtab softtabstop=2 shiftwidth=2

" Plugins: {{{1

function! ALE_JSON_Conf() abort

  if s:debug
    echomsg 'JSON ftplugin was called'
  endif

  if executable('prettier')
    let g:ale_fixers += {'json': ['prettier']}
  endif

  if executable('jq')
    let g:ale_fixers += {'json': ['jq']}
  endif

endfunction


" Autocmd: {{{1

let s:debug = 1

if has_key(plugs, 'ale') && &filetype==#'json'
  augroup alejsonconf
    au!
    autocmd Filetype * call ALE_JSON_Conf()
  augroup END
endif


" Commands: {{{1
" TODO: Could pretty easily make a command that runs python -m json.fix('%')
" on a buffer

" Atexit: {{{1
let b:undo_ftplugin = 'setlocal fo< com< cms< sts< et< sw<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
