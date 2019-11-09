
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


" Enable snippet completion
let g:OmniSharp_want_snippet=1
