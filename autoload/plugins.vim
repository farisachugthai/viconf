" ============================================================================
  " File: plugins.vim
  " Author: Faris Chugthai
  " Description: Plugin related autoloaded functions
  " Last Modified: Dec 05, 2019
" ============================================================================

function! plugins#GetAllSnippets() abort  " {{{
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
endfunction  " }}}

function! plugins#ExpandPossibleShorterSnippet() abort  " {{{
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let l:curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal! diw
    exe 'normal a' . l:curr_key
    exe 'normal a '
    return 1
  endif
  return 0
endfunction  " }}}

function! plugins#ExpandSnippetOrCarriageReturn() abort  " {{{
  " Hopefully will expand snippets or CR. Or it'll destroy deoplete's
  " ability to close the pum. *shrugs*
  let l:snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
      return l:snippet
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
    let l:git = 'git -C ' . glob('~/projects/dynamic_ipython')
    let l:commits = systemlist(l:git . ' log --oneline | head -n10')

    " mapping that lines up commits from this repo
    let l:git = 'Git'
    return map(l:commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. l:git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction  " }}}

function! plugins#filter_header(lines) abort  " {{{
    let l:longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let l:centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (l:longest_line / 2)) . v:val')
    return l:centered_lines
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
endfunction  " }}}

function! plugins#FloatingFZF() abort  " {{{
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
endfunction  " }}}

function! plugins#Voom() abort  " {{{
  let s:stddata = stdpath('data')
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

function! plugins#TagbarTypes() abort   " {{{
let g:tagbar_type_ansible = {
	\ 'ctagstype' : 'ansible',
	\ 'kinds' : [
	\ 't:tasks'],
	\ 'sort' : 0 }

let g:tagbar_type_css = {
    \ 'ctagstype' : 'Css',
    \ 'kinds'     : [
    \ 'c:classes',
    \ 's:selectors',
    \ 'i:identities']}

let g:tagbar_type_make = {'kinds':[
            \ 'm:macros',
            \ 't:targets'
            \ ]}

let g:tagbar_type_javascript = {
      \ 'ctagstype': 'javascript',
      \ 'kinds': [
      \ 'A:arrays',
      \ 'P:properties',
      \ 'T:tags',
      \ 'O:objects',
      \ 'G:generator functions',
      \ 'F:functions',
      \ 'C:constructors/classes',
      \ 'M:methods',
      \ 'V:variables',
      \ 'I:imports',
      \ 'E:exports',
      \ 'S:styled components',
      \ ]}

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
\ }

let g:tagbar_type_ps1 = {
    \ 'ctagstype' : 'powershell',
    \ 'kinds'     : [
        \ 'f:function',
        \ 'i:filter',
        \ 'a:alias'
    \ ]
\ }

let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : expand('$HOME/src/rst2ctags/rst2ctags.py'),
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
  \ 'c:classes',
  \ 'n:modules',
  \ 'f:functions',
  \ 'v:variables',
  \ 'v:varlambdas',
  \ 'm:members',
  \ 'i:interfaces',
  \ 'e:enums',
  \ ]
  \ }

let g:tagbar_type_snippets = {
      \ 'ctagstype' : 'snippets',
      \ 'kinds' : [
      \ 's:snippets',
      \ ]
      \ }

endfunction  " }}}


function! plugins#fugitive_head() abort
  " Fill a buffer with `git show HEAD`
  " Check that fugitive loaded.
  if !exists('g:loaded_fugitive')
    return
  endif

  " Not immediately useful but here's a way to check if you're in a fugitive blob buffer
  " if get(b:, 'fugitive_type', '') ==# 'blob'
  botright split | enew

  Gread! show HEAD
  setlocal nomodified
  setlocal buftype=nofile
endfunction
