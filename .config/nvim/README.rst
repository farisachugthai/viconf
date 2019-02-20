README
========

:Author: Faris Chugthai
:Date: 02/09/2019

To say vim has a lot of options, associated files and directories is an
understatement. But these can be broken down piece by piece to be more
easily digestible.

First I'll go over setting basic options.

Options
---------
The first and most obvious file is the :doc:`init.vim`. We can setup
the base options like so:

+--------------------------+----------------+
| Options                  |                |
|                          |                |
| .. code-block:: vim      |                |
|                          |                |
|    :let OPTION_NAME = 1  | Enable option  |
+--------------------------+----------------+
|    :let OPTION_NAME = 0  | Disable option |
+--------------------------+----------------+
|                          |                |
|                          |                |
| Continuation of settings |                |
+--------------------------+----------------+

let vs. set
~~~~~~~~~~~~
For anything but the most basic commands, let is always preferable.

``set`` allows one to set useful configurations and is easier to read than
some corresponding ``let`` statements, but it only allows one to
define a variable to one literal value.

``let`` allows for scoping variables, and as Vim has an incredibly unintuitive
system for coercing types, this will frequently come in handy.

Whitespace in Options
~~~~~~~~~~~~~~~~~~~~~
The ``set`` command is whitespace sensitive which can become quickly
cumbersome. The ``let`` command, in comparison, is not as strict.

It's absolutely still whitespace sensitive, but
``let`` allows for whitespace before and after the operator.

How do we utilize ``let`` for a built-in vim variables?

.. code-block:: vim

    let &grepprg = 'ag --nogroup --nocolor --column --vimgrep $*'

By prepending `&` to the variable, Vim knows we're modifying the value of
a variable it recognizes and not defining our own. The single quotes are
still required; however I find this more manageable than adding a `\\``
before every single space.

Directory Layout and Runtimepath
---------------------------------
How are the folders in a :mod:`pynvim` neovim directory tree supposed to be
laid out?

While each directory serves a specific purpose, depending on use case, not
all need to be created and used.

The variable of importance is ``runtimepath``. The varying
directories all affect how different settings are recorded and in what order
the code is ran.

Runtimepath
~~~~~~~~~~~


Ftdetect
^^^^^^^^^^
How does writing an ftdetect file work?
What necessary guards are there?

Ftplugin
^^^^^^^^^^
Ftplugin files should be used to totally override the configuration
neovim has built-in for a certain filetype.

You either have to be **THAT** discontent with it, or willing to simply
copy and paste the original and then add your own modifications in.

The standard ftplugin files on a Linux system are found in the
`runtime directory </usr/share/nvim/runtime>`_ in the
`ftplugin section </usr/share/nvim/runtime/ftplugin/`_.

In lieu of doing all of that, `after/ftplugin`_ simply builds on the
configuration that comes built in the with editor.

.. note:: Guards

    This is only true if you put ftplugin guards in your configs.
    However, you absolutely should.

As a result, we won't put the
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
Similar thing with `after/syntax`_. We also have a fair number of files in
`syntax`_

.. todo::

    We should probably set up some kind of guard so that it doesn't source
    a dozen times.


Working with Plugins
^^^^^^^^^^^^^^^^^^^^^
Vim Plug is a highly recommended plugin manager, and the one that I myself use.

Written by Junegunn Choi (also the author of FZF), vim-plug creates a simple way of interacting with plugins.

Beyond the basic commands you can read about in his README, vim-plug has
an API that exports the command ``plug``. This command utilizes vimscript to
return a dictionary with all of your currently loaded plugins.

This dict maintains the order that the plugins were loaded into the buffer and
can be accessed with

.. code-block:: vim

   echo keys(plugs)

This feature proves phenomenally useful in a handful of situations.

For example, one may want to check whether a ftplugin was lazily loaded.

In addition, one could be in the situation where they may have
different configuration files on different devices, and would like to
check whether a plugin was installed. It's also good for debugging and
seeing in what order a plugin loads.

For plugins that are dependent on each other, like how deoplete-jedi depends on
Jedi, this can help startuptimes and remedy unexpected behavior.


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
Ensure that mappings use the ``<Cmd>`` idiom in place of :kbd:`<C-o>` for insert
mode or :kbd:`<C-u>` for visual mode.

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
