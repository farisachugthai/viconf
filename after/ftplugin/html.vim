" ============================================================================
  " File: html.vim
  " Author: Faris Chugthai
  " Description: Html ftplugin
  " Last Modified: June 08, 2019
" ============================================================================

" css, js, jinja2, htmljinja and htmldjango all need things from here
" if &filetype !=# 'html' | finish | endif

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd=.html

" So this is from |ft-html-omni| I don't know if that call is necessary
setlocal omnifunc=htmlcomplete#CompleteTags
call htmlcomplete#DetectOmniFlavor()

" from runtime/ftplugin/html.vim
let g:ft_html_autocomment = 1

if &filetype ==# 'html'
  call ftplugins#ALE_Html_Conf()
endif

let b:undo_ftplugin = 'setlocal et< sw< sts< sua< ofu<'
      \ . '|unlet! b:undo_ftplugin'
