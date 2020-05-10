.. _if-pyth:

=======================
Neovim Python Interface
=======================

.. highlight:: vim

Notes for the interface between python and Neovim.

The various vim* and nvim_* functions
=====================================

Returns a dict! Good to vim.eval returning multiple types *as py3do doesn't.*::

   py3 print(type(vim.eval("g:coc_user_config")))


Unexpected Errors
=================

Modules
-------
Seriously why does this not work?::

   py3 import os
   py3 p = os.environ.get('$MYVIMRC')
   py3 print(p)

Just returned None.


Literally what the hell does this mean?

.. code-block:: python-traceback

   Error detected while processing function provider#python3#Call:
   line   18:
   Error invoking 'python_execute' on channel 5 (python3-script-host):
   Traceback (most recent call last):
   File "<string>", line 1, in <module>
   File "C:\Users\fac\scoop\apps\winpython\current\python-3.8.1.amd64\lib\site-packages\pynvim\api\nvim.py", line 299, in call
      return self.request('nvim_call_function', name, args, **kwargs)
   File "C:\Users\fac\scoop\apps\winpython\current\python-3.8.1.amd64\lib\site-packages\pynvim\api\nvim.py", line 182, in request
      res = self._session.request(name, *args, **kwargs)
   File "C:\Users\fac\scoop\apps\winpython\current\python-3.8.1.amd64\lib\site-packages\pynvim\msgpack_rpc\session.py", line 104, in request
      raise self.error_wrapper(err)
   pynvim.api.common.NvimError: Vim:E343: Invalid path: '**[number]' must be at the end of the path or be followed by '\'.-- REPLACE --

   Error detected while processing function <SNR>48_ClosePreview:
   line   18:
   E108: No such variable: "b:supertab_close_preview"


Python for command completion
-----------------------------
``:py3do`` can only return a ``str`` or None which sucks since we'd prefer a list.:

Also Jesus why does this write the return value to the buffer?::

   function! s:PythonMods(A, L, P) abort
      py3do return str(sys.modules)
   endfunction

Connecting to the socket is the easiest way a programmer can test the API,
