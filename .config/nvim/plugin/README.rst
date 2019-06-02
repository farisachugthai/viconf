.. _plugin-README:

======
README
======

:date: 05/24/2019

.. highlight:: vim

Common Vim Naming Conventions
=============================

Just making a short mental note that it's common convention to use
let ``g:loaded_plugin_name`` when writing a guard for a plugin.

It's common convention to use ``b:did_*`` for the indent, syntax and ftplugin.

For example, an rst filetype plugin doesn't need the var to be named
``b:did_rst_ftplugin``. The variable is buffer-local so it's implied what the
``&ft`` is and if not then you can check that ``&var`` right there.

Regardless, I'm going to keep doing that since you regularly see more than one
ftplugin in the output of `:scriptnames`.

In directories where it makes sense to load more than one file, like `syntax`_,
adding var names will probably pay dividends.

.. _syntax: ../syntax

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
