let b:did_ftplugin = 1

setlocal comments=:# commentstring=#\ %s expandtab
setlocal formatoptions-=t formatoptions+=croql
setlocal et ts=4 sw=2 sts=2

let b:yaml_schema = 'pyyaml'

syntax sync fromstart

if exists('*nvim_command')
  call nvim_command('UltiSnipsAddFiletypes ansible')
endif

let b:undo_ftplugin = 'setl com< cms< et< fo< sw< et< sts< ts<'
