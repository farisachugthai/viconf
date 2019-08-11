" ============================================================================
    " File: sh.vim
    " Author: Faris Chugthai
    " Description: Bash ftplugin
    " Last Modified: June 09, 2019
" ============================================================================
"
" Guard: {{{1
if exists('g:did_sh_vim_after_ftplugin') || &compatible || v:version < 700
    finish
endif
let g:did_sh_vim_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1

let g:is_bash = 1
let g:sh_fold_enabled= 4  "   (enable if/do/for folding)
let g:sh_fold_enabled= 3  "   (enables function and heregoc folding)

" highlighting readline options
let readline_has_bash = 1

setlocal commentstring=#\ %s
setlocal shiftwidth=4 expandtab softtabstop=4

setlocal colorcolumn=120

let b:is_bash = 1

" Plugins: {{{1
"
" ALE: {{{2

function! ALE_sh_conf() abort

  " if we're using powershell or cmd on windows set ALEs default shell to bash
  " TODO: set the path to shellcheck.
  if has('unix')
    let shell_is_bash = match(expand('$SHELL'), 'bash')
    if !shell_is_bash
      let g:ale_sh_shell_default_shell = 1
    endif

  else
    let s:bash_location = exepath('bash')
    if executable(s:bash_location)
      let g:ale_sh_shell_default_shell = 1
    endif
  endif

  let b:ale_linters = ['shell', 'shellcheck']
  if !has('unix')
    let b:ale_sh_shellcheck_executable = 'C:/tools/miniconda3/envs/neovim/bin/shellcheck.exe'
  endif

endfunction

augroup ALEshConf
    au!
    au Filetype sh call ALE_sh_conf()
augroup END

" Atexit: {{{1

let b:undo_ftplugin = 'set cms< sw< et< sts< cc< '

let &cpoptions = s:cpo_save
unlet s:cpo_save
