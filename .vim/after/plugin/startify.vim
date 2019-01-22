<<<<<<< Updated upstream
" Vim_Startify:
" What shows up in the startify list?

function! s:list_commits()
    let git = 'git -C ~/projects/viconf/'
    let commits = systemlist(git .' log --oneline | head -n10')
    let git = 'G'. git[1:]
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

let g:startify_lists = [
    \ { 'header': ['   MRU'],            'type': 'files' },
    \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
    \ { 'header': ['   Sessions'],       'type': 'sessions' },
    \ { 'header': ['   Commits'],        'type': function('s:list_commits') },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ ]

let g:startify_session_sort = 1
let g:startify_update_oldfiles = 1

" Setup devicons
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" Center the header and footer
function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())

" Don't show these files
let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc', ]
    " its explained why this won't. actually great explanation of those weird,
    " afile cfile sfile vars
    " \ '~/.local/share/nvim/plugged/' .*/doc',
    " \ ]
if has('gui_win32')
    let g:startify_session_dir = '$HOME\vimfiles\session'
else
    let g:startify_session_dir = '~/.vim/session'
endif
" TODO: Figure out how to set let g:startify_bookmarks = [ Contents of
" NERDTreeBookmarks ]
let g:startify_change_to_dir = 1
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
let g:startify_session_autoload = 1
" Not 100% sure if the code below works but here's hoping!
let g:startify_skiplist = [
        \ 'COMMIT_EDITMSG',
        \ glob('plugged/*/doc'),
        \ 'C:\Program Files\Vim\vim81\doc',
        \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
        \ ]
||||||| merged common ancestors
=======
" Vim_Startify: {{{1
" What shows up in the startify list?

function! s:list_commits()
    let git = 'git -C ~/projects/viconf/'
    let commits = systemlist(git .' log --oneline | head -n10')
    let git = 'G'. git[1:]
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

" Setup devicons
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" Center the header and footer
function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())

if has('gui_win32')
    let g:startify_session_dir = '$HOME\vimfiles\session'
else
    let g:startify_session_dir = '~/.vim/session'
endif
" TODO: Figure out how to set let g:startify_bookmarks = [ Contents of
" NERDTreeBookmarks ]
let g:startify_change_to_dir = 1
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
let g:startify_session_autoload = 1

let g:startify_session_sort = 1
let g:startify_update_oldfiles = 1


let g:startify_skiplist = [
        \ 'COMMIT_EDITMSG',
        \ glob('plugged/*/doc'),
        \ 'C:\Program Files\Vim\vim81\doc',
        \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
        \ ]

let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ { 'type': function('s:list_commits'), 'header': ['Commits']},
      \ ]
>>>>>>> Stashed changes
