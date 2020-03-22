" ============================================================================
    " File: todo.vim
    " Author: Faris Chugthai
    " Description: Todo grep
    " Last Modified: Aug 24, 2019
" ============================================================================

function! s:shell_cmds(cmd) abort  " {{{
  let entries = []
  let lines = split(system(cmd), '\n')
  if v:shell_error != 0 
    echoerr 'todo: s:shell_cmd shell_error: ' . v:shell_error
  endif

  for line in lines
    let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
    call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
  endfor
  return entries
endfunction  " }}}

function! todo#Todo(bang) abort  " {{{
" Grep for todos in the current repo and populate the quickfix list with them.
" You could run an if then to check you're in a git repo.
" Also could use ag/rg/fd and fzf instead of grep to supercharge this.

  " if exists(':Ggrep')
  " else
  for cmd in ['git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null',
              \ 'grep -rniI -e TODO -e todo -e FIXME -e XXX -e HACK * 2> /dev/null']
  let output = s:shell_cmd(cmd)
  endfor
  if !empty(output)
    if a:bang
      :tab %
    endif
    call setqflist(output)
    copen
  endif
endfunction
" }}}

function! todo#fzf(bang) abort  " {{{
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
" }}}

function! todo#OpenRangerIn(path, edit_cmd)  " {{{
  if exists('g:ranger_choice_file')
    if empty(glob(g:ranger_choice_file))
      let s:choice_file_path = g:ranger_choice_file
    else
      echom "Message from *Ranger.vim* :"
      echom "You've set the g:ranger_choice_file variable."
      echom "Please use the path for a file that does not already exist."
      echom "Using /tmp/chosenfile for now..."
    endif
  endif

  if exists('g:ranger_command_override')
    let s:ranger_command = g:ranger_command_override
  else
    let s:ranger_command = 'ranger'
  endif

  if !exists('s:choice_file_path')
    let s:choice_file_path = '/tmp/chosenfile'
  endif

  let currentPath = expand(a:path)
  let rangerCallback = { 'name': 'ranger', 'edit_cmd': a:edit_cmd }
  function! rangerCallback.on_exit(job_id, code, event)
    if a:code == 0
      silent! Bclose!
    endif
    try
      if filereadable(s:choice_file_path)
	for f in readfile(s:choice_file_path)
	  exec self.edit_cmd . f
	endfor
	call delete(s:choice_file_path)
      endif
    endtry
  endfunction
    enew
    if isdirectory(currentPath)
      call termopen(s:ranger_command . ' --choosefiles='
            \ . s:choice_file_path . ' "' . currentPath
            \ . '"', rangerCallback)
    else
      call termopen(s:ranger_command . ' --choosefiles='
            \ . s:choice_file_path . ' --selectfile="' . currentPath
            \ . '"', rangerCallback)
    endif
    startinsert
endfunction  " }}}

function! todo#OpenRangerOnVimLoadDir(argv_path)  " {{{
  " Open Ranger in the directory passed by argument
  let s:path = expand(a:argv_path)

  " Delete empty buffer created by vim
  :bdelete!

  " Open Ranger
  call todo#OpenRangerIn(path, 'edit')
endfunction  " }}}

