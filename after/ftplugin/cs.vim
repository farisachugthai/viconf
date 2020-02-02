
" if exists('b:did_ftplugin') | finish | endif
" let b:did_ftplugin = 1

if &filetype !=# 'cs'
  finish
endif

" This really needs to be filetype specific.

" The following commands are contextual, based on the cursor position.
nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>
nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>
nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>
" nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
" nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
" nnoremap <F2> :OmniSharpRename<CR>

" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 OmniRename call OmniSharp#RenameTo(<q-args>)

nnoremap <buffer> <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <buffer> <Leader>ss :OmniSharpStartServer<CR>
nnoremap <buffer> <Leader>sp :OmniSharpStopServer<CR>

" let b:undo_ftplugin = 'setlocal '
"       \ . '|unlet! b:undo_ftplugin'
