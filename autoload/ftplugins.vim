 "===========================================================================
    " File: ftplugins.vim
    " Author: Faris Chugthai
    " Description: Ftplugin specific autoloaded functions
    " Last Modified: August 28, 2019
" ============================================================================

" Guard: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=C

function! ftplugins#ALE_JSON_Conf() abort  " {{{1
  " Standard fixers defined for JSON
  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

  if executable('jq')
    let b:ale_fixers += ['jq']
    let b:ale_json_jq_options = '-SM'
    let b:ale_json_jq_filters = '.'
  endif

  if executable('fixjson')
    let b:ale_fixers += ['fixjson']
  endif

  if executable('jsonlint')
  " Jul 17, 2019: Only json linter available
    let b:ale_linters = ['jsonlint']
    let b:ale_linters_explicit = 1
  endif
endfunction

function! ftplugins#FormatFile() abort  " {{{1
  let l:lines='all'
  " 'pyf expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
  let b:ale_fixers = [ 'clang-format' ]
  " Should add a mapping
  " let g:clang_format_path =  expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
  " noremap <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
  " noremap! <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
" With this integration you can press the bound key and clang-format will
" format the current line in NORMAL and INSERT mode or the selected region in
" VISUAL mode. The line or region is extended to the next bigger syntactic
" entity.

" You can also pass in the variable "l:lines" to choose the range for
" formatting. This variable can either contain "<start line>:<end line>" or
" "all" to format the full file. So, to format the full file, write a function
" like:

" It operates on the current, potentially unsaved buffer and does not create
" or save any files. To revert a formatting, just undo.
" autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()
endfunction

" This is honestly really useful if you simply swap out the filetype
function! ftplugins#ClangCheckimpl(cmd)
  if &autowrite | wall | endif
  echo "running " . a:cmd . " ..."
  let l:output = system(a:cmd)
  cexpr l:output
  cwindow
  let w:quickfix_title = a:cmd
  if v:shell_error != 0
    cc
  endif
  let g:clang_check_last_cmd = a:cmd
endfunction

function! ftplugins#ClangCheck()
  let l:filename = expand('%')
  if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
    call ClangCheckImpl("clang-check " . l:filename)
  elseif exists("g:clang_check_last_cmd")
    call ClangCheckImpl(g:clang_check_last_cmd)
  else
    echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif

" nmap <silent> <F5> :call ClangCheck()<CR><CR>

" Idk why <CR> is  there twice and idk if it was a typo on the part of the
" Clang people but its in their official documentation..
endfunction


function! ftplugins#ALE_CSS_Conf() abort  " {{{1

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif
endfunction


function! ftplugins#ALE_sh_conf() abort  " {{{1
  " if we're using powershell or cmd on windows set ALEs default shell to bash
  " TODO: set the path to shellcheck.
  if has('unix')
    let shell_is_bash = match(expand('$SHELL'), 'bash')
    if !shell_is_bash
      let g:ale_sh_shell_default_shell = 1
    else
      let g:ale_sh_shell_default_shell = 0
    endif

 " else
    let s:bash_location = exepath('bash')
    if executable(s:bash_location)
      let g:ale_sh_shell_default_shell = 1
    endif
  endif

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  let b:ale_linters = ['shell', 'shellcheck']

  if !has('unix')
    let b:ale_sh_shellcheck_executable = 'C:/tools/miniconda3/envs/neovim/bin/shellcheck.exe'
  endif
endfunction


function! ftplugins#ALE_Html_Conf() abort  " {{{1

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

endfunction

function! ftplugins#ALE_JS_Conf() abort  " {{{1

  if !has('unix')
    let g:ale_windows_node_executable_path = fnameescape('C:/Program Files/nodejs/node.exe')
  endif

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

endfunction


function! ftplugins#ALE_Vim_Conf() abort  " {{{1
  let b:ale_linters = ['ale_custom_linting_rules']
  let b:ale_linters_explicit = 1

  if executable('vint')
    let b:ale_linters += ['vint']
  endif
endfunction

function! ftplugins#PythonPath() abort  " {{{1

  " Set up the path for python files
  " Somehow this still doesn't solve my  imports on windows so I might end up
  " doing this in python
  " AND THAT DOESN"T WORK AT ALL EITHER. Somehow that function returns 0????
  " if !has('unix')
  "   let s:ret_val = ftplugins#python_serves_python()
  "   return s:ret_val
  " endif

  let s:orig_path = &path

  if !empty('g:python3_host_prog')
    " I think it's only the root on unix
    " Miniconda3 on windows you only go up 1
    " if has('unix')
      let s:root_dir = fnamemodify('g:python3_host_prog', ':p:h:h')
      let s:site_pack = s:root_dir . '/Lib/python3.7/site-packages/**3'  " max out at 3 dir deep
    " else
    "   " i have no idea why but don't wrap this in a string. then nvim won't
    "   " expand it for some reason and it just feeds you the cwd
    "   let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h')

    "   " If you're using conda the dirs don't line up either
    "   let s:site_pack = s:root_dir . '/Lib/site-packages/**3'  " max out at 3 dir deep
    " endif
  else
    return s:orig_path
  endif

  " let s:path =  s:site_pack . ',' . s:orig_path
  " The current path and the buffer's dir. Also recursively search downwards
  let s:path = '.,,**,' . s:site_pack

  " I'm gonna go ahead and assume a conda installation on windows.
  " if !has('unix')
  "   let s:path = s:path . ',' . s:root_dir . '/Lib/*.py'
  "   let s:path = s:path . ',' . s:root_dir . '/Lib/**/*.py'
  " else
    let s:path = s:path . ',' . s:root_dir . '/lib/python3.7/*.py'
    let s:path = s:path . ',' . s:root_dir . '/lib/python3.7/**/*.py'
  " endif

  return s:path

endfunction

function! ftplugins#python_serves_python() abort  " {{{1

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

function! ftplugins#VimPath() abort  " {{{1

  let s:path='.,**,,'
  let s:path = s:path . ',' . expand('$VIMRUNTIME')

  if !exists('*stdpath')
    " honestly this is too hard without this
    return s:path
  endif

  " let s:path = s:path . ',' . stdpath('data') . '/plugged/**4'
  " let s:path = s:path . ',' . &rtp
  " rtp adds way too many things but add all my files
  let s:path = s:path . ',' . stdpath('config') . '/**'
  return s:path

endfunction

function! ftplugins#CPath() abort  " {{{1

  let s:path='.,**,,'

  if has('unix')
    let s:path = s:path . ',/usr/include,/usr/local/include'

    if isdirectory(expand('$HOME/.local/include'))
      let s:path = s:path . ',' .  expand('$HOME') . '/.local/include'
    endif

  else
    let s:path = s:path . ',C:/tools/miniconda3/envs/working/Library/include'
    let s:path = s:path . ',C:/tools/miniconda3/envs/working/include'

  endif

  return s:path

endfunction

function! ftplugins#YAPF() abort  " {{{1
  if exists(':TBrowseOutput')
    " Realistically should accept func args
    :TBrowseOutput !yapf %
  else
    " save old buffer
    let s:old_buffer = nvim_get_buffer_lines()
     call pydoc_help#scratch_buffer()
  endif
endfunction


function! ftplugins#ALE_Python_Conf() abort  " {{{1

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


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save

" Vim: fdl=0:fdls=0:
