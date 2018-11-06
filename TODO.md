# TODO

## To get nvim and vim synced up

*Motivation:*

Until I figure out how to get nvim set up as my git difftool, I have to maintain vim.

## To get nvim synced up on Termux and Linux

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

### Language Client

Currently the value of completefunc in an \*.md file.

Awh and the response for both if you open a \*.py file. Poor jedi.

### Current state

Deoplete isn't mentioned once in init.vim
I think all my settings are in the after/deoplete.vim file but I need to at
enable it right?

Maybe turn on logging to see what's going on?

Things are setup so that they work in \*.py files but I don't know if it's
very efficient or wildly redundant so...
