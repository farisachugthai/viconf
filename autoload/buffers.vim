" ============================================================================
  " File: buffers.vim
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with buffers.
  " Last Modified: Feb 22, 2020
" ============================================================================

function! buffers#EchoRTP() abort
  " Huh son of a bitch. I actually figured out an easier way to do this
  " let's do a check that this function exists then and do it the non-nvim way
  " otherwise
  if exists('*nvim_list_runtime_paths')
    for l:directory in nvim_list_runtime_paths()
      echomsg l:directory
    endfor
  else
    for l:i in split(&runtimepath, ',') | echomsg l:i | endfor
  endif
endfunction

