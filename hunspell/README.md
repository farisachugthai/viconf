# README

Moved hunspell files from <file:///usr/share/hunspell> to here via Git because locale
is misconfigured on the laptop.

Currently writing this file in the IPython console.

Used requests lib to download the diff from the .aff packaged with hunspell
and the Vim version.

URL:
    `<http://ftp.vim.org/vim/runtime/spell/en/en_US.diff>`

**Nov 02, 2018**

Moved the diff to the new aff. Now to try the mkspell!

:( didn't work. Getting an invalid region error. Whatever.

Way too much work to get spell checking working man.

Git checked out the <./en_US.dic> that was on laptop and they're different
sizes!

I also `git checkout laptop -- en-us.dic` file on laptop.

Still getting invalid region errors :/
