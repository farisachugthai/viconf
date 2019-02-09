.. _nvim-readme:

README
========

:Author: Faris Chugthai
:Date: 02/09/2019


Directory Layout and Runtimepath
---------------------------------

How are the folders in a :mod:`pynvim`/neovim directory tree supposed to be
laid out?

There are a few time tested design patterns that we can learn here.

While each directory serves a specific purpose, depending on use case, not all
need to be employed.

The first and most obvious file is the :module:`init.vim`. We can setup the base
options like so:

+--------------------------+----------------+
| Options                  |                |
|                          |                |
| .. code-block:: vim      |                |
|                          |                |
|    :let OPTION_NAME = 1  | Enable option  |
|    :let OPTION_NAME = 0  | Disable option |
|                          |                |
|                          |                |
| Continuation of settings |                |
+--------------------------+----------------+

Here's a follow up explanation that goes into more of the details.

The variable of importance is ``runtimepath``. The varying directories all
affect how different settings are recorded and in what order the code is ran.


Ftdetect
^^^^^^^^^^

How does sourcing ftdetect work?


Ftplugin
^^^^^^^^^^

Ftplugin should be used to totally override the built-in ftplugin. You either
have to be THAT discontent with it, or simply copy and paste it and then
add your own modifications in.

However `after/ftplugin`_ works better for that. As a result, we won't put the
usual ftplugin guard in there. However, we should do something to ensure
that buffers of a different filetype don't source everything in
`after/ftplugin`_.

For example, let's say we were in `after/ftplugin/gitcommit.vim`_

Something like this pseudo code would be perfect.

.. code-block:: vim

    ``if ft != None && ft != gitcommit | finish | endif``

Then put that in everything in that dir.


Syntax
^^^^^^^

Similar thing with `after/syntax`_. We also have a fair number of files in `syntax`_

We should probably set up some kind of guard so that it doesn't source a dozen
times.


Working with Plugins
^^^^^^^^^^^^^^^^^^^^^

Vim Plug is a highly recommended plugin manager, and it has an API that exports
the command ``plug``. This command returns a dictionary with a JSON encoded list
of all of your currently loaded plugins.

This feature proves phenomenally useful in situations where you may have
different configuration files, and would like to check whether a plugin was


Spell Files
^^^^^^^^^^^^

On the TODO list.

- Cleanup script for autocorrect.vim and spell files.
    - Luckily vim already has this functionality!

From the help docs

.. topic:: Spellfile Cleanup

    SPELLFILE CLEANUP         *spellfile-cleanup*

    The |zw| command turns existing entries in 'spellfile' into comment lines.
    This avoids having to write a new file every time, but results in the file
    only getting longer, never shorter.  To clean up the comment lines in all
    ".add" spell files do this:

    `:runtime spell/cleanadd.vim`

    This deletes all comment lines, except the ones that start with "##".  Use
    "##" lines to add comments that you want to keep.

    You can invoke this script as often as you like.  A variable is
    provided to skip updating files that have been changed recently.  Set
    it to the number
    of seconds that has passed since a file was changed before it will be
    cleaned. For example, to clean only files that were not changed in the last
    hour:

    `let g:spell_clean_limit = 60 * 60`

    The default is one second.


Mappings
---------

Ensure that mappings use the `<Cmd>` idiom in place of <C-o> for insert
mode or <C-u> for visual mode.

.. topic:: Map cmd

    :map-cmd
                            *<Cmd>* *:map-cmd*
    The <Cmd> pseudokey may be used to define a 'command mapping', which executes
    the command directly (without changing modes, etc.).  Where you might use
    :...<CR>" in the {lhs} of a mapping, you can instead use '<Cmd>...<CR>'.

    This is more flexible than `:<C-U>` in visual and operator-pending mode, or
    `<C-O>:` in insert-mode, because the commands are executed directly in the
    current mode (instead of always going to normal-mode).  Visual-mode is
    preserved, so tricks with |gv| are not needed.  Commands can be invoked
    directly in cmdline-mode (which otherwise would require timer hacks).

    Because <Cmd> avoids mode-changes (unlike ":") it does not trigger
    |CmdlineEnter| and |CmdlineLeave| events. This helps performance.

    Unlike <expr> mappings, there are no special restrictions on the <Cmd>
    command: it is executed as if an (unrestricted) |autocmd| was invoked or an
    async event event was processed.


.. _`after/ftplugin/gitcommit.vim`: after/ftplugin/gitcommit.vim
.. _`after/ftplugin/`: after/ftplugin/
.. _`after/syntax/`: after/syntax/
.. _`syntax/`: syntax/
