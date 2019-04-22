" From lua-require-example
function charblob#encode_buffer()
  call setline(1, luaeval(
  \    'require("charblob").encode(unpack(_A))',
  \    [getline(1, '$'), &textwidth, '  ']))
endfunction
