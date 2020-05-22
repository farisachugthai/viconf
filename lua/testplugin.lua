local vim = vim

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
-- now it can be accessed as `:py3 vim.lua._testplugin`
--
-- Taken from clink

local function get_git_info()
    local git_cmd = "git branch --verbose --no-color 2>nul"
    for line in io.popen(git_cmd):lines() do
        local _, _, name, commit = line:find("^%*.+%s+([^ )]+)%)%s+([a-f0-9]+)")
        if name and commit then
            return name, commit:sub(1, 6)
        end

        local _, _, name, commit = line:find("^%*%s+([^ ]+)%s+([a-f0-9]+)")
        if name and commit then
            return name, commit:sub(1, 6)
        end
    end

    return "NAME?", "COMMIT?"
end



-- he tcpserver
local function create_server(host, port, on_connection)
local server = vim.loop.new_tcp()
server:bind(host, port)
server:listen(128, function(err)
assert(not err, err)  -- Check for errors.
local sock = vim.loop.new_tcp()
server:accept(sock)  -- Accept client connection.
on_connection(sock)  -- Start reading messages.
end)
return server
end
local server = create_server('0.0.0.0', 0, function(sock)
sock:read_start(function(err, chunk)
assert(not err, err)  -- Check for errors.
if chunk then
  sock:write(chunk)  -- Echo received messages to the channel.
else  -- EOF (stream closed).
  sock:close()  -- Always close handles to avoid leaks.
end
end)
end)
print('TCP echo-server listening on port: '..server:getsockname().port)
