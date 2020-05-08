" header

function! remotes#termux_remote() abort  " {{{
  let g:python3_host_prog = expand('$PREFIX/bin/python')
  let g:loaded_python_provider = 1
  let g:node_host_prog = '/data/data/com.termux/files/home/.local/share/yarn/global/node_modules/neovim/bin/cli.js'
  let g:ruby_host_prog = '/data/data/com.termux/files/home/.gem/bin/neovim-ruby-host'

  if exists('$TMUX')
    let g:clipboard = {
          \   'name': 'tmux-clipboard',
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
endfunction   " }}}

function! remotes#ubuntu_remote() abort  " {{{1
  let g:python3_host_prog = '/usr/sbin/python'
  let g:python_host_prog = '/usr/sbin/python2'
  " ?
  let g:node_host_prog = 'nvm use default'
  let g:ruby_host_prog = expand('~/.gem/bin/neovim-ruby-host')

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
  else  " TODO: Could just use termux-clipboard-get and set
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

function! remotes#msdos_remote() abort  " {{{1
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

  call remotes#HardReset()
endfunction   " }}}

function! remotes#HardReset() abort   " {{{

  for i in ['clipboard' , 'node', 'python', 'python3', 'pythonx', 'ruby']
    try
      " :unlet g:loaded_clipboard_provider
      exe 'unlet! g:loaded_' . i . '_provider'
      " :runtime autoload/provider/clipboard.vim
      exe 'runtime! autoload/provider/' . i . '.vim'
    catch /.*/
      echoerr 'remotes#HardReset caught ' .. v:exception
    endtry
  endfor

endfunction   " }}}

" For a distressing amount of time `:UpdateRemotePlugins` has been failing in a way
" that simultaneously.:
"
" #) Freezes the entire terminal.
" #) Updates nothing
" #) Leaves no error messages
" #) Happens across devices
" and I can't track the bug down.It's been going on for months and at this point I've taken
" apart how neovim's remote hosts work well enough that i pretty much have it exclusively cataloged
" here. so if something fucks up, tinker here and make note of it.
if exists('g:loaded_remote_plugins')
  finish
endif
" So this var is explicitly checked at $VIMRUNTIME/plugin/rplugin.vim
let g:loaded_remote_plugins = fnamemodify(resolve(expand('%')), ':p')

" perl plugins


" node plugins
try
  call remote#host#RegisterPlugin('node', 'C:/Users/fac/.config/nvim/rplugin/node/coc_tag.js', [
     \ ])
catch /^.*E605**/
endtry


" python3 plugins
" The Python3 provider plugin will run in a separate instance of the Python3 host.
try
  call remote#host#RegisterClone('legacy-python3-provider', 'python3')
catch /^.*E605**/
endtry

try
  call remote#host#RegisterPlugin('legacy-python3-provider', 'script_host.py', [])
catch /^.*E605**/
endtry


" ruby plugins
try
  call remote#host#RegisterClone('legacy-ruby-provider', 'ruby')
catch /^.*E605**/
endtry

try
  call remote#host#RegisterPlugin('legacy-ruby-provider', s:plugin_path, [])
catch /^.*E605**/
endtry

" python plugins

" The Python provider plugin will run in a separate instance of the Python host.
try
  call remote#host#RegisterClone('legacy-python-provider', 'python')
catch /^.*E605**/
endtry

try
  call remote#host#RegisterPlugin('legacy-python-provider', 'script_host.py', [])
catch /^.*E605**/
endtry

