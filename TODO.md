# TODO

**Suggestion**

Dec 02, 2018:

Figure out if you can add a git hook that checks that for every time a new
file is committed to ./.config/nvim/ that one is also added to ./.vim

Until I figure out how to get nvim set up as my git difftool, I have to maintain vim.

## colors

1. Unfortunately, nvim periodically crashes. I'm not 100% sure why that is
   but until that's completely resolved, I need to have a comfortable fallback
   in Vim.

## To get nvim synced up on Termux and Linux

Because it's agitating not having feature parity.

It's not uncommon for the 2 init.vim files to have diffstats of over 400+ lines,
and the repository in total regularly has over 1000 additions and 1000 deletions.

Generally these are non-trivial differences as well.

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

### Nov 21, 2018

Well I figured at least part of that question out. The site dirs are for packages,
meaning groups of plugins. Don't worry about those.

Ftplugin should be used to totally override the built-in ftplugin. You either
have to be THAT discontent with it, or simply copy and paste it and then
add your own modifications in.

However after/ftplugin works better for that. As a result, we won't put the
usual ftplugin guard in there. However, we should do something to ensure
that buffers of a different filetype don't source everything in after/ftplugin.

For example, let's say we were in after/ftplugin/gitcommit.vim

Something like this pseudo code would be perfect:

`if ft != None && ft != gitcommit | finish | endif`

Then put that in everything in that dir.

Similar thing with after/syntax. We also have a fair number of files in syntax/

We should probably set up some kind of guard so that it doesn't source a dozen
times.

And how does sourcing ftdetect work? Because everything in my ftdetect always
shows up in `:scriptnames`.

Need to see how $VIMRUNTIME implements this.

## Better autocomplete

For your own housekeeping, think about coming up with a list of what the
hotkeys for deoplete, jedi, Lang Client/pyls are, and what completefunc and
omnifunc in varying filetypes are bound to.

Because I keep hitting tab and C-N and getting inconsistent behavior and
that needs to stop.

Nov 21, 2018:

This is so true. In your vim_setup.py file add a section for getting that cheat40
cheatsheet back in here.

Then add sections explaining the above. That was such a nice but underutilized
tool you had there.

### deoplete

Has a bunch of new mappings hopefully you'll find them pretty useful {I'm stoked}

### jedi

Going to leave it bound to C-Space to initialize autocomplete. Could use C-N
but that's kinda unclear since autocomplete doesn't need a trigger with
deoplete and C-N is 'pick the next element'

### Language Client

Currently the value of completefunc in an \*.md file.

Awh and the response for both if you open a \*.py file. Poor jedi.


Dec 01, 2018:
Never thought about this. nvim enables showmode automatically {i think?} and
so does airline. disable one for sure.
