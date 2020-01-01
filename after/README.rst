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

``&isfname`` and ``&iskeyword``
================================

Before FZF. I had way too much trouble getting these 2 set right for python
files.

``&isfname`` dictates what files are looked up in the ``&path`` variable.
This dictates a HUGE number of things, like what paths are considered
for ``:find`` and the ``gf`` family of mappings.

By adding a period to this variable, Vim knows to include it when looking for
python imports.

So something like:

.. code-block:: python

   from IPython.core.interactiveshell ...

Would count as 1 word rather than 3. By setting::

   setlocal includeexpr=substitute(v:fname,'\\.','/','g')
   setlocal suffixesadd=.py

We convert the periods to forward-slashes, and search the path for a file named
IPython/core/interactiveshell.py.

Perfect!

However, I didn't want to skip :kbd:`.` as a word delimiter. When using
:kbd:`w` and :kbd:`e` to move around, if a period is not considered as a word
delimiter, it becomes very easy to skip over way too much of a word.

Therefore ``&iskeyword`` needed to remove the period. Then w and e behave
normally while still allowing every feature in Vim related to the path to work.

Tldr
----

From my ftplugin for python files :file:`<after/ftplugin/python.vim>`_.::

   " YES I FINALLY GOT THIS RIGHT! In order to search the path with gf but still
   " stop when on '.' when using keys like w and e, add . period isfname, don't
   " add it to iskeyword. Jesus Christ I swear I've tried every iteration and
   " then had git unset it a dozen times.
   setlocal isfname+=.
   setlocal isk-=.

.. todo::
   from .thisdir import something
   is broken as it changes the single . to a / need to implement if only .[a-z]
   then ./


FZF Mappings
============

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


Special Shout Out to netrw
============================

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


Coc Inspiration
---------------

Here's a butt-ton of functions to map to AND commands to write.

Btw I wanna just state how well a ``:Tabularize /:`` just worked right now like wow.

n  <Plug>(coc-refactor) *              : <C-U>call       CocActionAsync('refactor')<CR>
n  <Plug>(coc-command-repeat) *        : <C-U>call       CocAction('repeatCommand')<CR>
n  <Plug>(coc-float-jump) *            : <C-U>call       coc#util#float_jump()<CR>
n  <Plug>(coc-float-hide) *            : <C-U>call       coc#util#float_hide()<CR>
n  <Plug>(coc-fix-current) *           : <C-U>call       CocActionAsync('doQuickfix')<CR>
n  <Plug>(coc-openlink) *              : <C-U>call       CocActionAsync('openLink')<CR>
n  <Plug>(coc-references) *            : <C-U>call       CocAction('jumpReferences')<CR>
n  <Plug>(coc-type-definition) *       : <C-U>call       CocAction('jumpTypeDefinition')<CR>
n  <Plug>(coc-implementation) *        : <C-U>call       CocAction('jumpImplementation')<CR>
n  <Plug>(coc-declaration) *           : <C-U>call       CocAction('jumpDeclaration')<CR>
n  <Plug>(coc-definition) *            : <C-U>call       CocAction('jumpDefinition')<CR>
n  <Plug>(coc-diagnostic-prev-error) * : <C-U>call       CocActionAsync('diagnosticPrevious', 'error')<CR>
n  <Plug>(coc-diagnostic-next-error) * : <C-U>call       CocActionAsync('diagnosticNext',     'error')<CR>
n  <Plug>(coc-diagnostic-prev) *       : <C-U>call       CocActionAsync('diagnosticPrevious')<CR>
n  <Plug>(coc-diagnostic-next) *       : <C-U>call       CocActionAsync('diagnosticNext')<CR>
n  <Plug>(coc-diagnostic-info) *       : <C-U>call       CocActionAsync('diagnosticInfo')<CR>
n  <Plug>(coc-format) *                : <C-U>call       CocActionAsync('format')<CR>
n  <Plug>(coc-format-selected) *       : <C-U>set        operatorfunc=<SNR>39_FormatFromSelected<CR>g@
n  <Plug>(coc-rename) *                : <C-U>call       CocActionAsync('rename')<CR>
n  <Plug>(coc-codeaction) *            : <C-U>call       CocActionAsync('codeAction',         '')<CR>
n  <Plug>(coc-codeaction-selected) *   : <C-U>set        operatorfunc=<SNR>39_CodeActionFromSelected<CR>g@
v  <Plug>(coc-codeaction-selected) *   : <C-U>call       CocActionAsync('codeAction',         visualmode())<CR>
v  <Plug>(coc-format-selected) *       : <C-U>call       CocActionAsync('formatSelected',     visualmode())<CR>
n  <Plug>(coc-codelens-action) *       : <C-U>call       CocActionAsync('codeLensAction')<CR>
n  <Plug>(coc-range-select) *          : <C-U>call       CocAction('rangeSelect',     '', v                     : true)<CR>
v  <Plug>(coc-range-select-backword) * : <C-U>call       CocAction('rangeSelect',     visualmode(), v           : false)<CR>
v  <Plug>(coc-range-select) *          : <C-U>call       CocAction('rangeSelect',     visualmode(), v           : true)<CR>

Also check out these git ones!

<Plug>(coc-git-chunk-inner)  <Plug>(coc-git-chunkinfo)    <Plug>(coc-git-nextchunk)
<Plug>(coc-git-chunk-outer)  <Plug>(coc-git-commit)       <Plug>(coc-git-prevchunk)

