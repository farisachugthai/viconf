" ============================================================================
    " File: sh.vim
    " Author: Faris Chugthai
    " Description: Bash ftplugin
    " Last Modified: June 09, 2019
" ============================================================================
"
" Global Options:
  " Setting global options in an ftplugin is odd
  let g:is_bash = 1
  let g:sh_fold_enabled= 4  "   (enable if/do/for folding)

  " highlighting readline options
  let g:readline_has_bash = 1

  let b:is_bash = 1
  let b:shell_is_bash = match(expand('$SHELL'), 'bash')
  if !b:shell_is_bash
    let g:ale_sh_shell_default_shell = 1
  else
    let g:ale_sh_shell_default_shell = 0
  endif


" Buffer Local:
  " if exists('b:did_ftplugin')
    " actually dont do anything because the bash ftplugin might be sourcing this
  " endif

  if &filetype ==# 'sh'
    source $VIMRUNTIME/ftplugin/sh.vim
    source $VIMRUNTIME/indent/sh.vim
  endif
  setlocal commentstring=#\ %s
  setlocal shiftwidth=4 expandtab softtabstop=4 ts=4
  setlocal colorcolumn=120
  " todo: ensure it works
  setlocal include=^\s*\%(so\%[urce]\*\zs[^\|]*

  " Uh?
  setlocal includeexpr=shellescape(v:fname)
  setlocal foldignore=
  setlocal foldmethod=syntax " we set up syntax folding at the top

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  let b:ale_linters = ['language_server', 'shell']

  " the original defines one too
  let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
        \. '|setlocal cms< sw< et< sts< ts< cc< include< '
        \. '|setlocal includeexpr< foldignore< foldmethod<'
        \. '|unlet! b:undo_ftplugin'
        \. '|unlet! b:did_ftplugin'
        \. '|unlet! b:ale_fixers'
        \. '|unlet! b:ale_linters'

" Compiler:

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

    let b:undo_ftplugin .= '|setlocal mp< efm<'
        \. '|silent! unmap <buffer> <F5>'
        \. '|silent! unmap! <buffer> <F5>'
        \. '|unlet! b:ale_linters'

    let b:ale_linters += ['shellcheck']
  endif

