if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

setlocal comments=:# commentstring=#\ %s expandtab
setlocal formatoptions-=t formatoptions+=croql
setlocal et ts=4 sw=2 sts=2

let b:yaml_schema = 'pyyaml'

syntax sync fromstart

if exists('*nvim_command')
  call nvim_command('UltiSnipsAddFiletypes ansible')
endif

py3 from _vim import pretty_it

" For more see ../python3/_vim
command! -buffer -bar -range=% Pyaml :<line1>,<line2>python pretty_it('yaml')

let b:undo_ftplugin = 'setl com< cms< et< fo< sw< et< sts< ts<'
            \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
