" ============================================================================
  " File: py.vim
  " Author: Faris Chugthai
  " Description: Working with the python API
  " Last Modified: November 14, 2019
" ============================================================================

function! py#list_snippets() abort  " {{{
  " Utilizing the python API and ultisnispzzz
  " Doesnt return anything?
  py3 from UltiSnips import UltiSnips_Manager
  py3 UltiSnips_Manager.list_snippets()
endfunction

function! py#list_snippets2() abort
  try
    py3 import UltiSnips
  catch
    return
  endtry
  python3 from UltiSnips.snippet_manager import SnippetManager
  " This expression raises an error. # TODO:
  let g:sm = py3eval("SnippetManager(" . g:UltiSnipsExpandTrigger, g:UltiSnipsJumpForwardTrigger, g:UltiSnipsJumpBackwardTrigger . ")")
  py3 sm.list_snippets()
endfunction " }}}

function! py#taglist() abort  " {{{1
  " Let's return the value from `vim.call` so that we can check it later if
  " need be
  py3 from pprint import pprint; tagfiles = (vim.call('tagfiles'))
  py3 pprint(tagfiles)
endfunction  " }}}

function! py#nvim_taglist() abort  " {{{1
  return nvim_call_function('tagfiles')
endfunction  " }}}

function! s:_PythonPath() abort  " {{{1
  " Set up the path var for python filetypes. Here we go!
  " Note: the path option is to find directories so it's usually unnecesssary
  " to glob if you have the /usr/lib/python dir in hand.

  " The current path and the buffer's dir. Also recursively search downwards
  let s:path = '.,,**,'

  if !has('python3')
    let &l:path = s:path
    return s:path
  endif
 
  if exists('g:python3_host_prog')
    " Note: Regardless of whether its unix or not, add dirs in reverse order
    " as we're appending them to the set option
    if has('unix')

       " #1) use the remote python's site packages
       " guess who figured something out today?
       python3 import site, vim;
       let s:site_pack = py3eval('site.USER_SITE')
       let s:path = s:path . s:site_pack . '/**'

      " #2) use the system python's std library modules
      " Oh don't forget the usr/lib one. Ugh. But android doesn't put that in
      " the same place as other unix OSes.
      if exists('$ANDROID_DATA')
        let s:path = s:path . ',' . expand('$PREFIX/lib/python3.8')
      else
        let s:path = s:path . ',/usr/lib/python3.8'
      endif

      " #3) use the remote pythons std lib modules
      let s:root_dir = fnamemodify(s:site_pack, ':p:h:h')
      let s:path = s:path . ',' . s:root_dir

    " then do it all over again for windows.
    " sunovabitch conda doesn't lay out the python dirs in the same spot as Unix
    else
      let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h')

      let s:site_pack = s:root_dir . '/lib/site-packages'
      let s:path = s:path . s:site_pack

      " This option requires that the '**' either is at the end of the path or
      " ends with a '/'
      " let s:path =  ',' . s:root_dir . '/lib/**1/' . s:path . ','

      " make this last. its the standard lib and we prepend it to the path so
      " it should be first in the option AKA last in the function
      " UGHHHHHHH VIM WHYYYYY. If you write this as s:root_dir . '/lib/*'
      " it only matches 1 letter and doesn't include the std lib as a result.
      " Shave off the glob to add more in. Yeah ikr?
      let s:path = s:root_dir . '/lib,' . s:path
    endif
  else

    python3 import site, vim, sys;
    let s:site_pack = py3eval('site.USER_SITE')
    let s:prefix = py3eval('sys.prefix')
    let s:path = s:path . s:site_pack

    let &l:path = s:path
    return s:path
  endif
  return s:path

endfunction  " }}}

function! py#PythonPath() abort  " {{{1
  let s:path = s:_PythonPath()
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
  " let s:0
  " todo: doesnt work. cant find file sp we raise
  let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))
  let s:src = s:repo_root . '/python3/pybuffers.py'
  call py3eval('s:src')
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

function! py#Cnxn() abort  " {{{
  " Credit: JustinMK
  " https://github.com/justinmk/config/blob/ad5b792049b352274d4cbd3525a2aff6ce296a7e/.config/nvim/init.vim#L1339-L1361
  terminal

  if has('unix')
    call chansend(&channel, "import pynvim,os\n")
    call chansend(&channel, "n = pynvim.attach('socket', path=os.environ.get('NVIM_LISTEN_ADDRESS'))\n")
  else
    call chansend(&channel, "import pynvim,os\r\n")
    call chansend(&channel, "n = pynvim.attach('socket', path=os.environ.get('NVIM_LISTEN_ADDRESS'))\r\n")
  endif

endfunction  " }}}

function! py#Cxn(...) abort  " {{{
  call py#Cnxn()

  let s:nvim_path = v:progpath
  let s:socket = stdpath('data') . '/socket'
  call chansend(&channel, "NVIM_LISTEN_ADDRESS= " . s:socket . " -u NORC\n")
  call chansend(&channel, ":let j=jobstart('nc -U ".v:servername."',{'rpc':v:true})\n")
  call chansend(&channel, ":call rpcrequest(j, 'nvim_set_var', 'cxn', v:servername)\n")
  call chansend(&channel, ":call rpcrequest(j, 'nvim_command', 'call py#Cnxn()')\n")
endfunction  " }}}
