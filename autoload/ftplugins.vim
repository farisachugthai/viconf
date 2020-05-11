 "===========================================================================
    " File: ftplugins.vim
    " Author: Faris Chugthai
    " Description: Almost exclusively ALE configurations
    " Last Modified: August 28, 2019
" ============================================================================

function! ftplugins#ALE_JSON_Conf() abort  " {{{
  " Standard fixers defined for JSON
  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

    let b:ale_fixers += ['prettier']

    let b:ale_fixers += ['jq']
    let b:ale_json_jq_options = '-SM'
    let b:ale_json_jq_filters = '.'
  " endif

    let b:ale_fixers += ['fixjson']

    let b:ale_linters = ['jsonlint']
    let b:ale_linters_explicit = 1
endfunction  " }}}

function! ftplugins#ALE_CSS_Conf() abort  " {{{
  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

    let b:ale_fixers += ['prettier']
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

function! ftplugins#ALE_Typescript() abort
  call ftplugin#ALE_JS_Conf()
  let b:ale_fixers += ['eslint']
  let b:ale_fixers += ['tslint']
  " if executable(expand('~/.config/coc/extensions/node_modules/tsserver'))
endfunction

function! ftplugins#ALE_Vim_Conf() abort  " {{{
  let b:ale_linters = ['ale_custom_linting_rules']
  let b:ale_linters_explicit = 1

    let b:ale_linters += ['vint']
endfunction  " }}}

function! ftplugins#typescript_setup() abort
  " node_modules
  let s:node_modules = finddir('node_modules', '.;', -1)
  if len(s:node_modules)
    let b:ts_node_modules = map(s:node_modules, { idx, val -> substitute(fnamemodify(val, ':p'), '/$', '', '')})
    unlet! s:node_modules
  endif
  " $PATH: {{{
  if exists('b:ts_node_modules')
    if $PATH !~? b:ts_node_modules[0]
      let $PATH = b:ts_node_modules[0] . ':' . $PATH
    endif
  endif
  " aliases
  let b:tsconfig_file = findfile('tsconfig.json', '.;')
  if len(b:tsconfig_file)
    try
      let b:tsconfig_data = json_decode(join(readfile(b:tsconfig_file)))
      " catch all Vim errors. thanks help docs
    catch /^Vim\%((\a\+)\)\=:E/
    endtry
    unlet! b:tsconfig_data
  endif
  unlet! b:tsconfig_file
  " }}}
  " Lint File On Write: {{{
  if executable('tslint')
    let &l:errorformat = '%EERROR: %f:%l:%c - %m,'
                       \.'%WWARNING: %f:%l:%c - %m,'
                       \.'%E%f:%l:%c - %m,'
                       \.'%-G%.%#'

    let &l:makeprg = 'tslint --format prose'
    let b:undo_ftplugin .= '|setlocal efm< mp<'
    echomsg 'ftplugin/typescript: Setting tslint as the compiler.'
    augroup TS
      autocmd!
      autocmd BufWritePost <buffer> silent make! <afile> | silent redraw!
    augroup END
  endif
endfunction

" Vim: set fdm=indent fdls=0:
