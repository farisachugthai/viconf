" ============================================================================
    " File: sh.vim
    " Author: Faris Chugthai
    " Description: Bash ftplugin
    " Last Modified: June 09, 2019
" ============================================================================
"
" Global Options: {{{
" Setting global options in an ftplugin is odd
let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heredoc folding)

" highlighting readline options
let g:readline_has_bash = 1

let b:is_bash = 1
let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
let b:ale_linters = ['language_server', 'shell']
" }}}

" Buffer Local: {{{
if exists('b:did_ftplugin')
  " actually dont do anything because the bash ftplugin might be sourcing this
endif

source $VIMRUNTIME/ftplugin/sh.vim
setlocal commentstring=#\ %s
setlocal shiftwidth=4 expandtab softtabstop=4 ts=4
syntax enable
syntax sync fromstart linebreaks=2
setl syntax=bash
setlocal colorcolumn=120
" todo: ensure it works
setlocal include=^\s*\%(so\%[urce]\*\zs[^\|]*

" the original defines one too
let b:undo_ftplugin .= '|setlocal sw< et< sts< cc< syntax< include< '
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
" }}}

" Compiler: {{{

" From none other than the shellcheck manpage!
if executable('shellcheck') || executable('shellcheck.exe')
  " could also do
  if globpath(&runtimepath, 'compiler/shellcheck.vim')
    compiler shellcheck
  else
    setlocal makeprg=shellcheck\ -f\ gcc\ %
  endif
  echomsg 'Using shellcheck for the compiler!'

  noremap <buffer> <F5> <Cmd>make %<CR>
  noremap! <buffer> <F5> <Cmd>make %<CR>

  let b:undo_ftplugin .= '|setlocal makeprg<'
      \ . '|silent! unmap <buffer> <F5>'
      \ . '|silent! unmap! <buffer> <F5>'
endif

call ftplugins#ALE_sh_conf()
" }}}

