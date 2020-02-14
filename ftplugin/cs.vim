" Vim filetype plugin file
" Language:	C#

" Only do this when not done yet for this buffer: {{{
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1
let s:keepcpo= &cpo
set cpo&vim

if &filetype !=# 'cs'
  finish
endif
" }}}

" Original CS plugin: {{{
" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,:///,://
" }}}

" Mine: {{{
" This really needs to be filetype specific.

" The following commands are contextual, based on the cursor position.
nnoremap <buffer> gd <Cmd>OmniSharpGotoDefinition<CR>
nnoremap <buffer> <Leader>fi <Cmd>OmniSharpFindImplementations<CR>
nnoremap <buffer> <Leader>fs <Cmd>OmniSharpFindSymbol<CR>
nnoremap <buffer> <Leader>fu <Cmd>OmniSharpFindUsages<CR>
nnoremap <buffer> <Leader>fm <Cmd>OmniSharpFindMembers<CR>
nnoremap <buffer> <Leader>fx <Cmd>OmniSharpFixUsings<CR>
nnoremap <buffer> <Leader>tt <Cmd>OmniSharpTypeLookup<CR>
nnoremap <buffer> <Leader>dc <Cmd>OmniSharpDocumentation<CR>
nnoremap <buffer> <C-\> <Cmd>OmniSharpSignatureHelp<CR>
inoremap <buffer> <C-\> <Cmd>OmniSharpSignatureHelp<CR>
" nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
" nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
nnoremap <buffer> <Leader>cc <Cmd>OmniSharpGlobalCodeCheck<CR>

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> <Cmd>OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> <Cmd>call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm <Cmd>OmniSharpRename<CR>
" nnoremap <F2> <Cmd>OmniSharpRename<CR>

" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 -buffer OmniRename call OmniSharp#RenameTo(<q-args>)

nnoremap <buffer> <Leader>cf <Cmd>OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <buffer> <Leader>ss <Cmd>OmniSharpStartServer<CR>
nnoremap <buffer> <Leader>sp :OmniSharpStopServer<CR>

" }}}

" {{{
let b:undo_ftplugin = 'setlocal fo< com< '
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'

let &cpo = s:keepcpo
unlet s:keepcpo
" }}}
