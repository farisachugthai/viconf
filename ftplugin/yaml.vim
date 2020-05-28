" ============================================================================
  " File: yaml.vim
  " Author: Faris Chugthai
  " Description: yaml ftplugin
  " Last Modified: March 05, 2020
" ============================================================================

let g:yaml_schema = 'pyyaml'
let b:yaml_schema = 'pyyaml'

if exists('b:did_ftplugin') | finish | endif

source $VIMRUNTIME/ftplugin/yaml.vim
source $VIMRUNTIME/indent/yaml.vim

" Options:
  setlocal comments=:# commentstring=#\ %s expandtab
  setlocal formatoptions-=t formatoptions+=croql
  setlocal expandtab tabstop=4 shiftwidth=2 softtabstop=2

  if exists('*nvim_command')
    call nvim_command('UltiSnipsAddFiletypes ansible')
  endif

function! Prettyyaml() range abort
  if !exists('provider#python3#Prog')
    return a:firstline
  endif
  let s:py3 = provider#python3#Prog()
  if s:py3 ==# ''
    return a:firstline
  endif
  return py3eval("from _vim import pretty_it; pretty_it('yaml')")
endfunction
" For more see ../python3/_vim
command! -buffer -bar -range PrettyYaml call Prettyyaml()

setlocal formatexpr=Prettyyaml()
" Idk if i would say this does what I want but it does something

let b:undo_ftplugin .= '|setl com< cms< et< fo< sw< et< sts< ts<'
            \ . '|unlet! b:undo_ftplugin'
            \ . '|unlet! b:did_ftplugin'
            \ . '|unlet! b:undo_indent'
            \ . '|unlet! b:did_indent'
            \ . '|silent! delcom PrettyYaml'
