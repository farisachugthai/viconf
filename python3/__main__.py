#!/usr/bin/env python
"""From outside Neovim, the script just delegates to the real nvim command:

Setting EDITOR='nvim-client -f' allows usage with git and pry:
"""
import asyncio
import os
import re
import sys
import time

import pynvim

def get_listed_buffers(nvim_):
    """Get a list of buffers that haven't been deleted. `nvim.buffers` includes
    buffers that have had `:bdelete` called on them and aren't in the buffer
    list, so we have to filter those out.
    """
    return set(buf.number for buf in nvim_.buffers if nvim_.eval('buflisted(%d)' % buf.number))


# For now, treat all arguments that don't start with - or + as filenames. This
# is good enough to recognize '-f' and `+11`, which is all this script really
# needs right now.
filenames = [
    re.sub(" ", r"\ ", os.path.abspath(arg))
    for arg in sys.argv[1:] if not arg[0] in ["-", "+"]
]

nvim_socket = os.environ.get("NVIM_LISTEN_ADDRESS")
if nvim_socket is None:
    # If we aren't running inside a `:terminal`, just exec nvim.
    os.execvp('nvim', sys.argv[:])

nvim = pynvim.attach('socket', path=nvim_socket)

existing_buffers = get_listed_buffers(nvim)

nvim.command('split')
nvim.command('args %s' % ' '.join(filenames))

new_buffers = get_listed_buffers(nvim).difference(existing_buffers)

for arg in sys.argv:
    if arg[0] == '+':
        nvim.command(arg[1:])

# The '-f' flag is a signal that we're in a situation like a `git commit`
# invocation where we need to block until the user is done with the file(s).
if '-f' in sys.argv and len(new_buffers) > 0:
    # The rule here is that the user is 'done' with the opened files when none
    # of them are visible onscreen. This allows for use cases like hitting `:q`
    # on a `git commit` tempfile. However, we can't just poll to see if they're
    # visible, because using `nvim.windows`, `nvim.eval()`, or `nvim.call()`
    # will interrupt any multi-key mappings the user may be inputting. The
    # solution is to set a buffer-local autocmd on each opened buffer so that
    # we only check for visibility immediately after the user either closes or
    # hides one of the buffers.
    channel_id = nvim.channel_id
    for buffer in new_buffers:
        nvim.command((
            'autocmd BufDelete,BufHidden <buffer=%d> ' +
            'call rpcnotify(%d, "check_buffers")'
        ) % (buffer, channel_id))

    stay_open = True
    while stay_open:
        # block until `rpcnotify` is called
        nvim.next_message()
        open_buffers = [window.buffer.number for window in nvim.windows]
        stay_open = any([buffer in open_buffers for buffer in new_buffers])

    # Now that none of the opened files are visible anymore, we do a few
    # cleanup steps before ending the script:
    #  * Clear the arg list, since otherwise `:next` would reopen the tempfile
    #    or whatever.
    #  * Clear the autocmds we added, since `bdelete` just hides the buffer and
    #    the autocmds will still be active if the user reopens the file(s).
    #  * Delete each of the buffers we created.
    nvim.command('argdel *')
    for buffer in new_buffers:
        nvim.command('autocmd! BufDelete,BufHidden <buffer=%d>' % buffer)
        nvim.command('bdelete! %d' % buffer)


async def client_connected(reader, writer):
    # Communicate with the client with
    # reader/writer streams.  For example:
    await reader.readline()

async def main(host, port):
    srv = await asyncio.start_server(
        client_connected, host, port)
    await srv.serve_forever()

# asyncio.run(main('127.0.0.1', 0))
