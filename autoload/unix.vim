" ============================================================================
  " File: unix.vim
  " Author: Faris Chugthai
  " Description: Autoloaded unix style functions
  " Last Modified: Oct 27, 2019
" ============================================================================

function! unix#tmux_send(content, dest) abort  " {{{ tmux send: 1
  " URL: https://gist.github.com/junegunn/2f271e4cab544e86a37e239f4be98e74
  let dest = empty(a:dest) ? input('To which pane? ') : a:dest
  let tempfile = tempname()
  call writefile(split(a:content, "\n", 1), tempfile, 'b')

  call system(printf('tmux load-buffer -b vim-tmux %s \;'
        \ ' paste-buffer -d -b vim-tmux -t %s',
        \ shellescape(tempfile), shellescape(dest)))

  call delete(tempfile)

endfunction
function! unix#tmux_map(key, dest) abort " Tmux Map: {{{1

  execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
  execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction
function! unix#UnixOptions() abort
  " These conditions only ever exist on Unix. Only run them if that's what
  " we're using

    if filereadable('/usr/share/dict/words')
      set dictionary+=/usr/share/dict/words
    endif

    if isdirectory(expand('$_ROOT/local/include/'))
        let &path = &path . ',' . expand('$_ROOT/local/include')
    endif

    if isdirectory(expand('$_ROOT') . '/include/libcs50')
        let &path = &path .','. expand('$_ROOT') . '/include/libcs50'
    endif
endfunction
function! unix#finger() abort
  " Finger: {Command and Function}
  " Example from :he command-complete
  " The following example lists user names to a Finger command
  " Yo this is a terrible command though because termux doesn't have the command
  " finger nor does it have read access to /etc/passwd
  "
  if executable('!finger')
    if filereadable('/etc/passwd')
      command! -complete=custom,unix#ListUsers -nargs=0 Finger !finger <args>
    endif
  endif
endfunction
function! unix#ListUsers(A,L,P) abort
  return system('cut -d: -f1 /etc/passwd')
endfun
function! unix#EditFileComplete(A,L,P) abort  " EditFileComplete: {{{1
  return split(globpath(&path, a:A), '\n')
endfunction
function! unix#SpecialEdit(files, mods) abort
" This example does not work for file names with spaces!
" so wait if that's true can't we just use shellescape...?
  for s:files in expand(a:files, 0, 1)
    exe a:mods . ' split ' . s:files
  endfor
endfunction
function! unix#RmDir(path)  " {{{1
	" sanity check; make sure it's not empty, /, or $HOME
	if empty(a:path)
		echoerr 'Attempted to delete empty path'
		return 0
	elseif a:path == '/' || a:path == $HOME
		echoerr 'Attempted to delete protected path: ' . a:path
		return 0
	endif
	return system("rm -rf " . shellescape(a:path))
endfunction
function! unix#system(pwd, cmd)  " {{{1
  " Executes {cmd} with the cwd set to {pwd}, without changing Vim's cwd.
  " If {pwd} is the empty string then it doesn't change the cwd.
	let cmd = a:cmd
	if !empty(a:pwd)
		let cmd = 'cd ' . shellescape(a:pwd) . ' && ' . cmd
	endif
	return system(cmd)
endfunction
