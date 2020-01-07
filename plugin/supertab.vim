" ============================================================================
  " File: supertab.vim
  " Author: Faris Chugthai
  " Description: Supertab configuration
  " Last Modified: May 14, 2019
" ============================================================================

if !exists('g:loaded_supertab') | finish | endif

" Culmination Of The Help Docs:

" Pretty much a copy paste of the last section of the help docs except
" I added the autocmd to it's own augroup.

" 40% of the way in he sets up the context for you.

" Might give this a try
let g:SuperTabDefaultCompletionType = '<C-x><C-u>'

" let g:SuperTabDefaultCompletionType = 'context'

" Note: once the buffer has been initialized, changing the value of this setting
" will not change the default complete type used. If you want to change the
" default completion type for the current buffer after it has been set, perhaps
" in an ftplugin, you'll need to call *SuperTabSetDefaultCompletionType* like so,
" supplying the completion type you wish to switch to:

let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
        \ ['&completefunc:<c-x><c-u>', '&omnifunc:<c-x><c-o>']

function! MyTagContext() abort
  if filereadable(expand('%:p:h') . '/tags')
    return "\<c-x>\<c-]>"
  endif
  " no return will result in the evaluation of the next
  " configured context
endfunction

let g:SuperTabCompletionContexts = ['MyTagContext', 's:ContextText', 's:ContextDiscover']

" When enabled, <CR> will cancel completion mode preserving the current text.
let g:SuperTabCrMapping = 1

let g:SuperTabClosePreviewOnPopupClose = 1  " (default value: 0)

augroup SuperTabOmniFunc
  autocmd!
  autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-p>", 1) |
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
