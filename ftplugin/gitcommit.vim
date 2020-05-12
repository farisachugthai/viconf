" ============================================================================
    " File: gitcommit.vim
    " Author: Faris Chugthai
    " Description: Git commit buffer mods
    " Last Modified: Nov 14, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

let s:ftplugin_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h'))
exec 'source ' . s:ftplugin_root . '/git.vim'
setlocal textwidth=72
setlocal spell

" Keep the first line of a git commit 50 char long and everything after 72.
setlocal colorcolumn=50,73
setlocal linebreak
setlocal cursorcolumn

" setlocal formatoptions-=t formatoptions+=croql
setlocal formatoptions=tqan1
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal nomodeline tabstop=8
setlocal autoindent

setlocal formatexpr=format#Format()

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \. '|setlocal tw< sp< cc< lbr< fo< com< cms< ai< fex<'
      \. '|unlet! b:undo_ftplugin'
      \. '|unlet! b:did_ftplugin'

command! -bang -bar -buffer -complete=custom,s:diffcomplete -nargs=* DiffGitCached :call s:gitdiffcached(<bang>0, b:git_dir, <f-args>)

let b:undo_ftplugin .= '|delc DiffGitCached'

function! s:diffcomplete(A,L,P)  " {{{
  let s:args = ''

  " It was at this moment i noticed vim has no "append this string" function
  if a:P <= match(a:L . ' -- ',' -- ')+3
    let s:args = s:args . '-p\n--stat\n--shortstat\n--summary\n--patch-with-stat\n--no-renames\n-B\n-M\n-C\n'
  endif

  if exists('b:git_dir') && a:A !~ '^-'

    let b:tree = fnamemodify(b:git_dir, ':h')
    if strpart(getcwd(), 0, strlen(b:tree)) == b:tree
      let s:args = s:args . '\n' . system('git diff --cached --name-only')
    endif
  endif
  return s:args
endfunction  " }}}

function! s:gitdiffcached(bang, gitdir, ...)  " {{{
  let b:tree = fnamemodify(a:gitdir,':h')
  let s:name = tempname()
  let s:git = 'git'

  if strpart(getcwd(),0,strlen(b:tree)) !=? b:tree
    let s:git .= " --git-dir=" . (exists("*shellescape") ? shellescape(a:gitdir) : '"' . a:gitdir.'"')
  endif

  if a:0
    let s:extra = join(map(copy(a:000),exists("*shellescape") ? 'shellescape(v:val)' : "'\"'.v:val.'\"'"))
  else
    let s:extra = '-p --stat=' . &columns
  endif

  call system(s:git.' diff --cached --no-color --no-ext-diff ' . s:extra . ' > ' . (exists('*shellescape') ? shellescape(s:name) : s:name))

  exe 'pedit '.(exists('*fnameescape') ? fnameescape(s:name) : s:name)

  wincmd P

  let b:git_dir = a:gitdir

  " **********
  " Bug:
  " **********
  " In the official ftplugin this command is here twice. I doubt this is intentional
  " command! -bang -bar -buffer -complete=custom,s:diffcomplete -nargs=* DiffGitCached :call s:gitdiffcached(<bang>0,b:git_dir,<f-args>)

  nnoremap <buffer> <silent> q :q<CR>
  setlocal buftype=nowrite nobuflisted noswapfile nomodifiable filetype=git
endfunction
" }}}
