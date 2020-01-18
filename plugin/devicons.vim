" ============================================================================
    " File: devicons.vim
    " Author: Faris Chugthai
    " Description: Devicons conf
    " Last Modified: Jan 17, 2020
" ============================================================================

scriptencoding utf-8
let g:webdevicons_enable_nerdtree = 1               " adding the flags to NERDTree
let g:airline_powerline_fonts = 1
let g:DevIconsEnableFoldersOpenClose = 1

" change the default character when no match found
" Heres the original
" let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''

" Heres a neat one! Fuck
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''

" enable file extension pattern matching glyphs on folder/directory (disabled by default with 0)
let g:DevIconsEnableFolderExtensionPatternMatching = 1

" Enable this for a specific ftplugin I'm curious what thisll look like. We
" already call that func but the rest I'm curious about.
" Tried netrw and it looks weird.
" setlocal statusline=%f\ %{WebDevIconsGetFileTypeSymbol()}\ %h%w%m%r\ %=%(%l,%c%V\ %Y\ %=\ %P%)

" Heres an example of how to override filetypes.
" let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
" let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['myext'] = 'ƛ'

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sqlite'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['python'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md'] = ''

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cs'] = ''

  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols= {
        \ 'styl'     : '',
        \ 'sass'     : '',
        \ 'scss'     : '',
        \ 'htm'      : '',
        \ 'html'     : '',
        \ 'slim'     : '',
        \ 'ejs'      : '',
        \ 'css'      : '',
        \ 'less'     : '',
        \ 'md'       : '',
        \ 'mdx'      : '',
        \ 'markdown' : '',
        \ 'rmd'      : '',
        \ 'json'     : '',
        \ 'js'       : '',
        \ 'mjs'      : '',
        \ 'jsx'      : '',
        \ 'rb'       : '',
        \ 'php'      : '',
        \ 'py'       : '',
        \ 'pyc'      : '',
        \ 'pyo'      : '',
        \ 'pyd'      : '',
        \ 'coffee'   : '',
        \ 'mustache' : '',
        \ 'hbs'      : '',
        \ 'conf'     : '',
        \ 'ini'      : '',
        \ 'yml'      : '',
        \ 'yaml'     : '',
        \ 'toml'     : '',
        \ 'bat'      : '',
        \ 'jpg'      : '',
        \ 'jpeg'     : '',
        \ 'bmp'      : '',
        \ 'png'      : '',
        \ 'gif'      : '',
        \ 'ico'      : '',
        \ 'twig'     : '',
        \ 'cpp'      : '',
        \ 'c++'      : '',
        \ 'cxx'      : '',
        \ 'cc'       : '',
        \ 'cp'       : '',
        \ 'c'        : '',
        \ 'cs'       : '',
        \ 'h'        : '',
        \ 'hh'       : '',
        \ 'hpp'      : '',
        \ 'hxx'      : '',
        \ 'hs'       : '',
        \ 'lhs'      : '',
        \ 'lua'      : '',
        \ 'java'     : '',
        \ 'sh'       : '',
        \ 'fish'     : '',
        \ 'bash'     : '',
        \ 'zsh'      : '',
        \ 'ksh'      : '',
        \ 'csh'      : '',
        \ 'awk'      : '',
        \ 'ps1'      : '',
        \ 'ml'       : 'λ',
        \ 'mli'      : 'λ',
        \ 'diff'     : '',
        \ 'db'       : '',
        \ 'sql'      : '',
        \ 'dump'     : '',
        \ 'clj'      : '',
        \ 'cljc'     : '',
        \ 'cljs'     : '',
        \ 'edn'      : '',
        \ 'scala'    : '',
        \ 'go'       : '',
        \ 'dart'     : '',
        \ 'xul'      : '',
        \ 'sln'      : '',
        \ 'suo'      : '',
        \ 'pl'       : '',
        \ 'pm'       : '',
        \ 't'        : '',
        \ 'rss'      : '',
        \ 'f#'       : '',
        \ 'fsscript' : '',
        \ 'fsx'      : '',
        \ 'fs'       : '',
        \ 'fsi'      : '',
        \ 'rs'       : '',
        \ 'rlib'     : '',
        \ 'd'        : '',
        \ 'erl'      : '',
        \ 'hrl'      : '',
        \ 'ex'       : '',
        \ 'exs'      : '',
        \ 'eex'      : '',
        \ 'leex'     : '',
        \ 'vim'      : '',
        \ 'ai'       : '',
        \ 'psd'      : '',
        \ 'psb'      : '',
        \ 'ts'       : '',
        \ 'tsx'      : '',
        \ 'jl'       : '',
        \ 'pp'       : '',
        \ 'vue'      : '﵂',
        \ 'elm'      : '',
        \ 'swift'    : '',
        \ 'xcplayground' : ''
        \}

  let s:file_node_exact_matches = {
        \ 'exact-match-case-sensitive-1.txt' : '1',
        \ 'exact-match-case-sensitive-2'     : '2',
        \ 'gruntfile.coffee'                 : '',
        \ 'gruntfile.js'                     : '',
        \ 'gruntfile.ls'                     : '',
        \ 'gulpfile.coffee'                  : '',
        \ 'gulpfile.js'                      : '',
        \ 'gulpfile.ls'                      : '',
        \ 'mix.lock'                         : '',
        \ 'dropbox'                          : '',
        \ '.ds_store'                        : '',
        \ '.gitconfig'                       : '',
        \ '.gitignore'                       : '',
        \ '.gitlab-ci.yml'                   : '',
        \ '.bashrc'                          : '',
        \ '.zshrc'                           : '',
        \ '.vimrc'                           : '',
        \ '.gvimrc'                          : '',
        \ '_vimrc'                           : '',
        \ '_gvimrc'                          : '',
        \ '.bashprofile'                     : '',
        \ 'favicon.ico'                      : '',
        \ 'license'                          : '',
        \ 'node_modules'                     : '',
        \ 'react.jsx'                        : '',
        \ 'procfile'                         : '',
        \ 'dockerfile'                       : '',
        \ 'docker-compose.yml'               : '',
        \}

  let s:file_node_pattern_matches = {
        \ '.*jquery.*\.js$'       : '',
        \ '.*angular.*\.js$'      : '',
        \ '.*backbone.*\.js$'     : '',
        \ '.*require.*\.js$'      : '',
        \ '.*materialize.*\.js$'  : '',
        \ '.*materialize.*\.css$' : '',
        \ '.*mootools.*\.js$'     : '',
        \ '.*vimrc.*'             : '',
        \ 'Vagrantfile$'          : ''
        \}

