" ============================================================================
  " File: pydoc_help
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with help buffers
  " Last Modified: Oct 20, 2019
" ============================================================================

" First 2 are stolen from $VIMRUNTIME/autoload/man.vim
" Handler for s:system() function
function! s:system_handler(jobid, data, event) dict abort
  if a:event is# 'stdout' || a:event is# 'stderr'
    let self[a:event] .= join(a:data, "\n")
  else
    let self.exit_code = a:data
  endif
endfunction

" Run a system command and timeout after 30 seconds.
function! s:system(cmd, ...) abort
  let opts = {
        \ 'stdout': '',
        \ 'stderr': '',
        \ 'exit_code': 0,
        \ 'on_stdout': function('s:system_handler'),
        \ 'on_stderr': function('s:system_handler'),
        \ 'on_exit': function('s:system_handler'),
        \ }
  let jobid = jobstart(a:cmd, opts)

  if jobid < 1
    throw printf('command error %d: %s', jobid, join(a:cmd))
  endif

  let res = jobwait([jobid], 30000)
  if res[0] == -1
    try
      call jobstop(jobid)
      throw printf('command timed out: %s', join(a:cmd))
    catch /^Vim(call):E900:/
    endtry
  elseif res[0] == -2
    throw printf('command interrupted: %s', join(a:cmd))
  endif
  if opts.exit_code != 0
    throw printf("command error (%d) %s: %s", jobid, join(a:cmd), substitute(opts.stderr, '\_s\+$', '', &gdefault ? '' : 'g'))
  endif

  return opts.stdout
endfunction

function! s:ExampleofOpeningBufferAndAcceptingArgs(mods) abort
  " also from man.vim
  try
    set eventignore+=BufReadCmd

    if a:mods !~# 'tab'
      " wait holy fuck does this not require a period ('.') to concatenate???
      execute 'silent keepalt edit' fnameescape(bufname)
    else
      execute 'silent keepalt' a:mods 'split' fnameescape(bufname)
    endif
  finally
    set eventignore-=BufReadCmd
  endtry
endfunction

function! pydoc_help#open_files(files) abort
  let l:bufnrs = []
    for l:file in a:files
      call bufload(l:file)
      call add(l:bufnrs, bufnr(l:file))
    endfor
  return l:bufnrs
endfunction

function! pydoc_help#scratch_buffer() abort
  if !has('nvim') | throw "Doesn't work on vim" | endif

  "  First param is buflisted?
  " Second is scratch buffer?1
  return nvim_create_buf(v:false, v:true)
endfunction

function! s:scratch_listed_buffer(bang) range abort
  let l:bufnum = nvim_create_buf(v:true, v:true)
  " Actually fuck trying to figure out how to switch to that buffer
  :Buffers
  return l:bufnum
endfunction

function! s:temp_buffer() abort
  " Use for setting a buffer that's been filled with text to something similar
  " to an 'rst' help page.

  if exists(':StripWhitespace')
    exec ':StripWhitespace'
  endif

  " hi! link Whitespace NONE
  setlocal relativenumber
  setlocal filetype=rst
  setlocal syntax=rst
  syntax sync fromstart
  syntax enable
  " Because i have it on in my rst filetype.
  setlocal nospell
  setlocal buftype=nofile bufhidden=delete noswapfile nowrap
  " don't do thi until we stop debugging
  " setlocal nomodified
endfunction

function! pydoc_help#PydocCbword(bang, mods) abort
  " Holy shit it works!!!
  let s:temp_cword = expand('<cWORD>')
  exec a:mods . 'enew' . a:bang
  exec ':r! pydoc ' . s:temp_cword
  call s:temp_buffer()
endfunction

function! s:handle_user_config() abort
  " Look at me handling user configured arguments!
  if exists('g:pydoc_window')
    if type('g:pydoc_window') == v:t_string
      exec g:pydoc_window
    else
      throw '/autoload/pydoc_help:'
            \ . ' g:pydoc_window needs to be one of "split" "vsplit" or "tabe"'
    endif
  else
    split
  endif
endfunction

function! pydoc_help#Pydoc(bang, module) abort
  "
  " Step 1: Create the buffer. Let's do them a favor and save the buffer before we leave.
  if &autowrite && &l:modified
    " Oh right nothing comes easy in vim
    if &l:readonly
      if a:bang
        :write!
      else
        throw 'pydoc_help#Pydoc: still only at step2'
      endif
    :write
  endif
  endif

  " I think either of these 2 ways works.
  " let s:buf = nvim_create_buf(v:false, v:true)
  exe 'keepjumps keepalt enew' . a:bang

  exe 'split ' . s:buf
  exec 'r!python -m pydoc ' . a:module

  call s:temp_buffer()
