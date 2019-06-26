" ============================================================================
    " File: remote.vim
    " Author: Faris Chugthai
    " Description: All the remote hosts that Neovim loads
    " Last Modified: June 08, 2019
" ============================================================================

" Preliminaries: {{{1
scriptencoding utf-8
let s:cpo_save = &cpoptions
set cpoptions&vim

" Remote Hosts: {{{1
  " Set the node and ruby remote hosts

" Node Host: {{{2
function! Get_Node_Host() abort
    " worked when i ran it with set shell=cmd
  if executable('yarn')
    if filereadable(shellescape(expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'))
      let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'

    elseif filereadable(shellescape(system('yarn global dir')) . '/node_modules/.bin/neovim-node-host')
        let g:node_host_prog = shellescape(system('yarn global dir')) . '/node_modules/.bin/neovim-node-host'
    endif

  " on the assumption that which has to stat every hashed exec on the $PATH,
  " I'd guess its the slowest way to fogure this out, but probably a really
  " smart one to fall back on.
  elseif executable('which')   " if we're using bash or we have 'nix tools loaded

      " slashes end up backwards on windows but let's see if that's not a problem
      " postscript: if it is utilize a function! g:Slash() abort
      " tr('\\', '/') or some shit to fix path names. Check out fugitive
      " or pathogen for inspiration.
      " ...or just set shellslash dude.

      let g:node_host_prog = system('which node')

  " TODO: do a conda check. I know this is annoying as hell but the remote
  " hosts keep getting unset!!
  else
    let g:loaded_node_provider = 1
  endif
endfunction

" call Get_Node_Host()

" Gem Remote Host. {{{2

function! Get_Ruby_Host() abort
  " Really doesn't help that I don't know anything about ruby.

  if executable('rvm')
    let g:ruby_host_prog = 'rvm system do neovim-ruby-host'
  elseif filereadable(expand('$_ROOT') . '/local/bin/neovim-ruby-host')
    let g:ruby_host_prog = expand('$_ROOT') . '/local/bin/neovim-ruby-host'
  elseif filereadable('~/.local/bin/neovim-ruby-host')
    let g:ruby_host_prog = '~/.local/bin/neovim-ruby-host'
  elseif filereadable(expand($_ROOT) . 'lib/ruby/gems/2.6.3/gems/neovim-0.8.0/exe/neovim-ruby-host')
    let g:ruby_host_prog = expand($_ROOT) . 'lib/ruby/gems/2.6.3/gems/neovim-0.8.0/exe/neovim-ruby-host'
  elseif filereadable(expand('$_ROOT') . 'bin/neovim-ruby-host')
    let g:ruby_host_prog = expand('$_ROOT') . 'bin/neovim-ruby-host'
  elseif executable('which')
    let g:ruby_host_prog = system('which ruby')
  else
    let g:loaded_ruby_provider = 1
  endif

endfunction

" call Get_Ruby_Host()

" Python Executables: {{{1

" Python3: {{{2

function! PythonRemoteHost() abort
  " If we have a virtual env start there. Actually we should probably check if
  " we have expand('$PIPENV_ACTIVE') == 1 dude fuckkk TODO
  if exists('$VIRTUAL_ENV')
      let g:python3_host_prog = expand('$VIRTUAL_ENV') . '/bin/python'
      let &path = &path . ',' . expand('$VIRTUAL_ENV') . '/lib/python3/*'

  " On Windows we conveniently get this env var with Conda.
  elseif exists('$CONDA_PYTHON_EXE')
    let g:python3_host_prog = expand('$CONDA_PYTHON_EXE')
    let &path = &path . ',' . expand('$CONDA_PYTHON_EXE')

  elseif exists('$CONDA_PREFIX')
    let g:python3_host_prog = expand('$CONDA_PREFIX/bin/python3')
    let &path = &path . ',' . expand('$CONDA_PREFIX/lib/python3/*')

  else
      " If not then just use the system python
    if executable(expand('$_ROOT') . '/bin/python3')
    let g:python3_host_prog = expand('$_ROOT') . '/bin/python3'
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python3/*'

    " well that's if we can find it anyway
    elseif executable('/usr/bin/python3')
      let g:python3_host_prog = '/usr/bin/python3'
      let &path = &path . ',' . '/usr/lib/python3/*'

    " and if we can't just disable it because it starts spouting off errors
    else
      let g:loaded_python3_provider = 1
    endif

  endif
endfunction

call PythonRemoteHost()

" Make it simpler to view the host. This is the same as
" provider#python3#Prog()
command! Python3Host -nargs=0 echo provider#pythonx#Detect(3)[0]

" python2 remote host: {{{2

function! RemotePython2Host() abort

  if executable(expand('$_ROOT') . '/bin/python2')
      let g:python_host_prog = expand('$_ROOT') . '/bin/python2'
      let &path = &path . ',' . expand('$_ROOT') . '/lib/python2/*'
  elseif executable('/usr/bin/python2')
      let g:python3_host_prog = '/usr/bin/python2'
      let &path = &path . ',' . '/usr/lib/python2/*'
  else
      let g:loaded_python_provider = 1
  endif
endfunction

call RemotePython2Host()

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
