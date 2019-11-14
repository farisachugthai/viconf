" ============================================================================
  " File: py.vim
  " Author: Faris Chugthai
  " Description: Working with the python API
  " Last Modified: November 14, 2019
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions-=C

function py#taglist() abort  " {{{1
" Still pretty shaky but getting better
  " call a vim function from python. tagfiles() is a builtin that displays the
  " included tags files for the buffer.

python3 << EOF
from pprint import pprint
pprint(vim.call('tagfiles'))

EOF
endfunction

function py#nvim_taglist() abort  " {{{1
  " Or if you wanna see a different way
  call nvim_call_function('tagfiles')
endfunction

function py#PythonPath() abort  " {{{1

  " Note: the path option is to find directories so it's usually unnecesssary
  " to glob if you have the /usr/lib/python dir in hand.
  " let s:orig_path = &path

  " The current path and the buffer's dir. Also recursively search downwards
  let s:path = '.,,**,'

  if !empty('g:python3_host_prog')

    if has('unix')
      let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h:h')
      " max out at 3 dir deep
      " don't go 3 dir in includes start going REALLY slowly
      let s:site_pack = s:root_dir . '/lib/python3.7/site-packages/**'

      let s:path = s:path . s:site_pack
      let s:path = ',' . s:root_dir . '/lib/python3.7/*' . s:path . ','
      let s:path =  ',' . s:root_dir . '/lib/python3.7/**/*' . s:path . ','

    " sunovabitch conda doesn't put stuff in the same spot
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

  " else
    " Todo i guess. lol sigh
    " return s:orig_path

  endif

  return s:path
  " if this still doesn't work keep wailing at python_serves_python

endfunction

function py#python_serves_python() abort  " {{{1

  python << EOF
  import site, sys, vim
  def setup_vim_path():
      vim_path = '.,**,,'
      vim_path += sys.prefix + ','

      for i in site.getsitepackages():
          vim_path += i + ','

      print(vim_path)
      return vim_path

EOF
endfunction

function py#YAPF() abort  " {{{1
  if exists(':TBrowseOutput')
    " Realistically should accept func args
    :TBrowseOutput !yapf %
  else
    " save old buffer
    let s:old_buffer = nvim_get_buffer_lines()
    call pydoc_help#scratch_buffer()
    " can we do this this way?
    " :py3 vim.current.buffer[:] = yapf -i %
    " TODO: check this
    call nvim_buf_set_lines('%', 0, '$', 0, '!yapf -i s:old_buffer')
  endif
endfunction


function py#ALE_Python_Conf() abort  " {{{1

  let b:ale_linters = ['flake8', 'pydocstyle', 'pyls']
  let b:ale_linters_explicit = 1

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  let b:ale_fixers += [ 'reorder-python-imports' ]

  if executable('yapf')
    let b:ale_fixers += ['yapf']
  else
    if executable('autopep8')
        let b:ale_fixers += ['autopep8']
    endif
  endif
endfunction


let &cpoptions = s:cpo_save
unlet s:cpo_save