endfunction

function! pydoc_help#OpenTempBuffer(...) abort
  " it took a BUNCH of attempts but i think i finally figured out how to do this right
  if !a:0
    return
  endif
  let s:bang = a:1
  let s:mods = a:2
  if len(a:000) > 2
    let s:bufname = a:3
  else
    let s:bufname = pydoc_help#scratch_buffer()
  endif
  exec s:mods . 'f' . s:bang . s:bufname
  call s:temp_buffer()
  return s:bufname
endfunction

function! pydoc_help#async_cursor(bang) abort
  let s:temp_cword = expand('<cWORD>')
  if a:bang
    keepjumps keepalt enew!
  else
    keepjumps keepalt new
  endif

  call jobstart('pydoc ' . s:temp_cword, {'on_stdout':{j,d,e->append(line('.'),d)}})
  call nvim_command('sleep 2')
  call s:temp_buffer()
endfunction

function! pydoc_help#async_cfile_mods(mods, bang) abort
  if !has('nvim') | throw "Doesn't work on vim" | endif
  let s:temp_cfile = expand('<cfile>')
  exec a:mods . 'enew' . a:bang
  call jobstart('pydoc ' . s:temp_cfile, {'on_stdout':{j,d,e->append(line('.'),d)}})
  call s:temp_buffer()
endfunction

function! pydoc_help#async_cfile() abort
  " Dude this is it.
  " If we can floating window this, I may have my first vim plugin down.

  if !has('nvim') | throw "Doesn't work on vim" | endif

  " save the word were looking for first
  let s:temp_cfile = expand('<cfile>')

  " Empty buffer
  let l:buf = nvim_create_buf(v:false, v:true)

  let l:opts = {'relative': 'cursor', 'width': 100, 'height': 24, 'col': 0,
      \ 'row': 0, 'anchor': 'NW', 'style': 'minimal'}

  " note we call v:true to enter the window
  let l:win = nvim_open_win(l:buf, v:true, l:opts)
  " optional: change highlight, otherwise Pmenu is used
  call nvim_win_set_option(l:win, 'winhl', 'Normal:MyHighlight')

  " To close the float, |nvim_win_close()| can be used.
  " 0 for the current window, v:false is for don't force
  nnoremap <buffer> q <Cmd>call nvim_win_close(0, v:true)<CR>
  call jobstart('pydoc ' . s:temp_cfile, {'on_stdout':{j,d,e->append(line('.'),d)}})
  call s:temp_buffer()
endfunction

function! pydoc_help#broken_scratch_buffer() abort
  " Not actually broken i just need to debug the commented out lines
  " basically how do i put the info i want into a list that can be properly
  " parsed by this API

  " From he api-floatwin. Only new versions of Nvim (maybe 0.4+ only?)
  let l:buf = nvim_create_buf(v:false, v:true)

  " and the help for that function
  " nvim_create_buf({listed}, {scratch})                       *nvim_create_buf()*
  "                 Creates a new, empty, unnamed buffer.

  "                 Parameters: ~
  "                     {listed}   Sets 'buflisted'
  "                     {scratch}  Creates a "throwaway" |scratch-buffer| for
  "                                temporary work (always 'nomodified')
  " original: should fill with pydoc output
  " TODO: this is the "broken" line
  " call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
  let l:opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
      \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}

  let l:win = nvim_open_win(l:buf, 0, l:opts)
  " optional: change highlight, otherwise Pmenu is used
  call nvim_win_set_option(l:win, 'winhl', 'Normal:MyHighlight')

  " To close the float, |nvim_win_close()| can be used.
  " 0 for the current window, v:false is for don't force
  nnoremap <buffer> q <Cmd>call nvim_win_close(0, v:false)<CR>
endfunction

function! pydoc_help#the_curse_of_nvims_floating_wins() abort
  " No seriously they're difficult to work with

  let s:opts = {
        \ 'relative': 'cursor',
        \ 'width': 10,
        \ 'height': 2,
        \ 'col': 0,
        \ 'row': 1,
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
        \ 'focusable': v:true
        \ }

  let s:win_handle = nvim_open_win(bufnr('%'), 0, s:opts)
  let l:floating_winnr  = nvim_win_get_number(s:win_handle)
  " So now we finally have a winnr which we can work with in a more reasonable
  " fashion. Sweet!!
  call nvim_win_set_option(s:win_handle, 'winhl', 'Special')
  return l:floating_winnr
endfunction

