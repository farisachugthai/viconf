.. _colors_readme:

=================================
README.txt for color scheme files
=================================

.. _colors_quick_start:

Quick Start
------------
Found this file in `$VIMRUNTIME/colors/README.txt`_

Formatted it to reStructured text formatting but figured it'd be nice to have.

These files are used for the ``:colorscheme`` command.  They appear in the
Edit/Color Scheme menu in the GUI.

Hints for writing a color scheme file:
--------------------------------------
There are two basic ways to define a color scheme.

1. Define a new Normal color and set the `background` option accordingly.

.. code-block:: vim

	set background={light or dark}
	highlight clear
	highlight Normal ...
	...

2. Use the default `Normal` color and automatically adjust to the
   value of `background`.

.. code-block:: vim

	highlight clear Normal
	set background&
	highlight clear
	if &background == "light"
	  highlight Error ...
	  ...
	else
	  highlight Error ...
	  ...
	endif

You can use ``:highlight clear`` to reset everything to the defaults, and then
change the groups that you want differently.  This also will work for groups
that are added in later versions of Vim.

Note that ``:highlight clear`` uses the value of `background`, thus set it
before this command.

Some attributes (e.g., `bold`) might be set in the defaults that you want
removed in your color scheme.  Use something like `gui=NONE` to remove the
attributes.

In case you want to set `background` depending on the colorscheme selected,
this autocmd might be useful

.. code-block:: vim

     autocmd SourcePre */colors/blue_sky.vim set background=dark

     " Replace "blue_sky" with the name of the colorscheme.

In case you want to tweak a colorscheme after it was loaded, check out the
`ColorScheme` autocommand event.

To clean up just before loading another colorscheme, use the `ColorSchemePre`
autocommand event.  For example:

.. code-block:: vim

   let g:term_ansi_colors = ...
   augroup MyColorscheme
      au!
      au ColorSchemePre * unlet g:term_ansi_colors
      au ColorSchemePre * au! MyColorscheme
   augroup END

To customize a colorscheme use another name, e.g.  `~/.vim/colors/mine.vim`_,
and use ``:runtime`` to load the original colorscheme

.. code-block:: vim

   " load the "evening" colorscheme
   runtime colors/evening.vim
   " change the color of statements
   hi Statement ctermfg=Blue guifg=Blue

To see which highlight group is used where, find the help for
`highlight-groups` and `group-name`.

You can use ``:highlight`` to find out the current colors.  Exception: the
`ctermfg` and `ctermbg` values are numbers, which are only valid for the current
terminal.  Use the color names instead.  See ``:help cterm-colors``.

The default color settings can be found in the source file `src/syntax.c`_.
Search for `highlight_init`.

Checklist
----------
If you think you have a color scheme that is good enough to be used by others,
please check the following items:

- Source the `<$VIMRUNTIME/colors/tools/check_colors.vim>`_ script to check for
  common mistakes.
- Does it work in a color terminal as well as in the GUI?
- Is ``g:colors_name`` set to a meaningful value?  In case of doubt you can do it this way.

.. code-block:: vim

    let g:colors_name = expand('<sfile>:t:r')


- Is `background` either used or appropriately set to "light" or "dark"?
- Try setting `hlsearch` and searching for a pattern, is the match easy to spot?
- Split a window with `:split` and `:vsplit`.  Are the status lines and vertical separators clearly visible?
- In the GUI, is it easy to find the cursor, also in a file with lots of syntax highlighting?
- Do not use hard coded escape sequences, these will not work in other terminals.  Always use color names or #RRGGBB for the GUI.


Help on ``hi cterm``
---------------------

The different attributes that can be set are:

		bold
		underline
		undercurl	curly underline
		reverse
		inverse		same as reverse
		italic
		standout
		strikethrough
		NONE		no attributes used (used to reset it)

guisp={color-name}					*highlight-guisp*
	These give the foreground (guifg), background (guibg) and special
	(guisp) color to use in the GUI.  "guisp" is used for undercurl
	and underline.
	There are a few special names:
		NONE		no color (transparent)
		bg		use normal background color
		background	use normal background color
		fg		use normal foreground color
		foreground	use normal foreground color
	To use a color name with an embedded space or other special character,
	put it in single quotes.  The single quote cannot be used then.
	Example: >
	    :hi comment guifg='salmon pink'
<
							*gui-colors*
	Suggested color names (these are available on most systems):
	    Red		LightRed	DarkRed
	    Green	LightGreen	DarkGreen	SeaGreen
	    Blue	LightBlue	DarkBlue	SlateBlue
	    Cyan	LightCyan	DarkCyan
	    Magenta	LightMagenta	DarkMagenta
	    Yellow	LightYellow	Brown		DarkYellow
	    Gray	LightGray	DarkGray
	    Black	White
	    Orange	Purple		Violet

	You can also specify a color by its RGB (red, green, blue) values.
	The format is "#rrggbb", where
		"rr"	is the Red value
		"gg"	is the Green value
		"bb"	is the Blue value
	All values are hexadecimal, range from "00" to "ff".  Examples: >
  :highlight Comment guifg=#11f0c3 guibg=#ff00ff
<


Possible nvim specific option
-----------------------------

blend={integer}					*highlight-blend*
	Override the blend level for a highlight group within the popupmenu
	or floating windows. Only takes effect if 'pumblend' or 'winblend'
	is set for the menu or window. See the help at the respective option.


*highlight-groups* *highlight-default*
-------------------------------------------

And remember that tag if you want descriptions for each highlight group
These are the builtin highlighting groups.  Note that the highlighting depends
on the value of 'background'.  You can see the current settings with the
":highlight" command.

