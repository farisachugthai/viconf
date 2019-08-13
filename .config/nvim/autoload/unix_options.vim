" ============================================================================
  " File: unix_options.vim
  " Author: Faris Chugthai
  " Description: Autoloaded Unix only options
  " Last Modified: August 12, 2019 
" ============================================================================

" Guard: {{{1
if exists('g:did_autoload_unix_options') || &compatible || v:version < 700
  finish
endif
let g:did_autoload_unix_options = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

if !has('unix') | finish | endif

function! unix_options#UnixOptions() abort   " {{{1
  " These conditions only ever exist on Unix. Only run them if that's what
  " we're using

    if filereadable('/usr/share/dict/words')
      set dictionary+=/usr/share/dict/words
    endif

    if exists($ANDROID_ROOT)
      " May 26, 2019: Just ran into my first problem from a filename with a space in the name *sigh*
      noremap <silent> <Leader>ts <Cmd>execute '!termux-share -a send ' . shellescape(expand("%"))<CR>
    endif

    if isdirectory(expand('$_ROOT/local/include/'))
        let &path = &path . ',' . expand('$_ROOT/local/include')
    endif

    if isdirectory(expand('$_ROOT') . '/include/libcs50')
        let &path = &path .','. expand('$_ROOT') . '/include/libcs50'
    endif

endfunction

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
