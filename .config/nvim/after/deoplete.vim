" Deoplete: {{{

" TODO:
" Set up some more fine-tuned options.
" Or at least merge the comments thing and the dict thing.

" From the docs it sounds like setting up omnifuncs might be a good idea but
" lang client should be taking care of that.
"
" Wth is up with the way we have sources setup? Why is it taking up so many lines
" can we not pass the function a dict?

" setting up loggings more than likely gonna be a good idea if this ends up shitting the bed
" or at least having something configured in case you wanna toggle it


let g:deoplete#enable_smart_case = 1
set completeopt+=noinsert                    " Autoselect feature

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

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

"" Do not complete too short words
call deoplete#custom#source(
\ 'dictionary', 'min_pattern_length', 3)

" Collect keywords from buffer path not directory Nvim was launched from
call deoplete#custom#source(
\ 'file', 'enable_buffer_path', 'True')

" If dictionary is already sorted, no need to sort it again.
call deoplete#custom#source( 'dictionary', 'sorters', [])

" Enable jedi source debug messages
" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', 'deoplete.log')
" Note: You must enable
"|deoplete-source-attribute-is_debug_enabled| to debug the
"sources.
" call deoplete#custom#source('jedi', 'is_debug_enabled', 1)

" }}}
