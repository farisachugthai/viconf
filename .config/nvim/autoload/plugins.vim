" ============================================================================
  " File: ultisnips.vim
  " Author: Faris Chugthai
  " Description: UltiSnips autoloaded functions
  " Last Modified: August 01, 2019 
" ============================================================================

" Guards: 

let s:cpo_save = &cpoptions
set cpoptions-=C

" UltiSnips: 

function! plugins#GetAllSnippets() abort  " 

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

function! plugins#ExpandPossibleShorterSnippet() abort " 
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe 'normal a' . curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction

" Expand Snippet Or CR: 
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

" Vim Plug: 

function! plugins#InstallPlug() abort  " 

    if empty(executable('curl')) | finish | endif  " what scope does this statement end?
    try " Successfully executed on termux
      execute('!curl --progress-bar --create-dirs -Lo '
            \ . stdpath('data') . '/site/autoload/plug.vim'
            \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    catch | echo v:exception | endtry
  endfunction

" Startify: 

" List Commits: 
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

function! plugins#filter_header(lines) abort  " 
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

" Atexit: 

let &cpoptions = s:cpo_save
unlet s:cpo_save
