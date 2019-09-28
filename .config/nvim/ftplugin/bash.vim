" The original ftplugin is so odd and it does nothing of value

if exists("b:did_ftplugin")
  finish
endif

runtime ftplugin/sh.vim after/ftplugin/sh.vim

let b:did_ftplugin
