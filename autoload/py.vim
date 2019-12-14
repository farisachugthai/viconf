" ============================================================================
  " File: py.vim
  " Author: Faris Chugthai
  " Description: Working with the python API
  " Last Modified: November 14, 2019
" ============================================================================

function! py#taglist() abort  " {{{1
" Still pretty shaky but getting better
  " call a vim function from python. tagfiles() is a builtin that displays the
  " included tags files for the buffer.

python3 << EOF
from pprint import pprint
pprint(vim.call('tagfiles'))

EOF
endfunction
function! py#nvim_taglist() abort  " {{{1
  " Or if you wanna see a different way
  call nvim_call_function('tagfiles')
endfunction
function! s:_PythonPath() abort  " {{{1

  " Set up the path var for python filetypes. Here we go!
  " Note: the path option is to find directories so it's usually unnecesssary
  " to glob if you have the /usr/lib/python dir in hand.

  " The current path and the buffer's dir. Also recursively search downwards
  let s:path = '.,,**,'

  " Set path based on nvims dynamically defined remote python host.
  if !empty('g:python3_host_prog')

    " Note: Regardless of whether its unix or not, add dirs in reverse order
    " as we're appending them to the set option
    if has('unix')

      " #1) use the remote python's site packages
      let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h:h')

      " Warning: Don't glob this one.
      " It includes so many things that basic lookups start going REALLY slowly
      let s:site_pack = s:root_dir . '/lib/python3.8/site-packages,'

      let s:path = s:path . s:site_pack

      " #2) use the system python's std library modules
      " Oh don't forget the usr/lib one. Ugh. But android doesn't put that in
      " the same place as other unix OSes.
      if exists('$ANDROID_DATA')
        let s:path = s:path . expand('$PREFIX/lib/python3.8') . ','
      else
        let s:path = s:path . '/usr/lib/python3.8,'
      endif

      " #3) use the remote pythons std lib modules
      let s:path = ',' . s:root_dir . '/lib/python3.8/*' . s:path . ','

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
    echoerr 'autoload/py.vim: g:python3_host_prog is not set'
    " Todo i guess. lol sigh
    let &l:path = s:path
    return s:path

  endif
  return s:path

endfunction
function! py#PythonPath() abort  " {{{1

  let s:path = s:_PythonPath()
  let &l:path = s:path
  return s:path

endfunction
function py#python_serves_python() abort  " {{{1

python3 << EOF
import site, sys, vim
import os
def setup_vim_path():
    vim_path = '.,**,,'
    vim_path += sys.prefix + ','

    for i in site.getsitepackages():
        vim_path += i + ','

    print(vim_path)
    return vim_path


def pure_python_path():
    """Attempt 2."""
    for p in sys.path:
    # Add each directory in sys.path, if it exists.
        if os.path.isdir(p):
            # Command 'set' needs backslash before each space.
            vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))


def Importer(mod):
    """Totally preliminary but this might be really useful.

    Check the docstring with your pydoc command.
    """
    from importlib.util import find_spec
    return find_spec(mod)

EOF

call pure_python_path()

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

  if executable('black')
    let b:ale_fixers+=['black']
  endif

  if executable('yapf')
    let b:ale_fixers += ['yapf']
  endif

  if executable('autopep8')
      let b:ale_fixers += ['autopep8']
  endif

endfunction
