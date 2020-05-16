" ============================================================================
    " File: css.vim
    " Author: Faris Chugthai
    " Description: css ftplugin
    " Last Modified: June 08, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" the whole thing is here
" source $VIMRUNTIME/ftplugin/css.vim
source $VIMRUNTIME/indent/css.vim

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd=.html,.css
setlocal omnifunc=csscomplete#CompleteCSS
" setlocal path=.,,**

" only difference between less and css ftplugin
" css
setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
" less
" setlocal comments=:// commentstring=//\ %s

compiler csslint

let &l:formatprg='!postcss'

let &l:include = '^\s*@import\s\+\%(url(\)\='

let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
let b:ale_fixers += ['prettier']

let b:undo_ftplugin = '|setlocal et< sw< sts< sua< ofu< mp< efm<'
      \. '|setlocal path< com< cms< fp< include<'
      \. '|unlet! b:ale_fixers'
      \. '|unlet! b:undo_ftplugin'
      \. '|unlet! b:did_ftplugin'
