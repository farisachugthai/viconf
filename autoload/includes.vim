" ============================================================================
  " File: includes.vim
  " Author: Faris Chugthai
  " Description: Settin up the path for different file types.
  " Last Modified: February 22, 2020
" ============================================================================

" See Also: ./py.vim and py#PythonPath

let s:CORE_MODULES = ["_debugger", "_http_agent", "_http_client",
	\ "_http_common", "_http_incoming", "_http_outgoing", "_http_server",
	\ "_linklist", "_stream_duplex", "_stream_passthrough", "_stream_readable",
	\ "_stream_transform", "_stream_writable", "_tls_legacy", "_tls_wrap",
	\ "assert", "buffer", "child_process", "cluster", "console", "constants",
	\ "crypto", "dgram", "dns", "domain", "events", "freelist", "fs", "http",
	\ "https", "module", "net", "node", "os", "path", "punycode", "querystring",
	\ "readline", "repl", "smalloc", "stream", "string_decoder", "sys",
	\ "timers", "tls", "tty", "url", "util", "vm", "zlib"]

function! includes#TypeScriptIncludeExpression(fname, gf) abort
  let b:ts_node_modules = s:ts_node_modules()

  " BUILT-IN NODE MODULES
  " =====================
  " they aren't natively accessible but we can use @types/node if available
  if index([ 'assert', 'async_hooks',
           \ 'base', 'buffer', 'child_process', 'cluster', 'console', 'constants',
           \ 'crypto', 'dgram', 'dns', 'domain', 'events', 'fs', 'globals',
           \ 'http', 'http2', 'https', 'inspector', 'net', 'os', 'path',
           \ 'perf_hooks','process', 'punycode',
           \ 'querystring', 'readline', 'repl', 'stream', 'string_decoder',
           \ 'timers', 'tls', 'trace_events', 'tty', 'url', 'util', 'v8', 'vm',
           \ 'worker_threads', 'zlib' ],
           \ a:fname) != -1

    let l:found_definition = b:ts_node_modules[0] . '/@types/node/' . a:fname . '.d.ts'

    if filereadable(l:found_definition)
      return l:found_definition
    endif

    return a:fname
  endif

  " LOCAL IMPORTS
  " =============
  " they are everywhere so we must get them right. check ./ then ../
  if a:fname =~? '^\.'
    if a:fname =~? '^\./$'
      return './index.ts'
    endif

    if a:fname =~? '\.\./$'
      return a:fname . 'index.ts'
    endif

    " ./foo
    " ./foo/bar
    " ../foo
    " ../foo/bar
    " simplify module name to find it more easily
    return substitute(a:fname, '^\W*', '', '')
  endif

  " ALIASED IMPORTS
  " ===============
  " https://code.visualstudio.com/docs/languages/jsconfig
  " https://webpack.js.org/configuration/resolve/#resolve-alias
  if !empty(get(b:, 'ts_config_paths', []))
    for l:path in b:ts_config_paths
      if a:fname =~? l:path[0]
        let l:base_name = substitute(a:fname, l:path[0], l:path[1] . '/', '')

        if isdirectory(l:base_name)
          return l:base_name . '/index'
        endif

        return l:base_name
      endif
    endfor
  endif

  " this is where we stop for include-search/definition-search
  " give up if there's no node_modules
  if !a:gf
    if filereadable(a:fname)
      return a:fname
    endif

    return 0
  endif

  return includes#NodeImports(a:fname)
endfunction

