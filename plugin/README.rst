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
I can't recommend `Tom Ryder's writing enough
<https://vimways.org/2018/from-vimrc-to-vim>`_


Common Vim Naming Conventions
=============================

Just making a short mental note that it's common convention to use
``let g:loaded_plugin_name`` when writing a guard for a plugin.

It's common convention to use ``b:did_ftplugin`` for a specific ftplugin,
and similarly named guards for the indent and syntax directories.

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

I found this in `after/plugin/vim-commentary.vim`_ but ... why? So I want
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

.. caution:: You actually won't reload it in any situation.


So there's actually no need anymore to define functions as::

   function! VimFoo() abort

And it'd actually possibly be better to define it without the :kbd:`!`.

We would want an error if that go re-sourced and re-defined.


Writing Plugins on NT systems
==============================

From ``:he source_crnl``

.. are you allowed to do that for a directive?

.. code-block:: help

   Windows: Files that are read with ":source" normally have <CR><NL> <EOL>s.
   These always work.  If you are using a file with <NL> <EOL>s (for example, a
   file made on Unix), this will be recognized if 'fileformats' is not empty and
   the first line does not end in a <CR>.  This fails if the first line has
   something like ":map <F1> :help^M", where "^M" is a <CR>.  If the first line
   ends in a <CR>, but following ones don't, you will get an error message,
   because the <CR> from the first lines will be lost.

   On other systems, Vim expects ":source"ed files to end in a <NL>.  These
   always work.  If you are using a file with <CR><NL> <EOL>s (for example, a
   file made on Windows), all lines will have a trailing <CR>.  This may cause
   problems for some commands (e.g., mappings).  There is no automatic <EOL>
   detection, because it's common to start with a line that defines a mapping
   that ends in a <CR>, which will confuse the automaton.

**tl;dr** Always use ff=unix ffs=unix,dos even on NT.


Debugging FZF
==============

Here are 2 commands I'm still actively working on.::

   " Doesn't work
   command! -bang -nargs=* -complete=file_in_path FZRgFind
         \ call fzf#vim#grep(
         \ 'rg --no-heading --smart-case --no-messages ^ '
         \ . shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview({'dir': system('git rev-parse --show-toplevel 2&>/dev/null')[:-2]}, 'up:60%')
         \ : fzf#vim#with_preview({'dir': system('git rev-parse --show-toplevel 2&>/dev/null')[:-2]}, 'right:50%:hidden', '?'),
         \ <bang>0)

   " Damn still doesn't work
   command! -bang -nargs=* -complete=file_in_path FZFind
         \ call fzf#vim#grep(
         \ 'rg --no-heading --smart-case --no-messages ^ '
         \ . shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%')
         \ : fzf#vim#with_preview('right:50%:hidden', '?'),
         \ <bang>0)
   " Grep: {{{2


Working with tags
==================

In the opposite vein of unimpaired (as unimpaired uses keybindings of the
flavor :kbd:`]` :kbd:`[a-z]`), I just found the keybinding :kbd:`g]`!

It's phenomenally useful but because of unimpaired I'm inclined to remember it
as ]g instead of g].

However that's not hard to fix!::

   nnoremap ]g g]
   nnoremap ]g g]

Then I began reviewing tagsrch.txt. And wow.::

                                                           *g]*
   g]			Like CTRL-], but use ":tselect" instead of ":tag".

                                                           *v_g]*
   {Visual}g]		Same as "g]", but use the highlighted text as the
                           " identifier.

                                                           *:tj* *:tjump*
   :tj[ump][!] [name]	Like ":tselect", but jump to the tag directly when
                           there is only one match.

                                                           *:stj* *:stjump*
   :stj[ump][!] [name]	Does ":tjump[!] [name]" and splits the window for the
                           selected tag.

                                                           *g_CTRL-]*
   g CTRL-]		Like CTRL-], but use ":tjump" instead of ":tag".

So let's do better than g]!::

   nnoremap ]g <Cmd>stjump!<CR>
   xnoremap ]g <Cmd>stjump!<CR>


.. note::
   The <Cmd> pseudo-mapping is only available on Neovim.


ALE --- Asynchronous Lint Engine
================================

By default ale uses location lists.

Location lists are tied to the window they were created for, not the
entire session as the quickfix list is. Because commands like ``:lwindow`` and ``:lopen`` are window
specific, you only see linting information for your current buffer to populate the list.

If ALE were to use the quickfix, you would see linting information for
every buffer you have open simultaneously, which would be a nightmare.

More importantly, you don't want every buffer to wipe your quickfix list
while you're in the middle of actually recompiling something
simply to view a few linter errors.

Quickfix
==========

See :file:`./buffers.vim` for the Quickfix_Mappings function,
