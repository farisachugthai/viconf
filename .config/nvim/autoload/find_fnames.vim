" Find all occurrences of a pattern in a file.
fun! find_fnames#in_buffer(pattern)
  if getbufvar(winbufnr(winnr()), "&ft") ==# "qf"
    call lf_msg#warn("Cannot search the quickfix window")
    return
  endif
  try
    silent noautocmd execute "lvimgrep /" . a:pattern . "/gj " . fnameescape(expand("%"))
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call lf_msg#warn("No match")
  endtry
  bo lwindow
endf

" Find all occurrences of a pattern in all open files.
fun! find_fnames#in_all_buffers(pattern)
  " Get the list of open files
  let l:files = map(filter(range(1, bufnr('$')), 'buflisted(v:val) && !empty(bufname(v:val))'), 'fnameescape(bufname(v:val))')
  cexpr [] " Clear quickfix list
  try
    silent noautocmd execute "vimgrepadd /" . a:pattern . "/gj" join(l:files)
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call lf_msg#warn("No match")
  endtry
  bo cwindow
endf

fun! find_fnames#choose_dir(...) " ... is an optional prompt
  let l:idx = inputlist([get(a:000, 0, "Change directory to:"), "1. ".getcwd(), "2. ".expand("%:p:h"), "3. Other"])
  let l:dir = (l:idx == 1 ? getcwd() : (l:idx == 2 ? expand("%:p:h") : (l:idx == 3 ? fnamemodify(input("Directory: ", "", "file"), ':p') : "")))
  if strlen(l:dir) <= 0
    call lf_msg#notice("Cancelled.")
    return ''
  endif
  return l:dir
endf

fun! find_fnames#grep(args)
  if getcwd() != expand("%:p:h")
    let l:dir = find_fnames#choose_dir()
    if empty(l:dir) | return | endif
    execute 'lcd' l:dir
  endif
  execute 'silent grep!' a:args
  bo cwindow
  redraw!
endf

fun! s:get_ff_output(inpath, outpath, callback, channel, status)
  let l:output = filereadable(a:outpath) ? readfile(a:outpath) : []
  silent! call delete(a:outpath)
  silent! call delete(a:inpath)
  call function(a:callback)(l:output)
endf

for s:ff_bin in ['sk', 'fzf', 'fzy', 'selecta', 'pick', ''] " Sort according to your preference
  if executable(s:ff_bin)
    break
  endif
endfor

