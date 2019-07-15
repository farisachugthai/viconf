" ----------------------------------------------------------------------------
" tmux
" ----------------------------------------------------------------------------
"  URL: https://gist.github.com/junegunn/2f271e4cab544e86a37e239f4be98e74

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions&vim

" Functions: {{{1

function! s:unix#tmux_send(content, dest) range
  let dest = empty(a:dest) ? input('To which pane? ') : a:dest
  let tempfile = tempname()
  call writefile(split(a:content, "\n", 1), tempfile, 'b')
  call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
        \ shellescape(tempfile), shellescape(dest)))
  call delete(tempfile)
endfunction

function! s:unix#tmux_map(key, dest)
  execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
  execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction


function! s:unix#UnixOptions() abort
  " These conditions only ever exist on Unix. Only run them if that's what
  " we're using

    if filereadable('/usr/share/dict/words')
      set dictionary+=/usr/share/dict/words
    endif

    if g:termux
      " May 26, 2019: Just ran into my first problem from a filename with a space in the name *sigh*
      noremap <silent> <Leader>ts <Cmd>exe "!termux-share -a send " . shellescape(expand("%"))<CR>
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
