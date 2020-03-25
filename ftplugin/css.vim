" ============================================================================
    " File: css.vim
    " Author: Faris Chugthai
    " Description: css ftplugin
    " Last Modified: June 08, 2019
" ============================================================================

if &filetype !=# 'css' || &filetype !=# 'less'
  finish
endif

source $VIMRUNTIME/ftplugin/css.vim

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd=.html,.css
setlocal omnifunc=csscomplete#CompleteCSS
setlocal path=.,,**

" only difference between less and css ftplugin
" css
setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
" less
" setlocal comments=:// commentstring=//\ %s

compiler csslint
let &l:formatprg=postcss
let &l:include = '^\s*@import\s\+\%(url(\)\='
call ftplugins#ALE_CSS_Conf()

let b:undo_ftplugin = 'setlocal et< sw< sts< sua< ofu< mp< efm<'
      \ . '|setlocal path< com< cms<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