" Filter a list and return a List of selected items.
" 'input' is either a shell command that sends its output, one item per line,
" to stdout, or a List of items to be filtered.
fun! find_fnames#fuzzy(input, callback, prompt)
  if empty(s:ff_bin) " Fallback
    call find_fnames#interactively(a:input, a:callback, a:prompt)
    return
  endif

  let l:ff_cmds = {
        \ 'fzf':     "|fzf -m --height 15 --prompt '".a:prompt."> ' 2>/dev/tty",
        \ 'fzy':     "|fzy --lines=15 --prompt='".a:prompt."> ' 2>/dev/tty",
        \ 'pick':    "|pick -X",
        \ 'selecta': "|selecta 2>/dev/tty",
        \ 'sk':      "|sk -m --height 15 --prompt '".a:prompt."> '"
        \ }

  let l:ff_cmd = l:ff_cmds[s:ff_bin]

  if type(a:input) ==# 1 " v:t_string
    let l:inpath = ''
    let l:cmd = a:input . l:ff_cmd
  else " Assume List
    let l:inpath = tempname()
    call writefile(a:input, l:inpath)
    let l:cmd  = 'cat '.fnameescape(l:inpath) . l:ff_cmd
  endif

  if !has('gui_running') && executable('tput') && filereadable('/dev/tty')
    let l:output = systemlist(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; ' . l:cmd, &lines))
    redraw!
    silent! call delete(a:inpath)
    call function(a:callback)(l:output)
    return
  endif

  let l:outpath = tempname()
  let l:cmd .= " >" . fnameescape(l:outpath)

  if has('terminal')
    botright 15split
    call term_start([&shell, &shellcmdflag, l:cmd], {
          \ "term_name": a:prompt,
          \ "curwin": 1,
          \ "term_finish": "close",
          \ "exit_cb": function('s:get_ff_output', [l:inpath, l:outpath, a:callback])
          \ })
  else
   silent execute '!' . l:cmd
   redraw!
   call s:get_ff_output(l:inpath, l:outpath, a:callback, -1, v:shell_error)
  endif
endf

fun! s:filter_close(bufnr, action, winrestsize)
  " Move to previous window, wipe search buffer, and restore window layout
  wincmd p
  execute "bwipe!" a:bufnr
  exe a:winrestsize
  let &scrolloff=g:default_scrolloff

  if a:action ==# 'S'
    split
  elseif a:action ==# 'V'
    vsplit
  elseif a:action ==# 'T'
    tabnew
  endif

  redraw
  echo "\r"
endf

" Interactively filter a list of items as you type, and execute an action on
" the selected item. Sort of a poor man's CtrlP.
"
" input:    either a shell command that sends its output, one item per line,
"           to stdout, or a List of items to be filtered.
fun! find_fnames#interactively(input, callback, prompt) abort
  let l:prompt = a:prompt . '>'
  let l:filter = ''  " Text used to filter the list
  let l:undoseq = [] " Stack to tell whether to undo when pressing backspace (1 = undo, 0 = do not undo)
  let l:winrestsize = winrestcmd() " Save current window layout
  " botright 10new does not set the right height, e.g., if the quickfix window is open
  botright 1new | 9wincmd +
  setlocal buftype=nofile bufhidden=wipe nobuflisted nonumber norelativenumber noswapfile noundofile
        \  nowrap winfixheight foldmethod=manual nofoldenable modifiable noreadonly
  setlocal statusline=%#CommandMode#\ Finder\ %*\ %l\ of\ %L
  let l:cur_buf = bufnr('%') " Store current buffer number
  set scrolloff=0
  if type(a:input) ==# 1 " v:t_string
    let l:input = systemlist(a:input)
    call setline(1, l:input)
  else " Assume List
    call setline(1, a:input)
  endif
  setlocal cursorline
  redraw
  echo l:prompt . ' '
  while 1
    let &ro=&ro " Force status line update
    let l:error = 0 " Set to 1 when pattern is invalid
    try
      let ch = getchar()
    catch /^Vim:Interrupt$/  " CTRL-C
      return s:filter_close(l:cur_buf, '', l:winrestsize)
    endtry
    if ch ==# "\<bs>" " Backspace
      let l:filter = l:filter[:-2]
      let l:undo = empty(l:undoseq) ? 0 : remove(l:undoseq, -1)
      if l:undo
        silent norm u
      endif
      norm gg
    elseif ch >=# 0x20 " Printable character
      let l:filter .= nr2char(ch)
      let l:seq_old = get(undotree(), 'seq_cur', 0)
      try
        execute 'silent keeppatterns g!:\m' . escape(l:filter, '~\[:') . ':norm "_dd'
      catch /^Vim\%((\a\+)\)\=:E/
        let l:error = 1
      endtry
      let l:seq_new = get(undotree(), 'seq_cur', 0)
      call add(l:undoseq, l:seq_new != l:seq_old) " seq_new != seq_old iff buffer has changed
      norm gg
    elseif ch ==# 0x1B " Escape (cancel)
      return s:filter_close(l:cur_buf, '', l:winrestsize)
    elseif ch ==# 0x0D || ch ==# 0x13 || ch ==# 0x16 || ch ==# 0x14 " Enter/CTRL-S/CTRL-V/CTRL-T (accept)
      let l:result = [getline('.')]
      call s:filter_close(l:cur_buf, nr2char(ch + 64), l:winrestsize)
      if !empty(l:result[0])
        call function(a:callback)(l:result)
      endif
      return
    elseif ch ==# 0x0C " CTRL-L (clear)
      call setline(1, type(a:input) ==# 1 ? l:input : a:input) " 1 == v:t_string
      let l:undoseq = []
      let l:filter = ''
      redraw
    elseif ch ==# 0x0B " CTRL-K
      norm k
    elseif ch ==# 0x02 || ch ==# 0x04 || ch ==# 0x06 || ch ==# 0x0A || ch ==# 0x15 " CTRL-B, CTRL-D, CTRL-F, CTRL-J, CTRL-U
      execute "normal" nr2char(ch)
    endif
    redraw
    echo (l:error ? '[Invalid pattern] ' : '').l:prompt l:filter
  endwhile
endf


"
" Find file
"
fun! s:set_arglist(paths)
  if empty(a:paths) | return | endif
  execute "args" join(map(a:paths, 'fnameescape(v:val)'))
endf

" Filter a list of paths and populate the arglist with the selected items.
fun! find_fnames#arglist(input_cmd)
  call find_fnames#interactively(a:input_cmd, 's:set_arglist', 'Choose file')
endf

" Fuzzy filter a list of paths and populate the arglist with the selected items.
fun! find_fnames#arglist_fuzzy(input_cmd)
  call find_fnames#fuzzy(a:input_cmd, 's:set_arglist', 'Choose files')
endf

fun! find_fnames#file(...) " ... is an optional directory
  let l:dir = (a:0 > 0 ? ' '.a:1 : ' .')
  call find_fnames#arglist_fuzzy(executable('rg') ? 'rg --files'.l:dir : 'find'.l:dir.' -type f')
endf

"
" Find buffer
"
fun! s:switch_to_buffer(buffers)
  execute "buffer" split(a:buffers[0], '\s\+')[0]
endf


" When 'unlisted' is set to 1, show also unlisted buffers
fun! find_fnames#buffer(unlisted)
  let l:buffers = map(split(execute('ls'.(a:unlisted ? '!' : '')), "\n"), { i,v -> substitute(v, '"\(.*\)"\s*line\s*\d\+$', '\1', '') })
  call find_fnames#interactively(l:buffers, 's:switch_to_buffer', 'Switch buffer')
endf

"
" Find tag in current buffer
"
fun! s:jump_to_tag(tags)
  let [l:tag, l:bufname, l:line] = split(a:tags[0], '\s\+')
  execute "buffer" "+".l:line l:bufname
endf

fun! find_fnames#buffer_tag()
  call find_fnames#interactively(lf_tags#file_tags('%', &ft), 's:jump_to_tag', 'Choose tag')
endf

"
" Find in quickfix/location list
"
fun! s:jump_to_qf_entry(items)
  execute "crewind" matchstr(a:items[0], '^\s*\d\+', '')
endf

fun! s:jump_to_loclist_entry(items)
  execute "lrewind" matchstr(a:items[0], '^\s*\d\+', '')
endf

fun! find_fnames#in_qflist()
  let l:qflist = getqflist()
  if empty(l:qflist)
    call lf_msg#warn('Quickfix list is empty')
    return
  endif
  call find_fnames#interactively(split(execute('clist'), "\n"), 's:jump_to_qf_entry', 'Filter quickfix entry')
endf

fun! find_fnames#in_loclist(winnr)
  let l:loclist = getloclist(a:winnr)
  if empty(l:loclist)
    call lf_msg#warn('Location list is empty')
    return
  endif
  call find_fnames#interactively(split(execute('llist'), "\n"), 's:jump_to_loclist_entry', 'Filter loclist entry')
endf

"
" Find colorscheme
"
fun! s:set_colorscheme(colors)
  execute "colorscheme" a:colors[0]
endf

let s:colors = []

fun! find_fnames#colorscheme()
  if empty(s:colors)
    let s:colors = map(globpath(&runtimepath, "colors/*.vim", v:false, v:true) , 'fnamemodify(v:val, ":t:r")')
    let s:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", v:false, v:true) , 'fnamemodify(v:val, ":t:r")')
  endif
  call find_fnames#interactively(s:colors, 's:set_colorscheme', 'Choose colorscheme')
endf


" Wow this is already fairly long and in need of some review
function! find_fnames#smart_quote_input(input)
  if get(g:, 'find_fnames#disable_smart_quoting', 0) > 0
    return a:input
  endif
  let hasQuotes = match(a:input, '"') > -1 || match(a:input, "'") > -1
  let hasOptions = match(' ' . a:input, '\s-[-a-zA-Z]') > -1
  let hasEscapedSpacesPlusPath = match(a:input, '\\ .*\ ') > 0
  return hasQuotes || hasOptions || hasEscapedSpacesPlusPath ? a:input : '-- "' . a:input . '"'
endfunction

function! find_fnames#trim_and_escape_register_a()
  let query = getreg('a')
  let trimmedQuery = trim(query)
  let escapedQuery = escape(trimmedQuery, "'#%\\")
  call setreg('a', escapedQuery)
endfunction

function! find_fnames#fzf_ag_raw(command_suffix, ...)
  if !executable('ag')
    return s:warn('ag is not found')
  endif

  let userOptions = get(g:, 'find_fnames#ag_options', '')
  let command = 'ag --nogroup --column --color ' . trim(userOptions . ' ' . a:command_suffix)
  return call('fzf#vim#grep', extend([command, 1], a:000))
endfunction

function! find_fnames#fzf_rg_raw(command_suffix, ...)
  if !executable('rg')
    return s:warn('rg is not found')
  endif

  let userOptions = get(g:, 'find_fnames#rg_options', '')
  let command = 'rg --column --line-number --no-heading --color=always ' . trim(userOptions . ' ' . a:command_suffix)
  return call('fzf#vim#grep', extend([command, 1], a:000))
endfunction

function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction
