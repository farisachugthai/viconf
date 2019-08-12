" ============================================================================
  " File: ultisnips.vim
  " Author: Faris Chugthai
  " Description: UltiSnips autoloaded functions
  " Last Modified: August 01, 2019 
" ============================================================================

" Guards: {{{1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Functions: {{{1

" ultisnips#GetAllSnippets: {{{1

" Definitely a TODO

function! plugins#GetAllSnippets() abort

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

" ultisnips#ExpandPossibleShorterSnippet: {{{1

function! plugins#ExpandPossibleShorterSnippet() abort
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe 'normal a' . curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction

" Expand Snippet Or CR: {{{1
" Hopefully will expand snippets or CR. Or it'll destroy deoplete's
" ability to close the pum. *shrugs*
function! plugins#ExpandSnippetOrCarriageReturn() abort
  let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
      return snippet
    else
      return "\<CR>"
    endif
endfunction

" List Commits: {{{1
function! plugins#list_commits() abort
  " note: Don't forget that
  " echo isdirectory('~/projects/viconf')
  " outputs 0 on windows and
  " echo isdirectory(glob('~/projects/viconf'))
  " outputs 1 so we have to glob it to get anything to show up in startify
    let git = 'git -C ' . glob('~/projects/dynamic_ipython')
    let commits = systemlist(git . ' log --oneline | head -n10')

    " mapping that lines up commits from this repo
    let git = 'Git'
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction


" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
