" ============================================================================
    " File: ale.vim
    " Author: Faris Chugthai
    " Description: Ale configuration
    " Last Modified: May 11, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'ale')
    finish
endif

if exists('g:did_ale_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_ale_after_plugin = 1


" Mappings: {{{1

" This isn't working idk why
noremap <Leader>l <Plug>(ale_toggle_buffer)<CR>

noremap ]a <Plug>(ale_next_wrap)
noremap [a <Plug>(ale_previous_wrap)

" `:ALEInfoToFile` will write the ALE runtime information to a given filename.
" The filename works just like |:w|.

" <Meta-a> now gives detailed messages about what the linters have sent to ALE
noremap <A-a> <Plug>(ale_detail)

" This might be a good idea. * is already 'search for the cword' so let ALE
" work in a similar manner right?
noremap <Leader>* <Plug>(ale_go_to_reference)

noremap <Leader>a <Cmd>ALEInfo<CR>

" Options: {{{2

" For buffer specific options, see ../ftplugin/*.vim
let g:ale_fixers = { '*': [ 'remove_trailing_lines', 'trim_whitespace' ] }
let g:ale_fix_on_save = 1

" Now because you fix the trailing whitespace and trailing lines
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_warn_about_trailing_blank_lines = 0

let g:ale_list_vertical = 1

let g:ale_set_signs = 1
let g:ale_sign_column_always = 1
let g:ale_virtualenv_dir_names = [ expand('$HOME/virtualenvs') ]

" Quickfix:

" By default ale uses location list which I never remember
let g:ale_set_quickfix = 1
let g:ale_set_loclist = 0
