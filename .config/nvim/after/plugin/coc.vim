" ============================================================================
    " File: coc.vim
    " Author: Faris Chugthai
    " Description: Coc plugin mods
    " Last Modified: Sep 26, 2019
" ============================================================================

" Global options are in ../../coc_settings.json

" Guard: {{{1
if !exists('g:did_coc_loaded')  | finish | endif

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

" Env vars: {{{2
let $NVIM_COC_LOG_LEVEL = 'debug'
let $NVIM_COC_LOG_FILE = stdpath('data') . '/site/coc.log'

" General: {{{2

" TODO:
" May have to extend after a has('unix') check.
" Yeah probably need to make system checks to get rid of incorrect
" non portable definitions in the JSON file.
let g:WorkspaceFolders = [
      \ stdpath('config'),
      \ expand('$HOME/projects/dynamic_ipython'),
      \ expand('$HOME/projects/viconf'),
      \ expand('$HOME/python/tutorials'),
      \ ]

let g:coc_quickfix_open_command = 'cwindow'
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

	" call coc#config('coc.preferences', {
	" 	\ 'timeout': 1000,
	" 	\})
	" call coc#config('languageserver', {
	" 	\ 'ccls': {
	" 	\   "command": "ccls",
	" 	\   "trace.server": "verbose",
	" 	\   "filetypes": ["c", "cpp", "objc", "objcpp"]
	" 	\ }
	" 	\})

" Mappings: {{{1

" Basic: {{{2
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Refresh completions with C-Space
inoremap <silent><expr> <C-Space> coc#refresh()

" As a heads up theres also a coc#select#snippet
" I think supertab does the <CR> thing for us
inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <buffer> gK <Plug>(coc-definition)

" Bracket maps: {{{2
" Shit none of these work
nnoremap [g <Plug>(coc-diagnostic-prev)
nnoremap ]g <Plug>(coc-diagnostic-next)

" Note: Tried adding <expr> and didn't work
nnoremap [c  <Plug>(coc-git-prevchunk)
nnoremap ]c  <Plug>(coc-git-nextchunk)

" Remap for rename current word: {{{2
nnoremap <expr> <F2> <Plug>(coc-refactor)
xnoremap <F2> <Cmd>'<,'>CocCommand document.renameCurrentWord<CR>

" Easier Grep: {{{2
nnoremap ,cw <Cmd>execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'<CR>

" CocOpenLog: {{{2
" C-m only moves you down a line in normal mode. Pointless.
" fuck it also maps to CR
" nnoremap <expr> <C-m> coc#client#open_log()
nnoremap <expr> <C-g> coc#client#open_log()

" Easier Grep: {{{2 Mnenomic CocFind
" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> ,cf <Cmd>exe 'CocList -I --input=' . expand('<cword>') . ' grep'<CR>

" Grep By Motion: Mnemonic CocSelect {{{2
" Don't use vmap I don't want this in select mode!
" Q: How to grep by motion?
" A: Create custom keymappings like:
xnoremap ,cs :<C-u>call plugins#GrepFromSelected(visualmode())<CR>
nnoremap ,cs :<C-u>set operatorfunc=plugins#GrepFromSelected<CR>g@


" Using CocList: {{{1

" How have I not mapped the most basic Coc command?
nnoremap <C-g> <Cmd>CocList<CR>

" Show all diagnostics
command! -nargs=0 CocDiagnostics <Cmd>CocList diagnostics<CR>

" Maps For CocList X: {{{2
nnoremap <silent> ,d  <Cmd>CocList diagnostics<CR>
" Manage extensions
nnoremap <silent> ,e  <Cmd>CocList extensions<CR>
" Show commands
nnoremap <silent> ,c  <Cmd>CocList commands<CR>
" Find symbol of current document
nnoremap <silent> ,o  <Cmd>CocList outline<CR>
" Search workspace symbols
nnoremap <silent> ,s  <Cmd>CocList -I symbols<CR>

" Amazingly leader j k and p aren't taken. From the readme
nnoremap <silent> <Leader>j  :<C-u>CocNext<CR>
nnoremap <silent> ,j  :<C-u>CocNext<CR>
nnoremap <silent> <Leader>k  :<C-u>CocPrev<CR>
nnoremap <silent> ,k  :<C-u>CocPrev<CR>
nnoremap <silent> <Leader>r  :<C-u>CocListResume<CR>
nnoremap <silent> ,r  :<C-u>CocListResume<CR>

xmap ,m  <Plug>(coc-format-selected)
nmap ,m  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap ,a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nnoremap ,a  <Plug>(coc-codeaction)

" Autofix problem of current line
nnoremap <silent> ,f  <Plug>(coc-fix-current)
nnoremap <silent> ,q <Plug>(coc-fix-current)

" Format visually selected text
xmap <silent> ,m  <Plug>(coc-format-selected)

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
