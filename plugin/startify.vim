" ============================================================================
    " File: startify.vim
    " Author: Faris Chugthai
    " Description: Vim_Startify configuration
    " Last Modified: Nov 16, 2019
" ============================================================================

if has('unix')
  let g:startify_change_to_dir = 1
endif

" let g:startify_use_env = 1
let g:startify_fortune_use_unicode = 1
" let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
" let g:startify_session_sort = 1
" let g:startify_relative_path = 1
let g:startify_change_to_vcs_root = 0

" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
" let g:startify_session_autoload = 1
" let g:startify_session_sort = 1

let g:startify_session_savevars = [
       \ 'g:startify_session_savevars',
       \ 'g:startify_session_savecmds',
       \ ]

       " 'g:random_plugin_use_feature'
" Commands and bookmarks officially use A B C D E F G H I!
let g:startify_commands = [
      \ {'a': 'Ag'},
      \ {'b': 'Buffers'},
    \ {'f': ['FZF!', 'FZF!'],},
    \ {'g': ['Git status!', 'Gstatus'],},
    \ {'h': ['Vim Reference', 'h ref'],},
    \ ]

let g:startify_bookmarks = [
      \ {'c': '~/.local/share/nvim/plugged/coc.nvim'},
      \ {'d': '~/projects/dynamic_ipython/README.rst'},
      \ { 'i': '~/projects/viconf/init.vim' },
      \ ]
" What the fuck! Its still reading everyrhing perfectly.
"
" In fact, if i comment out the finish it STOPS working...what the hell?
" Keep MRU below the current directorys MRU. But those are inheritently longer
" than everything else so keep them below everything else.
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions']              },
    \ { 'type': 'commands',  'header': ['   Commands']              },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']             },
    \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()]       },
    \ { 'type': 'files',     'header': ['   MRU']                   },
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
