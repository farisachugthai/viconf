" ============================================================================
  " File: find_files.vim
  " Author: Faris Chugthai
  " Description: Find files autoload
  " Last Modified: August 02, 2019
" ============================================================================

function! find_files#build_quickfix_list(lines) abort  " {{{1
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction  " }}}

function! s:make_sentence(lines) abort  " {{{1
  " *fzf-vim-reducer-example*
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction  " }}}

function! find_files#plug_help_sink(line)  abort " {{{1
  " Call :PlugHelp to use fzf to open a window with all of the plugins
  " you have installed listed and upon pressing enter open the help
  " docs. That's not a great explanation but honestly easier to explain
  " with a picture.
  let l:dir = g:plugs[a:line].dir
  for l:pat in ['doc/*.txt', 'README.md']
    let l:match = get(split(globpath(l:dir, l:pat), "\n"), 0, '')
    if len(l:match)
      execute 'tabedit' l:match
      return
    endif
  endfor
  tabnew
  execute 'Explore' l:dir
endfunction  " }}}

function! find_files#buflist() abort  " {{{1
  redir => s:ls
  silent! ls
  redir END
  return split(s:ls, '\n')
endfunction  " }}}

function! find_files#bufopen(e) abort  " {{{1
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  return v:true
endfunction  " }}}

function! find_files#FZFMru() abort  " {{{1
    call fzf#run(fzf#wrap('history', {
        \ 'source'  :   v:oldfiles,
        \ 'sink'    :   'edit',
        \ 'options' :  ['--multi', '--ansi'],
        \ 'down'    :    '40%'}))
endfunction  " }}}

function! find_files#FZFGit() abort  " {{{1
  " Remove trailing new line to make it work with tmux splits
  let l:directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
  if !v:shell_error
    lcd `=directory`
    call fzf#run(fzf#wrap('gitfiles', {
        \ 'dir'   : l:directory,
        \ 'source': 'git ls-files',
        \ 'sink'  : 'e',
        \ 'window': '50vnew'}))
  else
      FZF
  endif
  " 'source': 'git ls-files',
  " 'down'  : '40%'
endfunction  " }}}

function! find_files#termux_remote() abort  " {{{1
  let g:python3_host_prog = exepath('python')
  let g:loaded_python_provider = 1
  let g:node_host_prog = '/data/data/com.termux/files/usr/bin/neovim-node-host'
  let g:ruby_host_prog = '/data/data/com.termux/files/home/.gem/bin/neovim-ruby-host'

  if exists('$TMUX')
    let g:clipboard = {
          \   'name': 'tmux-clipboard',
          \   'copy': {
          \      '+': 'tmux load-buffer -',
          \      '*': 'tmux load-buffer -',
          \    },
          \   'paste': {
          \      '+': 'tmux save-buffer -',
          \      '*': 'tmux save-buffer -',
          \   },
          \   'cache_enabled': 1,
          \ }
  else
    let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \      '*': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \    },
          \   'paste': {
          \      '+': {-> get(g:, 'foo', [])},
          \      '*': {-> get(g:, 'foo', [])},
          \   },
          \ }

  endif
endfunction   " }}}

function! find_files#ubuntu_remote() abort  " {{{1
  let g:python3_host_prog = '/usr/bin/python3'
  let g:python_host_prog = '/usr/bin/python2'
  let g:node_host_prog = expand('~/.local/share/yarn/global/node_modules/neovim/bin/cli.js')
  let g:ruby_host_prog = expand('~/.gem/bin/neovim-ruby-host')

  if exists('$TMUX')
    let g:clipboard = {
          \   'name': 'myclipboard',
          \   'copy': {
          \      '+': 'tmux load-buffer -',
          \      '*': 'tmux load-buffer -',
          \    },
          \   'paste': {
          \      '+': 'tmux save-buffer -',
          \      '*': 'tmux save-buffer -',
          \   },
          \   'cache_enabled': 1,
          \ }
  else  " TODO: Could just use termux-clipboard-get and set
    let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \      '*': {lines, regtype -> extend(g:, {'foo': [lines, regtype]}) },
          \    },
          \   'paste': {
          \      '+': {-> get(g:, 'foo', [])},
          \      '*': {-> get(g:, 'foo', [])},
          \   },
          \ }

  endif
endfunction  " }}}

function! find_files#msdos_remote() abort  " {{{1
  " Don't set python paths dynamically it's such a headache
  " let g:python3_host_prog = 'C:\Python38\python.exe'
  let g:python3_host_prog = 'C:\Users\fac\scoop\apps\miniconda3\current\python.exe'
  let g:python_host_prog = 'C:\Python27\python.exe'
  let g:loaded_ruby_provider = 1

  " wow this one actually fucking worked
  let g:node_host_prog = 'C:\Users\fac\scoop\apps\winpython\current\n\node_modules\neovim\bin\cli.js'

  let g:clipboard = {
        \   'name': 'winClip',
        \   'copy': {
        \      '+': 'win32yank.exe -i --crlf',
        \      '*': 'win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --crlf',
        \      '*': 'win32yank.exe -o --crlf',
        \   },
        \   'cache_enabled': 1,
        \ }
endfunction   " }}}

function! find_files#RipgrepFzf(query, fullscreen)  abort   " {{{

  " In the default implementation of `Rg`, ripgrep process starts only once with
  " the initial query (e.g. `:Rg foo`) and fzf filters the output of the process.

  " This is okay in most cases because fzf is quite performant even with millions
  " of lines, but we can make fzf completely delegate its search responsibliity to
  " ripgrep process by making it restart ripgrep whenever the query string is
  " updated. In this scenario, fzf becomes a simple selector interface rather than
  " a "fuzzy finder".

  " - `--bind 'change:reload:rg ... {q}'` will make fzf restart ripgrep process
  "   whenever the query string, denoted by `{q}`, is changed.
  " - With `--phony` option, fzf will no longer perform search. The query string
  "   you type on fzf prompt is only used for restarting ripgrep process.
  " - Also note that we enabled previewer with `fzf#vim#with_preview`.

  let l:command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let l:initial_command = printf(l:command_fmt, shellescape(a:query))
  let l:reload_command = printf(l:command_fmt, '{q}')
  let l:spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.l:reload_command]}
  call fzf#vim#grep(l:initial_command, 1, fzf#vim#with_preview(l:spec), a:fullscreen)
endfunction  " }}}

function! find_files#RgSearch(txt) abort  " {{{
  let l:rgopts = ' '
  if &ignorecase == 1
    let l:rgopts = l:rgopts . '-i '
  endif
  if &smartcase == 1
    let l:rgopts = l:rgopts . '-S '
  endif
  silent! exe 'grep! ' . l:rgopts . a:txt
  if len(getqflist())
    exe g:rg_window_location 'copen'
    redraw!
  else
    cclose
    redraw!
    echomsg 'No match found for ' . a:txt
  endif
endfunction  " }}}

" Vim: set fdm=marker:
