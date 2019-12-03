" ============================================================================
    " File: startify.vim
    " Author: Faris Chugthai
    " Description: Vim_Startify configuration
    " Last Modified: Nov 16, 2019
" ============================================================================

" Guard: {{{1
if !exists('g:loaded_startify')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

let g:startify_session_dir =  stdpath('config') . '/session'

if has('unix')
  let g:startify_change_to_dir = 1
endif

let g:startify_use_env = 1
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1
let g:startify_relative_path = 1
let g:startify_change_to_vcs_root = 0

" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
let g:startify_session_autoload = 1
" let g:startify_session_sort = 1

let g:startify_session_savevars = [
       \ 'g:startify_session_savevars',
       \ 'g:startify_session_savecmds',
       \ ]

       " 'g:random_plugin_use_feature'

" Index: {{{1
let g:startify_commands = [
    \ {'h': ['Vim Reference', 'h ref'],},
    \ {'f': ['FZF!', 'FZF!'],},
    \ {'g': ['Git status!', 'Gstatus'],},
    \ ]

" Temporarily turn this off
finish

" What the fuck! Its still reading everyrhing perfectly.
"
" In fact, if i comment out the finish it STOPS working...what the hell?
let g:startify_lists = [
    \ { 'type': 'commands',  'header': ['   Commands']              },
    \ { 'type': 'sessions',  'header': ['   Sessions']              },
    \ { 'type': function('plugins#list_commits'),  'header': ['   Dynamic IPython']},
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']             },
    \ { 'type': 'files',     'header': ['   MRU']                   },
    \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()]       },
    \ ]

" Setup_devicons: {{{1
let entry_format = "'   ['. index .']'. repeat(' ', (3 - strlen(index)))"

if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
    let entry_format .= ". WebDevIconsGetFileTypeSymbol(entry_path) .' '.  entry_path"
else
    let entry_format .= '. entry_path'
endif

function! StartifyEntryFormat() abort
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" let g:startify_custom_header = plugins#filter_header(startify#fortune#cowsay())

" Skiplist: {{{1
" Don't show these files

let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ glob(stdpath('data') . '/plugged/**/doc/*'),
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc', ]

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
