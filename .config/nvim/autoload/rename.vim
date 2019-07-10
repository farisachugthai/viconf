" ============================================================================
    " File: rename.vim
    " Author: Faris Chugthai
    " Description: A description of the file below
    " Last Modified: July 08, 2019
" ============================================================================

" Rename: {{{1

" Setup Functions: {{{2
"
function! rename#isdropbox() abort
  let s:buf = expand(expand('%'))
  return s:buf 
endfunction

" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>za
