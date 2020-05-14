" header
let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))


function! remotes#init() abort  " {{{
  " Dispatches the remainder here
  if !has('unix')
    call remotes#msdos()
  else
    if s:termux
       call remotes#termux()
  " call remotes#HardReset()
    else
      call remotes#ubuntu()
    endif
  endif
endfunction  " }}}

function! remotes#unix_clipboard() abort " {{{

  if exists('$TMUX')
    let g:clipboard = {
          \   'name': 'myclipboard',
          \   'copy': {
          \      '+': 'tmux load-buffer -',
          \      '*': 'tmux load-buffer -',
          \    },
          \   'paste': {
          \      '+': 'tmux save-buffer -',
          \      '*': 'tmux save-buffer -',
          \   },
          \   'cache_enabled': 1,
          \ }
  else
    let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \      '*': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \    },
          \   'paste': {
          \      '+': {-> get(g:, 'foo', [])},
          \      '*': {-> get(g:, 'foo', [])},
          \   },
          \ }

  endif
endfunction  " }}}

function! remotes#_sources(ruby_host) abort  " {{{
  source $VIMRUNTIME/autoload/remote/host.vim
  source $VIMRUNTIME/autoload/provider/python3.vim
  source $VIMRUNTIME/autoload/provider/pythonx.vim
  source $VIMRUNTIME/autoload/provider/python.vim
" Note that this line will raise if script_host ia already registered.
  " unlet! g:loaded_python3_provider | source $VIMRUNTIME/autoload/provider/python3.vim
  source $VIMRUNTIME/autoload/provider/node.vim
  source $VIMRUNTIME/autoload/provider/ruby.vim

  if a:ruby_host is v:true
    rubyfile $VIMRUNTIME/autoload/provider/script_host.rb
  endif

  source $VIMRUNTIME/autoload/provider/clipboard.vim
endfunction   " }}}

function! remotes#termux() abort
  " From what i can tell, this line alone is as good as :UpdateRemotePlugins
  let g:python3_host_prog = s:repo_root . '/.venv/bin/python'
  let g:loaded_python_provider = 1

  augroup FuckingRemotes
    au!
    " *****
    " Bug:
    " *****
    " syntax hl fucks up here
    au! UltiSnips_AutoTrigger *
  augroup END
  unlet! g:loaded_python3_provider

  let g:node_host_prog = '/data/data/com.termux/files/home/.local/share/yarn/global/node_modules/neovim/bin/cli.js'
  let g:ruby_host_prog = '/data/data/com.termux/files/home/.gem/bin/neovim-ruby-host'

  call remotes#unix_clipboard()
  call remotes#_sources(v:true)
endfunction   " }}}

function! remotes#ubuntu_remote() abort  " {{{
  let g:python3_host_prog = '/usr/sbin/python'
  let g:python_host_prog = '/usr/sbin/python2'
  " ?
  " let g:node_host_prog = 'nvm use default'
  let g:node_host_prog = expand('~/.local/share/yarn/global/node_modules/neovim/bin/cli.js')
  let g:ruby_host_prog = expand('~/.gem/bin/neovim-ruby-host')

  call remotes#unix_clipboard()
  call remotes#_sources(v:true)
endfunction  " }}}

function! remotes#msdos_remote() abort  " {{{
  " Don't set python paths dynamically it's such a headache
  " let g:python3_host_prog = 'C:\Python38\python.exe'
  let g:python3_host_prog = 'C:/Users/fac/scoop/apps/winpython/current/python-3.8.1.amd64/python.exe'
  let g:python_host_prog = 'C:/Python27/python.exe'
  let g:loaded_ruby_provider = 1
  " wow this one actually fucking worked
  let g:node_host_prog = 'C:\Users\fac\scoop\apps\winpython\current\n\node_modules\neovim\bin\cli.js'

    let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \      '*': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \    },
          \   'paste': {
          \      '+': {-> get(g:, 'foo', [])},
          \      '*': {-> get(g:, 'foo', [])},
          \   },
          \ }

  "  let g:clipboard = {
  "        \   'name': 'winClip',
  "        \   'copy': {
  "        \      '+': 'win32yank.exe -i --crlf',
  "        \      '*': 'win32yank.exe -i --crlf',
  "        \    },
  "        \   'paste': {
  "        \      '+': 'win32yank.exe -o --crlf',
  "        \      '*': 'win32yank.exe -o --crlf',
  "        \   },
  "        \   'cache_enabled': 1,
  "        \ }

  source $VIMRUNTIME/autoload/provider/clipboard.vim
  call remotes#HardReset()
endfunction   " }}}

function! remotes#HardReset() abort   " {{{

  for i in ['clipboard' , 'node', 'python', 'python3', 'pythonx', 'ruby']
    try
      " :unlet g:loaded_clipboard_provider
      exe 'silent! unlet! g:loaded_' . i . '_provider'
      " :runtime autoload/provider/clipboard.vim
      exe 'source $VIMRUNTIME/autoload/provider/' . i . '.vim'
    catch /.*/
      echoerr 'remotes#HardReset caught ' . v:exception
    endtry
  endfor

  source $VIMRUNTIME/autoload/provider/clipboard.vim
endfunction   " }}}

" For a distressing amount of time `:UpdateRemotePlugins` has been failing in a way
" that simultaneously.:
"
" #) Freezes the entire terminal.
" #) Updates nothing
" #) Leaves no error messages
" #) Happens across devices
" I can't track the bug down.It's been going on for months and at this point
" I've taken apart how neovim's remote hosts work well enough that i pretty much
" have it exclusively cataloged here. so if something fucks up, tinker here and
" make note of it. So this var is explicitly checked at $VIMRUNTIME/plugin/rplugin.vim


" Also wortb noting: remote#host#RegisterClone can be called repeatedly so
" we can leave this as a global.
" remote#host#RegisterPlugin WILL raise so don't leave it at the global level.

" perl plugins


" node plugins

" python3 plugins
" The Python3 provider plugin will run in a separate instance of the Python3 host.
try
  call remote#host#RegisterClone('legacy-python3-provider', 'python3')
catch
endtry


" ruby plugins
try
  call remote#host#RegisterClone('legacy-ruby-provider', 'ruby')
catch
endtry

" python plugins

" The Python provider plugin will run in a separate instance of the Python host.
try
  call remote#host#RegisterClone('legacy-python-provider', 'python')
catch
endtry

