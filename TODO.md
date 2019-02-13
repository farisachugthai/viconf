# TODO

Feb 12, 2019:

Officially getting to the point of moving files out of the vim folder.
I never use vim for anything at this point so the extra maintenance is quite
honestly just a burden.

Feb 09, 2019:

## Added Functionality with Clang and Ranger

Should add in bindings for the clang and ranger stuff I added.
[clang-format.py](./.config/nvim/pythonx/clang-format.py)
[clang-rename.py](./.config/nvim/pythonx/clang-rename.py)
Wasn't sure where to put it either so it's in pythonx for the time being.
Also moved the vim_setup script there. As well as the skeleton file.

Feb 04, 2019:

1) Startify doesn't display any MRU's even though it's explicitly stated to list
in my plugin conf.
  - Still isn't doing so on Termux but is for Ubuntu sometimes.

Is this a problem with the main.shada file or startify being configured
incorrectly? `:StartifyDebug` isn't giving me too much.

2) Do I have ftplugin guards on all my ftplugins? Is the snippet that I have
for ftplugins correct? And do I have guards on all my plugin files?
  - Very seriously thinking about dropping deoplete it's getting on my nerves.
  - Btw an absolutely perfect plugin guard is now in your init.vim on the Termux
  branch so make sure to diff what you need to and get that over here.

*Thanks Tabularize! Pulled that one off with:*
`:Tabularize /|`!

Nothing too complicated at all.

| Key              | Description        |
| ---              | -----------        |
| <kbd>1</kbd>     | List               |
| <kbd>2</kbd>     | List               |
| <kbd>3</kbd>     | List               |
| <kbd>4</kbd>     | List               |
| <kbd>6</kbd>     | List               |
| <kbd>8</kbd>     | Visualizer         |
| <kbd>space</kbd> | Change visualizer  |
| <kbd>=</kbd>     | Clock              |
| <kbd>z</kbd>     | Random Music       |
| <kbd>p</kbd>     | Pause/Play         |
| <kbd>r</kbd>     | Repeat mode on/off |
| <kbd>enter</kbd> | Play Music         |

Would definitely make this easier to use than forcing another poor soul to
learn Vimscript.

In addition, a more cleanly embedded IPython terminal would be phenomenal.

I've got just the thing for ya man. Check in Dropbox/vim/py/nvim-REPL.md I
think it is. I've got a bunch of code blocks that'll get you working with
an interactive IPython instance that's controlling neovim programtically
**WHILE INSIDE OF NEOVIM**.
