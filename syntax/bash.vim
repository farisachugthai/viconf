

" Just in case i didn't get them fro the sh plugin
let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heredoc folding)

" highlighting readline options
let g:readline_has_bash = 1

if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syntax sync fromstart linebreaks=2
let b:is_bash = 1
source $VIMRUNTIME/syntax/sh.vim
