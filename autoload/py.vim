" ============================================================================
  " File: py.vim
  " Author: Faris Chugthai
  " Description: Working with the python API
  " Last Modified: November 14, 2019
" ============================================================================

function! py#taglist() abort  " {{{
  " Let's return the value from `vim.call` so that we can check it later if
  " need be
  py3 from pprint import pprint
  py3 tagfiles = (vim.call('tagfiles'))
  py3 pprint(tagfiles)
endfunction  " }}}

function! py#nvim_taglist() abort  " {{{
  return nvim_call_function('tagfiles')
endfunction  " }}}

function! py#PythonPath() abort  " {{{1
  py3 import site
  let s:path = '.,,**,'
  let s:user_site = py3eval('site.USER_SITE')
  if s:user_site ==# 0
    let s:path = py#SecondTry()
    return s:path
  endif
  let s:path .= s:user_site
  let l:python_path = py3eval('sys.path')
  for l:i in l:python_path
    let s:path .=   ',' . l:i
    " Got this idea from tpope. thanks for the genius as always
    let &l:tags .= ',' . l:i
  endfor
  let &l:path = s:path
  return s:path
endfunction  " }}}


function! py#SecondTry() abort  " {{{

  let s:temp_python = exepath('python3')
  if s:temp_python !=# ''
    let g:python3_host_prog = s:temp_python
    if has('unix')
      let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h:h')
      let s:path = s:root_dir . '/lib/python3.8/*' . s:path . ','
      let s:site_pack = s:root_dir . '/lib/python3.8/site-packages/**,'

      let s:path = s:path . s:site_pack
      let s:path =  s:root_dir . '/lib/python3.8/**/*' . ',' . s:path

    " sunovabitch conda doesn't put stuff in the same spot. TODO: check the ret value of exepath
    " for a match of "conda" instead of a unix check
    else
        let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h')

        let s:site_pack = s:root_dir . '/lib/site-packages/**2/'
        let s:path = s:path . s:site_pack

        " This option requires that the **# either is at the end of the path or
        " ends with a '/'
        " let s:path =  ',' . s:root_dir . '/lib/**1/' . s:path . ','
        " make this last. its the standard lib and we prepend it to the path so
        " it should be first in the option AKA last in the function
        let s:path = s:root_dir . '/lib' . s:path
      endif
   endif

   return s:path

endfunction

function! py#YAPF() abort  " {{{1
  if exists(':TBrowseOutput')
    " Realistically should accept func args
    :TBrowseOutput !yapf %
  else
    " save old buffer
    let s:old_buffer = nvim_get_buffer_lines()
    let s:new_buffer = pydoc_help#scratch_buffer()
    " can we do this this way?
    " :py3 vim.current.buffer[:] = yapf -i %
    " TODO: check this
    call nvim_buf_set_lines('%', 0, '$', 0, '!yapf -i s:old_buffer')
  endif
endfunction  " }}}

function! py#ALE_Python_Conf() abort  " {{{1
  let b:ale_linters = ['flake8', 'pydocstyle', 'pyls']
  let b:ale_linters_explicit = 1

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  let b:ale_fixers += [ 'reorder-python-imports' ]

  if executable('black')
    let b:ale_fixers+=['black']
  endif

  if executable('autopep8')
    let b:ale_fixers += ['autopep8']
  endif
endfunction  " }}}

function! py#Black() abort  " {{{
  " TODO: at some point or another should accept ranges as arguments
  let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))
  let s:src = s:repo_root . '/python3/pybuffers.py'
  exec 'py3file ' . s:src
  py3 from pybuffers import blackened_vim;
  py3 blackened_vim()
endfunction  " }}}

function! py#black_these(bufs) abort range  " {{{
  " Can you do this with a range of buffers?
  for l:buf in a:bufs
    <line1>,<line2>py3 from pybuffers import blackened_vim
    call py3eval('blackened_vim(l:buf)')
  endfor
endfunction   " }}}

function! py#black_version() abort  " {{{
  py3 from py import black_version; black_version()
endfunction  " }}}

function! s:timed(func) abort  " {{{
  let l:start = reltime()
  call a:func()
  let l:seconds = reltimefloat(reltime(l:start))
  return l:seconds
endfunction  " }}}

