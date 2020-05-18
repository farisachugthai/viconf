 "===========================================================================
    " File: ftplugins.vim
    " Author: Faris Chugthai
    " Description: Almost exclusively ALE configurations
    " Last Modified: August 28, 2019
" ============================================================================

function! ftplugins#typescript_setup() abort
  " node_modules
  let s:node_modules = finddir('node_modules', '.;', -1)
  if len(s:node_modules)
    let b:ts_node_modules = map(s:node_modules, { idx, val -> substitute(fnamemodify(val, ':p'), '/$', '', '')})
    unlet! s:node_modules
  endif
  " $PATH:
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

  " Lint File On Write:
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
