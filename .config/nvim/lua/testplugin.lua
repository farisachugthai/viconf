-- testplugin

-- from the nvim help docs
-- https://pynvim.readthedocs.io/en/latest/usage/python-plugin-api.html

local a = vim.api
local function add(a,b)
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


-- Alternatively, place the code in /lua/testplugin.lua under your plugin
-- repo root, and use::

-- vim.exec_lua("_testplugin = require('testplugin')").
-- Then, the module can be acessed as vim.lua._testplugin.

-- mod = vim.lua._testplugin
-- mod.add(2,3) # => 5
-- mod.buffer_ticks() # => list of ticks
