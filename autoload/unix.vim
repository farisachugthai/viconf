" ============================================================================
  " File: unix.vim
  " Author: Faris Chugthai
  " Description: Autoloaded unix style functions
  " Last Modified: Oct 27, 2019
" ============================================================================

scriptencoding utf8

function! s:tmux_enabled() abort
  " From fzf.vim
  if has('gui_running') || !exists('$TMUX')
    return 0
  endif

  if exists('s:tmux')
    return s:tmux
  endif

  let s:tmux = 0
  if !executable(s:fzf_tmux)
    if executable('fzf-tmux')
      let s:fzf_tmux = 'fzf-tmux'
    else
      return 0
    endif
  endif

  let l:output = system('tmux -V')
  let s:tmux = !v:shell_error && l:output >=? 'tmux 1.7'
  return s:tmux
endfunction

function! unix#tmux_send(content, dest) abort
  if !s:tmux_enabled() | return | endif
  " URL: https://gist.github.com/junegunn/2f271e4cab544e86a37e239f4be98e74
  let l:dest = empty(a:dest) ? input('To which pane? ') : a:dest
  let l:tempfile = tempname()
  call writefile(split(a:content, "\n", 1), l:tempfile, 'b')

  call system(printf('tmux load-buffer -b vim-tmux %s \;'
        \ . ' paste-buffer -d -b vim-tmux -t %s',
        \ shellescape(l:tempfile), shellescape(l:dest)))

  call delete(l:tempfile)
endfunction

function! unix#tmux_map(key, dest) abort
  if !s:tmux_enabled() | return | endif
  execute printf('nnoremap <silent> %s "tyy:call unix#tmux_send(@t, "%s")<cr>', a:key, a:dest)
  execute printf('xnoremap <silent> %s "ty:call unix#tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction

function! unix#UnixOptions() abort
  " These conditions only ever exist on Unix. Only run them if that's what
  " we're using

  if filereadable('/usr/share/dict/words')
    setglobal dictionary+=/usr/share/dict/words
  endif

  if isdirectory(expand('$_ROOT/local/include/'))
    let &g:path = &path . ',' . expand('$_ROOT/local/include')
  endif

  if isdirectory(expand('$_ROOT') . '/include/libcs50')
    let &g:path = &path .','. expand('$_ROOT') . '/include/libcs50'
  endif

    call coc#config('languageserver', {'clangd': { 'args':
                    \ ['--background-index' ], 'command': 'clangd', 'filetypes': [ 'c', 'cpp',
                    \ 'objc', 'objcpp' ], 'rootPatterns': [ 'compile_flags.txt',
                    \ 'compile_commands.json', '.git/' ], 'shell': 'true' }})

  let g:startify_change_to_dir = 1
  let g:tagbar_iconchars = ['▷', '◢']
  let g:startify_change_to_dir = 1

  if executable('ag')
    imap <C-x><C-f> <Plug>(fzf-complete-file-ag)
    imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
  else
    imap <C-x><C-f> <Plug>(fzf-complete-file)
    imap <C-x><C-j> <Plug>(fzf-complete-path)
  endif

  " A bunch of these are now unix only because there's something fucked with either the way i have
  " external shell commands set to run or the way fzf does it.

  imap <expr> <C-x><C-l> fzf#vim#complete(fzf#wrap({
    \ 'prefix': '^.*$',
    \ 'source': 'rg -n ^ --color always',
    \ 'options': '--ansi --delimiter : --nth 3..',
    \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '')}}))

  " Uhhh C-b for buffer?
  inoremap <expr> <C-x><C-b> fzf#vim#complete#buffer_line()

  function! s:make_sentence(lines) abort
    return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
  endfunction

  imap <expr> <C-x><C-s>    fzf#vim#complete#word(
      \ {'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    40})
  " And add a shorter version
  inoremap <C-s>            <C-x><C-s>

  imap <expr> <C-x><C-k>    fzf#vim#complete(
              \ {'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
              \ 'options': '-ansi --multi --cycle',
              \ 'left': 30})
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
  " From help docs
  return system('cut -d: -f1 /etc/passwd')
endfunction

function! unix#EditFileComplete(A,L,P) abort
  " Also from helpdocs
  return split(globpath(&path, a:A), '\n')
endfunction

function! unix#SpecialEdit(files, mods) abort
  " This example does not work for file names with spaces!
  " so wait if that's true can't we just use shellescape...?
  for s:files in expand(a:files, 0, 1)
    exe a:mods . ' split ' . s:files
  endfor
endfunction

function! unix#RmDir(path) abort
  " sanity check; make sure it's not empty, /, or $HOME
  if empty(a:path)
    echoerr 'Attempted to delete empty path'
    return 0
  elseif a:path ==# '/' || a:path == $HOME
    echoerr 'Attempted to delete protected path: ' . a:path
    return 0
  endif
  return unix#system('rm -rf ' . shellescape(a:path))
endfunction

function! unix#system(cmd, ...)  abort
  " Executes {cmd} with the cwd set to {pwd}, without changing Vim's cwd.
  " If {pwd} is the empty string then it doesn't change the cwd.
  let l:cmd = a:cmd
  if !empty(a:000)
    let l:pwd = a:1
    let l:cmd = 'cd ' . shellescape(l:pwd) . ' && ' . l:cmd
  endif
  return system(l:cmd)
endfunction

