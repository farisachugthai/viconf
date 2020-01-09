 "===========================================================================
    " File: ftplugins.vim
    " Author: Faris Chugthai
    " Description: Ftplugin specific autoloaded functions
    " Last Modified: August 28, 2019
" ============================================================================
function! ftplugins#ALE_JSON_Conf() abort  " {{{1
  " Standard fixers defined for JSON
  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif

  " if executable('jq')
  " actually i don't care add this no matter what
    let b:ale_fixers += ['jq']
    let b:ale_json_jq_options = '-SM'
    let b:ale_json_jq_filters = '.'
  " endif

  if executable('fixjson')
    let b:ale_fixers += ['fixjson']
  endif

  " if executable('jsonlint')
  " Jul 17, 2019: Only json linter available. So  enabled it no matter what
  " then? Like what other choice do you have right?
    let b:ale_linters = ['jsonlint']
    let b:ale_linters_explicit = 1
  " endif
endfunction
function! ftplugins#FormatFile() abort  " {{{1
  let l:lines='all'
  " 'pyf expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
  let b:ale_fixers = [ 'clang-format' ]
  " Should add a mapping
  if filereadable('C:/tools/vs/2019/Community/VC/Tools/Llvm/bin/clang-format.exe')
    let g:clang_format_path = 'C:/tools/vs/2019/Community/VC/Tools/Llvm/bin/clang-format.exe'
  endif
  " let g:clang_format_path =  expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
  noremap <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
  noremap! <Leader><C-c>f <Cmd>pyfile expand('$XDG_CONFIG_HOME') . '/nvim/pythonx/clang-format.py'
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
function! ftplugins#ClangCheckimpl(cmd) abort  " {{{1
" This is honestly really useful if you simply swap out the filetype
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
function! ftplugins#ClangCheck()  abort  " {{{1
  let l:filename = expand('%')
  if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
    call ftplugins#ClangCheckImpl("clang-check " . l:filename)
  elseif exists("g:clang_check_last_cmd")
    call ftplugins#ClangCheckImpl(g:clang_check_last_cmd)
  else
    echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif

endfunction
function! ftplugins#ALE_CSS_Conf() abort  " {{{1

  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  if executable('prettier')
    let b:ale_fixers += ['prettier']
  endif
endfunction
function! ftplugins#ALE_sh_conf() abort  " {{{1
  " this is probably a waste of time when compiler shellcheck exists
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
function! ftplugins#VimPath() abort  " {{{1

  " I know you may be thinking, there are no include or defines in a vim file
  " what the hell do you need to muck with the path for.
  " autoloaded functions!
  let s:path='.,**,'
  let s:path = s:path . expand('$VIMRUNTIME') . ','

  if !exists('*stdpath') | let &l:path = s:path | return s:path | endif

  let s:path = s:path . stdpath('config') . '/autoload,'

  " Idk if this is gonna glob the way I want.
  let s:path = s:path . stdpath('data') . '/**1/autoload,'

  let &l:path = s:path
  return s:path

endfunction
function! ftplugins#CPath() abort  " {{{1

  let s:path='.,**,,'

  if has('unix')
    let s:path = s:path . '/usr/include,/usr/local/include,'

    if isdirectory(expand('$HOME/.local/include'))
      let s:path = s:path . ',' .  expand('$HOME') . '/.local/include'
    endif

  else
    " we did it.
    if exists('$INCLUDE')
      let s:path = s:path . expand('$INCLUDE')
      return s:path
    endif

    if isdirectory('C:/tools/miniconda3/envs/neovim/Library/include')
      let s:path = s:path . 'C:/tools/miniconda3/envs/neovim/Library/include,'
      let s:path = s:path . 'C:/tools/miniconda3/envs/neovim/include,'
    endif

    if isdirectory('C:/tools/vs/2019/BuildTools/VC/Tools/MSVC/14.23.28105/include')
      let s:path = s:path . 'C:/tools/vs/2019/BuildTools/VC/Tools/MSVC/14.23.28105/include,'
    endif

    if isdirectory('C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include')
      let s:path = s:path . 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include,'
    endif

    " Yo honestly this is the one you're looking for
    if isdirectory('C:/Program Files (x86)/Windows Kits/10/include/10.0.17763.0/um')
      let s:path = s:path . 'C:/Program Files (x86)/Windows Kits/10/include/10.0.17763.0/um'
    endif

    if exists('$INCLUDEDIR')
      let s:path = s:path . expand('$INCLUDEDIR')
    endif

  endif

  return s:path

endfunction
