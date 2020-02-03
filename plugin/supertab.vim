" ============================================================================
  " File: supertab.vim
  " Author: Faris Chugthai
  " Description: Supertab configuration
  " Last Modified: May 14, 2019
" ============================================================================

if exists('b:did_supertab') || &compatible || v:version < 700
  finish
endif
let b:did_supertab = 1

if exists('plugs')
  if !has_key(plugs, 'supertab')
    finish
  endif
endif

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
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']

" set completefunc=SuperTabCodeComplete

augroup SuperTabOmniFunc
  autocmd!
  autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-p>", 1) |
    \ endif
augroup END
