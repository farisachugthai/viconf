" ============================================================================
  " File: unix.vim
  " Author: Faris Chugthai
  " Description: Autoloaded unix style functions
  " Last Modified: July 24, 2019 
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=c

" ----------------------------------------------------------------------------
" tmux
" ----------------------------------------------------------------------------
" URL: https://gist.github.com/junegunn/2f271e4cab544e86a37e239f4be98e74

" Tmux Send: {{{1

function! unix#tmux_send(content, dest) range
  let dest = empty(a:dest) ? input('To which pane? ') : a:dest
  let tempfile = tempname()
  call writefile(split(a:content, "\n", 1), tempfile, 'b')
  call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
        \ shellescape(tempfile), shellescape(dest)))
  call delete(tempfile)
endfunction

" Tmux Map: {{{1

function! unix#tmux_map(key, dest)
  execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
  execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction

" Unix Options: {{{1

function! unix#UnixOptions() abort
  " These conditions only ever exist on Unix. Only run them if that's what
  " we're using

    if filereadable('/usr/share/dict/words')
      set dictionary+=/usr/share/dict/words
    endif

    if g:termux
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

" Finger: {{{1

" Example from :he command-complete
" The following example lists user names to a Finger command

" Yo this is a terrible command though because termux doesn't have the command
" finger nor does it have read access to /etc/passwd
if executable('!finger')
  if filereadable('/etc/passwd')
    command! -complete=custom,unix#ListUsers -nargs=0 Finger !finger <args>

    function! unix#ListUsers(A,L,P)
        return system('cut -d: -f1 /etc/passwd')
    endfun
  endif
endif

" EditFileComplete: {{{1

function! unix#EditFileComplete(A,L,P)
  return split(globpath(&path, a:A), '\n')
endfunction

" This example does not work for file names with spaces!
" so wait if that's true can't we just use shellescape...?

" SpecialEdit: {{{1

function! unix#SpecialEdit(files, mods) abort
  for f in expand(a:files, 0, 1)
    exe a:mods . ' split ' . f
  endfor
endfunction

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
