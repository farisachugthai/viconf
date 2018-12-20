" Deoplete:

" General: {{{1
let g:deoplete#enable_smart_case = 1
set completeopt+=noinsert                    " Autoselect featur
call deoplete#custom#option('max_list', 25)                 " Default is 500 like dude i can't see that

" Mappings: {{{1
" Delete 1 char and reload the popup menu
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

" On <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

" Refresh candidates. Are we clobbering anything? Wth is it set to insert tab???
inoremap <expr><C-l> deoplete#refresh()

" Undo completion
inoremap <expr><C-g> deoplete#undo_completion()

" Manually trigger completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" Deoplete Sources: {{{1
" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

" Do not complete too short words
call deoplete#custom#source('dictionary',
    \ 'min_pattern_length',
    \ 3)

" Also same thing if they come from LangClient
call deoplete#custom#source('LanguageClient',
    \ 'min_pattern_length',
    \ 2)

" Collect keywords from buffer path not directory Nvim was launched from
call deoplete#custom#source( 'file',
    \ 'enable_buffer_path',
    \ 'True')

" If dictionary is already sorted, no need to sort it again.
call deoplete#custom#source( 'dictionary', 'sorters', [])

" I want UltiSnips suggestions to appear first.
call deoplete#custom#source('UltiSnips', 'rank', '9999')

" Logging: {{{1
" Let's start logging stuff about deoplete a little
call deoplete#enable_logging('INFO', '~/.local/share/nvim/deoplete.log')

" Enable jedi source debug messages
call deoplete#custom#option('profile', v:true)
call deoplete#enable_logging('DEBUG', 'deoplete.log')
call deoplete#custom#source('jedi', 'is_debug_enabled', 1)
"
" Don't know if the below is still true
" Note: You must enable
"|deoplete-source-attribute-is_debug_enabled| to debug the
"sources.
" call deoplete-source-attribute-is_debug_enabled(v:True)
