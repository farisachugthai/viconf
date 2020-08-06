" ============================================================================
  " File: find_files.vim
  " Author: Faris Chugthai
  " Description: Find files autoload
  " Last Modified: August 02, 2019
" ============================================================================

function! find_files#build_quickfix_list(lines) abort
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! s:make_sentence(lines) abort
  " *fzf-vim-reducer-example*
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

function! find_files#RgSearch(txt) abort
  let l:rgopts = ' '
  if &ignorecase == 1
    let l:rgopts = l:rgopts . '-i '
  endif
  if &smartcase == 1
    let l:rgopts = l:rgopts . '-S '
  endif
  silent! exe 'grep! ' . l:rgopts . a:txt
  if len(getqflist())
    exe g:rg_window_location 'copen'
    redraw!
  else
    cclose
    redraw!
    echomsg 'No match found for ' . a:txt
  endif
endfunction

