README
======

This directory contains the snippets for `UltiSnips`_.

.. _`UltiSnips`: https://github.com/sirver/ultisnips

Notes on Ultisnips
=======================

And now this file contains my UltiSnips notes. It was really overwhelming
my python snippets file so I figured why not consolidate them here?

At the end of the line::

   snippet triggerword <description> <options>

Configuration
----------------

First things first, UltiSnips needs to be configured for snippets to work
correctly. The 2 most important variables to set are ``g:UltiSnipsDirs``
and ``g:UltiSnipsDirectories`` as they tell UltiSnips where to look for
your snippets.

.. todo Mention that usp can't be snippets and explain why usps is set to 0

After configuring ``g:UltiSnipsDirs`` and ``g:UltiSnipsDirectories`` as you
would like, using the `UltiSnipsEdit` command should open the folder that your
snippets are housed in.

Options
--------

We have a few options to choose from when defining snippets. They are as follows:

Snippets Options
^^^^^^^^^^^^^^^^^^

The following are options to modify the way that snippets behave. My most
commonly used options are::

    b Only expand a snippet if it is the only text on the line
    ...


   s  Remove whitespace immediately at the end of a line after skipping over a
      tabstop. This is useful if there is a
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

Important Considerations:
^^^^^^^^^^^^^^^^^^^^^^^^^^

 Write a clear description for every single snippet. Whlie this may sound
 tedious, it pays massive dividends. When there are multiple snippets to
 choose from the only help you'll get is what you write the description you
 make. So make it clear what the difference between
 ``snippet argprse`` and ``snippet argprser`` are in the description!

Do not use the 'b' option for snippets that could be expanded after a comment
For example, in :ref:`vim.snippets`, the header snippet is regularly text
that has already been written and is commented out. With the ``b`` option, a
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

Make sure you have `https://www.github.com/junegunn/fzf.vim`_ installed.
I absolutely love this plugin and it's endless configurability.

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

For persistent changes use 'extends {filetype to be added}' at the top of the
snippets file you would like extending the target.

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

.. note did the keyboard trick work?

<kbd>M-u</kbd> isn't bound to anything in insert mode; however,
it is bound to delete a fairly large amount of text in normal mode.

Be careful of that, and possibly disable it by remapping it to <nop>.

Programmatic Editing
--------------------

Vim's Search and Replace
~~~~~~~~~~~~~~~~~~~~~~~~

Frequently I ran into the problem of snippets having the 'b' option
unnecessarily and sometimes to a detrimental effect.

As a result, I determined that a relatively quick way to fix those options was
to utilize Vim's built in "search and replace" functions.

First, one must visually select the snippets of interest.
Pressing <kbd>Shift</kbd><kbd>v</kbd> and then using <kbd>j</kbd><kbd>k</kbd>
as necessary will suffice.


.. code:: vim
   '<,'>s/ b$/sw/gc

The command above limits the search to the visually selected area as indicated
by '<,'>. `s` is the search command. Then we move to the text to find.

/<Space>b$

This indicates that if there is one preceding whitespace, the letter b, and an
end of line character, find it and delete it.

/sw

Replace the text with sw. You may choose any option you find useful.

/gc

`g` simply indicates to Vim to replace all instances of `<Space>b$`. It's not
necessary here; however, it's a good habit to get into.

`c` means "require confirmation. Once again, not necessary but a good habit to
get into.

UltiSnips Patterns
~~~~~~~~~~~~~~~~~~

One of the more useful idioms I've stumbled upon is the snippet

.. code:: vim

   snippet foo
   ${0:{$VISUAL:placeholder text}}
   endsnippet

This allows one to either select text in visual mode and then expand the
snippet, or simply expand the snippet and fill in the tabstop.

If the placeholder text is sufficiently helpful, then this'll greatly
aide any writing one is doing.

The following 2 commands allow for quick substitutions in order to
more closely resemble the desired snippets.

.. code:: vim

   :'<,'>s/${1/${0:${VISUAL/
   :'<,'>s/}$/}}/

Roadmap
-------

That feels a lot nicer than **THE WALL OF TODOS** doesn't it?

In the file `python.snippets`_, the last snippet is a postfix.

Here's an example snippet for you to hack away at.

.. code::

   if:
      # pre-expand
      var.if<Tab>

      # post-expand
      if(var):

So if you get to the end of the expression, then insert

.. code:: html

   <kbd>.</kbd>if<kbd><Tab></kbd>

It'll expand to a regular if statement. You could make similar expressions with
`ifn` and `ifnn` expanding to `if var is None` or `if var is not None`.


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

.. _`https://www.github.com/junegunn/fzf.vim`: https://www.github.com/junegunn/fzf.vim
