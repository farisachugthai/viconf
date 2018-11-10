# TODO

Consider writing a python script that imports either vim or neovim and modifies
the default config file from ipython or jupyter.

The whole file needs

:%s/##/#/g
:%s/#c/# c/g
:%s/#-/# /g

run on it from the outset. How do we make this a script? A function?
A plugin? Give it an \<SID\> and a mapping?

Oct 15, 2018:
Fix up ./.config/nvim/vim-setup.py that file is an absolute mess
