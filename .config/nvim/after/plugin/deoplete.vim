" Deoplete:

" General: {{{1
let g:deoplete#enable_smart_case = 1
set completeopt+=noinsert                    " Autoselect feature

" Options: {{{1
call deoplete#custom#option('max_list', 25)                 " Default is 500 like dude i can't see that

" - range_above = Search for words N lines above.
" - range_below = Search for words N lines below.
" - mark_above = Mark shown for words N lines above.
" - mark_below = Mark shown for words N lines below.
" - mark_changes = Mark shown for words in the changelist.
call deoplete#custom#var('around', {
\   'range_above': 15,
\   'range_below': 15,
\   'mark_above': '[↑]',
\   'mark_below': '[↓]',
\   'mark_changes': '[*]',
\})

" Mappings: {{{1
" Delete 1 char and reload the popup menu
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

" On <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

" function! s:my_cr_function() abort
"     return deoplete#close_popup()
" endfunction

" Refresh candidates. Are we clobbering anything? Wth is it set to insert tab???
inoremap <expr><C-l> deoplete#refresh()

" Undo completion
inoremap <expr><C-g> deoplete#undo_completion()

" Deoplete Sources: {{{1
" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

" Do not complete too short words
call deoplete#custom#source('dictionary', 'min_pattern_length', 3)

" If dictionary is already sorted, no need to sort it again.
call deoplete#custom#source( 'dictionary', 'sorters', [])

" Also same thing if they come from LangClient
" Check out *deoplete-source-attribute-min_pattern_length* I think 2 is
" actually the default
call deoplete#custom#source('LanguageClient', 'min_pattern_length', 3)

" Collect keywords from buffer path not directory Nvim was launched from
call deoplete#custom#source( 'file', 'enable_buffer_path', 'True')

" I want UltiSnips suggestions to appear first.
call deoplete#custom#source('UltiSnips', 'rank', '1')

" Logging: {{{1
" Let's start logging stuff about deoplete a little
" Also remember that you can jump to a file with <kbd>gf</kbd>
" Any way we can make this call silent?
call deoplete#enable_logging('INFO', expand('~/.local/share/nvim/deoplete.log'))

" Enable jedi source debug messages
call deoplete#custom#option('profile', v:true)
call deoplete#custom#source('jedi', 'is_debug_enabled', 1)
" UltiSnips randomly acting weird.
call deoplete#custom#source('ultisnips', 'is_debug_enabled', 1)
