.. _nvim-readme:

README
========

:Author: Faris Chugthai
:Date: 02/03/2019

Directory Layout and Runtimepath
---------------------------------

How are the folders in a neovim directory tree supposed to be laid out?

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
~~~~~~~~

How does sourcing ftdetect work?

Ftplugin
~~~~~~~~

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
~~~~~~

Similar thing with `after/syntax`_. We also have a fair number of files in `syntax`_

We should probably set up some kind of guard so that it doesn't source a dozen
times.

.. _`after/ftplugin/gitcommit.vim`: after/ftplugin/gitcommit.vim
.. _`after/ftplugin/`: after/ftplugin/
.. _`after/syntax/`: after/syntax/
.. _`syntax/`: syntax/
