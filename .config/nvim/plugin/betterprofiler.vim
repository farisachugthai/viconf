" Profiling commands

" 04/29/2019

function! g:BetterProfiler(fname) abort
  " Because Vim's built in profiling capabilities are nonsensical like wtf?
  setlocal shellslash
  profile! start tempfile.log

  if s:Debug
    " echomsg fname actually causes an error so that's good i guess
    echomsg a:fname
  endif

  profile file a:fname
  source a:fname
  profile stop
  profile dump

  msg = 'No errors mostly because fuck exception catching in this platform!'
  return msg
endfunction

let s:Debug = 1

let b:fname = '~/projects/viconf/.config/nvim/colors/gruvbox8.vim'

call g:BetterProfiler(b:fname)


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
