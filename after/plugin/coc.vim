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
" Be aware that this formats the file on every CR so don't do this everywhere
" inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"))
" Actually you have to use this one because otherwise CR autoselects the first
" thing on the PUM which is terrible when you're just trying to insert
" whitespace.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

"Cycle through completion entries with tab/shift+tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

nnoremap <expr><buffer> gK <Plug>(coc-definition)<CR>
nnoremap <expr><buffer> gu <Plug>(coc-usages)<CR>

" Bracket maps: {{{2
" Shit none of these work
nnoremap [g <Plug>(coc-diagnostic-prev)<CR>
nnoremap ]g <Plug>(coc-diagnostic-next)<CR>

" Note: Tried adding <expr> and didn't work
nnoremap [c  <Plug>(coc-git-prevchunk)<CR>
nnoremap ]c  <Plug>(coc-git-nextchunk)<CR>

" Remap for rename current word: {{{2
nnoremap <expr> <F2> <Plug>(coc-refactor)<CR>

" Instead of actually writing a '<,'> are we allowed to use the * char?
xnoremap <F2> <Cmd>'<,'>CocCommand document.renameCurrentWord<CR>

" CocOpenLog: {{{2
" C-m only moves you down a line in normal mode. Pointless.
" fuck it also maps to CR
" nnoremap <expr> <C-m> coc#client#open_log()
nnoremap ,l <Cmd>CocOpenLog<CR>

" And let's add one in for CocInfo
nnoremap ,i <Cmd>CocInfo<CR>


" Grep By Motion: Mnemonic CocSelect {{{2
" Don't use vmap I don't want this in select mode!
" Q: How to grep by motion?
" A: Create custom keymappings like:
xnoremap ,cs :<C-u>call plugins#GrepFromSelected(visualmode())<CR>
nnoremap ,cs :<C-u>set operatorfunc=plugins#GrepFromSelected<CR>g@

" Show all diagnostics
command! -nargs=0 CocDiagnostic call CocActionAsync('diagnosticInfo')

" Maps For CocList X: {{{2

nnoremap <C-g> <Cmd>CocList<CR>

nnoremap ,d  <Cmd>CocList diagnostics<CR>

" Orrrrr
" nnoremap ,d <Plug>(coc-diagnostic-info)<CR>

" Manage extensions
nnoremap ,e  <Cmd>CocList extensions<CR>
" Show commands
nnoremap ,c  <Cmd>CocList commands<CR>
" Find symbol of current document
nnoremap ,o  <Cmd>CocList outline<CR>
" Search workspace symbols
nnoremap ,s  <Cmd>CocList -I symbols<CR>

" Easier Grep Using CocList Words:
nnoremap ,w <Cmd>execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'<CR>

command! -nargs=0 CocWords execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'

" Keymapping for grep word under cursor with interactive mode
nnoremap ,g <Cmd>exe 'CocList -I --input=' . expand('<cword>') . ' grep'<CR>

" TODO: Figure out the ternary operator, change nargs to ? and if arg then
" input=arg else expand(cword)
command! -nargs=0 CocGrep execute 'CocList -I --input=' . expand('<cword>') . ' grep'

" CocResume: {{{2
" Amazingly leader j k and p aren't taken. From the readme
nnoremap <Leader>j  :<C-u>CocNext<CR>
nnoremap ,j  :<C-u>CocNext<CR>
nnoremap <Leader>k  :<C-u>CocPrev<CR>
nnoremap ,k  :<C-u>CocPrev<CR>
nnoremap <Leader>r  :<C-u>CocListResume<CR>
nnoremap ,r  :<C-u>CocListResume<CR>

" Other Mappings: {{{2
xmap ,m  <Plug>(coc-format-selected)<CR>
nmap ,m  <Plug>(coc-format-selected)<CR>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap ,a  <Plug>(coc-codeaction-selected)<CR>
" Remap for do codeAction of current line
nnoremap ,a  <Plug>(coc-codeaction)<CR>

" Now codeLens. No reason for h outside of it not being bound.
nnoremap ,h <Plug>(coc-codelens-action)<CR>

" Open the URL in the same way as netrw
nnoremap gx <Plug>(coc-openlink)<CR>

" Coc Usages
nnoremap ,u <Plug>(coc-references)<CR>

command! -nargs=0 CocReferences call CocAction('jumpReferences')

nnoremap ,. <Plug>(coc-command-repeat)<CR>

command! -nargs=0 CocRepeat call CocAction('repeatCommand')

" Autofix problem of current line
nnoremap ,f  <Plug>(coc-fix-current)<CR>
nnoremap ,q  <Plug>(coc-fix-current)<CR>

" Commands: {{{1

" Let's group these together by prefixing with Coc
" Use `:Format` to format current buffer
command! -nargs=0 CocFormat call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold call CocActionAsync('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 CocSort call CocAction('runCommand', 'editor.action.organizeImport')

" Just tried this and it worked! So keep checking :CocList commands and add
" more as we go.
command! -nargs=0 CocPython call CocActionAsync('runCommand', 'python.startREPL')|

" Let's also get some information here.
" call CocAction('commands') is a lamer version of CocCommand
" similar deal with CocFix and CocAction() -quickfix

" Autocmds: {{{1

" Use autocmd to force lightline update.
" Well I have my own statusline function but you're close
if exists('*Statusline_expr')
  autocmd User CocStatusChange,CocDiagnosticChange call Statusline_expr()
endif

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
