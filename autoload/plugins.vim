" ============================================================================
  " File: ultisnips.vim
  " Author: Faris Chugthai
  " Description: Plugin related autoloaded functions
  " Last Modified: August 01, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=C

" UltiSnips: {{{1
function! plugins#GetAllSnippets() abort  " {{{2

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

function! plugins#ExpandPossibleShorterSnippet() abort   " {{{2
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe 'normal a' . curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction

" Expand Snippet Or CR: {{{2
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

" Vim Plug: {{{1
function! plugins#InstallPlug() abort  " {{{2

  " Unsure of how to capture return code
  if empty(executable('curl')) | return | endif
  try " Successfully executed on termux
    execute('!curl --progress-bar --create-dirs -Lo '
            \ . stdpath('data') . '/site/autoload/plug.vim'
            \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  catch | echo v:exception | endtry
  echomsg 'Now using a homebrewed solution to get Vim-plug'
  endfunction

" Startify: {{{1
function! plugins#list_commits() abort  " {{{2
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

function! plugins#filter_header(lines) abort  " {{{2
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

function! plugins#startify_bookmarks() abort  " {{{2

  let s:nerdbookmarks = readfile(expand($HOME) . '/.NERDTreeBookmarks')
  if !filereadable(s:nerdbookmarks) | return | endif

  if empty(g:startify_bookmarks)
    let g:startify_bookmarks = []
  endif
  for s:idx_str in s:nerdbookmarks
    if empty(s:idx_str)
      return
    else
      " dict isn't working. try list unpacking.
      let [_, s:idx_dir] = split(s:idx_str)
      " let bookmarksdict = {g:idx_list[0]: g:idx_list[1]}
      " call extend(g:startify_bookmarks, bookmarksdict)
      call extend(g:startify_bookmarks, [s:idx_dir])
    endif
  endfor
endfunction


" Fugitive: {{{1
function! plugins#FugitiveMappings() abort   " {{{2

  noremap <silent> <Leader>gb   <Cmd>Gblame<CR>
  noremap <silent> <Leader>gc   <Cmd>Gcommit<CR>
  noremap <silent> <Leader>gd   <Cmd>Gdiffsplit!<CR>
  cabbrev Gd Gdiffsplit!<Space>
  noremap <silent> <Leader>gds  <Cmd>Gdiffsplit! --staged<CR>
  cabbrev gds2 Git diff --stat --staged
  noremap <silent> <Leader>gds2 <Cmd>Git diffsplit! --stat --staged<CR>
  noremap <silent> <Leader>ge   <Cmd>Gedit<Space>
  noremap <silent> <Leader>gf   <Cmd>Gfetch<CR>
  cabbrev gL 0Glog --pretty=oneline --graph --decorate --abbrev --all --branches
  noremap <silent> <Leader>gL   <Cmd>0Glog --pretty=oneline --graph --decorate --abbrev --all --branches<CR>
  noremap <silent> <Leader>gm   <Cmd>Gmerge<CR>
  " Make the mapping longer but clear as to whether gp would pull or push
  noremap <silent> <Leader>gpl  <Cmd>Gpull<CR>
  noremap <silent> <Leader>gps  <Cmd>Gpush<CR>
  noremap <silent> <Leader>gq   <Cmd>Gwq<CR>
  noremap <silent> <Leader>gQ   <Cmd>Gwq!<CR>
  noremap <silent> <Leader>gR   <Cmd>Gread<Space>
  noremap <silent> <Leader>gs   <Cmd>Gstatus<CR>
  noremap <silent> <Leader>gst  <Cmd>Git diffsplit! --stat<CR>
  noremap <silent> <Leader>gw   <Cmd>Gwrite<CR>
  noremap <silent> <Leader>gW   <Cmd>Gwrite!<CR>

endfunction

" Coc: {{{1

function! plugins#GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList grep ' . word
endfunction


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
