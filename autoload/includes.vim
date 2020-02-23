" ============================================================================
  " File: includes.vim
  " Author: Faris Chugthai
  " Description: Settin up the path for different file types.
  " Last Modified: February 22, 2020
" ============================================================================

" See Also: ./py.vim and py#PythonPath

function! includes#TypeScriptIncludeExpression(fname, gf) abort  " {{{
    " BUILT-IN NODE MODULES
    " =====================
    " they aren't natively accessible but we can use @types/node if available
    if index([ 'assert', 'async_hooks',
             \ 'base', 'buffer',
             \ 'child_process', 'cluster', 'console', 'constants', 'crypto',
             \ 'dgram', 'dns', 'domain',
             \ 'events',
             \ 'fs',
             \ 'globals',
             \ 'http', 'http2', 'https',
             \ 'inspector',
             \ 'net',
             \ 'os',
             \ 'path', 'perf_hooks', 'process', 'punycode',
             \ 'querystring',
             \ 'readline', 'repl',
             \ 'stream', 'string_decoder',
             \ 'timers', 'tls', 'trace_events', 'tty',
             \ 'url', 'util',
             \ 'v8', 'vm',
             \ 'worker_threads',
             \ 'zlib' ], a:fname) != -1

      let found_definition = b:ts_node_modules[0] . '/@types/node/' . a:fname . '.d.ts'

      if filereadable(found_definition)
          return found_definition
      endif

      return 0
    endif

    " LOCAL IMPORTS
    " =============
    " they are everywhere so we must get them right
    if a:fname =~ '^\.'
      " ./
      if a:fname =~ '^\./$'
        return './index.ts'
      endif

      " ../
      if a:fname =~ '\.\./$'
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
      for path in b:ts_config_paths
        if a:fname =~ path[0]
          let base_name = substitute(a:fname, path[0], path[1] . '/', '')

          if isdirectory(base_name)
            return base_name . '/index'
          endif

          return base_name
        endif
      endfor
    endif

    " this is where we stop for include-search/definition-search
    if !a:gf
      if filereadable(a:fname)
        return a:fname
      endif

      return 0
    endif

    " NODE IMPORTS
    " ============
    " give up if there's no node_modules
    if empty(get(b:, 'ts_node_modules', []))
        if filereadable(a:fname)
            return a:fname
        endif

        return 0
    endif

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
    let parts = split(a:fname, '/')

    if parts[0] =~ '^@'
      let package_name = join(parts[0:1], '/')
      let sub_path = join(parts[2:-1], '/')
    else
      let package_name = parts[0]
      let sub_path = join(parts[1:-1], '/')
    endif

    " find the package.json for that package
    let package_json = b:ts_node_modules[-1] . '/' . package_name . '/package.json'

    " give up if there's no package.json
    if !filereadable(package_json)
      if filereadable(a:fname)
        return a:fname
      endif

      return 0
    endif

    if len(sub_path) == 0
      " grab data from the package.json
      if !has_key(b:ts_packages, a:fname)
        let package = json_decode(join(readfile(package_json)))
        let b:ts_packages[a:fname] = {
                    \ "pack": fnamemodify(package_json, ':p:h'),
                    \ "entry": substitute(get(package, "typings", get(package, "main", "index.js")), '^\.\{1,2}\/', '', '')
                    \ }
      endif

      " build path from 'typings' key
      " fall back to 'main' key
      " fall back to 'index.js'
      return b:ts_packages[a:fname].pack . "/" . b:ts_packages[a:fname].entry
    else
      " build the path to the module
      let common_path = fnamemodify(package_json, ':p:h') . '/' . sub_path

      " first, try with .ts and .js
      let found_ext = glob(common_path . '.[jt]s', 1)
      if len(found_ext)
        return found_ext
      endif

      " second, try with /index.ts and /index.js
      let found_index = glob(common_path . '/index.[jt]s', 1)
      if len(found_index)
        return found_index
      endif

      " give up
      if filereadable(a:fname)
        return a:fname
      endif

      return 0
    endif

    " give up
    if filereadable(a:fname)
      return a:fname
    endif

    return a:fname . '.d.ts'
  endfunction   " }}}

