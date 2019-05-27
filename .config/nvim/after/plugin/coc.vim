" ============================================================================
    " File: coc.vim
    " Author: Faris Chugthai
    " Description: Coc plugin mods
    " Last Modified: March 22, 2019
" ============================================================================

" Options are in coc_settings.json

" Guard: {{{1
if !has_key(plugs, 'coc.nvim')
    finish
endif

if exists('b:did_coc_after_plugin') || &compatible || v:version < 700
    finish
endif
let b:did_coc_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim


" Mappings: {{{1
" Refresh completions
inoremap <silent><expr> <c-space> coc#refresh()

" Set Enter to accept autocompletion. More settings in
" ~/.config/nvim/coc-settings.json
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Navigate snippet placeholders using tab
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'


let &cpoptions = s:cpo_save
unlet s:cpo_save
