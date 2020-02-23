" ============================================================================
  " File: typescript.vim
  " Author: Faris Chugthai
  " Description: Stole it from romainl and i ain't even ashamed
  " Last Modified: November 18, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

source $VIMRUNTIME/ftplugin/javascript.vim

" Original:
" https://gist.githubusercontent.com/romainl/a50b49408308c45cc2f9f877dfe4df0c/raw/1ab8eb733948c0c89d11553cc0e00f4ab251f31e/typescript.vim

if !exists('b:did_typescript_setup')
  " node_modules
  let node_modules = finddir('node_modules', '.;', -1)
  if len(node_modules)
    let b:ts_node_modules = map(node_modules, { idx, val -> substitute(fnamemodify(val, ':p'), '/$', '', '')})
    unlet node_modules
  endif

  " $PATH
  if exists('b:ts_node_modules')
    if $PATH !~ b:ts_node_modules[0]
      let $PATH = b:ts_node_modules[0] . ':' . $PATH
    endif
  endif

  " aliases
  let b:tsconfig_file = findfile('tsconfig.json', '.;')

  if len(b:tsconfig_file)

    " Yeah i think it's this one. reading in the file and it might not be utf-8
    try
    let tsconfig_data = json_decode(join(readfile(b:tsconfig_file)))
    " catch all Vim errors. thanks help docs
    catch /^Vim\%((\a\+)\)\=:E/
    endtry

    " TODO: What do we do if this line raises an err
    " let paths = values(map(tsconfig_data.compilerOptions.paths, {key, val -> [
    "             \ glob2regpat(key),
    "             \ substitute(val[0], '\/\*$', '', '')]
    "             \ }))

    " for path in paths
    "   let path[1] = finddir(path[1], '.;')
    " endfor

    " let b:ts_config_paths = paths

    unlet! tsconfig_data
    " unlet paths
  endif

  unlet! b:tsconfig_file
  " lint file on write
  if executable('tslint')
    let &l:errorformat = '%EERROR: %f:%l:%c - %m,'
                     \ . '%WWARNING: %f:%l:%c - %m,'
                     \ . '%E%f:%l:%c - %m,'
                     \ . '%-G%.%#'

    let &l:makeprg = 'tslint --format prose'

    echomsg 'ftplugin/typescript: Setting tslint as the compiler.'
    augroup TS
      autocmd!
      autocmd BufWritePost <buffer> silent make! <afile> | silent redraw!
    augroup END
  endif

  " matchit
  let b:match_words = '\<function\>:\<return\>,'
                  \ . '\<do\>:\<while\>,'
                  \ . '\<switch\>:\<case\>:\<default\>,'
                  \ . '\<if\>:\<else\>,'
                  \ . '\<try\>:\<catch\>:\<finally\>'

  let b:did_typescript_setup = 1
endif

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

" more helpful gf
nnoremap <silent> <buffer> gf         :call <SID>GF(expand('<cfile>'), 'find')<CR>
xnoremap <silent> <buffer> gf         <Esc>:<C-u>call <SID>GF(visual#GetSelection(), 'find')<CR>
nnoremap <silent> <buffer> <C-w><C-f> :call <SID>GF(expand('<cfile>'), 'sfind')<CR>
xnoremap <silent> <buffer> <C-w><C-f> <Esc>:<C-u>call <SID>GF(visual#GetSelection(), 'sfind')<CR>

if !exists("*s:GF")
  function s:GF(text, cmd)
    let include_expression = TypeScriptIncludeExpression(a:text, 1)

    if len(include_expression) > 1
      execute a:cmd . " " . include_expression
    else
      echohl WarningMsg
      echo "Can't find file " . a:text
      echohl None
    endif
  endfunction
endif

let b:undo_ftplugin = 'setlocal isf< sua< '
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:match_words'
      \ . '|unlet! b:did_ftplugin'
