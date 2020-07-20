" ============================================================================
    " File: todo.vim
    " Author: Faris Chugthai
    " Description: Todo grep
    " Last Modified: Aug 24, 2019
" ============================================================================

function! s:shell_cmds(cmd) abort
  let l:entries = []
  let l:lines = split(system(a:cmd), '\n')
  if v:shell_error != 0
    echoerr 'todo: s:shell_cmd shell_error: ' . v:shell_error
  endif

  for l:line in l:lines
    let [l:fname, l:lno, l:text] = matchlist(l:line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
    call add(l:entries, { 'filename': l:fname, 'lnum': l:lno, 'text': l:text })
  endfor
  return l:entries
endfunction

function! todo#Todo(bang) abort
  " Grep for todos in the current repo and populate the quickfix list with them.
  " You could run an if then to check you're in a git repo.
  " Also could use ag/rg/fd and fzf instead of grep to supercharge this.

  " if exists(':Ggrep')
  " else
  for l:cmd in ['git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null',
              \ 'grep -rniI -e TODO -e todo -e FIXME -e XXX -e HACK * 2> /dev/null']
  let l:output = s:shell_cmds(l:cmd)
  endfor
  if !empty(l:output)
    if a:bang
      :tabnew
    endif
    call setqflist(l:output)
    copen
  endif
endfunction

function! todo#fzf(bang) abort
  if !exists('b:git_dir')
    let b:git_dir = FugitiveGitDir()
  endif

  let s:grep_cmd = 'git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null'
  call fzf#run(fzf#wrap('git-grep', {
        \ 'source' : s:grep_cmd,
        \ 'sink': 'pedit',
        \ 'dir': 'git rev-parse --show-root',
        \ 'options': ['--ansi', '--multi', '--border', '--prompt', 'FZF Git Grep:', '--reverse']},
        \ a:bang ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden')))
endfunction
