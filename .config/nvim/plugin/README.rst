.. _plugin-README:

README
======

:date: 05/24/2019

.. highlight:: vim

Just making a short mental note that it's common convention to use
let ``g:loaded_plugin_name`` when writing a guard for a plugin.

It's common convention to use ``b:did_*`` for the indent, syntax and ftplugin.

For example, an rst filetype plugin doesn't need the var to be named
``b:did_rst_ftplugin``. The variables buffer-local so it's implied what the
``&ft`` is *and if not then you can check that ``&var`` right there.*

Regardless, I'm going to keep doing that since you regularly see more than one
ftplugin in scriptnames.

In directories where it makes sense to load more than one file, like syntax,
adding var names will probably pay dividends.
