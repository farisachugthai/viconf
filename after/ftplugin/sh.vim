" ============================================================================
    " File: sh.vim
    " Author: Faris Chugthai
    " Description: Bash ftplugin
    " Last Modified: June 09, 2019
" ============================================================================
"
" Guard: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=C

" Global Options: {{{1

" Setting global options in an ftplugin is odd
let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heredoc folding)

" highlighting readline options
let g:readline_has_bash = 1

" Sh Bash Specific: {{{1
if &filetype !=# 'sh' || &filetype !=# 'bash'
  " sh files get sourced in to highlight everything from vim src files to
  " markdown to rst and a whole bunch of others. so first check that we're not
  " just being sourced for the syntax groups
  finish
endif

setlocal commentstring=#\ %s
setlocal shiftwidth=4 expandtab softtabstop=4

setlocal colorcolumn=120

let b:undo_ftplugin = 'setlocal cms< sw< et< sts< cc< '
      \ . '|unlet! b:undo_ftplugin'

" Compiler: {{{1

" From none other than the shellcheck manpage!
if executable('shellcheck') || executable('shellcheck.exe')
  " could also do
  if globpath(&rtp, "compiler/shellcheck.vim")
    compiler shellcheck
  else
    setlocal makeprg=shellcheck\ -f\ gcc\ %
  endif
  echomsg 'Using shellcheck for the compiler!'

  noremap <buffer> <F5> <Cmd>make %<CR>
  noremap! <buffer> <F5> <Cmd>make %<CR>

  let b:undo_ftplugin .= 'setlocal makeprg<'
      \ . '|unmap <buffer> <F5>'
      \ . '|unmap! <buffer> <F5>'

endif

" Plugins: {{{1

if !empty('g:loaded_ale') && &filetype==#'sh' || &filetype==#'bash'
  call ftplugins#ALE_sh_conf()
endif

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
