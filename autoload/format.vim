" ========================================================================
    " File: format.vim
    " Author: Faris Chugthai
    " Description: Autoloaded formatter from :he format-formatexpr
    " Last Modified: February 24, 2019
" ========================================================================

function! format#Format() abort
  " fall back to Vims internal reformatting
  if mode() !=# 'n' | return 1 | endif
  let l:lines = getline(v:lnum, v:lnum + v:count - 1)
  call map(l:lines, {key, val -> substitute(val, '\s\+$', '', 'g')})
  call setline('.', l:lines)

  " do not run internal formatter!
  " but why not
  " return 0
endfunction

function! format#MarkdownFoldText() abort
  let l:line = getline(v:lnum)

  " Regular headers
  let l:depth = match(l:line, '\(^#\+\)\@<=\( .*$\)\@=')
  if l:depth > 0 | return '>' . l:depth | endif

  " Setext style headings
  let l:nextline = getline(v:lnum + 1)
  if (l:line =~? '^.\+$') && (l:nextline =~? '^=\+$') | return '>1' | endif
  if (l:line =~? '^.\+$') && (l:nextline =~? '^-\+$') | return '>2' | endif

  return '='
endfunction

function! format#ClangCheckimpl(cmd) abort
  " This is honestly really useful if you simply swap out the filetype
  if &autowrite | wall | endif
  echomsg 'running ' . a:cmd . ' ...'
  let l:output = system(a:cmd)
  cexpr l:output
  cwindow
  let w:quickfix_title = a:cmd
  if v:shell_error != 0
    cc
  else
    echomsg 'shell error: ' . v:shell_error
  endif
  let g:clang_check_last_cmd = a:cmd
endfunction

function! format#ClangCheck()  abort
  let l:filename = expand('%')
  if l:filename =~# '\.\(cpp\|cxx\|cc\|c\)$'
    call format#ClangCheckImpl('clang-check ' . l:filename)
  elseif exists('g:clang_check_last_cmd')
    call format#ClangCheckImpl(g:clang_check_last_cmd)
  else
    echomsg "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif
endfunction

" Vim: set fdm=indent:
