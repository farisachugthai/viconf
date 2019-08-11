
" An action can be a reference to a function that processes selected lines
function! find_files#build_quickfix_list(lines) abort
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! find_files#fzf_statusline() abort
    " Override statusline as you like
    highlight fzf1 ctermfg=81 ctermbg=234
    highlight fzf2 ctermfg=81 ctermbg=234
    highlight fzf3 ctermfg=81 ctermbg=234
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

function! find_files#fzf_maps() abort
    inoremap <expr> <C-x><C-k> fzf#complete({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': '--preview=bat --ansi --multi --cycle', 'left': 30})

    inoremap <expr> <C-k> fzf#complete({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': '--preview=bat --ansi --multi --cycle', 'left': 30})
endfunction

" Explore PlugHelp: {{{

" Call :PlugHelp to use fzf to open a window with all of the plugins
" you have installed listed and upon pressing enter open the help
" docs. That's not a great explanation but honestly easier to explain
" with a picture.
" TODO: Screenshot usage.
function! find_files#plug_help_sink(line)
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

" FZFBuffers: {{{1

function! find_files#buflist() abort
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function!  find_files#bufopen(e) abort
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction


function! find_files#FZFMru() abort
    call fzf#run({
        \ 'source':   v:oldfiles,
        \ 'sink' :   'edit',
        \ 'options': '-m --no-sort',
        \ 'down':    '40%'
        \ })
endfunction

function! find_files#FZFGit() abort
    " Remove trailing new line to make it work with tmux splits
    let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
    if !v:shell_error
        lcd `=directory`
        call fzf#run({
            \ 'sink': 'edit',
            \ 'dir': directory,
            \ 'source': 'git ls-files',
            \ 'down': '40%'
            \ })
    else
        FZF
    endif
endfunction