function! includes#NodeImports(fname) abort
  " NODE IMPORTS
  " ============

  " split the filename in meaningful parts:
  " - a package name, used to search for the package in node_modules/
  " - a subpath if applicable, used to reach the right module
  "
  " example:
  " import bar from 'coolcat/foo/bar';
  " - package_name = coolcat
  " - sub_path     = foo/bar
  "
  " special case:
  " import something from '@scope/something/else';
  " - package_name = @scope/something
  " - sub_path     = else
  let l:parts = split(a:fname, '/')

  if l:parts[0] =~? '^@'
    let l:package_name = join(l:parts[0:1], '/')
    let l:sub_path = join(l:parts[2:-1], '/')
  else
    let l:package_name = l:parts[0]
    let l:sub_path = join(l:parts[1:-1], '/')
  endif

  " find the package.json for that package
  let l:package_json = b:ts_node_modules[-1] . '/' . l:package_name . '/package.json'

  " give up if there's no package.json
  if !filereadable(l:package_json)
    if filereadable(a:fname)
      return a:fname
    endif

    return 0
  endif

  if len(l:sub_path) == 0
    " grab data from the package.json
    if !has_key(b:ts_packages, a:fname)
      let l:package = json_decode(join(readfile(l:package_json)))

      let b:ts_packages[a:fname] = {
                  \ 'pack': fnamemodify(l:package_json, ':p:h'),
                  \ 'entry': substitute(get(l:package, 'typings',
                  \  get(l:package, 'main', 'index.js')),
                  \  '^\.\{1,2}\/', '', '')
                  \ }
    endif

    " build path from 'typings' key
    " fall back to 'main' key
    " fall back to 'index.js'
    return b:ts_packages[a:fname].pack . '/' . b:ts_packages[a:fname].entry
  else
      " build the path to the module
      let l:common_path = fnamemodify(l:package_json, ':p:h') . '/' . l:sub_path

      " first, try with .ts and .js
      let l:found_ext = glob(l:common_path . '.[jt]s', 1)
      if len(l:found_ext)
        return l:found_ext
      endif

      " second, try with /index.ts and /index.js
      let l:found_index = glob(l:common_path . '/index.[jt]s', 1)
      if len(l:found_index)
        return l:found_index
      endif
    " give up
    if filereadable(a:fname)
      return a:fname
    endif
  return 0
  endif
endfunction

function! includes#VimPath() abort
  " I know you may be thinking, there are no include or defines in a vim file
  " what the hell do you need to muck with the path for.
  " autoloaded functions!
  let s:path='.,**,'
  let s:path = s:path . expand('$VIMRUNTIME') . ','

  if !exists('*stdpath') | let &l:path = s:path | return s:path | endif

  let s:path = s:path . stdpath('config') . '/autoload,'
  let s:path = s:path . stdpath('data') . ','
  " Idk if this is gonna glob the way I want.
  let s:path = s:path . stdpath('data') . '/**1/autoload,'

  let &l:path = s:path
  return s:path
endfunction

function! includes#CPath() abort
  let s:path='.,**,,'

  if exists('$PREFIX')
    let s:root  = expand('$PREFIX')
  else
    let s:root  = '/usr'
  endif

  if has('unix')
    let s:path = s:path . s:root. '/include,' . s:root . '/local/include,'

    if isdirectory(expand('$HOME/.local/include'))
      let s:path = s:path . ',' .  expand('$HOME') . '/.local/include'
    endif

  else
    " Note: shellslash HAS to be set for this to work.
    let s:old_ss = &shellslash
    set shellslash
    " we did it.
    if exists('$INCLUDE')
      let s:path = s:path . expand('$INCLUDE')
      " Don't forget to change it back though!
      let &shellslash = s:old_ss
      let &l:path = s:path
      return s:path
    endif

    " 2015-2019 vcredist
    if isdirectory('C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC')
      let s:path = s:path . 'C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/**,'
    endif

    " 2010 redist
    if isdirectory('C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include')
      let s:path = s:path . 'C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include,'
    endif

    " Yo honestly this is the one you're looking for
    if isdirectory('C:/Program Files (x86)/Windows Kits/10/include')
      let s:path = s:path . 'C:/Program Files (x86)/Windows Kits/10/include/**3,'
    endif

    if exists('$INCLUDEDIR')
      let s:path = s:path . ',' . expand('$INCLUDEDIR') . ','
    endif

    " some good python ones
    if isdirectory('C:/Users/fac/scoop/apps/winpython/current/python-3.8.1.amd64/include')
      let s:path .= 'C:/Users/fac/scoop/apps/winpython/current/python-3.8.1.amd64/include,'
    endif

    let &shellslash = s:old_ss
  endif

  let &l:path = s:path
  return s:path
endfunction

function! s:ts_node_modules() abort
  " node_modules
  let s:node_modules = finddir('node_modules', '.;', -1)
  if len(s:node_modules)
    let b:ts_node_modules = map(s:node_modules, { idx, val -> substitute(fnamemodify(val, ':p'), '/$', '', '')})
    unlet! s:node_modules
  endif
endfunction

function! includes#typescript_setup() abort
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
