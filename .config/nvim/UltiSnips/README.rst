README
======

This directory contains the snippets for UltiSnips.

.. _`UltiSnips`: https://github.com/sirver/ultisnips

Notes on Ultisnips
=======================

And now this file contains my UltiSnips notes. It was really overwhelming
my python snippets file so I figured why not consolidate them here?

At the end of the line::

   snippet triggerword <description> <options>

Options
--------

**TODO**: Get rid of these I never use them.

The following are options to modify the way that snippets behave. My most
commonly used options are::

    b Only expand a snippet if it is the only text on the line
    ...


   s  Remove whitespace immediately before the cursor at the end of a line
      before jumping to the next tabstop.  This is useful if there is a
      tabstop with optional text at the end of a line.

   t  Do not expand tabs - If a snippet definition includes leading tab
      characters, by default UltiSnips expands the tab characters honoring
      the Vim 'shiftwidth', 'softtabstop', 'expandtab' and 'tabstop'
      indentation settings. (For example, if 'expandtab' is set, the tab is
      replaced with spaces.) If this option is set, UltiSnips will ignore the
      Vim settings and insert the tab characters as is. This option is useful
      for snippets involved with tab delimited formats.
   w  Word boundary - With this option, the snippet is expanded if
      the tab trigger start matches a word boundary and the tab trigger end
      matches a word boundary. In other words the tab trigger must be
      preceded and followed by non-word characters. Word characters are
      defined by the 'iskeyword' setting. Use this option, for example, to
      permit expansion where the tab trigger follows punctuation without
      expanding suffixes of larger words.


**Important tip!**:

    Write a clear description for every single snippet. Whlie this may sound
    tedious, it pays massive dividends. When there are multiple snippets to
    choose from the only help you'll get is what you write the description you
    make. So make it clear what the difference between
    ``snippet argprse`` and ``snippet argprser`` are in the description!

Important Considerations
^^^^^^^^^^^^^^^^^^^^^^^^^

Do not use the 'b' option for snippets that could be expanded after a comment
For example, in :ref:`vim.snippets`, the header snippet is regularly text
that has already been written and is commented out. With the `b` option, a
commented out header will not expand.

Usage
-----

I want to go over a few things that initially confused me about UltiSnips, and
how I managed to solve any problems I had with the plugin.

Finding Your Snippets
^^^^^^^^^^^^^^^^^^^^^^^

Memorizing your snippet's names is awful. The vim-snippets repository has
thousands of snippets in it, and the difference between expanding ``def`` and
``deff`` can produce huge differences in output.

Therefore finding available snippets relatively quickly while not getting
bogged down searching for them is imperative.

FZF
^^^^

Make sure you have fzf.vim installed. I absolutely love this plugin and it's
endless configurability.

If you run `:Snippets` on the ex cmdline, FZF will create a window with a
terminal that greps all snippets configured for the filetype.

.. note::

   I personally use Ag, the Silver-Searcher for the backend of FZF. It's substantially
   faster and I've generally found it much more accessible than GNU Grep.

FZF can also be configured to display a preview window peer at the exact
snippet; in addition to the fact that it allows you to write a header! I'd
advise throwing reminders to yourself for useful keybindings.

If you need to extend the available snippets only one time, use
``UltiSnipsAddFileType``.

For persistent changes use 'extends {filetype to be added}'

Now let's look at a snippet.

.. code-block::

    snippet imp "import statement" b
        import ${0:module}
    endsnippet

After typing imp<Tab>, our code will expand to the import expression. Straight
forward enough right? Most editors offer snippet functionality so to avoid
repeating anything that's already in the UltiSnips documentation, I'll gloss
over this part.

The API for UltiSnips is quite interesting, as it exposes
:func:`UltiSnips#ListSnippets()`.

This function displays what snippets you could expand to using a greedy
search through your snippet files. As in, typing "doc" and then running
:func:`UltiSnips#ListSnippets()` will display doc, docs, docstring if
you have them defined. If you've defined the same word in different
snippet files, (I.E. I have doc defined in most snippet files), then
it will display:

   1. (doc) description <File-Location>

Which will indicate to you exactly which filetype it came from.

Vim has spotty handling of the Alt or Meta key; however Neovim handles
it quite gracefully. This leaves a full modifier key that has almost nothing
bound to it, and as a result, I'd recommend binding it in your init.vim
somewhat like this.

.. code:: vim

   inoremap <M-u> call UltiSnips#ListSnippets()<CR>

M-u isn't bound to anything in insert mode; however,
it is bound to delete a fairly large amount of text in normal mode.

Be careful of that, and possibly disable it by remapping it to <nop>.

Configuration
----------------

After configuring ``g:UltiSnipsDirs`` and ``g:UltiSnipsDirectories``
as you would like, using the UltiSnipsEdit command should open the folder that
your snippets are housed in.

From @SirVer himself.

Standing On The Shoulders of Giants
===================================

The snippets have been collected from various other project which I want to
express my gratitude for. My main source for inspiration where the following
two projects:

   TextMate: http://svn.textmate.org/trunk/Bundles/
   SnipMate: http://code.google.com/p/snipmate/

UltiSnips has seen contributions by many individuals. Those contributions have
been merged into this collection seamlessly and without further comments.

-- vim:ft=rst:nospell:
