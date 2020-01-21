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


Difference between ``&isfname`` and ``&iskeyword``
==================================================

This just happened to me so I suppose it'd be a good idea to jot it down.

What's the difference between these 2 options?

``iskeyword`` is used for movements like :kbd:`w`, :kbd:`e` and many other
things on top of it.

``isfname`` is used for includes, defines, and paths. While that sounds really
C specific, for a Vim user with reasonable ftplugin specific configurations,
``:find`` is a more convenient way to navigate than ``:e`` and :kbd:`gf` is
a completely necessary part of my workflow these days.

In my reStructured text ftplugin, I added :kbd:`.` to ``iskeyword`` in order
to have dotted packages, *I.E. IPython.core.interactiveshell*, recognized
as 1 word.


Vim Filetype Plugin
====================

Some folding is now supported with :envvar:`VIMRUNTIME`\/syntax/vim.vim::

   " g:vimsyn_folding == 0 or doesn't exist: no syntax-based folding
   " g:vimsyn_folding =~ 'a' : augroups
   " g:vimsyn_folding =~ 'f' : fold functions
   " g:vimsyn_folding =~ 'P' : fold python   script

   let g:vimsyn_folding = 'afP'

Worked really well however caused a noticeable slowdown on startup.

.. note::
   The actual increase in startuptime was relatively small; however,
   in the grand scheme of things it's too annoying that 50%+ of vim's
   startuptime is spent on syntax highlighting and folding rather than the
   40+ plugins being loaded at any time.
   As a result syntax based highlighting got disabled.


Allows users to specify the type of embedded script highlighting they want
(perl/python/ruby/tcl support)::

   " g:vimsyn_embed == 0   : don't embed any scripts
   " g:vimsyn_embed =~# 'l' : embed lua
   " g:vimsyn_embed =~# 'm' : embed mzscheme
   " g:vimsyn_embed =~# 'p' : embed perl
   " g:vimsyn_embed =~# 'P' : embed python
   " g:vimsyn_embed =~# 'r' : embed ruby
   " g:vimsyn_embed =~# 't' : embed tcl
   let g:vimsyn_embed = 'P'


Disabling Autocommands
======================
Oct 16, 2019:
The number of autocommands in the plugin vim-markdown is crazy.

**ALL BufEnters, WinEnters, BufLeaves, InsertLeave, InsertEnters.**

It's a filetype specific plugin why does it need to refresh the syntax in EVERY BUFFER????
To top it off, I don't think his syntax file is written correctly. I fixed
the first few lines where he checks for ``b:did_syntax`` incorrectly, and
markdown files went from loading in 600ms to 500. *sigh*.

To clear them I used::

  if exists('#Mkd')
    au! Mkd
  endif

.. warning::
   Don't condense that down to 1 line! autocmds can not have other commands
   following them

The following won't work.::

  if exists('#Mkd') | au! Mkd | endif

And in case you were wondering yes::

   exists('#autocmd group')

is the syntax used here.

