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

if exists('g:did_startify_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_startify_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Startify Lists: {{{1

let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   MRU']                   },
    \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()]       },
    \ { 'type': 'sessions',  'header': ['   Sessions']              },
    \ { 'type': function('plugins#list_commits'),  'header': ['   Dynamic IPython']},
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

let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ glob( stdpath('data') . 'plugged/*/doc'),
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc', ]

" Session Dir: {{{1

" Here's a way cleaner way of doing this. Now we don't depend on nvim/vim, win or linux.
" Just make a dir in the config directory that's called session.
let g:startify_session_dir =  stdpath('config') . '/session'

" General Options: {{{1
" TODO: Figure out how to set let g:startify_bookmarks = [ Contents of
" NERDTreeBookmarks ]
" TODO: Also set g:startify_commands so more than 2 lists show up

    let g:startify_commands = [
        \ {'h': ['Vim Reference', 'h ref'],}
        \ ]

if has('unix')
  let g:startify_change_to_dir = 1
endif

let g:startify_use_env = 1
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1

" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
let g:startify_session_autoload = 1
let g:startify_session_sort = 1

" Autocommand: {{{1

augroup StartifyConf
  au!
  autocmd User Startified setlocal cursorline
augroup END

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
