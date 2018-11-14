This directory contains the snippets for UltiSnips.

:URL: https://github.com/sirver/ultisnips

Notes on Ultisnips
=======================

And now this file contains my UltiSnips notes. It was really overwhelming
my python snippets file so I figured why not consolidate them here?

At the end of the line::

    snippet triggerword <description> <options>

We have a few options to choose from.

== ============================================================================
s   Remove whitespace immediately before the cursor at the end of a line
    before jumping to the next tabstop.  This is useful if there is a
    tabstop with optional text at the end of a line.
== ============================================================================
t   Do not expand tabs - If a snippet definition includes leading tab
    characters, by default UltiSnips expands the tab characters honoring
    the Vim 'shiftwidth', 'softtabstop', 'expandtab' and 'tabstop'
    indentation settings. (For example, if 'expandtab' is set, the tab is
    replaced with spaces.) If this option is set, UltiSnips will ignore the
    Vim settings and insert the tab characters as is. This option is useful
    for snippets involved with tab delimited formats.
== ============================================================================


**Important tip!**:
    Write a good description for each snippet. When there are multiple to choose
    from the only help you'll get is what you write the description you make.
    So make it clear what the difference between
    ``snippet argprse`` and ``snippet argprser`` are in the description!


Configuration
---------------------------------------------------

After configuring ``g:UltiSnipsDirs`` and g:UltiSnipsDirectories as you would like,
using the UltiSnipsEdit command should open the folder that your snippets
are housed in.


Usage
-----

Memorizing your snippet's names is awful so make sure you have fzf.vim installed
and run Snippets to see all snippets configured for the filetype.

Now let's look at a snippet.


.. code-block:: python

    snippet imp "import statement" b
        import ${0:module}
    endsnippet


That b at the end is an option that means 'must be at the beginning of line'.

There are a few places where it's invoked in the snippets, but unnecessarily

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
