" ============================================================================
    " File: ultisnips.vim
    " Author: Faris Chugthai
    " Description: UltiSnips plugin configuration.
    " Last Modified: May 13, 2019
" ============================================================================

" Guards: {{{1

if exists('b:did_ultisnips_after_plugin') || &compatible || v:version < 700
    finish
endif
let b:did_ultisnips_after_plugin = 1

if !has_key(plugs, 'ultisnips')
    finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" Mappings: {{{1

noremap <F4> <Cmd>UltiSnipsEdit<CR>
noremap! <F4> <Cmd>UltiSnipsEdit<CR>

noremap <F6> <Cmd>Snippets<CR>
noremap! <F6> <Cmd>Snippets<CR>

inoremap <C-Tab> * <Cmd>call ultisnips#listsnippets()<CR>

" Options: {{{1

let g:snips_author = 'Faris Chugthai'
let g:snips_github = 'https://github.com/farisachugthai'
let g:UltiSnipsSnippetDir = [ expand('~') . '/.config/nvim/UltiSnips' ]
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsListSnippets = '<C-Tab>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:ultisnips_python_style = 'numpy'
let g:ultisnips_python_quoting_style = 'double'
let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsEditSplit = 'tabdo'

" Defining it in this way means that UltiSnips doesn't iterate
" through every dir in &rtp which should save a lot of time
let g:UltiSnipsSnippetDirectories = [ expand('~') . '/.config/nvim/UltiSnips' ]

" Functions And Commands: {{{1

" From the help docs
function! ExpandPossibleShorterSnippet()
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    execute 'normal a' . curr_key
    execute 'normal a '
    return 1
  " not from help docs but tell me what you got regardless
  else
    echo UltiSnips#SnippetsInCurrentScope()
    return 0
  endif
  return 0
endfunction

" Changed the mapping to Alt-S for snippets.
inoremap <silent> <M-s> <C-R>=(ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

" Atexit

let &cpoptions = s:cpo_save
unlet s:cpo_save
