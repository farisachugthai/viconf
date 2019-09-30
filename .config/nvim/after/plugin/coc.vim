" ============================================================================
    " File: coc.vim
    " Author: Faris Chugthai
    " Description: Coc plugin mods
    " Last Modified: Sep 26, 2019
" ============================================================================

" Global options are in ../../coc_settings.json

" Guard: {{{1
if !exists('g:loaded_coc')  | finish | endif

let s:cpo_save = &cpoptions
set cpoptions-=C


" Options: {{{1

let $NVIM_COC_LOG_LEVEL = 'debug'
let $NVIM_COC_LOG_FILE = stdpath('data') . '/site/coc.log'

" May have to extend after a has('unix') check.
let g:WorkspaceFolders = [
      \ stdpath('config'),
      \ expand('$HOME/projects/dynamic_ipython'),
      \ expand('$HOME/projects/viconf'),
      \ expand('$HOME/python/tutorials'),
      \ ]

let g:coc_quickfix_open_command = 'cwindow'

let g:coc_snippet_next = '<Tab>'

let g:coc_snippet_prev = '<S-Tab>'

" Mappings:- {{{1

" Basics: {{{2

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Refresh completions with C-Space
inoremap <silent><expr> <C-Space> coc#refresh()

" As a heads up theres also a coc#select#snippet
inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Did they need <expr>
inoremap <buffer><expr> gK <Plug>(coc-definition)

" Shit none of these work
nnoremap [g <Plug>(coc-diagnostic-prev)
nnoremap ]g <Plug>(coc-diagnostic-next)

nnoremap <expr> [c  <Plug>(coc-git-prevchunk)
nnoremap <expr> ]c  <Plug>(coc-git-nextchunk)

" Remap for rename current word
nnoremap <expr> <F2> <Plug>(coc-refactor)
xnoremap <F2> <Cmd>'<,'>CocCommand document.renameCurrentWord<CR>

nnoremap <silent> <Leader>cw  <Cmd>execute 'CocList -I --normal --input=' 
      \. expand('<cword>') . ' words'<CR>

" Easier Grep: {{{2 Mnenomic CocFind
" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <Leader>cf <Cmd>exe 'CocList -I --input=' 
      \. expand('<cword>') . ' grep'<CR>

" Mnemonic: CocSelect {{{2
" Don't use vmap I don't want this in select mode!
" Q: How to grep by motion?
" A: Create custom keymappings like:
xnoremap <leader>cs :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
nnoremap <leader>cs :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@

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
  execute 'CocList grep ' . word
endfunction

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
xmap <C-c>m  <Plug>(coc-format-selected)
nmap <C-c>m  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <C-c><C-a>  <Plug>(coc-codeaction-selected)
" nmap <C-c>a  <Plug>(coc-codeaction-selected)

" Autofix problem of current line
nnoremap <C-c><C-f>  <Plug>(coc-fix-current)
nnoremap <silent> <C-c>q <Plug>(coc-fix-current)

" Format visually selected text
xmap <C-c>m  <Plug>(coc-format-selected)

" Commands: {{{1

" Let's group these together by prefixing with Coc

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