function! py#timedblack() abort  " {{{
  return s:timed(py#Black())
endfunction  " }}}

function! py#py_import(...) abort   " {{{
  " Call the func with a list of desired args
  python3 py.import_into_vim(a:000)
endfunction  " }}}

function! s:OpenIPython(...) abort  " {{{
  call s:check_modified()
  " terminal ipython
  " if len(a:000) is 0
  call termopen('ipython')
  " else
  "   Handle this i guess?
  "   needs to be a dict that can be passed to jobstart()
  "   let l:pyjob = termopen('ipython', a:000)
  " endif
endfunction  " }}}

function! py#Cnxn(bang, ...) abort  " {{{

  call s:OpenIPython(a:000)
  if has('unix')
    call chansend(&channel, "import pynvim,os\n")
    call chansend(&channel, "n = pynvim.attach('socket', path=os.environ.get('nvim_listen_address'))\n")
  else
    setlocal fileformat=dos
    call chansend(&channel, "import pynvim,os\r\n")
    call chansend(&channel, "n = pynvim.attach('socket', path=os.environ.get('nvim_listen_address'))\r\n")
  endif

endfunction  " }}}

function! py#Yours(bang, ...)  abort
  call s:OpenIPython(a:000)
  if has('unix')
    call chansend(&channel, "import pynvim_,os\n")
    call chansend(&channel, "n = pynvim_.attach('socket', path=os.environ.get('nvim_listen_address'))\n")
  else
    setlocal fileformat=dos
    call chansend(&channel, "import pynvim_,os\r\n")
    call chansend(&channel, "n = pynvim_.attach('socket', path=os.environ.get('nvim_listen_address'))\r\n")
  endif
endfunction

function! s:check_modified() abort  " {{{
  " TODO:
  if &modified is 1 && &autowrite is 1
    write
  " we're probably gonna need a handful of fucking if elses for this to do
  " what i want.
  endif

endfunction  " }}}

function! py#RefreshSnippets() abort  " {{{
  py3 UltiSnips_Manager._refresh_snippets()
endfunction  " }}}

function! py#list_snippets() abort  " {{{
  " Utilizing the python API and ultisnispzzz
  " Doesnt return anything?
  py3 UltiSnips_Manager.list_snippets()
endfunction  " }}}

function! s:error(msg) abort  " {{{
  echohl ErrorMsg
  echom a:msg
  echohl None
endfunction   " }}}

function! s:warn(msg)  abort " {{{
  echohl WarningMsg
  echom a:msg
  echohl None
endfunction  " }}}

function! py#ErrorFormat() abort  " {{{
  " The following lines set Vim's errorformat variable, to allow the
  " quickfix window to show Python tracebacks properly. It is much
  " easier to use let than set, because set requires many more
  " characters to be escaped. This is much easier to read and
  " maintain. % escapes are still needed however before any regex meta
  " characters. Hence \S (non-whitespace) becomes %\S etc.  Note that
  " * becomes %#, so .* (match any character) becomes %.%#  Commas must
  " also be escaped, with a backslash (\,). See the Vim help on
  " quickfix for details.
  "
  " Python errors are multi-lined. They often start with 'Traceback', so
  " we want to capture that (with +G) and show it in the quickfix window
  " because it explains the order of error messages.
  let s:efm  = '%+GTraceback%.%#,'

  " The error message itself starts with a line with 'File' in it. There
  " are a couple of variations, and we need to process a line beginning
  " with whitespace followed by File, the filename in "", a line number,
  " and optional further text. %E here indicates the start of a multi-line
  " error message. The %\C at the end means that a case-sensitive search is
  " required.
  let s:efm .= '%E  File "%f"\, line %l\,%m%\C,'
  let s:efm .= '%E  File "%f"\, line %l%\C,'

  " The possible continutation lines are idenitifed to Vim by %C. We deal
  " with these in order of most to least specific to ensure a proper
  " match. A pointer (^) identifies the column in which the error occurs
  " (but will not be entirely accurate due to indention of Python code).
  let s:efm .= '%C%p^,'

  " Any text, indented by more than two spaces contain useful information.
  " We want this to appear in the quickfix window, hence %+.
  let s:efm .= '%+C    %.%#,'
  let s:efm .= '%+C  %.%#,'

  " The last line (%Z) does not begin with any whitespace. We use a zero
  " width lookahead (\&) to check this. The line contains the error
  " message itself (%m)
  let s:efm .= '%Z%\S%\&%m,'

  " We can ignore any other lines (%-G)
  let s:efm .= '%-G%.%#'

  let &l:efm = s:efm
  return s:efm
endfunction  " }}}
