# TODO

## Improve docs

It'll make this repo (and all of my repos) much more palatable if we document
things. A good one would be a table with all important keybindings you have
shown. Plus GitHub Flavored Markdown supports that easily!

Picture something like this:

| Key | Description |
| --- | ----------- |
| <kbd>1</kbd>| List |
| <kbd>2</kbd>| List |
| <kbd>3</kbd>| List |
| <kbd>4</kbd>| List |
| <kbd>6</kbd>| List |
| <kbd>8</kbd>| Visualizer |
| <kbd>space</kbd>| Change visualizer |
| <kbd>=</kbd>| Clock |
| <kbd>z</kbd>| Random Music |
| <kbd>p</kbd>| Pause/Play |
| <kbd>r</kbd>| Repeat mode on/off |
| <kbd>enter</kbd>| Play Music |

Would definitely make this easier to use than forcing another poor soul to
learn Vimscript.

- Review snippets and effectively use them while learning new languages

On the horizon, a 'nice to have' would be workspace/project integration.

In addition, a more cleanly embedded IPython terminal would be phenomenal.
An active Jupyter kernel and a notebook would be great.

## Suggestion

**Dec 02, 2018:**

Figure out if you can add a git hook that checks that for every time a new
file is committed to ./.config/nvim/ that one is also added to ./.vim

## To get nvim and vim synced up

*Motivation:*

1. Unfortunately, nvim periodically crashes. I'm not 100% sure why that is
   but until that's completely resolved, I need to have a comfortable fallback
   in Vim.

## To get nvim synced up on Termux and Linux

Because it's agitating not having feature parity.

It's not uncommon for the 2 init.vim files to have diff-stats of over 400+ lines,
and the repository in total regularly has over 1000 additions and 1000 deletions.

Generally these are non-trivial differences as well.

Also you're going to want to run :Glog in .config/nvim/UltiSnips/rst.snippets
Because I'm thinking that I mindlessly checked out the version from Termux.

Dec 01, 2018: dude i don't know what you did but i think you probably
really boinked the rst.snippets.

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

In your (./vim_setup.py) file add a section for getting that cheat40
cheatsheet back in here.

Then add sections explaining the above. That was such a nice but underutilized
tool you had there.