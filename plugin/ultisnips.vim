" ============================================================================
    " File: ultisnips.vim
    " Author: Faris Chugthai
    " Description: UltiSnips plugin configuration.
    " Last Modified: Jun 29, 2019
" ============================================================================

" Might need to start setting this because i'm still not getting
" autocompletion to work the way i want.
" let b:did_autoload_ultisnips_map_keys = 1

if exists('g:did_ultisnips_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_ultisnips_plugin = 1


" Options: {{{
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

let g:ultisnips_python_style = 'numpy'
let g:ultisnips_python_quoting_style = 'double'
let g:UltiSnipsEnableSnipMate = 0

" context is an interesting option. it's a vert split unless textwidth <= 80
let g:UltiSnipsEditSplit = 'context'

let g:snips_author = 'Faris Chugthai'
let g:snips_github = 'https://github.com/farisachugthai'

let g:UltiSnipsSnippetDir = [stdpath('config') . '/UltiSnips']

" Defining it and limiting it to 1 directory means that UltiSnips doesn't
" iterate through every dir in &rtp which saves an immense amount of time
" on startup.
let g:UltiSnipsSnippetDirectories = [ stdpath('config') . '/UltiSnips' ]

let g:UltiSnipsUsePythonVersion = 3

" Literally listed in the help docs as unused. Why not?
let g:UltiSnipsListSnippets = '<C-\>'

" Oddly, setting this var only sets it in select-mode though.
" So let's add a few mappings to help us along.

" }}}

" Mappings: {{{

noremap <F4> <Cmd>UltiSnipsEdit<CR>
noremap! <F4> <Cmd>UltiSnipsEdit<CR>

if exists(':Snippets')
  noremap <F6> <Cmd>Snippets<CR>
  noremap! <F6> <Cmd>Snippets<CR>
else
  noremap <F6> <Cmd>UltiSnipsListSnippets<CR>
  noremap! <F6> <Cmd>UltiSnipsListSnippets<CR>
endif

" Changed the mapping to Alt-S for snippets.
inoremap <silent> <M-s> <C-R>=(plugins#ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>
" }}}

" Functions And Commands: {{{

command! -complete=filetype -bar UltiSnipsListSnippets call UltiSnips#ListSnippets()
" }}}
