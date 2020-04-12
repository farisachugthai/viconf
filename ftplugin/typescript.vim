" ============================================================================
  " File: typescript.vim
  " Author: Faris Chugthai
  " Description: Stole it from romainl and i ain't even ashamed
  " Last Modified: November 18, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" Simple Options: {{{
source $VIMRUNTIME/ftplugin/javascript.vim
source $VIMRUNTIME/indent/typescript.vim
setlocal expandtab tabstop=4 softtabstop=2 shiftwidth=2
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(\\)\\s*['\"\.]
let &l:define  = '^\s*\('
             \ . '\(export\s\)*\(default\s\)*\(var\|const\|let\|function\|class\|interface\)\s'
             \ . '\|\(public\|private\|protected\|readonly\|static\)\s'
             \ . '\|\(get\s\|set\s\)'
             \ . '\|\(export\sdefault\s\|abstract\sclass\s\)'
             \ . '\|\(async\s\)'
             \ . '\|\(\ze\i\+([^)]*).*{$\)'
             \ . '\)'
setlocal includeexpr=includes#TypeScriptIncludeExpression(v:fname,0)
setlocal suffixesadd+=.ts,.tsx,.d.ts
setlocal isfname+=@-@
" }}}

" Original: {{{
" https://gist.githubusercontent.com/romainl/a50b49408308c45cc2f9f877dfe4df0c/raw/1ab8eb733948c0c89d11553cc0e00f4ab251f31e/typescript.vim
if !exists('b:did_typescript_setup')
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
endif
" }}}

" }}}

" Matchit: {{{
if exists('g:loaded_matchit')
  let b:match_words = '\<function\>:\<return\>,'
                  \ . '\<do\>:\<while\>,'
                  \ . '\<switch\>:\<case\>:\<default\>,'
                  \ . '\<if\>:\<else\>,'
                  \ . '\<try\>:\<catch\>:\<finally\>'
  let b:did_typescript_setup = 1
endif  " }}}

" More Helpful GF: {{{
nnoremap <silent> <buffer> gf         <Cmd>call <SID>GF(expand('<cfile>'), 'find')<CR>
xnoremap <silent> <buffer> gf         <Cmd>call <SID>GF(visual#GetSelection(), 'find')<CR>
nnoremap <silent> <buffer> <C-w><C-f> <Cmd>call <SID>GF(expand('<cfile>'), 'sfind')<CR>
xnoremap <silent> <buffer> <C-w><C-f> <Cmd>call <SID>GF(visual#GetSelection(), 'sfind')<CR>

if !exists('*s:GF')
  function! s:GF(text, cmd)  " {{{
    let l:include_expression = TypeScriptIncludeExpression(a:text, 1)

    if len(l:include_expression) > 1
      execute a:cmd . ' ' . l:include_expression
    else
      echohl WarningMsg
      echo 'Can not find file ' . a:text
      echohl None
    endif
  endfunction  " }}}
endif
" }}}

" Undo FTPlugin: {{{
" Theres actually an undo defined in js.vim
let b:undo_ftplugin .='|setlocal isf< sua< syntax< et< sts< sw< ts< '
                   \. '|setlocal inex< def< inc< inde< '
                   \. '|unlet! b:undo_ftplugin'
                   \. '|unlet! l:include_expression'
                   \. '|unlet! b:match_words'
                   \. '|unlet! b:did_ftplugin'
                   \. '|unlet! b:undo_indent'
                   \. '|unlet! b:did_indent'
                   \. '|silent! nunmap <buffer> gf'
                   \. '|silent! xunmap <buffer> gf'
                   \. '|silent! nunmap <buffer> <C-w><C-f>'
                   \. '|silent! xunmap <buffer> <C-w><C-f>'
" }}}
