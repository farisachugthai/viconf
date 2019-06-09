" ============================================================================
    " File: js.vim
    " Author: Faris Chugthai
    " Description: js ftplugin
    " Last Modified: June 09, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_js_after_ftplugin') || &compatible || v:version < 700
  finish
endif
let g:did_js_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd=.html,.css,.js

" Plugins: {{{1

function! ALE_JS_Conf()

  let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

endfunction

augroup alejsconf
    au!
    autocmd Filetype html if has_key(plugs, 'ale') | call ALE_JS_Conf() | endif
augroup END

" Atexit: {{{1

let b:undo_ftplugin = 'set et< sw< sts< sua<'
let &cpoptions = s:cpo_save
unlet s:cpo_save
