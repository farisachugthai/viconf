function add(a,b)
  return a+b
end

local function buffer_ticks()
  local ticks = {}
  for _, buf in ipairs(a.nvim_list_bufs()) do
      ticks[#ticks+1] = a.nvim_buf_get_changedtick(buf)
  end
  return ticks
end

_testplugin = {add=add, buffer_ticks=buffer_ticks}

-- Can run with `:py3 vim.exec_lua("_testplugin=require('testplugin')")`
-- now it can be accessed as vim.lua._testplugin
