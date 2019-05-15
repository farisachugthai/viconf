" ============================================================================
  " File: supertab.vim
  " Author: Faris Chugthai
  " Description: Supertab configuration
  " Last Modified: May 14, 2019
" ============================================================================

" Guard: {{{1

if !has_key(plugs, 'supertab')
  finish
endif

if exists('b:did_supertab_after_plugin') || &compatible || v:version < 700
  finish
endif
let b:did_supertab_after_plugin = 1


" Culmination Of The Help Docs: {{{1
  let g:SuperTabDefaultCompletionType = 'context'
  autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-p>") |
    \ endif


" This configuration will result in a completion flow like so:

"   if text before the cursor looks like a file path:
"     use file completion
"   elif text before the cursor looks like an attempt to access a member
"   (method, field, etc):
"     use user completion
"       where user completion is currently set to supertab's
"       completion chaining, resulting in:
"         if omni completion has results:
"           use omni completion
"         else:
"           use keyword completion
"   else:
"     use keyword completion
