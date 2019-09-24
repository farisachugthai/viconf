" ============================================================================
    " File: coc.vim
    " Author: Faris Chugthai
    " Description: Coc plugin mods
    " Last Modified: Jul 15, 2019
" ============================================================================

" Global options are in ../../coc_settings.json

" Guard: {{{1
if !exists('g:loaded_coc')  | finish | endif

let s:cpo_save = &cpoptions
set cpoptions-=C


" Options: {{{1

let $NVIM_COC_LOG_LEVEL='debug'
let $NVIM_COC_LOG_FILE =stdpath('data') . '/site/coc.log'

" May have to extend after a has('unix') check.
let g:WorkspaceFolders = [
      \ stdpath('config'),
      \ expand('$HOME/projects/dynamic_ipython')
      \ expand('$HOME/projects/viconf'),
      \ expand('$HOME/python/tutorials'),
      \ ]

let g:coc_quickfix_open_command = 'cwindow'

let g:coc_snippet_next = '<tab>'

let g:coc_snippet_prev = '<S-Tab>'

" Mappings: {{{1

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Refresh completions with C-Space
inoremap <silent><expr> <C-Space> <Plug>coc#refresh()

inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Shit none of these work
nnoremap [g <Plug>(coc-diagnostic-prev)
nnoremap ]g <Plug>(coc-diagnostic-next)

" Remap for rename current word
nnoremap <expr> <F2> <Plug>(coc-refactor)
xnoremap <F2> <Cmd>'<,'>CocCommand document.renameCurrentWord<CR>

" Easier Grep: {{{2
"
" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <Leader>cf :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>

" Q: How to grep by motion?

" A: Create custom keymappings like:

vnoremap <leader>g :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
nnoremap <leader>g :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@

function! s:GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList grep '.word
endfunction

nnoremap <silent> <Leader>w  <Cmd>execute 'CocList -I --normal --input='.expand('<cword>').' words'<CR>


" Remap For Rename Current Word: {{{2

" Remap for format selected region. e for errors and visual selection
xmap <C-c>m  <Plug>(coc-format-selected)
nmap <C-c>m  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <C-c><C-a>  <Plug>(coc-codeaction-selected)
" nmap <C-c>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
noremap <expr><buffer> <C-c><C-a>  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap <C-c><C-f>  <Plug>(coc-fix-current)

noremap <silent> <C-c>q <Plug>(coc-fix-current)
" Using CocList: {{{1

" Show all diagnostics
command! -nargs=0 CocDiagnostics <Cmd>CocList diagnostics<CR>
nnoremap <silent> <C-c><C-d>  <Cmd>CocList diagnostics<CR>
" Manage extensions
nnoremap <silent> <C-c><C-e>  <Cmd>CocList extensions<CR>
" Show commands
nnoremap <silent> <C-c><C-c>  <Cmd>CocList commands<CR>
" Find symbol of current document
nnoremap <silent> <C-c><C-o>  <Cmd>CocList outline<CR>
" Search workspace symbols
nnoremap <silent> <C-c><C-s>  <Cmd>CocList -I symbols<CR>
" Do default action for next item.
nnoremap <silent> <C-c>j      <Cmd>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <C-c>k      <Cmd>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <C-c><C-r>  <Cmd>CocListResume<CR>
" noremap <silent> <C-c>r <Cmd>CocListResume<CR>
noremap <silent> <C-c><C-d>   <Cmd>CocList diagnostics<CR>
noremap <silent> <C-c> <C-d>   <Cmd>CocList diagnostics<CR>
xmap <C-c>m  <Plug>(coc-format-selected)
nmap <C-c>m  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <C-c><C-a>  <Plug>(coc-codeaction-selected)
" nmap <C-c>a  <Plug>(coc-codeaction-selected)

" Fix autofix problem of current line
nmap <C-c><C-f>  <Plug>(coc-fix-current)
noremap <silent> <C-c>q <Plug>(coc-fix-current)

" Commands: {{{1

" Let's group these together by prefixing with C

" Use `:Format` to format current buffer
command! -nargs=0 CocFormat call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold call CocActionAsync('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 CocSort :call CocAction('runCommand', 'editor.action.organizeImport')

" Just tried this and it worked! So keep checking :CocList commands and add
" more as we go.
command! -nargs=0 CocPython call CocActionAsync('runCommand', 'python.startREPL')|

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
