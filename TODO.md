# TODO

## To get nvim and vim synced up

*Motivation:*

Until I figure out how to get nvim set up as my git difftool, I have to maintain vim.

## To get nvim synced up on Termux and Linux

Because it's agitating not having feature parity.

## Get spell checking set up right

Honestly this is quite a difficult process. I'm struggling to correctly work
with the spellfiles in ./hunspell/

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
hotkeys for deoplete, jedi, lang client/pyls are, and what completefunc and
omnifunc in varying filetypes are bound to.

Because I keep hitting tab and C-N and getting inconsistent behavior and
that needs to stop.

### deoplete

has a bunch of new mappings hopefully you'll find them pretty useful {i'm stoked}

### jedi

gonna leave it bound to C-Space to initialize autocomplete. could use C-N
but that's kinda unclear since autocomplete doesn't need a trigger with
deoplete and C-N is 'pick the next element'

### language client

currently the value of completefunc in an \*.md file.

awh and the response for both if you open a \*.py file. Poor jedi.

### Current state

Deoplete isn't mentioned once in init.vim
I think all my settings are in the after/deoplete.vim file but I need to at
enable it right?

Maybe turn on logging to see what's going on?

Things are setup so that they work in \*.py files but I don't know if it's
very efficient or wildly redundant so...
