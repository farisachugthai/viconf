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
endfunction
function! s:make_sentence(lines) abort  " {{{1
  " *fzf-vim-reducer-example*
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction
function! find_files#fzf_maps() abort  " {{{1

  imap <expr> <C-x><C-s> fzf#vim#complete#word({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    40})

  " And add a shorter version
  inoremap <C-s> <C-x><C-s>

    imap <expr> <C-x><C-k> fzf#complete({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': '-ansi --multi --cycle', 'left': 30})

    inoremap <C-k> <C-x><C-k>
endfunction
function! find_files#plug_help_sink(line)  " {{{1
  " Call :PlugHelp to use fzf to open a window with all of the plugins
  " you have installed listed and upon pressing enter open the help
  " docs. That's not a great explanation but honestly easier to explain
  " with a picture.
  " TODO: Screenshot usage.
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction
function! find_files#buflist() abort  " {{{1
  redir => s:ls
  silent! ls
  redir END
  return split(s:ls, '\n')
endfunction
function! find_files#bufopen(e) abort  " {{{1
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction
function! find_files#FZFMru() abort  " {{{1
    call fzf#run(fzf#wrap('history', {
        \ 'source'  :   v:oldfiles,
        \ 'sink'    :   'edit',
        \ 'options' :  ['--multi', '--ansi'],
        \ 'down'    :    '40%'}))
endfunction
function! find_files#FZFGit() abort  " {{{1
    " Remove trailing new line to make it work with tmux splits
    let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
    if !v:shell_error
        lcd `=directory`
        call fzf#run(fzf#wrap({
            \ 'dir'   : directory,
            \ 'source': 'git ls-files',
            \ 'sink'  : 'e',
            \ 'window': '50vnew'}))
    else
        FZF
    endif
    " 'source': 'git ls-files',
    " 'down'  : '40%'
endfunction
function! find_files#termux_remote() abort  " {{{1

  let g:python3_host_prog = exepath('python')
  let g:loaded_python_provider = 1
  let g:node_host_prog = '/data/data/com.termux/files/usr/bin/neovim-node-host'
  let g:ruby_host_prog = '/data/data/com.termux/files/home/.gem/bin/neovim-ruby-host'

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
  endif
endfunction
function! find_files#ubuntu_remote() abort  " {{{1

  let g:python3_host_prog = exepath('python3')
  let g:python_host_prog = '/usr/bin/python2'
  let g:node_host_prog = exepath('neovim-node-host')
  let g:loaded_ruby_provider = 1

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
  endif

endfunction
function! find_files#msdos_remote() abort  " {{{1
  let g:python3_host_prog = 'C:/tools/miniconda3/envs/neovim/python.exe'
  let g:python_host_prog = 'C:/tools/miniconda3/envs/py2/python.exe'
  let g:loaded_ruby_provider = 1
  let g:node_host_prog = 'C:/tools/nvm/v13.0.1/neovim-node-host'
  let g:clipboard = {
        \   'name': 'winClip',
        \   'copy': {
        \      '+': 'win32yank.exe -i --crlf',
        \      '*': 'win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --lf',
        \      '*': 'win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 1,
        \ }
endfunction
function! find_files#RipgrepFzf(query, fullscreen)

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

  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)

endfunction
