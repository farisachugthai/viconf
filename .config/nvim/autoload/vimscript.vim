" ============================================================================
  " File: vimscript.vim
  " Author: Faris Chugthai
  " Description: Helpers for writing Vimscript files
  " Last Modified: July 13, 2019
" ============================================================================

" Global Ftplugin: {{{1
"
function! s:vimscript#after_ft()

  let s:cur_ft = &filetype
  let s:after_ftplugin_dir = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/after/ftplugin/'
  let s:after_ftplugin_file = s:after_ftplugin_dir . s:cur_ft . '.vim'
  let s:ftplugin_dir = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/ftplugin/'
  let s:ftplugin_file = s:ftplugin_dir . s:cur_ft . '.vim'

  if file_readable(s:ftplugin_file)
    exec 'edit ' . s:ftplugin_file
    return

  elseif file_readable(s:after_ftplugin_file)
    exec 'edit ' . s:after_ftplugin_file
    return

  elseif file_readable(fnamemodify(resolve(stdpath('config') . '/ftplugin' . s:cur_ft . '.vim')))
    exec 'edit ' . stdpath('config') . '/ftplugin' . s:cur_ft . '.vim'
    return

  elseif file_readable(fnamemodify(resolve(stdpath('config') . '/after/ftplugin' . s:cur_ft . '.vim')))
    exec 'edit ' . stdpath('config') . '/after/ftplugin' . s:cur_ft . '.vim'
    return

  endif

  echomsg 'No ftplugin found!'

  " This seems like a reasonable return after a fail.
  return v:False

endfunction
