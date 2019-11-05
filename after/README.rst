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


Special Shoutout to netrw
-------------------------

I had no idea you could do this.

.. todo:: can you use help as an identifier for the code directive?

.. sourcecode:: help

   * One may mark files with the cursor atop a filename and
    then pressing "mf".

   * With gvim, in addition one may mark files with
    <s-leftmouse>. (see |netrw-mouse|)

   * One may use the :MF command, which takes a list of
    files (for local directories, the list may include
    wildcards -- see |glob()|) >

          :MF *.c
   <
    (Note that :MF uses |<f-args>| to break the line
    at spaces)

   * Mark files using the |argument-list| (|netrw-mA|)

   * Mark files based upon a |location-list| (|netrw-qL|)

   * Mark files based upon the quickfix list (|netrw-qF|)
    (|quickfix-error-lists|)

   The following netrw maps make use of marked files:

   |netrw-a|	Hide marked files/directories
   |netrw-D|	Delete marked files/directories
   |netrw-ma|	Move marked files' names to |arglist|
   |netrw-mA|	Move |arglist| filenames to marked file list
   |netrw-mb|	Append marked files to bookmarks
   |netrw-mB|	Delete marked files from bookmarks
   |netrw-mc|	Copy marked files to target
   |netrw-md|	Apply vimdiff to marked files
   |netrw-me|	Edit marked files
   |netrw-mF|	Unmark marked files
   |netrw-mg|	Apply vimgrep to marked files
   |netrw-mm|	Move marked files to target
   |netrw-mp|	Print marked files
   |netrw-ms|	Netrw will source marked files
   |netrw-mt|	Set target for |netrw-mm| and |netrw-mc|
   |netrw-mT|	Generate tags using marked files
   |netrw-mv|	Apply vim command to marked files
   |netrw-mx|	Apply shell command to marked files
   |netrw-mX|	Apply shell command to marked files, en bloc
   |netrw-mz|	Compress/Decompress marked files
   |netrw-O|	Obtain marked files
   |netrw-R|	Rename marked files

