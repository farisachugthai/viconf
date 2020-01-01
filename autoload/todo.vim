" ============================================================================
    " File: todo.vim
    " Author: Faris Chugthai
    " Description: Todo grep
    " Last Modified: Aug 24, 2019
" ============================================================================

function! todo#Todo() abort  " {{{1
" Grep for todos in the current repo and populate the quickfix list with them.
" You could run an if then to check you're in a git repo.
" Also could use ag/rg/fd and fzf instead of grep to supercharge this.

  let entries = []
  for cmd in ['git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null',
              \ 'grep -rniI -e TODO -e todo -e FIXME -e XXX -e HACK * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
function! todo#fzf() abort  " {{{1
  if !exists('b:git_dir') | return | endif

  let s:grep_cmd = 'git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null'
  call fzf#run(fzf#wrap('git-grep', {
        \ 'source' : 's:grep_cmd',
        \ 'options': ['--ansi', '--multi', '--border', '--prompt', 'FZF Git Grep:', '--reverse'],}))
        " \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden'),
endfunction
