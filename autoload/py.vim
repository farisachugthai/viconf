" ============================================================================
  " File: py.vim
  " Author: Faris Chugthai
  " Description: Working with the python API
  " Last Modified: November 14, 2019
" ============================================================================

function! py#taglist() abort  " {{{
  " Let's return the value from `vim.call` so that we can check it later if
  " need be
  py3 from pprint import pprint; tagfiles = (vim.call('tagfiles'))
  py3 pprint(tagfiles)
endfunction  " }}}

function! py#nvim_taglist() abort  " {{{
  return nvim_call_function('tagfiles')
endfunction  " }}}

function! py#PythonPath() abort  " {{{1
  py3 import site
  let s:path = '.,,**,'
  let s:user_site = py3eval('site.USER_SITE')
  let s:path .= s:user_site
  for i in py3eval('sys.path')
    let s:path .= i . ','
  endfor
  let &l:path = s:path
  return s:path
endfunction  " }}}

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

function! py#black_these(bufs) abort  " {{{

  " Can you do this with a range of buffers?
  for buf in a:bufs
    py3 from pybuffers import blackened_vim
    py3 blackened_vim(buf)
  endfor
endfunction   " }}}

function! py#black_version() abort  " {{{
  py3 from py import black_version; black_version()
endfunction  " }}}

function! s:timed(func) abort  " {{{
  let start = reltime()
  call a:func()
  let seconds = reltimefloat(reltime(start))
  return seconds
endfunction  " }}}

function! py#timedblack() abort  " {{{
  return s:timed(py#Black())
endfunction  " }}}

function! py#py_import(...) abort   " {{{
  " Call the func with a list of desired args
  python3 py.import_into_vim(a:000)
endfunction  " }}}

function! py#Cnxn(...) abort  " {{{
  call s:check_modified()
  " terminal ipython
  if len(a:000) is 0
    call termopen('ipython')
  else
    " Handle this i guess?
    call termopen('ipython', a:000)
  endif

  " Credit: JustinMK
  " https://github.com/justinmk/config/blob/ad5b792049b352274d4cbd3525a2aff6ce296a7e/.config/nvim/init.vim#L1339-L1361
  if has('unix')
    call chansend(&channel, "import pynvim,os\n")
    call chansend(&channel, "n = pynvim.attach('socket', path=os.environ.get('NVIM_LISTEN_ADDRESS'))\n")
  else
    setlocal ff=dos
    call chansend(&channel, "import pynvim,os\r\n")
    call chansend(&channel, "n = pynvim.attach('socket', path=os.environ.get('NVIM_LISTEN_ADDRESS'))\r\n")
  endif

endfunction  " }}}

function s:check_modified() abort  " {{{
  " TODO:
  if &modified is 1 && &autowrite is 1
    write
  " we're probably gonna need a handful of fucking if elses for this to do
  " what i want.
  endif

endfunction  " }}}

function! py#Cxn(...) abort  " {{{
  call py#Cnxn()

  let s:nvim_path = v:progpath
  let s:socket = stdpath('data') . '/socket'
  " call chansend(&channel, "%env NVIM_LISTEN_ADDRESS= " . s:socket . " -u NORC\n")
  " call chansend(&channel, ":let j=jobstart('nc -U ".v:servername."',{'rpc':v:true})\n")
  " call chansend(&channel, ":call rpcrequest(j, 'nvim_set_var', 'cxn', v:servername)\n")
  " call chansend(&channel, ":call rpcrequest(j, 'nvim_command', 'call py#Cnxn()')\n")
endfunction  " }}}

function! py#RefreshSnippets() abort  " {{{
  py3 UltiSnips_Manager._refresh_snippets()
endfunction  " }}}

function! py#list_snippets() abort  " {{{
  " Utilizing the python API and ultisnispzzz
  " Doesnt return anything?
  py3 UltiSnips_Manager.list_snippets()
endfunction  " }}}
