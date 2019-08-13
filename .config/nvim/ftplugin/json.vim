" ============================================================================
  " File: json.vim
  " Author: Faris Chugthai
  " Description: JSON ftplugin
  " Last Modified: June 23, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=c

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

" Syntax File: {{{2

let g:vim_json_warnings = 1

" Plugins: {{{1

function! s:ALE_JSON_Conf() abort
  " Slowly but surely I'm working towards a uniform way of doing this

  if s:debug
    echomsg 'JSON ftplugin was called'
  endif

  " Standard fixers defined for JSON
  let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

  if executable('jq')
    let b:ale_fixers += ['jq']
  endif

  " Jul 17, 2019: Only json linter available
  if executable('fixjson')
    let b:ale_linters = ['fixjson']
    let b:ale_linters_explicit = 1
  endif

endfunction


" Autocmd: {{{1

let s:debug = 1

if has_key(plugs, 'ale')
  augroup alejsonconf
    au!
   autocmd Filetype json call s:ALE_JSON_Conf()
  augroup END
endif

" Commands: {{{1
" TODO: Could pretty easily make a command that runs python -m json.fix('%')
" on a buffer
" Unfortunately I can't get the right invocation down :/

" Atexit: {{{1
let b:undo_ftplugin = 'setlocal fo< com< cms< et< sts< sw< sua<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
