.. _plugin-README:

=============
User Plugins
=============

:date: 05/24/2019

.. highlight:: vim

Aka the directory for blocks of Vimscript that got too long to justifiably
stay in the `init.vim <../init.vim>`_.

Below are just some notes on how to best work with these files.

Motivation
==========

If you're not sure why you would want to begin breaking up your vimrc,
I can't recommend `Tom Ryder's writing enough`__.

.. __ : https://vimways.org/2018/from-vimrc-to-vim/

Common Vim Naming Conventions
=============================

Just making a short mental note that it's common convention to use
``let g:loaded_plugin_name`` when writing a guard for a plugin.

It's common convention to use ``b:did_ftplugin`` for a specific ftplugin,
and similarly named guards for the indent and syntax directoreis.

Particularly relevant because, for example, an rst filetype plugin doesn't
need the var to be named ``b:did_rst_ftplugin``.

The variable is buffer-local so it's implied what the
``&ft`` is and if not then you can check that ``&var`` right there.

In spite of that I'm going to keep naming the guards this way as 
you regularly see more than one ftplugin in the output of `scriptnames`.

In directories where it makes sense to load more than one file, like `syntax`_,
adding var names will probably pay dividends.

.. _syntax: ../syntax


Autocmd for Vim Commentary
===========================

Also. I found this in `after/plugin/vim-commentary.vim`_ but... why? So I want
to move it in here but I'm not actually sure where.

.. code-block:: vim

   " Should I make it only 1 keybinding? Would make interface easier
   augroup commentary
       autocmd!
       autocmd Filetype python noremap <Leader># ^<Plug>CommentaryLine
       autocmd Filetype javascript noremap <Leader>// ^<Plug>CommentaryLine
       autocmd Filetype vim noremap <Leader>" ^<Plug>CommentaryLine
   augroup END


Function Scoping
=================

If you set a guard at the beginning of a plugin file that reads something
to the effect of::

   " Guard: {{{1
   if exists('g:did_plugin_name') || &compatible || v:version < 700
      finish
   endif
   let g:did_plugin_name = 1

As it's been set globally, we won't reload the file unless we explicitly
`source %` it.

So there's actually no need anymore to define functions as::

   function! VimFoo() abort

And it'd actually possibly be better to define it without the :kbd:`!`.

We would want an error if that go re-sourced and re-defined.
