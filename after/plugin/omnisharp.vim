" ============================================================================
  " File: omnisharp.vim
  " Author: Faris Chugthai
  " Description: The Omnisharp LSP for C#
  " Last Modified: February 09, 2020
" ============================================================================

" if exists('b:did_omnisharp') || &compatible || v:version < 700
"   finish
" endif
" let b:did_omnisharp = 1

let g:OmniSharp_server_stdio = 1
" let g:OmniSharp_server_stdio = 1

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

" Update semantic highlighting after all text changes
" let g:OmniSharp_highlight_types = 3
" Update semantic highlighting on BufEnter and InsertLeave
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_selector_ui = 'fzf'

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

augroup END

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -bang -nargs=1 RenameOmniSharp :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

let g:OmniSharp_want_snippet=1
