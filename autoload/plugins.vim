" ============================================================================
  " File: plugins.vim
  " Author: Faris Chugthai
  " Description: Plugin related autoloaded functions
  " Last Modified: Dec 05, 2019
" ============================================================================

function! plugins#GetAllSnippets() abort  " {{{
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
endfunction  " }}}

function! plugins#ExpandPossibleShorterSnippet() abort  " {{{
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe 'normal a' . curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction  " }}}

function! plugins#ExpandSnippetOrCarriageReturn() abort  " {{{
  " Hopefully will expand snippets or CR. Or it'll destroy deoplete's
  " ability to close the pum. *shrugs*
  let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
      return snippet
    else
      return "\<CR>"
    endif
  endfunction  " }}}

function! plugins#InstallPlug() abort  " {{{
  " Unsure of how to capture return code
  if empty(executable('curl')) | return | endif
  try " Successfully executed on termux
    execute('!curl --progress-bar --create-dirs -Lo '
            \ . stdpath('data') . '/site/autoload/plug.vim'
            \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  catch | echoerr v:exception | endtry
endfunction  " }}}

function! plugins#list_commits() abort  " {{{
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
endfunction  " }}}

function! plugins#filter_header(lines) abort  " {{{
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction  " }}}

function! plugins#startify_bookmarks() abort  " {{{
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
endfunction  " }}}

function! plugins#GrepFromSelected(type) abort  " {{{
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
endfunction  " }}}

function! plugins#FloatingFZF() abort  " {{{
  let width = float2nr(&columns * 0.9)
  let height = float2nr(&lines * 0.6)
  let opts = { 'relative': 'editor',
              \ 'row': (&lines - height) / 2,
              \ 'col': (&columns - width) / 2,
              \ 'width': width,
              \ 'height': height }

  let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
endfunction  " }}}

function! plugins#Voom() abort  " {{{
  let s:stddata = stdpath('data')
  let s:plugin_dir = s:stddata . '/plugged/'
  let s:voom_dir = s:plugin_dir . 'voom/autoload/voom/voom_vimplugin2657'
  let s:voom_file = s:voom_dir . '/voom_vim.py'
  let s:voom_rst_file = s:voom_dir . '/voom_mode_rst'
  try
    let ret = py3file s:voom_file
    py3file s:voom_rst_file
    return ret
  catch
    return v:false
  endtry
endfunction  " }}}

function! plugins#AleMappings() abort  " {{{

  " Actual Mappings: {{{
  " Follow the lead of vim-unimpaired with a for ale
  nnoremap ]a <Cmd>ALENextWrap<CR>zz
  nnoremap [a <Cmd>ALEPreviousWrap<CR>zz

  " `:ALEInfoToFile` will write the ALE runtime information to a given filename.
  " The filename works just like |:w|.

  " <Meta-a> now gives detailed messages about what the linters have sent to ALE
  nnoremap <A-a> <Cmd>ALEDetail<CR><bar>:normal! zz<CR>

  " I'm gonna make all my ALE mappings start with Alt so it's easier to distinguish
  nnoremap <A-r> <Cmd>ALEFindReference<CR>

  " Dude why can't i get plug mappings right???
  nnoremap <A-i> <Cmd>ALEInfo<CR>
  " }}}
  
  " Options: {{{

  let g:ale_virtualtext_cursor = 1
  let g:ale_virtualtext_prefix =  'ALE: '
  let g:ale_virtualtext_delay = 200
  let g:ale_close_preview_on_insert = 1
  let g:ale_echo_cursor = 1
  let g:ale_completion_enabled = 1
  let g:ale_set_signs = 1
  " let g:ale_sign_column_always = 1
  let g:ale_change_sign_column_color = 0
  let g:ale_sign_warning = 'W'
  let g:ale_sign_info = 'I'
  let g:ale_sign_error = 'E'
  let g:ale_sign_highlight_linenrs = 1
  let g:ale_sign_style_warning = 'E'
  let g:ale_pattern_options_enabled = 1
  let g:ale_pattern_options = {'\.min.js$': {'ale_enabled': 0}}
  " For buffer specific options, see ../ftplugin/*.vim
  let g:ale_fixers = { '*': [ 'remove_trailing_lines', 'trim_whitespace' ] }
  let g:ale_fix_on_save = 1

  " When ALE is linting bash files recognize it as sh
  let g:ale_linter_aliases = {
      \ 'ps1': ['powershell', 'cs'],
      \ 'htmljinja': ['html', 'handlebars'],
      \ 'jinja': ['html', 'handlebars'],
      \ 'htmldjango': 'html',
      \ 'bash': 'sh',
      \ 'xonsh': 'python',
      \ }

  " When ale is linting C# only use OmniSharp
  let g:ale_linters = {
      \ 'cs': ['OmniSharp']
      \ }
  let g:ale_list_vertical = 1
  " }}}

  " Python specific globals: {{{

  " Goddamn this is so long I might wanna autoload this no?
  " Eh. Nah.
  let g:ale_python_pyls_config = {
        \   'pyls': {
        \     'plugins': {
        \       'flake8': {
        \         'enabled': v:true
        \       },
        \ 'jedi_completion': {
        \   'enabled': v:true
        \ },
        \ 'jedi_hover': {
        \   'enabled': v:true
        \ },
        \ 'jedi_references': {
        \   'enabled': v:true
        \ },
        \ 'jedi_signature_help': {
        \   'enabled': v:true
        \ },
        \ 'jedi_symbols': {
        \   'all_scopes': v:true,
        \   'enabled': v:true
        \ },
        \ 'mccabe': {
        \   'enabled': v:true,
        \   'threshold': 15
        \ },
        \ 'preload': {
        \   'enabled': v:true
        \ },
        \ 'pycodestyle': {
        \   'enabled': v:false
        \ },
        \ 'pydocstyle': {
        \   'enabled': v:true,
        \   'match': '(?!test_).*\\.py',
        \   'matchDir': '[^\\.].*'
        \ },
        \ 'pyflakes': {
        \   'enabled': v:true
        \ },
        \ 'rope_completion': {
        \   'enabled': v:true
        \ },
        \ 'yapf': {
        \   'enabled': v:true
        \       }
        \     }
        \   }
        \ }

  let g:ale_python_auto_pipenv = 1
  let g:ale_python_black_auto_pipenv = 1
  let g:ale_python_pydocstyle_auto_pipenv = 1
  let g:ale_python_flake8_auto_pipenv = 1
  let g:ale_python_pyls_auto_pipenv = 1

  " Checkout ale/autoload/ale/python.vim this is the base definition
  let g:ale_virtualenv_dir_names = [
      \   '.env',
      \   '.venv',
      \   'env',
      \   've-py3',
      \   've',
      \   'virtualenv',
      \   'venv',
      \ ]

  if isdirectory(expand('~/.virtualenvs'))
    let g:ale_virtualenv_dir_names += [expand('~/.virtualenvs')]
  endif

  if isdirectory(expand('~/scoop/apps/winpython/current'))
    let g:ale_virtualenv_dir_names +=  [expand('~/scoop/apps/winpython/current')]
  endif

  if isdirectory(expand('~/.local/share/virtualenvs'))
    let g:ale_virtualenv_dir_names += [ expand('~/.local/share/virtualenvs') ]
  endif

  let g:ale_cache_executable_check_failures = v:true
  let g:ale_linters_ignore = {'python': ['pylint']}

  " Example from the help page
  " Use just ESLint for linting and fixing files which end in '.js'
  let g:ale_pattern_options = {
              \   '\.js$': {
              \       'ale_linters': ['eslint'],
              \       'ale_fixers': ['eslint'],
              \ },
              \ }

  let g:ale_lsp_show_message_severity = 'information'
  " }}}

endfunction  " }}}

