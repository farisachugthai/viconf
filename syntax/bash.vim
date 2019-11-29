" Nov 30, 2019
" Hey we're slow as shit but it works!

" syntax sync linebreaks=1
" Btw this line will conceal EVERYTHING so be careful
" syntax conceal on
syntax sync fromstart

syn include $VIMRUNTIME/syntax/sh.vim
unlet! b:current_syntax
runtime $VIMRUNTIME/syntax/sh.vim
unlet! b:current_syntax
runtime syntax/sh.vim
unlet! b:current_syntax
runtime after/syntax/sh.vim
unlet! b:current_syntax

hi! link shVar Identifier
