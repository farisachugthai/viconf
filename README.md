# README

While still a work-in-progress, this repository houses a collection of
initialization files I use to run Neovim and Vim on Linux, Windows 10, and
[Termux](github.com/termux/termuxapp) on Android.

Neovim is my primary text editor and as a result, I've attempted integrating it
into as much of my workflow as possible.

As a result of personal modifications, this setup currently has:

- Automatic autocompletion for any filetype Vim supported filetype
- Snippet integration/expansion for 24 different filetypes. Well over 1000
  snippets are included.
  - Vim's python integration is utilized to expand some snippets. Over 20
    functions are imported and used throughout the varying snippet files.
- Git integration with aliases via Tim Pope's plugin [Fugitive](github.com/tpope/vim-fugitive)
- Lightly configured embedded terminal
- Seamless tmux integration.
  - The keybindings for both vim and tmux correspond so that jumping from one Vim window to another Tmux pane uses the same keys
  - The statuslines not only correspond, but they're synchronized so that when
  one changes, the other does as to match.
- Asynchronous linters that are configured in my [dotfiles](github.com/farisachugthai/dotfiles)
  - Supports flake8, pydocstyle, the python-language-server and others
- Syntax highlighting for files from Zim wiki
- Spell-checking with dictionaries that have been personally compiled and reviewed
- Multiple colorschemes that support xterm-256 or 24 bit terminals.

**Disclaimer**

Many of the snippets were not authored by me. That credit goes to
[honza](github.com/honza) in his [vim-snippets](github.com/honza/vim-snippets)
repository

## Plugins Used

- [vim-plug](junegunn/vim-plug)
- [FZF](github.com/junegunn/fzf)
- [FZF.vim](github.com/junegunn/fzf.vim)
- [NERDTree](github.com/scrooloose/nerdTree)
- [Jedi-Vim](github.com/davidhalter/jedi-vim)
- [Git-Gutter](github.com/airblade/vim-gitgutter)
- [Fugitive](github.com/tpope/vim-fugitive)
- [Vim-Commentary - tpope](github.com/tpope/vim-commentary)
- [ALE, the Asynchronous Lint Engine](github.com/w0rp/ale)
- [Vim-Tmux-Navigator](github.com/christoomey/vim-tmux-navigator)
- [LanguageClient](github.com/autozimu/LanguageClient-neovim)
- [UltiSnips](github.com/SirVer/ultisnips)
- [Airline](github.com/vim-airline/vim-airline)
- [Tmuxline](github.com/edkolev/tmuxline.vim)
- [Startify](github.com/mhinz/vim-startify)
- [Deoplete](github.com/Shougo/deoplete.nvim)
- [Deoplete-jedi](github.com/zchee/deoplete-jedi)
- [Tagbar](github.com/majutsushi/tagbar)
- [Tabular](github.com/godlygeek/tabular)
- [Voom](github.com/vim-voom/voom)
- [Devicons](github.com/ryanoasis/vim-devicons)

## TODO


- Modify syntax highlighting of markdown files.
  Underscores are in the SpellBad highlight group.
- Review snippets and effectively use them while learning new languages

On the horizon, a 'nice to have' would be workspace/project integration.

In addition, a more cleanly embedded IPython terminal would be phenomenal.
An active Jupyter kernel and a notebook would be great

TODO:
Add a screenshot section. Definitely one from Termux.

**Disclaimer**

Many of the snippets were not authored by me. That credit goes to
[honza](github.com/honza) in his [vim-snippets](github.com/honza/vim-snippets)
 repository

## License

This project is licensed under the MIT License. {Should we have more here?}

## Acknowledgments

- [vim](github.com/vim/vim)
- [Neovim](github.com/neovim/neovim)

I want to individually thank @tpope and @junegunn for their Fugitive and FZF
plugins respectively. Largely because reading through the source code for
those projects helped kick off my excitement in tweaking and optimizing my
workflow.

Drew Neil's Vimcasts is a perpetual source of information for me as is his
book Practical Vim.

Derek Wyatt's videos also deserve some praise here.

Steve Losh's Learn VimScript the Hard Way is a book I recently picked up, and
would highly recommend!
