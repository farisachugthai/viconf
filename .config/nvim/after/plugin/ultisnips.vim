" ============================================================================
    " File: ultisnips.vim
    " Author: Faris Chugthai
    " Description: UltiSnips plugin configuration.
    " Last Modified: Mar 23, 2019
" ============================================================================

" Guards: {{{1

if exists('did_ultisnips') || &compatible || v:version < 700
    finish
endif
let did_ultisnips = 1

if !has_key(plugs, 'ultisnips')
    finish
endif

" Mappings: {{{2

noremap <F4> <Cmd>UltiSnipsEdit<CR>
noremap! <F4> <Cmd>UltiSnipsEdit<CR>

noremap <F6> <Cmd>Snippets<CR>
noremap! <F6> <Cmd>Snippets<CR>

" Options: {{{2

let g:snips_author = 'Faris Chugthai'
let g:snips_github = 'https://github.com/farisachugthai'
let g:UltiSnipsSnippetDir = [ expand('~') . '/.config/nvim/UltiSnips' ]
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsListSnippets = '<C-Tab>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
inoremap <C-Tab> * <Esc>:call ultisnips#listsnippets()<CR>
let g:ultisnips_python_style = 'numpy'
let g:ultisnips_python_quoting_style = 'double'
let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsEditSplit = 'tabdo'
" Defining it in this way means that UltiSnips doesn't iterate
" through every dir in &rtp which should save a lot of time
let g:UltiSnipsSnippetDirectories = [ expand('~') . '/.config/nvim/UltiSnips' ]
