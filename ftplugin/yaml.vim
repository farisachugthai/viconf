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

setlocal comments=:# commentstring=#\ %s expandtab
setlocal formatoptions-=t formatoptions+=croql
setlocal expandtab tabstop=4 shiftwidth=2 softtabstop=2

syntax sync fromstart
syntax enable

if exists('*nvim_command')
  call nvim_command('UltiSnipsAddFiletypes ansible')
endif

" For more see ../python3/_vim
command! -buffer -bar -range=% PrettyYaml :<line1>,<line2>python3 from _vim import pretty_it; pretty_it('yaml')

let b:undo_ftplugin .= '|setl com< cms< et< fo< sw< et< sts< ts<'
            \ . '|unlet! b:undo_ftplugin'
            \ . '|unlet! b:did_ftplugin'
            \ . '|unlet! b:undo_indent'
            \ . '|unlet! b:did_indent'
            \ . '|silent! delcom PrettyYaml'
