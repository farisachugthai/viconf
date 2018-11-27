# TODO

## To get nvim and vim synced up

**Motivation:**

Until I figure out how to get nvim set up as my git difftool, I have to maintain vim.

## colors

Laptop needs to checkout colors and get terminal color update for onedark.

## To get nvim synced up on Termux and Linux

Also checkout .config/nvim/after/ftplugin/markdown.vim.

Because it's agitating not having feature parity.

Also you're going to want to run :Glog in .config/nvim/UltiSnips/rst.snippets
Because I'm thinking that I mindlessly checked out the version from Termux.
The problem is that I probably added a couple good snippets in there, and by
checking it out from a different branch I may have lost them. So look at the
historical versions you have and make sure you didn't do that.

Don't checkout sh.snippets either I have a bunch of snippets that need
descriptions but otherwise look pretty good and need to get moved over
to other branches as well.

## Get spell checking set up right

Honestly this is quite a difficult process. I'm struggling to correctly work
with the spell files in ./hunspell/

Keep in mind that if you're manually working with a .add spellfile, that you
can run :sort and alphabetize all the words in the file!

And after that...

## Get ftplugins set up a little more cleanly

Largely a product of still struggling with optimizing settings with respect to
the sequence of elements in 'runtimepath'.

Distinguishing what goes in your ftplugins and your general files.

Whether to put ftplugins in .config/nvim/ftplugin, .config/nvim/after/ftplugin
.local/share/nvim/site/ftplugin or .local/share/nvim/site/after/ftplugin

## Better autocomplete

For your own housekeeping, think about coming up with a list of what the
hotkeys for deoplete, jedi, Lang Client/pyls are, and what completefunc and
omnifunc in varying filetypes are bound to.

Because I keep hitting tab and C-N and getting inconsistent behavior and
that needs to stop.

### deoplete

Has a bunch of new mappings hopefully you'll find them pretty useful {I'm stoked}

### jedi

Going to leave it bound to C-Space to initialize autocomplete. Could use C-N
but that's kinda unclear since autocomplete doesn't need a trigger with
deoplete and C-N is 'pick the next element'
