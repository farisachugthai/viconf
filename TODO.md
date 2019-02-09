# TODO

Feb 04, 2019:

1) Startify doesn't display any MRU's even though it's explicitly stated to list
in my plugin conf.

Is this a problem with the main.shada file or startify being configured
incorrectly? `:StartifyDebug` isn't giving me too much.

2) Do I have ftplugin guards on all my ftplugins? Is the snippet that I have
for ftplugins correct? And do I have guards on all my plugin files?
  - Very seriously thinking about dropping deoplete it's getting on my nerves.

Jan 21, 2019:

  Riv clobbers insert mode <kbd>Tab</kbd> which basically disables UltiSnips
  and really messes with Deoplete. *sigh*.

Jan 16, 2019:

- Fix FZF:
  I just remembered that I added a hook to enter nvim every time
  I hit enter in FZF. That's causing some weird errors when I use <C-x><C-f>
  to get FZF to complete file paths, and as a result, it's not doing anything.

## Improve Docs

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
