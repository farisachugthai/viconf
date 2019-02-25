" UltiSnips:

if !has_key(plugs, 'ultisnips')
    finish
endif

if exists('b:did_ultisnips') || &cp || v:version < 700
    finish
endif
let b:did_ultisnips = 1

" TODO: Is it better to put <Cmd> here? For the insert mode ones maybe.
" I use this command constantly
nnoremap <Leader>se <Cmd>UltiSnipsEdit<CR>
nnoremap <Leader>sn <Cmd>UltiSnipsEdit<CR>

" TODO: Is C-o better than Esc? Also add a check that if has_key(plug['fzf'])
" then and only then make these mappings. should just move to fzf plugin
inoremap <F6> <C-o>:Snippets<CR>
nnoremap <F6> :Snippets<CR>


let g:UltiSnipsSnippetDir = [ '~/.config/nvim/UltiSnips' ]
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
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']
