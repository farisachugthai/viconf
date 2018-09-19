# TODO

## To get nvim and vim synced up

*Motivation:*

Until I figure out how to get nvim set up as my git difftool, I have to maintain vim.

## To get nvim synced up on Termux and Linux

Because it's agitating not having feature parity.

## Get spell checking set up right

And after that...

## Get ftplugins set up a little more cleanly

Largely a product of still struggling with optimizing settings with respect to
the sequence of elements in 'runtimepath'.

Distinguishing what goes in your ftplugins and your general files.

Whether to put ftplugins in .config/nvim/ftplugin, .config/nvim/after/ftplugin
.local/share/nvim/site/ftplugin or .local/share/nvim/site/after/ftplugin

## Better autocomplete

For your own housekeeping, think about coming up with a list of what the
hotkeys for deoplete, jedi, lang client/pyls are, and what completefunc and
omnifunc in varying filetypes are bound to.

Because I keep hitting tab and C-N and getting inconsistent behavior and
that needs to stop.

### Current state

Deoplete isn't mentioned once in init.vim
I think all my settings are in the after/deoplete.vim file but I need to at
enable it right?

Maybe turn on logging to see what's going on?

Things are setup so that they work in \*.py files but I don't know if it's
very efficient or wildly redundant so...


I know this sounds corny but the most important thing on this list is:

**HAVE FUN DUDE**

Try implementing something new just because. Test the waters.

You could easily make a temp feature branch, pop all stashes,
commit whatever's going on, and then burn and destroy that branch the next
day if it didn't sit right.

Or you could do that for new plugins! Oooo I like that.
