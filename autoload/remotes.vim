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

let s:termux = isdirectory('/data/data/com.termux')    " Termux check from Evervim. Thanks!
let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

" TIL: finish can't be used inside of a function as it doesn't count as 'sourced'
if exists('g:autoloaded_remotes')
  finish
endif
let g:autoloaded_remotes = 1  " just to let me know that this got sourced

function! remotes#unix_clipboard() abort
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
endfunction

function! remotes#termux() abort
  " From what i can tell, this line alone is as good as :UpdateRemotePlugins
  " let g:python3_host_prog = s:repo_root . '/.venv/bin/python'
  let g:loaded_python_provider = 1
  let g:python3_host_prog = expand("$PREFIX/bin/python")

  " let g:node_host_prog = '/data/data/com.termux/files/home/.local/share/yarn/global/node_modules/neovim/bin/cli.js'
  let g:node_host_prog = '/data/data/com.termux/files/usr/bin/neovim-node-host'
  let g:ruby_host_prog = '/data/data/com.termux/files/home/.gem/bin/neovim-ruby-host'

  let g:loaded_remote_plugins = '/data/data/com.termux/files/home/.local/share/nvim/rplugin.vim'

  call remote#host#RegisterPlugin('node', '/data/data/com.termux/files/home/projects/viconf/rplugin/node/coc_tag.js', [])
  " $VIMRUNTIME/autoload/remote/host.vim
  " call remote#host#Register('python', '*',
  "       \ function('provider#pythonx#Require'))
  " call remote#host#Register('python3', '*',
  "       \ function('provider#pythonx#Require'))
  " $VIMRUNTIME/autoload/provider/python.vim
  " The Python provider plugin will run in a separate instance of the Python
  " host.
  " call remote#host#RegisterClone('legacy-python-provider', 'python')
  " call remote#host#RegisterPlugin('legacy-python-provider', 'script_host.py', [])

  " $VIMRUNTIME/autoload/provider/python3.vim
  " The Python3 provider plugin will run in a separate instance of the Python3
  " host.
  " call remote#host#RegisterClone('legacy-python3-provider', 'python3')
  " call remote#host#RegisterPlugin('legacy-python3-provider', 'script_host.py', [])

  " And for all of this, $VIMRUNTIME/autoload/provider/pythonx.vim,
  " is still the file i want to entirely rewrite. no values are returned from the functions, the
  " vars are referenced globally but are s: scoped like its literally fucking impossible to work
  " with.
  "
  " So this line need to be under the registerplugin call. Btw wouldnt it make more sense to have
  " registerplugin before clone? Whatever.
  " Because we set this $VIMRUNTIME/plugin/rplugin.vim isnt gomna load
  " from $VIMRUNTIME/autoload/provider/python3.vim
  " provider#python3#Call
    " Ensure that we can load the Python host before bootstrapping
    " i want the object first also i wanna make sure that this is getting called
  " let g:python3host = remote#host#Require('legacy-python3-provider')
  call remotes#unix_clipboard()
endfunction

function! remotes#ubuntu() abort
  let g:python3_host_prog = '/usr/bin/python3.8'
  let g:python_host_prog = '/usr/bin/python2'
  " ?
  " let g:node_host_prog = 'nvm use default'
  let g:node_host_prog = expand('~/.local/share/yarn/global/node_modules/neovim/bin/cli.js')
  let g:ruby_host_prog = expand('~/.gem/bin/neovim-ruby-host')

  call remotes#unix_clipboard()
endfunction

function! remotes#msdos() abort
  " Don't set python paths dynamically it's such a headache
  let g:python3_host_prog = 'C:\Users\Casey\scoop\apps\miniconda3\current\envs\pyqt\python.exe'
  " let g:python_host_prog = 'C:\Users\Casey\.windows-build-tools\python27\python.exe'
  " wow this one actually fucking worked
  let g:node_host_prog = 'C:\Users\Casey\scoop\persist\nodejs-lts\bin\node_modules\neovim\bin\cli.js'
  " let g:ruby_host_prog = 'C:\Users\Casey\scoop\apps\ruby\current\bin\ruby.exe'

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
  try
    call remote#host#RegisterPlugin('node', 'C:/Users/Casey/.config/nvim/rplugin/node/coc_tag.js', [])
  catch
  endtry
endfunction

function! remotes#ResetPython() abort
    " I don't know why
  unlet! g:python3_host_prog
  let g:python3_host_prog = exepath('python')
endfunc

function! remotes#HardReset(ruby_host) abort
  " Note that this line will raise if script_host ia already registered.
  " unlet! g:loaded_python3_provider | source $VIMRUNTIME/autoload/provider/python3.vim

  " This right here was 70% of the previous startuptime
  if a:ruby_host is v:true
    rubyfile $VIMRUNTIME/autoload/provider/script_host.rb
  endif
endfunction

function! remotes#init() abort
  if exists('g:autoloaded_remotes_init')
    echo 'remotes#init: Something is sourcing this twice.'
    return
  endif

  " just to let me know that this got sourced
  let g:autoloaded_remotes_init = 1

  if !has('nvim')
    return
  endif

  " Dispatches the module as needed here
  if !has('unix')
    call remotes#msdos()
  else
    if s:termux
      call remotes#termux()
    else
      call remotes#ubuntu()
    endif
  endif
  " So i dont think this responds to PluginsForHost
  " source $VIMRUNTIME/autoload/provider/clipboard.vim

  let g:failed_providers = {}

  source $VIMRUNTIME/autoload/remote/host.vim

  source $VIMRUNTIME/autoload/remote/define.vim

  " Dont load python because for some reason thats the only one that takes 200ms
  for i in ['node', 'python3', 'pythonx', 'ruby']
    try
      " :unlet g:loaded_clipboard_provider
      exe 'silent! unlet! g:loaded_' . i . '_provider'
      " :runtime autoload/provider/clipboard.vim
      exe 'source $VIMRUNTIME/autoload/provider/' . i . '.vim'
      try
        call remote#host#PluginsForHost(i)
      catch /.*/
        let g:failed_providers[i + "_host"] = v:exception
      endtry
      " Note that this line will raise if script_host ia already registered.
      " unlet! g:loaded_python3_provider | source $VIMRUNTIME/autoload/provider/python3.vim
    catch
      " **DO NOT** echoerr. It'll jam the functoin and stop the rest of the for loop from continuing.
      let g:failed_providers[i] = v:exception
    endtry

  endfor
  source $VIMRUNTIME/autoload/provider/clipboard.vim
  return g:failed_providers
endfunction
