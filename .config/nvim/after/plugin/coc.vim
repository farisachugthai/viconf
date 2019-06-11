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
"       \ pumvisible() ? '\<C-n>' :
"       \ <SID>check_back_space() ? '\<TAB>' :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? '\<C-p>' : '\<C-h>'

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

" Use `[c` and `]c` to navigate diagnostics
" First check that gitgutter doesn't have these mapped first
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
" might be better as u for usagea
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup Cocaction
  au!
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Commands: {{{1

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 SortImport :call CocAction('runCommand', 'editor.action.organizeImport')

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
