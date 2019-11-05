
" Dude they wrote everything python that's dope
let g:OmniSharp_loglevel = 'DEBUG'

" It's faster when it's not in python though
let g:OmniSharp_server_stdio = 1

" Python logging path
let g:OmniSharp_python_path = stdpath('data') . '/site/log'

" " Defaults:
" let g:OmniSharp_highlight_groups = {
" \ 'csUserIdentifier': [
" \   'constant name', 'enum member name', 'field name', 'identifier',
" \   'local name', 'parameter name', 'property name', 'static symbol'],
" \ 'csUserInterface': ['interface name'],
" \ 'csUserMethod': ['extension method name', 'method name'],
" \ 'csUserType': ['class name', 'enum name', 'namespace name', 'struct name']
" \}

let g:OmniSharp_timeout = 5
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_selector_ui = 'fzf'

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

augroup END

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
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <buffer> <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <buffer> <Leader>ss :OmniSharpStartServer<CR>
nnoremap <buffer> <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
let g:OmniSharp_want_snippet=1
