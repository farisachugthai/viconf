=========
Ftplugins
=========

.. highlight:: vim

Vim's distributed readme
========================

From ``$VIMRUNTIME/ftplugin/README.txt`` in Vim 8.1.

The ftplugin directory is for Vim plugin scripts that are only used for a
specific filetype.

All files ending in .vim in this directory and subdirectories will be sourced
by Vim when it detects the filetype that matches the name of the file or
subdirectory.
For example, these are all loaded for the `c` filetype:

	``c.vim``
	``c_extra.vim``
	``c/settings.vim``

Note that the ``_`` in ``c_extra.vim`` is required to separate the filetype name
from the following arbitrary name.

The filetype plugins are only loaded when the `:filetype plugin` command has
been used.

The default filetype plugin files contain settings that 95% of the users will
want to use.  They do not contain personal preferences, like the value of
`shiftwidth`.

If you want to do additional settings, or overrule the default filetype
plugin, you can create your own plugin file.  See `:help ftplugin` in Vim.

Guards
-------

I don't know what I'm doing wrong but when I prepend the files in this directory
with the standard::

   if exists("b:did_ftplugin")
      finish
   endif
   let b:did_ftplugin = 1

That file immediately stops executing anything. So are my ftplugins being loaded
after the ones in ``$VIMRUNTIME``? Why?

.. seealso::

   RESTRUCTURED TEXT			*rst.vim* *ft-rst-syntax*
   he rst.vim or ft-rst-syntax or syntax 2600.

.. admonition:: g:rst_syntax_code_list

   Don't put bash instead of sh.
   $VIMRUNTIME/syntax/rst.vim iterates over this var and if it can't find a
   bash.vim syntax file it will crash.

