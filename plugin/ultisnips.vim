" ============================================================================
    " File: ultisnips.vim
    " Author: Faris Chugthai
    " Description: UltiSnips plugin configuration.
    " Last Modified: Jun 29, 2019
" ============================================================================

" Options: {{{1
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

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

let g:UltiSnipsExpandTrigger = '<Tab>'

" Literally listed in the help docs as unused. Why not?
let g:UltiSnipsListSnippets = '<C-\>'

" Oddly, setting this var only sets it in select-mode though.
" So let's add a few mappings to help us along.
" nnoremap <C-\> :<C-u>call UltiSnips#ListSnippets()<CR>

" TODO: Not really working. Kinda hard to get it to behave how I'd like.
vnoremap <C-\> :<C-u>call UltiSnips#ListSnippets()<CR>
" Yo and here's a different way of doing this
" nnoremap <expr> <C-\> py#list_snippets()
" And another!
" vnoremap <C-\> <Cmd>py#list_snippets()

noremap <F4> <Cmd>UltiSnipsEdit<CR>
noremap! <F4> <Cmd>UltiSnipsEdit<CR>

if exists(':FufSnippets')
  noremap <F6> <Cmd>FufSnippets<CR>
  noremap! <F6> <Cmd>FufSnippets<CR>
else
  noremap <F6> <Cmd>UltiSnipsListSnippets<CR>
  noremap! <F6> <Cmd>UltiSnipsListSnippets<CR>
endif

" C-@ is repeat last inserted text. But so is <C-Spc>. And <C-a> in insert
" mode. Fuck <C-S-2> is open a new tab in microsoft terminal. Hm.
inoremap <C-@> <Cmd>echo UltiSnips#ListSnippets()<CR>

" Functions And Commands: {{{1

" Changed the mapping to Alt-S for snippets.
inoremap <silent> <M-s> <C-R>=(plugins#ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

command! UltiSnipsListSnippets call UltiSnips#ListSnippets()
