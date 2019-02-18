
" UltiSnips:
" 90% sure i need to rename these to use them.

" GetAllSnippets: {{{3
" Definitely a TODO
function! GetAllSnippets()
  call UltiSnips#SnippetsInCurrentScope(1)
  let list = []
  for [key, info] in items(g:current_ulti_dict_info)
    let parts = split(info.location, ':')
    call add(list, {
      \'key': key,
      \'path': parts[0],
      \'linenr': parts[1],
      \'description': info.description,
      \})
  endfor
  return list
endfunction

" Expandable:{{{3

" TODO: Come up with a mapping for it. Also what is E746
" Go to the annotations for an explanation of this function.
" function UltiSnips#IsExpandable()
"     return !(
"         \ col('.') <= 1
"         \ || !empty(matchstr(getline('.'), '\%' . (col('.') - 1) . 'c\s'))
"         \ || empty(UltiSnips#SnippetsInCurrentScope())
"         \ )
" endfunction

" ExpandPossibleShorterSnippet: {{{3

function! ExpandPossibleShorterSnippet()
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe 'normal a' . curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction
inoremap <silent> <C-L> <C-R>=(ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

" Expand Snippet Or CR: {{{3
" Hopefully will expand snippets or CR. Or it'll destroy deoplete's
" ability to close the pum. *shrugs*
function! ExpandSnippetOrCarriageReturn() abort
  let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
      return snippet
    else
      return "\<CR>"
    endif
endfunction

inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"
