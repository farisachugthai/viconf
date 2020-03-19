 "===========================================================================
    " File: ftplugins.vim
    " Author: Faris Chugthai
    " Description: Almost exclusively ALE configurations
    " Last Modified: August 28, 2019
" ============================================================================

function! ftplugins#ALE_JSON_Conf() abort  " {{{
  " Standard fixers defined for JSON
  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

  " if executable('jq')
  " actually i don't care add this no matter what
    let b:ale_fixers += ['jq']
    let b:ale_json_jq_options = '-SM'
    let b:ale_json_jq_filters = '.'
  " endif

  if executable('fixjson')
    let b:ale_fixers += ['fixjson']
  endif

    let b:ale_linters = ['jsonlint']
    let b:ale_linters_explicit = 1
endfunction  " }}}

function! ftplugins#ALE_CSS_Conf() abort  " {{{

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

endfunction  " }}}

function! ftplugins#ALE_sh_conf() abort  " {{{

  " this is probably a waste of time when compiler shellcheck exists
  " if we're using powershell or cmd on windows set ALEs default shell to bash
  " TODO: set the path to shellcheck.
  if has('unix')
    let shell_is_bash = match(expand('$SHELL'), 'bash')
    if !shell_is_bash
      let g:ale_sh_shell_default_shell = 1
    else
      let g:ale_sh_shell_default_shell = 0
    endif
    let s:bash_location = exepath('bash')
    if executable(s:bash_location)
      let g:ale_sh_shell_default_shell = 1
    endif
  endif

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  let b:ale_linters = ['shell', 'shellcheck']

  " if !has('unix')
  "   let b:ale_sh_shellcheck_executable = 'C:/tools/miniconda3/envs/neovim/bin/shellcheck.exe'
  " endif

endfunction  " }}}

function! ftplugins#ALE_Html_Conf() abort  " {{{

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  " he checks for executability too let's say fuck it
  let b:ale_fixers += ['prettier', 'stylelint', 'csslint']

endfunction  " }}}

function! ftplugins#ALE_JS_Conf() abort  " {{{

  if !has('unix')
    let g:ale_windows_node_executable_path = fnameescape('C:/Program Files/nodejs/node.exe')
  endif

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  let b:ale_fixers += ['prettier']

endfunction  " }}}

function! ftplugins#ALE_Vim_Conf() abort  " {{{
  let b:ale_linters = ['ale_custom_linting_rules']
  let b:ale_linters_explicit = 1

  if executable('vint')
    let b:ale_linters += ['vint']
  endif
endfunction  " }}}
