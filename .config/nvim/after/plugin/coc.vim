" ============================================================================
    " File: coc.vim
    " Author: Faris Chugthai
    " Description: Coc plugin mods
    " Last Modified: Jul 15, 2019
" ============================================================================

" Options are in coc_settings.json

" Guard: {{{1
if !has_key(plugs, 'coc.nvim')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions-=C

if exists('g:did_coc_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_coc_plugin = 1

" Mappings: {{{1

" This section primarily focuses on setting up the autocompletion aspect
" Refresh completions with C-Space
inoremap <silent><expr> <C-Space> coc#refresh()

" Set Enter to accept autocompletion. More settings in
" ~/.config/nvim/coc-settings.json
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : 
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Shit none of these work
" nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
" nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

" " Remap keys for gotos
" " Now let's start working with the niceties of an LSP. Docs and symbols
" nnoremap <silent> gd <Plug>(coc-definition)
" nnoremap <silent> gy <Plug>(coc-type-definition)
" nnoremap <silent> gi <Plug>(coc-implementation)
" nnoremap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   " Jun 15, 2019: Added none if we do something like `:r!pydoc thing`
"   if (index(['vim','help','none'], &filetype) >= 0)
"     execute 'h ' . expand('<cWORD>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

" Remap for rename current word
nnoremap <F2> <Plug>(coc-rename)
xnoremap <F2> <Cmd>CocCommand document.renameCurrentWord<CR>

augroup CocConf

  au!

  " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Close the popupmenu when completions done
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

augroup end


" Using CocList: {{{1

" Show all diagnostics
nnoremap <silent> <C-c><C-d> <Cmd>CocList diagnostics<CR>
" Manage extensions
nnoremap <silent> <C-c><C-e> <Cmd>CocList extensions<CR>
" Show commands
nnoremap <silent> <C-c><C-c>  <Cmd>CocList commands<CR>
" Find symbol of current document
nnoremap <silent> <C-c><C-o>  <Cmd>CocList outline<CR>
" Search workspace symbols
nnoremap <silent> <C-c><C-s> <Cmd>CocList -I symbols<CR>
" Do default action for next item.
nnoremap <silent> <C-c>j  <Cmd>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <C-c>k  <Cmd>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <C-c><C-r>  <Cmd>CocListResume<CR>
" noremap <silent> <C-c>r <Cmd>CocListResume<CR>
noremap <silent> <C-c><C-d> <Cmd>CocList diagnostics<CR>


" Remap For Rename Current Word: {{{1

" Remap for format selected region. e for errors and visual selection
xmap <C-c>m  <Plug>(coc-format-selected)
nmap <C-c>m  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <C-c><C-a>  <Plug>(coc-codeaction-selected)
" nmap <C-c>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <C-c><C-a>  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap <C-c><C-f>  <Plug>(coc-fix-current)

" Dude that is an OBNOXIOUS amount of typing though.
noremap <silent> <C-c>q <Plug>(coc-fix-current)

" Commands: {{{1

" Let's start grouping these together by prefixing with C or something

" Use `:Format` to format current buffer
command! -nargs=0 CFormat :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? CFold :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 CSort :call CocAction('runCommand', 'editor.action.organizeImport')

" Just tried this and it worked! So keep checking :CocList commands and add
" more as we go.
command! -nargs=0 CPython :call CocActionAsync('runCommand', 'python.startREPL')|

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
