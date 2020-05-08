.. _if-pyth:

=======================
Neovim Python Interface
=======================

.. highlight:: vim

Notes for the interface between python and Neovim.

Creating a remote connection to a python interpreter
=====================================================
Requires a little digging in the source code if a simple
``:UpdateRemotePlugins`` isn't working for you.::

   if exists('g:loaded_python3_provider')
     finish
   endif
   let [s:prog, s:err] = provider#pythonx#Detect(3)
   let g:loaded_python3_provider = empty(s:prog) ? 1 : 2

Upon errors, make sure to check for an value of 2 for
``g:loaded_python3_provider``. That means that at least something's *trying*
to initialize a connection. Also note this from
``$VIMRUNTIME/autoload/remote/host.vim``.::

   " Registration of standard hosts

   " Python/Python3
   call remote#host#Register('python', '*',
         \ function('provider#pythonx#Require'))
   call remote#host#Register('python3', '*',
         \ function('provider#pythonx#Require'))

   " Ruby
   call remote#host#Register('ruby', '*.rb',
         \ function('provider#ruby#Require'))

   " nodejs
   call remote#host#Register('node', '*',
         \ function('provider#node#Require'))

So by default we try to establish the hosts in this way. Note that there
is no such thing as a ``provider#python3#Require`` or
``provider#python#Require`` function, they're grouped together at
:file:`$VIMRUNTIME/autoload/provider/pythonx.vim`.


.. _python-variables:

Accessing variables in Vim from python
======================================
On the ex cmdline, use one of the ``vim.eval``, ``vim.command``, ``vim.exec``
commands to retrieve Vim values.

.. todo::
   Report back with differentiating features of each.


.. _python-visual:

Getting the visual selection from Vim and accessing in Python
-------------------------------------------------------------
https://www.tummy.com/blogs/2007/03/01/using-python-in-vim-with-visual-selection/

From this blog post.:

   In the python+vim code, there are two ways to get access to a visual selection.
   One is to use the “vim.current.range” object. For example, use “v” in vim and
   select a range, then do “:python foo()” to call a function with that range
   available to the “foo” function.

   vim.current.range will give you a list-like object of the lines in the visual
   selection.

   For access to the starting and ending position of the selection, you can use
   “vim.current.buffer.mark('<')”, which will give you the line and column of the
   start of the visual selection. Similarly, the “>” mark will give you the end
   position.

Excellent.

.. _python-nvim-functions:

The various vim* and nvim_* functions
=====================================
Returns a dict! Hats off to ``vim.eval`` for returning multiple types as
``py3do`` doesn't.::

   py3 print(type(vim.eval("g:coc_user_config")))


.. _python-exceptions:

Unexpected Errors
=================
Seriously why does this not work?::

   py3 import os
   py3 p = os.environ.get('$MYVIMRC')
   py3 print(p)

Just returned `None`.

Btw.
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


The Remote/Provider API
========================
Examples of the Vimscript functions in $VIMRUNTIME/autoload.

.. function:: provider#pythonx#CheckForModule

   Returns a list in the form [success, error_message].
   Therefore, a result similar to [1, ''] means we found it.

   While inside of Nvim, only one of these lines passed.::

      echo provider#pythonx#CheckForModule('python3', '_vim', 3)
      echo provider#pythonx#CheckForModule('python3', 'vim' 3)
      echo provider#pythonx#CheckForModule('python3', 'vim', 3)
      echo provider#pythonx#CheckForModule('python3', 'pynvim', 3)
      echo provider#pythonx#CheckForModule('python3', 'pytest', 3)

   Which was odd to me. The _vim and vim modules don't actually exist but
   shouldn't we still inform the remote interpreter that we think so?

   *Btw in case you were wondering, yes, pytest was the only one that worked.*


Python API spilling into Vimscript
==================================
So this line has an interesting error message.::

   echo nvim_tabpage_list_wins('')
   E5555: API call: Wrong type for argument 1, expecting Tabpage.

That's the python API. How the hell do I access a Tabpage from Vimscript?

