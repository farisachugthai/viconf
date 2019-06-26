" ============================================================================
  " File: json.vim
  " Author: Faris Chugthai
  " Description: JSON
  " Last Modified: June 23, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_python_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_python_after_plugin = 1

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

" Plugins: {{{1

function! ALE_JSON_Conf() abort

  " we already defined it globally so let's be lazy but not use += on an uninitialized
  " buffer local variable
  let b:ale_fixers = g:ale_fixers

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

  if executable('jq')
    let b:ale_fixers += ['jq']
  endif

endfunction


" Autocmd: {{{1

augroup alejsonconf
    au!
    autocmd Filetype json if has_key(plugs, 'ale') | call ALE_JSON_Conf() | endif
augroup END


" Atexit: {{{1
let b:undo_ftplugin = 'setlocal formatoptions< comments< commentstring<'
