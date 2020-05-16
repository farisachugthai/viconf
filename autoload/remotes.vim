" For a distressing amount of time `:UpdateRemotePlugins` has been failing in a way
" that simultaneously.:
"
" #) Freezes the entire terminal.
" #) Updates nothing
" #) Leaves no error messages
" #) Happens across devices
" and I can't track the bug down. It's been going on for months and at this point I've taken
" apart how neovim's remote hosts work well enough that I pretty much have the user facing portion
" of the code laid out here. So if something fucks up, tinker here and make note of it.

if exists('g:loaded_autoload_remotes') || &compatible || v:version < 700
    finish
endif
" let g:loaded_autoload_remotes = 1

let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))


function! remotes#init() abort  " {{{
  " Dispatches the remainder here
  if !has('unix')
    call remotes#msdos()
  else
    if s:termux
      call remotes#termux()
    else
      call remotes#ubuntu()
    endif
  endif
endfunction  " }}}

function! remotes#termux() abort  " {{{

  " From what i can tell, this line alone is as good as :UpdateRemotePlugins
  source $VIMRUNTIME/autoload/remote/host.vim

  let g:python3_host_prog = expand('$PREFIX/bin/python')
  source $VIMRUNTIME/autoload/provider/python3.vim

  let g:loaded_python_provider = 1

  let g:node_host_prog = '/data/data/com.termux/files/home/.local/share/yarn/global/node_modules/neovim/bin/cli.js'
  source $VIMRUNTIME/autoload/provider/node.vim

  let g:ruby_host_prog = '/data/data/com.termux/files/home/.gem/bin/neovim-ruby-host'
  source $VIMRUNTIME/autoload/provider/ruby.vim
  rubyfile $VIMRUNTIME/autoload/provider/script_host.rb

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
  source $VIMRUNTIME/autoload/provider/clipboard.vim
endfunction   " }}}

function! remotes#ubuntu() abort  " {{{
  " From what i can tell, this line alone is as good as :UpdateRemotePlugins
  source $VIMRUNTIME/autoload/remote/host.vim

  let g:python3_host_prog = '/usr/sbin/python'
  source $VIMRUNTIME/autoload/provider/python3.vim
  let g:python_host_prog = '/usr/sbin/python2'
  source $VIMRUNTIME/autoload/provider/python.vim
  " ?
  " let g:node_host_prog = 'nvm use default'
  let g:node_host_prog = expand('~/.local/share/yarn/global/node_modules/neovim/bin/cli.js')
  source $VIMRUNTIME/autoload/provider/node.vim
  let g:ruby_host_prog = expand('~/.gem/bin/neovim-ruby-host')
  source $VIMRUNTIME/autoload/provider/ruby.vim
  rubyfile $VIMRUNTIME/autoload/provider/script_host.rb

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
    " TODO: Could just use termux-clipboard-get and set
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
          \   }

  endif
  source $VIMRUNTIME/autoload/provider/clipboard.vim
endfunction  " }}}

function! remotes#msdos() abort  " {{{
  " From what i can tell, this line alone is as good as :UpdateRemotePlugins
  source $VIMRUNTIME/autoload/remote/host.vim

  " Don't set python paths dynamically it's such a headache
  let g:python3_host_prog = 'C:/Users/fac/scoop/apps/winpython/current/python-3.8.1.amd64/python.exe'
  " silent! unlet! g:loaded_python3_provider
  source $VIMRUNTIME/autoload/provider/python3.vim

  let g:python_host_prog = 'C:\Users\fac\.windows-build-tools\python27\python.exe'
  " silent! unlet! g:loaded_python_provider
  source $VIMRUNTIME/autoload/provider/python.vim

  source $VIMRUNTIME/autoload/provider/pythonx.vim

  let g:node_host_prog = 'C:\Users\fac\scoop\apps\winpython\current\n\node_modules\neovim\bin\cli.js'
  " silent! unlet! g:loaded_node_provider
  " source $VIMRUNTIME/autoload/provider/node.vim

  let g:ruby_host_prog = 'C:/Users/fac/scoop/apps/ruby/current/bin/ruby.exe'
  " silent! unlet! g:loaded_ruby_provider
  " Sourcing this file also gets the script_host.rb file
  " source $VIMRUNTIME/autoload/provider/ruby.vim

  let g:clipboard = {
        \   'name': 'winClip',
        \   'copy': {
        \      '+': 'win32yank.exe -i --crlf',
        \      '*': 'win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --crlf',
        \      '*': 'win32yank.exe -o --crlf',
        \   },
        \   'cache_enabled': 1,
        \ }

  source $VIMRUNTIME/autoload/provider/clipboard.vim
  " return remotes#HardReset()

endfunction   " }}}

function! remotes#HardReset() abort   " {{{

  let g:failed_providers = {}
  for i in ['clipboard' , 'node', 'python', 'python3', 'pythonx', 'ruby']
    try
      " :unlet g:loaded_clipboard_provider
      exe 'unlet! g:loaded_' . i . '_provider'
      exe 'unlet! g:'. i . 'host_prog'
      exe 'source $VIMRUNTIME/autoload/provider/' . i . '.vim'
    catch
      " **DO NOT** echoerr. It'll jam the functoin and stop the rest of the for loop from continuing.
      let g:failed_providers[i] = v:exception
    endtry
  endfor

  rubyfile $VIMRUNTIME/autoload/provider/script_host.rb
  return g:failed_providers
endfunction   " }}}
