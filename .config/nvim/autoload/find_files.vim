" ============================================================================
  " File: find_files.vim
  " Author: Faris Chugthai
  " Description: Find files autoload
  " Last Modified: August 02, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_autoload_find_files') || &compatible || v:version < 700
  finish
endif
let g:did_autoload_files = 1

let s:cpo_save = &cpoptions
set cpoptions-=C


" FZF: {{{1
" An action can be a reference to a function that processes selected lines
function! find_files#build_quickfix_list(lines) abort  " {{{1
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction


" Maps
function! find_files#fzf_maps() abort  " {{{1
  if executable('bat')
    inoremap <expr> <C-x><C-k> fzf#complete({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': '--preview=bat --ansi --multi --cycle', 'left': 30})

    inoremap <expr> <C-k> fzf#complete({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': '--preview=bat --ansi --multi --cycle', 'left': 30})
  endif
endfunction

" Explore PlugHelp: {{{

" Call :PlugHelp to use fzf to open a window with all of the plugins
" you have installed listed and upon pressing enter open the help
" docs. That's not a great explanation but honestly easier to explain
" with a picture.
" TODO: Screenshot usage.
function! find_files#plug_help_sink(line)  " {{{1
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
    call fzf#run(fzf#wrap({
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

function! s:make_sentence(lines) abort  " {{{1
  " *fzf-vim-reducer-example*
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

function! find_files#fzf_spell() abort  " {{{1
  imap <expr> <C-x><C-s> fzf#vim#complete#word({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    40})

  " And add a shorter version
  inoremap <C-s> <C-x><C-s>
endfunction

function! find_files#termux_remote() abort  " {{{1

  let g:python3_host_prog = exepath('python')
  let g:loaded_python_provider = 1
  let g:node_host_prog = '/data/data/com.termux/files/usr/bin/neovim-node-host'
  let g:ruby_host_prog = '/data/data/com.termux/files/home/.gem/bin/neovim-ruby-host'

endfunction

function! find_files#ubuntu_remote() abort  " {{{1

    let g:python3_host_prog = exepath('python3')
    let g:python_host_prog = '/usr/bin/python2'
    let g:node_host_prog = exepath('neovim-node-host')
    let g:ruby_host_prog = exepath('neovim-ruby-host')

endfunction

function! find_files#msdos_remote() abort  " {{{1

  " if !empty(exepath('python.exe'))
  "   let g:python3_host_prog = exepath('python.exe')
  " elseif !empty(exepath('python3.exe'))
  "   let g:python3_host_prog = exepath('python3.exe')
  " elseif executable('C:/tools/miniconda3/python.exe')  " fuck it
  "   let g:python3_host_prog = 'C:/tools/miniconda3/python.exe'
  " else
  "   let g:loaded_python3_provider = 1
  "   echoerr 'Could not find the remote python3 host.'
  " endif
  let g:python3_host_prog = 'C:/tools/miniconda3/envs/neovim/python.exe'

  let g:python_host_prog = 'C:/tools/miniconda3/envs/py2/python.exe'

  let g:loaded_ruby_provider = 1

  if !empty(exepath('neovim-node-host'))
    let g:node_host_prog = exepath('neovim-node-host')
  else
    let g:loaded_node_provider = 1
  endif

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

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
