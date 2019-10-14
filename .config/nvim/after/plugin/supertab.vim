" ============================================================================
  " File: supertab.vim
  " Author: Faris Chugthai
  " Description: Supertab configuration
  " Last Modified: May 14, 2019
" ============================================================================

" Guard: {{{1
if !exists('g:loaded_supertab') | finish | endif

if exists('g:did_supertab_after_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_supertab_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=c

" Culmination Of The Help Docs: {{{1

" Pretty much a copy paste of the last section of the help docs except
" I added the autocmd to it's own augroup.
" We may have been premature in deciding that.
"
"40% of the way in he sets up the context for you.

" Context Dependent Completion: {{{2
let g:SuperTabDefaultCompletionType = 'context'

" Note: once the buffer has been initialized, changing the value of this setting
" will not change the default complete type used. If you want to change the
" default completion type for the current buffer after it has been set, perhaps
" in an ftplugin, you'll need to call *SuperTabSetDefaultCompletionType* like so,
" supplying the completion type you wish to switch to:

" Are we allowed to do this?
call SuperTabSetDefaultCompletionType('coc#refresh()')

let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
        \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

function MyTagContext()
  if filereadable(expand('%:p:h') . '/tags')
    return "\<c-x>\<c-]>"
  endif
  " no return will result in the evaluation of the next
  " configured context
endfunction

let g:SuperTabCompletionContexts =
    \ ['MyTagContext', 's:ContextText', 's:ContextDiscover']

" When enabled, <cr> will cancel completion mode preserving the current text.
let g:SuperTabCrMapping = 1

let g:SuperTabClosePreviewOnPopupClose = 1  " (default value: 0)

" Completion Chaining: {{{1

augroup SuperTabOmniFunc
  autocmd!
  autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-p>") |
    \ endif
augroup END


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

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
