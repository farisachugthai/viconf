" ============================================================================
  " File: find_files.vim
  " Author: Faris Chugthai
  " Description: Find files autoload
  " Last Modified: August 02, 2019
" ============================================================================

function! find_files#build_quickfix_list(lines) abort
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! s:make_sentence(lines) abort
  " *fzf-vim-reducer-example*
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

function! find_files#plug_help_sink(line)  abort
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
endfunction

function! find_files#buflist() abort
  redir => s:ls
  silent! ls
  redir END
  return split(s:ls, '\n')
endfunction

function! find_files#bufopen(e) abort
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  return v:true
endfunction

function! find_files#FZFMru(bang) abort
    call fzf#run(fzf#wrap('history', {
        \ 'source'  :    v:oldfiles,
        \ 'sink'    :   'edit',
        \ 'options' :   ['--multi', '--ansi'],
        \ 'down'    :   '40%'},
        \ a:bang))

endfunction

function! find_files#FZFGit(bang) abort
  " Remove trailing new line to make it work with tmux splits
  let l:directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
  if !v:shell_error
    lcd `=directory`
    call fzf#run(fzf#wrap('gitfiles', {
        \ 'dir'   : l:directory,
        \ 'source': 'git ls-files',
        \ 'sink'  : 'e',
        \ 'window': '50vnew'},
        \ a:bang))
  else
      FZF.a:bang
  endif
endfunction

function! find_files#RipgrepFzf(query, fullscreen)  abort

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

  let l:command_fmt = 'rg --column --line-number --no-heading'
                  \. '--max-count=5 --color=always --smart-case'
                  \. '--max-columns-preview --hidden --glob-case-insensitive --glob=!.git %s || true'

  let l:initial_command = printf(l:command_fmt, shellescape(a:query))
  let l:reload_command = printf(l:command_fmt, '{q}')
  let l:spec = {'options': ['--phony', '--ansi', '--query', a:query, '--bind', 'change:reload:'.l:reload_command]}
  call fzf#vim#grep(l:initial_command, 1, fzf#vim#with_preview(l:spec), a:fullscreen)
endfunction

function! find_files#RgSearch(txt) abort
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
endfunction

