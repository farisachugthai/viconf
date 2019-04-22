
if exists('g:charblob_loaded')
  finish
endif
let g:charblob_loaded = 1

command MakeCharBlob :call charblob#encode_buffer()
