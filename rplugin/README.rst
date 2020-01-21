
Don't git add this!!!

Output from an IPython session in the REPL in a `:term` buffer.

.. code-block:: ipython

   In [8]: nvim = pynvim.attach('socket', path=os.environ.get('NVIM_LISTEN_ADDRESS'))

   In [9]: dir(nvim)
   Out[9]:
   ['__class__',
    '__delattr__',
    '__dict__',
    '__dir__',
    '__doc__',
    '__enter__',
    '__eq__',
    '__exit__',
    '__format__',
    '__ge__',
    '__getattribute__',
    '__gt__',
    '__hash__',
    '__init__',
    '__init_subclass__',
    '__le__',
    '__lt__',
    '__module__',
    '__ne__',
    '__new__',
    '__reduce__',
    '__reduce_ex__',
    '__repr__',
    '__setattr__',
    '__sizeof__',
    '__str__',
    '__subclasshook__',
    '__weakref__',
    '_decode',
    '_err_cb',
    '_from_nvim',
    '_get_lua_private',
    '_session',
    '_thread_invalid',
    '_to_nvim',
    'api',
    'async_call',
    'buffers',
    'call',
    'channel_id',
    'chdir',
    'close',
    'command',
    'command_output',
    'current',
    'err_write',
    'error',
    'eval',
    'exec_lua',
    'feedkeys',
    'foreach_rtp',
    'from_nvim',
    'from_session',
    'funcs',
    'input',
    'list_runtime_paths',
    'loop',
    'lua',
    'metadata',
    'new_highlight_source',
    'next_message',
    'options',
    'out_write',
    'quit',
    'replace_termcodes',
    'request',
    'run_loop',
    'session',
    'stop_loop',
    'strwidth',
    'subscribe',
    'tabpages',
    'types',
    'ui_attach',
    'ui_detach',
    'ui_try_resize',
    'unsubscribe',
    'vars',
    'version',
    'vvars',
    'windows',
    'with_decode']

   In [10]: nvim.buffers
   Out[10]: <pynvim.api.nvim.Buffers at 0x1487a88ff88>

   In [11]: len(nvim.buffers)
   Out[11]: 5

   In [12]: nvim.buffers[0]
   ---------------------------------------------------------------------------
   KeyError                                  Traceback (most recent call last)
   <ipython-input-12-4ab76ea7a605> in <module>
   ----> 1 nvim.buffers[0]

   C:\tools\miniconda3\lib\site-packages\pynvim\api\nvim.py in __getitem__(self, number)
       479             if b.number == number:
       480                 return b
   --> 481         raise KeyError(number)
       482
       483     def __contains__(self, b):

   KeyError: 0

   In [13]: for i in nvim.buffers:
       ...:     print(i)
       ...:
   <Buffer(handle=2)>
   <Buffer(handle=3)>
   <Buffer(handle=5)>
   <Buffer(handle=7)>
   <Buffer(handle=8)>

   In [14]: nvim.buffers.__dir__()
   Out[14]:
   ['_fetch_buffers',
    '__module__',
    '__doc__',
    '__init__',
    '__len__',
    '__getitem__',
    '__contains__',
    '__iter__',
    '__dict__',
    '__weakref__',
    '__repr__',
    '__hash__',
    '__str__',
    '__getattribute__',
    '__setattr__',
    '__delattr__',
    '__lt__',
    '__le__',
    '__eq__',
    '__ne__',
    '__gt__',
    '__ge__',
    '__new__',
    '__reduce_ex__',
    '__reduce__',
    '__subclasshook__',
    '__init_subclass__',
    '__format__',
    '__sizeof__',
    '__dir__',
    '__class__']

   In [15]: class ExtraBuf(pynvim.api.Buffer):
       ...:     def __init__(self, *args, **kwargs):
       ...:         super().__init__(*args, **kwargs)
       ...:     def __slice__(self):
       ...:         """Idk how to do this."""
       ...:         pass
       ...:     def __copy__(self):
       ...:         return copy.copy(self)
       ...:

   In [16]: len(nvim.buffers)
   Out[16]: 5

   In [17]: test = ExtraBuf()
   ---------------------------------------------------------------------------
   TypeError                                 Traceback (most recent call last)
   <ipython-input-17-aea33797fdab> in <module>
   ----> 1 test = ExtraBuf()

   <ipython-input-15-024119499b62> in __init__(self, *args, **kwargs)
         1 class ExtraBuf(pynvim.api.Buffer):
         2     def __init__(self, *args, **kwargs):
   ----> 3         super().__init__(*args, **kwargs)
         4     def __slice__(self):
         5         """Idk how to do this."""

   TypeError: __init__() missing 2 required positional arguments: 'session' and 'code_data'

   In [18]: class ExtraBuf(pynvim.api.Buffer):
       ...:     def __init__(self, session, code_data, *args, **kwargs):
       ...:         super().__init__(session, code_data, *args, **kwargs)
       ...:     def __slice__(self):
       ...:         """Idk how to do this."""
       ...:         pass
       ...:     def __copy__(self):
       ...:         return copy.copy(self)
       ...:

   In [19]: import copy

   In [20]: test = ExtraBuf()
   ---------------------------------------------------------------------------
   TypeError                                 Traceback (most recent call last)
   <ipython-input-20-aea33797fdab> in <module>
   ----> 1 test = ExtraBuf()

   TypeError: __init__() missing 2 required positional arguments: 'session' and 'code_data'

   In [21]: test = ExtraBuf(nvim, None)
   ---------------------------------------------------------------------------
   TypeError                                 Traceback (most recent call last)
   <ipython-input-21-e44341c85edb> in <module>
   ----> 1 test = ExtraBuf(nvim, None)

   <ipython-input-18-cc8633baa41a> in __init__(self, session, code_data, *args, **kwargs)
         1 class ExtraBuf(pynvim.api.Buffer):
         2     def __init__(self, session, code_data, *args, **kwargs):
   ----> 3         super().__init__(session, code_data, *args, **kwargs)
         4     def __slice__(self):
         5         """Idk how to do this."""

   C:\tools\miniconda3\lib\site-packages\pynvim\api\common.py in __init__(self, session, code_data)
        30         self._session = session
        31         self.code_data = code_data
   ---> 32         self.handle = unpackb(code_data[1])
        33         self.api = RemoteApi(self, self._api_prefix)
        34         self.vars = RemoteMap(self, self._api_prefix + 'get_var',

   TypeError: 'NoneType' object is not subscriptable

   In [22]: from pynvim.api.common import unpackb

