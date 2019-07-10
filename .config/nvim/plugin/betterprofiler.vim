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

if !has('profile') || !has('reltime')  " timing functionality
  finish
endif

if has('+shellslash')
  set shellslash
endif


" Functions: {{{1

function! g:BetterProfiler(fname) abort
  " Because Vim's built in profiling capabilities are nonsensical like wtf?
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

endfunction

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

" Probably shouldn't allow for a range but this needs a good amount of
" debugging anyway
command! -bang Profile -complete=buffer,file -nargs=1 -range=% call s:profile(<bang>0)

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
