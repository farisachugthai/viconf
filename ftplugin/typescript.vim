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

  call ftplugins#typescript_setup()
  let b:did_typescript_setup = 1
endif
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
