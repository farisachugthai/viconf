" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax commands
    " Last Modified: April 08, 2019
" ============================================================================

" Syntax Highlighting Functions: {{{1

" HL: {{{2
" Whats the highlighting group under my cursor?
function! syncom#HL()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction

" HiC: {{{3

" Heres a possibly easier way to do this. Still in testing.
" Mar 17, 2019: So far does the exact same thing!
function! syncom#HiC()
    echo 'Highlighting group: ' . synIDattr(synID(line('.'), col('.'), 1), 'name')
    echo 'Foreground color: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')
endfunction

" HiDebug: {{{2
" function! s:HiD()
"     echo join(map(synstack(line('.'), col('.')), 'synIDattr(id, "name")') '\n')
" endfunction

" command! HiD call <SID>HiD()

" HiAll: {{{2
function! syncom#rHiQF()
  " synstack returns a list. takes lnum and col.
  " map is crazy specific in its argument requirements. map(list, string)
  " cexpr evals a command and adds it to the quickfist list
  cexpr! map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
