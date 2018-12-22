README
========
:Author: Faris Chugthai <farischugthai.gmail.com>
:Date: 12/21/2018

Directory Layout
-----------------

How are the folders in a neovim directory tree supposed to be laid out?

While each directory serves a specific purpose, depending on use case, not all
need to be employed.

The first and most obvious file is the :module:`init.vim`. We can setup the base
options like so:

+-------------------------------------------------------------+
|" Options                  |                                 |
|" =========================|                                 |
|                           |                                 |
|.. code-block:: vimscript                                    |
|                                                             |
|    :let OPTION_NAME = 1   | Enable option                   |
|    :let OPTION_NAME = 0   | Disable option                  |
|                           |                                 |
|                           |                                 |
|" Continuation of settings |                                 |
+-------------------------------------------------------------+

Here's a follow up explanation that goes into more of the details

Ftplugin should be used to totally override the built-in ftplugin. You either
have to be THAT discontent with it, or simply copy and paste it and then
add your own modifications in.

However after/ftplugin works better for that. As a result, we won't put the
usual ftplugin guard in there. However, we should do something to ensure
that buffers of a different filetype don't source everything in after/ftplugin.

For example, let's say we were in after/ftplugin/gitcommit.vim

Something like this pseudo code would be perfect::

    ``if ft != None && ft != gitcommit | finish | endif``

Then put that in everything in that dir.

Similar thing with after/syntax. We also have a fair number of files in syntax/

We should probably set up some kind of guard so that it doesn't source a dozen
times.

And how does sourcing ftdetect work? Because everything in my ftdetect always
shows up in `:scriptnames`.

Need to see how :var:`$VIMRUNTIME` implements this.