function! s:ReplaceModuleAlias() abort
  " For example:
  "   import foo as bar
  " if `bar` is in the ExpandModulePath's return value, it should be
  " replaced with `foo`.
  let l:cur_col = col('.')
  let l:cur_line = line('.')
  let l:module_path = s:ExpandModulePath()
  let l:module_names = split(l:module_path, '\.')
  let l:module_orig_name = l:module_names[0]
  if search('import \+[0-9a-zA-Z_.]\+ \+as \+' . l:module_orig_name)
    let l:line = getline('.')
    let l:name = matchlist(l:line, 'import \+\([a-zA-Z0-9_.]\+\) \+as')[1]
    if l:name !=# ''
        let l:module_orig_name = l:name
    endif
  endif
  if l:module_names[0] != l:module_orig_name
      let l:module_names[0] = l:module_orig_name
  endif
  call cursor(l:cur_line, l:cur_col)
  return join(l:module_names, '.')
endfunction

function! s:ExpandModulePath() abort
    " Extract the 'word' at the cursor, expanding leftwards across identifiers
    " and the . operator, and rightwards across the identifier only.
    "
    " For example:
    "   import xml.dom.minidom
    "           ^   !
    "
    " With the cursor at ^ this returns 'xml'; at ! it returns 'xml.dom'.
    let l:line = getline('.')
    let l:pre = l:line[:col('.') - 1]
    let l:suf = l:line[col('.'):]
    return matchstr(l:pre, '[A-Za-z0-9_.]*$') . matchstr(l:suf, '^[A-Za-z0-9_]*')
endfunction

function! pydoc_help#show(...) abort
  " AHHHHH THIS WORKS!!!!
  let l:word = s:ReplaceModuleAlias()
  let l:buf = nvim_create_buf(v:false, v:true)
  if a:0 == 0
    " switch to our new buffer
    exec 'b' . l:buf
  elseif a:0 == 1
      tabnew!
      exec 'b' . l:buf
  else
    throw 'autoload:pydoc_help#show: wrong # of args'
  endif

  call jobstart('pydoc ' . l:word, {'on_stdout' : {j, d, e->append(line('.'),d)} } )
  call s:temp_buffer()
  " Make it vertical
  wincmd L
  normal! gg
  keepjumps keepalt wincmd p
endfunction

function! s:is_preview_window_open() abort
  " Source: vim-plug
  silent! wincmd P
  if &previewwindow
    wincmd p
    return 1
  endif
endfunction

function! s:opened_preview_window() abort
  " Sorry junegunn but its tpope.
  for l:i in range(1, winnr('$'))
    if getwinvar(l:i, '&previewwindow') == 1
      return l:i
    endif
  endfor
  return -1
endfunction

function! pydoc_help#PreviewShow() abort
  " erghhhhh. still not there but it's close.
  " dude preview windows are weird and there's an odd amount of basic
  " functions fucking NEEDING to have specific types. like i didn't realize
  " that the very basic `:buffer` family of commands all take names similar
  " to the output of buf_name() and doing a lot of this with bufnr was a
  " mistake.
  " let orig_buffer = bufnr('%')
  "
  let l:word = s:ExpandModulePath()

  " dude look at this phenomenally helpful shit from the docs on
  " preview-window
  if l:word =~? '\a'			" if the word contains a letter

  " Here's a smarter way of doing this courtesy of t pope
  let l:name = tempname()

  " Fuck what do if we don't have a file name?
  try
    if &autowrite && &modified == 1
      write
    endif
  catch
  endtry
  " Note: DONT USE pedit! it'll discard current changes to a buffer!!
  exe 'pedit ' . fnameescape(l:name)
  " Now go there
  wincmd P
  if &previewwindow == 1		" if we really get there...
    match none			" delete existing highlight
    call jobstart('pydoc ' . l:word, {'on_stdout' : {j, d, e->append(line('.'),d)} } )
    call s:temp_buffer()
  nnoremap <buffer> <silent> q :q<CR>
    " wincmd p			" back to old window
  else
    echoerr "We're not in the preview window?"
    return
  endif

  else
    return
  endif
endfunction

function! pydoc_help#WholeLine(...) abort
  " Also works. Dude I'm on a roll

  let l:cur_line = getline(line('.'))
  let l:buf = nvim_create_buf(v:false, v:true)
  if a:0 == 0
    " switch to our new buffer
    exec 'b' . l:buf
  elseif a:0 == 1
      tabnew!
      exec 'b' . l:buf
  else
    throw 'autoload:pydoc_help#show: wrong # of args'

  endif
  " I dont wanna futz with it if it works but remember that funcs can handle
  " a range arg and that the python3 command automatically understands it
  py3 import pydoc
  py3 curline = vim.command('let cur_line = getline(line("."))')
  py3 vim.current.buffer.append(pydoc.help(cur_line))
endfunction

