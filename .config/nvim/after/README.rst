.. _after-readme:

Final Modifications
===================

This is the directory that gets final say on everything.

FZF Mappings
------------

There are so many commands that come with FZF that I'm gonna rebuild his table.
-----------------+--------------------------------------------------------------
Command          | List
-----------------+-------------------------------------------------------------+
 `Files [PATH]`    | Files (similar to  `:FZF` )
 `GFiles [OPTS]`   | Git files ( `git ls-files` )
 `GFiles?`         | Git files ( `git status` )
 `Buffers`         | Open buffers
 `Colors`          | Color schemes
 `Ag [PATTERN]`    | {ag} ( `ALT-A`  to select all,  `ALT-D`  to deselect all)
 `Rg [PATTERN]`    | {rg} ( `ALT-A`  to select all,  `ALT-D`  to deselect all)
 `Lines [QUERY]`   | Lines in loaded buffers
 `BLines [QUERY]`  | Lines in the current buffer
 `Tags [QUERY]`    | Tags in the project ( `ctags -R` )
 `BTags [QUERY]`   | Tags in the current buffer
 `Marks`           | Marks
 `Windows`         | Windows
 `Locate PATTERN`  |  `locate`  command output
 `History`         |  `v:oldfiles`  and open buffers
 `History:`        | Command history
 `History/`        | Search history
 `Snippets`        | Snippets ({UltiSnips}{8})
 `Commits`         | Git commits (requires {fugitive.vim}{9})
 `BCommits`        | Git commits for the current buffer
 `Commands`        | Commands
 `Maps`            | Normal mode mappings
 `Helptags`        | Help tags [1]
 `Filetypes`       | File types
 ------------------------------------------------------------------------------
