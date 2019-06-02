" ============================================================================
  " File: betterprofiler.vim
  " Author: Faris Chugthai
  " Description: Profiling commands
  " Last Modified: May 30, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_better_profiler_vim_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_better_profiler_vim_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Functions: {{{1

" 04/29/2019

function! g:BetterProfiler(fname) abort
  " Because Vim's built in profiling capabilities are nonsensical like wtf?
  setlocal shellslash
  profile! start tempfile.log

  " Toggle debugging
  let s:Debug = 0

  if s:Debug
    " echomsg fname actually causes an error so that's good i guess
    echomsg a:fname
  endif

  profile file a:fname
  source a:fname
  profile stop
  profile dump

  let b:msg = 'No errors mostly because fuck exception catching in this platform!'
  return b:msg
endfunction

" ...wth was i trying to do here?
" let s:Debug = 1
" let b:fname = '~/projects/viconf/.config/nvim/colors/gruvbox8.vim'
" call g:BetterProfiler(b:fname)


" AH I forgot Junegunn has one written as well!

" Profile: {{{1

" Profile a func or file. Oooo I could use XDG_DATA_HOME instead of _ROOT there
function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start expand('$_ROOT') . 'tmp/profile.log'
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0)

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
