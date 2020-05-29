" ============================================================================
  " File: plugins.vim
  " Author: Faris Chugthai
  " Description: Plugin related autoloaded functions
  " Last Modified: Dec 05, 2019
" ============================================================================

if exists('*stdpath')
  let s:stddata = stdpath("data")
else
  let s:stddata = resolve(expand('~/.local/share/nvim'))
endif
let s:stdconfig = exists('*stdpath') ? stdpath('config') : resolve(expand('~/.config/nvim'))


function! plugins#GetAllSnippets() abort
  call UltiSnips#SnippetsInCurrentScope(1)
  let l:list = []
  for [l:key, l:info] in items(g:current_ulti_dict_info)
    let l:parts = split(l:info.location, ':')
    call add(l:list, {
      \'key': l:key,
      \'path': l:parts[0],
      \'linenr': l:parts[1],
      \'description': l:info.description,
      \})
  endfor
  return l:list
endfunction

function! plugins#ExpandPossibleShorterSnippet() abort
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let l:curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal! diw
    exe 'normal a' . l:curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction

function! plugins#ExpandSnippetOrCarriageReturn() abort
  " Hopefully will expand snippets or CR. Or it'll destroy deoplete's
  " ability to close the pum. *shrugs*
  let l:snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
      return l:snippet
    else
      return "\<CR>"
    endif
  endfunction

function! plugins#InstallPlug() abort
  " Unsure of how to capture return code
  if empty(executable('curl')) | return | endif
  try " Successfully executed on termux
    execute('!curl --progress-bar --create-dirs -Lo '
            \ . s:stddata . '/site/autoload/plug.vim'
            \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  catch | echoerr v:exception | endtry
endfunction

function! plugins#list_commits() abort
  " note: Don't forget that
  " echo isdirectory('~/projects/viconf')
  " outputs 0 on windows and
  " echo isdirectory(glob('~/projects/viconf'))
  " outputs 1 so we have to glob it to get anything to show up in startify
    " let l:git = 'git -C ' . glob('~/projects/dynamic_ipython')
    let l:git = 'Git'
    let l:commits = systemlist(l:git . ' log --oneline | head -n10')

    " mapping that lines up commits from this repo
    return map(l:commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. l:git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

function! plugins#filter_header(lines) abort
    let l:longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let l:centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (l:longest_line / 2)) . v:val')
    return l:centered_lines
endfunction

function! plugins#startify_bookmarks() abort
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

function! plugins#GrepFromSelected(type) abort
  let l:saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let l:word = substitute(@@, '\n$', '', 'g')
  let l:word = escape(l:word, '| ')
  let @@ = l:saved_unnamed_register
  execute 'CocList grep ' . l:word
endfunction

function! plugins#FloatingFZF() abort
  " simply used to set window specific settings for FZF.
  " not intended for end users.
  let l:width = float2nr(&columns * 0.9)
  let l:height = float2nr(&lines * 0.6)
  let l:opts = { 'relative': 'editor',
              \ 'row': (&lines - l:height) / 2,
              \ 'col': (&columns - l:width) / 2,
              \ 'width': l:width,
              \ 'height': l:height }

  let l:win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, l:opts)
  call setwinvar(l:win, '&winhighlight', 'NormalFloat:Normal')
endfunction

function! plugins#Voom() abort
  let s:plugin_dir = s:stddata . '/plugged/'
  let s:voom_dir = s:plugin_dir . 'voom/autoload/voom/voom_vimplugin2657'
  let s:voom_file = s:voom_dir . '/voom_vim.py'
  let s:voom_rst_file = s:voom_dir . '/voom_mode_rst'
  try
    py3file s:voom_file
    py3file s:voom_rst_file
  catch
    return v:false
  endtry
endfunction

function! plugins#fugitive_head() abort
  if !exists('g:loaded_fugitive')
    " return
    exec 'source ' . s:stddata . '/plugged/vim-fugitive/plugin/fugitive.vim'
  endif

  " Not immediately useful but here's a way to check if you're in a fugitive blob buffer
  " if get(b:, 'fugitive_type', '') ==# 'blob'
  botright split | enew

  :Gread! show HEAD
  setlocal nomodified
  setlocal buftype=nofile
endfunction  " }}}
