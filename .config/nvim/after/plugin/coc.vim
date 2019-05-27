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
" Refresh completions with C-Space
inoremap <silent><expr> <C-Space> <Cmd>coc#refresh()<CR>

" Set Enter to accept autocompletion. More settings in
" ~/.config/nvim/coc-settings.json
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Map <tab> for trigger completion, completion confirm, snippet expand and jump
" like VSCode. >

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Note: the `coc-snippets` extension is required for this to work.
" Holy hell that's a hell of a setup!
" Supertab's also installed hahahah
let g:coc_snippet_prev = '<S-Tab>'

let &cpoptions = s:cpo_save
unlet s:cpo_save
