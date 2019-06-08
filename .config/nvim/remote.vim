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

function! Get_Node_Host() abort
  " So we should be able to refactor the yarn portion out.
  " It's the same on every platform.
  if executable('yarn')
    if filereadable(shellescape(expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'))
      let g:node_host_prog = expand('$XDG_DATA_HOME') . '/yarn/global/node_modules/.bin/neovim-node-host'
    endif

  elseif executable('which')   " if we're using bash or we have 'nix tools loaded

      " slashes end up backwards on windows but let's see if that's not a problem
      " postscript: if it is utilize a function! g:Slash() abort
      " tr('\\', '/') or some shit to fix path names. Check out fugitive
      " or pathogen for inspiration.
      let g:node_host_prog = system('which node')

  else
    let g:loaded_node_provider = 1
  endif
endfunction

call Get_Node_Host()

" gem remote host. should be refactored.
if g:termux

  if filereadable(expand($_ROOT) . 'lib/ruby/gems/2.6.3/gems/neovim-0.8.0/exe/neovim-ruby-host')
      let g:ruby_host_prog = expand($_ROOT) . 'lib/ruby/gems/2.6.3/gems/neovim-0.8.0/exe/neovim-ruby-host'
  elseif filereadable(expand('$_ROOT') . 'bin/neovim-ruby-host')
      let g:ruby_host_prog = expand('$_ROOT') . 'bin/neovim-ruby-host'
  endif

elseif g:ubuntu
  if executable('rvm')
      let g:ruby_host_prog = 'rvm system do neovim-ruby-host'
  elseif filereadable(expand('$_ROOT') . '/local/bin/neovim-ruby-host')
      let g:ruby_host_prog = expand('$_ROOT') . '/local/bin/neovim-ruby-host'
  elseif filereadable('~/.local/bin/neovim-ruby-host')
      let g:ruby_host_prog = '~/.local/bin/neovim-ruby-host'
  endif

endif

" Python Executables: {{{1

" Python3: {{{2
" If we have a virtual env start there
if exists('$VIRTUAL_ENV')
    let g:python3_host_prog = expand('$VIRTUAL_ENV') . '/bin/python'
    let &path = &path . ',' . expand('$VIRTUAL_ENV') . '/lib/python3/*'

" Or a conda env. Not trying to ruin your day here but Windows sets a var
" '$CONDA_PREFIX_1' if CONDA_SHLVL > 1....
" doesn't matter we can circumvent all of it
elseif exists('$CONDA_PYTHON_EXE')
  let g:python3_host_prog = expand('$CONDA_PYTHON_EXE')
  let &path = &path . ',' . expand('$CONDA_PYTHON_EXE')

elseif exists('$CONDA_PREFIX')

  " Needs to use CONDA_PREFIX as the other env vars conda sets will only establish the base env not the current one
  let g:python3_host_prog = expand('$CONDA_PREFIX/bin/python3')
  " Let's hope I don't break things for Windows
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

" Also add a python2 remote host: {{{2
if executable(expand('$_ROOT') . '/bin/python2')
    let g:python_host_prog = expand('$_ROOT') . '/bin/python2'
    let &path = &path . ',' . expand('$_ROOT') . '/lib/python2/*'
elseif executable('/usr/bin/python2')
    let g:python3_host_prog = '/usr/bin/python2'
    let &path = &path . ',' . '/usr/lib/python2/*'
else
    let g:loaded_python_provider = 1
endif

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
