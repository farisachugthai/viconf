.. _after-readme:

===================
Final Modifications
===================

.. highlight:: vim

This is the directory that gets final say on everything.

As a result it contains all configuration files related to plugins I have
installed. In addition, every file will start with a block of guard that follows
the following structure.::

    " Guard: {{{1
    if !has_key(plugs, `plugin_name`)
        finish
    endif

    if exists('g:did_`plugin_name_after_plugin`') || &compatible || v:version < 700
        finish
    endif
    let g:did_`plugin_name_after_plugin` = 1


Filetype plugins are listed for all the filetypes I commonly use.


FZF Mappings
------------

.. gotta give this one to riv wouldn't have been able to make this table otherwise

+------------------+-----------------------------------------------------------+
| Command          | List                                                      |
+------------------+-----------------------------------------------------------+
| Files [PATH]     | Files (similar to ``:FZF``                                |
+------------------+-----------------------------------------------------------+
| `GFiles [OPTS]`  | Git files ( `git ls-files` )                              |
+------------------+-----------------------------------------------------------+
| `GFiles?`        | Git files ( `git status` )                                |
+------------------+-----------------------------------------------------------+
| `Buffers`        | Open buffers                                              |
+------------------+-----------------------------------------------------------+
| `Colors`         | Color schemes                                             |
+------------------+-----------------------------------------------------------+
| `Ag [PATTERN]`   | {ag} ( `ALT-A`  to select all,  `ALT-D`  to deselect all) |
+------------------+-----------------------------------------------------------+
| `Rg [PATTERN]`   | {rg} ( `ALT-A`  to select all,  `ALT-D`  to deselect all) |
+------------------+-----------------------------------------------------------+
| `Lines [QUERY]`  | Lines in loaded buffers                                   |
+------------------+-----------------------------------------------------------+
| `BLines [QUERY]` | Lines in the current buffer                               |
+------------------+-----------------------------------------------------------+
| `Tags [QUERY]`   | Tags in the project ( `ctags -R` )                        |
+------------------+-----------------------------------------------------------+
| `BTags [QUERY]`  | Tags in the current buffer                                |
+------------------+-----------------------------------------------------------+
| `Marks`          | Marks                                                     |
+------------------+-----------------------------------------------------------+
| `Windows`        | Windows                                                   |
+------------------+-----------------------------------------------------------+
| `Locate PATTERN` | `locate`  command output                                  |
+------------------+-----------------------------------------------------------+
| `History`        | `v:oldfiles`  and open buffers                            |
+------------------+-----------------------------------------------------------+
| `History:`       | Command history                                           |
+------------------+-----------------------------------------------------------+
| `History/`       | Search history                                            |
+------------------+-----------------------------------------------------------+
| `Snippets`       | Snippets ({UltiSnips}{8})                                 |
+------------------+-----------------------------------------------------------+
| `Commits`        | Git commits (requires {fugitive.vim}{9})                  |
+------------------+-----------------------------------------------------------+
| `BCommits`       | Git commits for the current buffer                        |
+------------------+-----------------------------------------------------------+
| `Commands`       | Commands                                                  |
+------------------+-----------------------------------------------------------+
| `Maps`           | Normal mode mappings                                      |
+------------------+-----------------------------------------------------------+
| `Helptags`       | Help tags [1]                                             |
+------------------+-----------------------------------------------------------+
| `Filetypes`      | File types                                                |
+------------------+-----------------------------------------------------------+
