
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions-=C

syntax sync linebreaks=1
syntax conceal on
syntax sync  fromstart
syn include $VIMRUNTIME/syntax/sh.vim

runtime $VIMRUNTIME/syntax/sh.vim

" do we need to load more?

let &cpoptions = s:cpo_save
unlet s:cpo_save
