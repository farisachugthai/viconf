# TODO

## To get nvim and vim synced up

*Motivation:*

Until I figure out how to get nvim set up as my git difftool, I have to maintain vim.

## To get nvim synced up on Termux and Linux

Because it's agitating not having feature parity.

## Get spell checking set up right

And after that...

## Work on getting ftplugins set up in .local not .config


Sep 24, 2018

Laptop needs to:
Move jedi configuration from after/ftplugin to init.vim.

Consider writing a python script that imports either vim or neovim and modifies
the default config file from ipython or jupyter.

The whole file needs

:%s/##/#/g
:%s/#c/# c/g
:%s/#-/# /g

run on it from the outset. How do we make this a script? A function?
A plugin? Give it an \<SID\> and a mapping?
