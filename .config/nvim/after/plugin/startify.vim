" ============================================================================
    " File: startify.vim
    " Author: Faris Chugthai
    " Description: Vim_Startify configuration
    " Last Modified: June 22, 2019
" ============================================================================

" Plugin Guard: {{{1
if !has_key(plugs, 'vim-startify')
    finish
endif

if exists('g:did_startify_after_plugin') || &cp || v:version < 700
    finish
endif
let g:did_startify_after_plugin = 1


" List Commits: {{{1
function! s:list_commits()
  " note: Don't forget that
  " echo isdirectory('~/projects/viconf')
  " outputs 0 on windows and
  " echo isdirectory(glob('~/projects/viconf'))
  " outputs 1 so we have to glob it to get anything to show up in startify
    let git = 'git -C ' . glob('~/projects/viconf')
    if empty(g:windows)
      let commits = systemlist(git . ' log --oneline | head -n10')
    else
      " Assume powershell
      let commits = systemlist(git . ' log --oneline | Get-Content -TotalCount 10')
    endif

    " mapping that lines up commits from this repo
    let git = 'Git' . git[1:]
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

" Startify Lists: {{{1

let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   MRU']                   },
    \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()]       },
    \ { 'type': 'sessions',  'header': ['   Sessions']              },
    \ { 'type': function('s:list_commits'),  'header': ['   Viconf']},
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']             },
    \ { 'type': 'commands',  'header': ['   Commands']              },
    \ ]

" Setup_devicons: {{{1
function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" Center The Header And Footer: {{{1
function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())

" Skiplist: {{{1
" Don't show these files

" the last 2 lines are the same aren't they?
let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ glob( stdpath('data') . 'plugged/*/doc'),
    \ 'C:\Program Files\Vim\vim81\doc',
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc', ]

" Session Dir: {{{1

" Here's a way cleaner way of doing this. Now we don't depend on nvim/vim, win or linux.
" Just make a dir in the config directory that's called session.
let g:startify_session_dir =  stdpath('config') . 'session'

" General Options: {{{1
" TODO: Figure out how to set let g:startify_bookmarks = [ Contents of
" NERDTreeBookmarks ]

" This might be getting messed up on windows
" let g:startify_change_to_dir = 1

let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1

" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
let g:startify_session_autoload = 1
let g:startify_session_sort = 1
