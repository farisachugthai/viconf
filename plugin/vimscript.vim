" ============================================================================
  " File: vimscript.vim
  " Author: Faris Chugthai
  " Description: The last call for options to set before we stop sourcing
  " the plugins dir
  " Last Modified: Aug 12, 2019
" ============================================================================

if exists('g:loaded_vimscript_vim') || &compatible || v:version < 700
    finish
endif
let g:loaded_vimscript_vim = 1

" Rg options: {{{
if !exists('g:rg_binary')
  let g:rg_binary = 'rg'
endif

if !exists('g:rg_format')
  let g:rg_format = "%f:%l:%c:%m"
endif

if !exists('g:rg_command')
  let g:rg_command = g:rg_binary . ' --vimgrep'
endif

if !exists('g:rg_root_types')
  let g:rg_root_types = ['.git']
endif

if !exists('g:rg_window_location')
  let g:rg_window_location = 'botright'
endif " }}}

" Platform Specific Options: {{{

if has('unix')
  call unix#UnixOptions()
else
  call msdos#set_shell_cmd()
endif " }}}

" Fix the path: {{{

if !exists('b:did_ftplugin')
  if exists('*stdpath')  " fuckin vim
    let &path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'  . ',' . stdpath('config')
  else
    let &path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'
  endif
endif " }}}

" In Which I Learn How Complete Works: {{{

command! -bar -complete=buffer ScratchBuffer call pydoc_help#scratch_buffer()

command! -bar -complete=compiler Compiler compiler <args>
" '<,'>s/compiler/event/g
" You may find that ---^ does you good
command! -bar -complete=event Event event<args>

command! -bar -bang -complete=var -nargs=+ Var set<bang> <args>

" well check out how cool this is. shouldnt be so surprised that this works
command! -complete=environment -bar -nargs=+ Env let $<args>

command! -bar RerunLastCmd call histget('cmd', -1)  " }}}

" Commands from the help pages. map.txt: {{{
" Replace a range with the contents of a file
" (Enter this all as one line)
command! -bar -range -nargs=1 -complete=file Replace <line1>-pu_|<line1>,<line2>d|r <args>|<line1>d

" Count the number of lines in the range
command! -bar -range -nargs=0 Lines  echo <line2> - <line1> + 1 'lines'  " }}}

" Last Call For Options: {{{1
if &omnifunc ==# '' | setlocal omnifunc=syntaxcomplete#Complete | endif

if &completefunc ==# '' | setlocal completefunc=syntaxcomplete#Complete | endif  " }}}

" Vim: set fdm=marker:
