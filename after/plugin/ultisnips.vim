" ============================================================================
    " File: ultisnips.vim
    " Author: Faris Chugthai
    " Description: UltiSnips plugin configuration.
    " Last Modified: Jun 29, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_ultisnips_after_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_ultisnips_after_plugin = 1

if !has_key(plugs, 'ultisnips')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions-=C

" Mappings: {{{1
noremap <F4> <Cmd>UltiSnipsEdit<CR>
noremap! <F4> <Cmd>UltiSnipsEdit<CR>

noremap <F6> <Cmd>Snippets<CR>
noremap! <F6> <Cmd>Snippets<CR>

" Seriously why does this not work yet
" inoremap <C-Tab> * <Cmd>call ultisnips#listsnippets()<CR>

" Options: {{{1

let g:snips_author = 'Faris Chugthai'
let g:snips_github = 'https://github.com/farisachugthai'

" Do a directory check before we assign and also use the stdpath() function
if isdirectory(stdpath('config') . '/UltiSnips')
  let g:UltiSnipsSnippetDir = [stdpath('config') . '/UltiSnips']
endif

" well poop i didn't realize i never set this
let g:UltiSnipsUsePythonVersion = 3

let g:UltiSnipsExpandTrigger = '<C-j>'
" " TODO: Mapped in ConEmu and I don't know how to unmap a system keybinding...
" Literally listed in the help docs as unused. Why not?
let g:UltiSnipsListSnippets = '<C-\>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:ultisnips_python_style = 'numpy'
let g:ultisnips_python_quoting_style = 'double'
let g:UltiSnipsEnableSnipMate = 0

let g:UltiSnipsEditSplit = 'context'  " context is an interesting option. it's a vert split unless textwidth <= 80

" Defining it and limiting it to 1 directory means that UltiSnips doesn't
" iterate through every dir in &rtp which saves an immense amount of time
" on startup.
let g:UltiSnipsSnippetDirectories = [ stdpath('config') . '/UltiSnips' ]

" Functions And Commands: {{{1

" Changed the mapping to Alt-S for snippets.
inoremap <silent> <M-s> <C-R>=(plugins#ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

command! UltiSnipsListSnippets call UltiSnips#ListSnippets()

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
