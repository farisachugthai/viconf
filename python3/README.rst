=======================
Neovim Python Interface
=======================

Notes for the interface between python and Neovim.

Unexpected Errors
=================

Seriously why does this not work?::

   py3 import os
   py3 p = os.environ.get('$MYVIMRC')
   py3 print(p)

Just returned None.
