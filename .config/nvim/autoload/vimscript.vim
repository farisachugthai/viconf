" ============================================================================
  " File: vimscript.vim
  " Author: Faris Chugthai
  " Description: Helpers for writing Vimscript files
  " Last Modified: July 13, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=c

" Global Ftplugin: {{{1

function! vimscript#after_ft() abort

  let s:debug = 1
  let s:cur_ft = &filetype
  let s:after_ftplugin_dir = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/after/ftplugin/'
  let s:after_ftplugin_file = s:after_ftplugin_dir . s:cur_ft . '.vim'
  let s:ftplugin_dir = fnamemodify(resolve(expand('<sfile>')), ':p:h') . '/ftplugin/'
  let s:ftplugin_file = s:ftplugin_dir . s:cur_ft . '.vim'

  if file_readable(s:ftplugin_file)
    if s:debug | echomsg 's:ftplugin is ' . string(s:ftplugin_file) | endif
    exec 'edit ' . s:ftplugin_file
    return

  elseif file_readable(s:after_ftplugin_file)
    if s:debug | echomsg 's:ftplugin is ' . string(s:after_ftplugin_file) | endif
    exec 'edit ' . s:after_ftplugin_file
    return

  elseif file_readable(fnamemodify(resolve(stdpath('config') . '/ftplugin' . s:cur_ft . '.vim')))
    exec 'edit ' . stdpath('config') . '/ftplugin/' . s:cur_ft . '.vim'
    return

  elseif file_readable(fnamemodify(resolve(stdpath('config') . '/after/ftplugin' . s:cur_ft . '.vim')))
    exec 'edit ' . stdpath('config') . '/after/ftplugin/' . s:cur_ft . '.vim'
    return

  " If we can't find anything I wrote at least show me the default
  elseif v:true
    exec 'split $VIMRUNTIME/ftplugin/' . s:cur_ft . '.vim'
  endif

  echomsg 'No ftplugin found!'

  " This seems like a reasonable return after a fail.
  return v:False

endfunction


" Functions: {{{1

function! vimscript#BetterProfiler(fname) abort
  " Because Vim's built in profiling capabilities are nonsensical like wtf?

  " Toggle debugging
  let s:Debug = 1

  let s:logfile = expand(stdpath('data') . '/site/profile.log')
  profile! start s:logfile

  if s:Debug
  " echomsg fname actually causes an error so that's good i guess
    echomsg string(a:fname)
  endif

" :prof[ile][!] file {pattern}
" 		Profile script file that matches the pattern {pattern}.
" 		See |:debug-name| for how {pattern} is used.
" 		This only profiles the script itself, not the functions
" 		defined in it.
" 		When the [!] is added then all functions defined in the script
" 		will also be profiled.
" 		Note that profiling only starts when the script is loaded
" 		after this command.  A :profile command in the script itself
" 		won't work.
  profile file a:fname
  source a:fname
  profile stop
  profile dump

endfunction

" let s:Debug = 1
" let b:fname = '~/projects/viconf/.config/nvim/colors/gruvbox8.vim'
" call g:BetterProfiler(b:fname)

" AH I forgot Junegunn has one written as well!

" Profile: {{{1

" Profile a func or file. Oooo I could use XDG_DATA_HOME instead of _ROOT there
function! vimscript#profile(bang) abort
  if a:bang
    profile pause
    noautocmd qall
  else
    let s:logfile = expand(stdpath('data') . '/site/profile.log')
    profile start s:logfile
    profile func *
    profile file *
  endif
endfunction


let &cpoptions = s:cpo_save
unlet s:cpo_save
