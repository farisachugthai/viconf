# README

![Screenshot](./images/neodark_statuslines.png)

While still a work-in-progress, this repository houses a collection of
initialization files I use to run Neovim on Linux, Windows 10, and
[Termux](https://www.github.com/termux/termuxapp) on Android.

## Vim

My configuration for Vim has been deprecated as of March 2019. The files in this
repository therefore do not attempt to maintain compatibility with Vi or Vim's
default behavior.

There are no checks that will resemble the following:

- `if has('nvim')`
- `if has(patch7*)` as Neovim was forked from Vim7.4
- `if has(terminal)` or `if has(autocmd)` or `if has(tmap)`. These are all
features that have been built into every version of Neovim.

Neovim is my primary text editor and as a result, I've attempted integrating it
into as much of my workflow as possible.


## Features

As a result of personal modifications, this setup currently has:

- Real time interactive displays for reStructured Text files.
  - The plugin [Riv.vim](https://www.github.com/gu-fan/riv.vim) allows one to
  run `docutils` on a buffer and then preview it in a browser.

- [Personally configured](./.config/nvim/after/ftplugin/) filetype plugins and
added [filetype detection](./.config/nvim/ftdetect).

- [Improved syntax highlighting](./.config/nvim/syntax/man.vim) for man pages over the defaults provided by either Neovim or Vim.
  - This was accomplished by merging together the highlighting groups of
  both Neovim and Vim, and then adding around 20 links to color groups.
  - It also depends on the variable `g:colors_name` being set to `Gruvbox`.

- Automatic autocompletion for any filetype Vim supports via
[coc.nvim](https://www.github.com/neoclide/coc.nvim).
  - This plugin depends on node.js and Yarn being installed.

- Snippet integration/expansion for 24 different filetypes. Well over [1000
  snippets](./.config/nvim/UltiSnips) are included.
  - Nvim's Python integration is utilized to expand some snippets. Over [20 functions](./.config/nvim/pythonx/snippets_helper.py) are imported and used throughout the varying snippet files.

- Git integration with aliases via Tim Pope's plugin
[Fugitive](https://www.github.com/tpope/vim-fugitive).

- Lightly configured embedded terminal. 20+ convenience mappings are provided to
ease navigation between Nvim windows and the embedded terminal.

- Seamless Tmux integration.
  - Keybindings for both Nvim and tmux correspond so that jumping from a Nvim window to a Tmux pane uses the same keys.
  - The configuration for Tmux is displayed at [dotfiles](https://www.github.com/farisachugthai/dotfiles).

- Asynchronous linters thanks to the Asynchronous Lint Engine or
[ALE](https://www.github.com/w0rp/ale).
  - Support for specific filetype dependent linters including ReStructured Text
  are configured in my
  [dotfiles](https://www.github.com/farisachugthai/dotfiles) repo.
  - Specifically Flake8, pydocstyle, the python-language-server and others.


- Syntax highlighting for files from [Zim
wiki](https://github.com/jaap-karssenberg/zim-desktop-wiki) found at
[zimwiki.vim](./.config/nvim/syntax/zimwiki.vim)

- Spell-checking with dictionaries that have been personally compiled and reviewed.
  - For the full list of words check
  [en.utf-8.add](./.config/nvim/spell/en.utf-8.add)

- Multiple colorschemes that support xterm-256 or 24 bit terminals including
Solarized, Jellybeans, Gruvbox and Monokai.
  - An explanation of how to work with colorschemes is given at the
  [README](./.config/nvim/colors/README.rst)

## Usage

### Basics Keymappings

+-----------------------------------------------------------------------------------------+
| Keycode                       | Mode     | [Command]Description                         |
| :---:                         | :---:    | :---                                         |
| <kbd>h</kbd>                  | Norm     | Move cursor one char left                    |
| <kbd>j</kbd>                  | Norm     | Move cursor one char down                    |
| <kbd>k</kbd>                  | Norm     | Move cursor one char up                      |
| <kbd>l</kbd>                  | Norm     | Move cursor one char right                   |
| <kbd>w</kbd>                  | Norm     | Move cursor to the beginning of the next word|
| <kbd>b</kbd>                  | Norm     | Move cursor to the beginning of the prev word|
| <kbd>M</kbd>                  | Norm     | Move cursor to vertical center               |
| <kbd>gg</kbd>                 | Norm     | Move to the first line                       |
| <kbd>G</kbd>                  | Norm     | Move to the last line                        |
| <kbd>:</kbd><kbd>w</kbd>      | Cmd      | Save the current buffer                      |
| <kbd>:</kbd><kbd>q</kbd>      | Cmd      | Close the buffer without saving              |
+-----------------------------------------------------------------------------------------+

### Remappings

Further explanations for how nvim is configured can be found in my personal
[Neovim README](./.config/nvim/README.rst).

### Diffs

+----------------------------------+
| Command            | Keycode     |
|                    |             |
|next change         |          ]c |
|previous change     |         \[c |
|diff obtain         |          do |
|diff put            |          dp |
|fold open           |          zo |
|fold close          |          zc |
|rescan files        | :diffupdate |
+----------------------------------+


## Plugins Used

The configuration for the plugins used by Neovim are currently being refactored
out of the [init.vim](./.config/nvim/init.vim) and moved into the directory
[after/plugin](./.config/nvim/after/plugin)

By factoring these files out of the init.vim, it becomes easier to check that
Vim-Plug actually loaded the plugin. If the plugin was not loaded, the
configuration file runs `finish` immediately.

This allows for extensive modification to the way that Neovim handles files and
allows for startup time to remain the realm of 200 milliseconds.


Currently, lazily loaded modification files exist for:

- [airline.vim](./.config/nvim/after/plugin/airline.vim)
- [deoplete.vim](./.config/nvim/after/plugin/deoplete.vim)
- [fzf.vim](./.config/nvim/after/plugin/fzf.vim)
- [lang_client.vim](./.config/nvim/after/plugin/lang_client.vim)
- [lightline.vim](./.config/nvim/after/plugin/lightline.vim)
- [nerdtree.vim](./.config/nvim/after/plugin/nerdtree.vim)
- [riv.vim](./.config/nvim/after/plugin/riv.vim)
- [startify.vim](./.config/nvim/after/plugin/startify.vim)
- [ultisnips.vim](./.config/nvim/after/plugin/ultisnips.vim)

### NERDTree

- [NERDTree](https://www.github.com/scrooloose/nerdTree)

NERDTree is a file explorer plugin that provides "project drawer"
functionality to your vim editing.  You can learn more about it with
`:help NERDTree`.

#### QuickStart

Launch using <kbd><Leader>nt</kbd>.


### Sources for all plugins

Here's a current list of all my plugins, a summary of their usage, and notes
on my personal customizations.

- [vim-plug](https://www.github.com/junegunn/vim-plug)
- [FZF](https://www.github.com/junegunn/fzf)
- [FZF.vim](https://www.github.com/junegunn/fzf.vim)
- [Jedi-Vim](https://www.github.com/davidhalter/jedi-vim)
- [Git-Gutter](https://www.github.com/airblade/vim-gitgutter)
- [Fugitive](https://www.github.com/tpope/vim-fugitive)
- [Vim-Commentary - tpope](https://www.github.com/tpope/vim-commentary)
- [ALE, the Asynchronous Lint Engine](https://www.github.com/w0rp/ale)
- [Vim-Tmux-Navigator](https://www.github.com/christoomey/vim-tmux-navigator)
- [LanguageClient](https://www.github.com/autozimu/LanguageClient-neovim)
- [UltiSnips](https://www.github.com/SirVer/ultisnips)
- [Airline](https://www.github.com/vim-airline/vim-airline)
- [Tmuxline](https://www.github.com/edkolev/tmuxline.vim)
- [Startify](https://www.github.com/mhinz/vim-startify)
- [Deoplete](https://www.github.com/Shougo/deoplete.nvim)
- [Deoplete-jedi](https://www.github.com/zchee/deoplete-jedi)
- [Tagbar](https://www.github.com/majutsushi/tagbar)
- [Tabular](https://www.github.com/godlygeek/tabular)
- [Voom](https://www.github.com/vim-voom/voom)
- [Riv.vim](https://www.github.com/gu-fan/riv.vim)
- [Devicons](https://www.github.com/ryanoasis/vim-devicons)

## License

This project is licensed under the MIT License.

## Acknowledgments

- [vim](https://www.github.com/vim/vim)
- [Neovim](https://www.github.com/neovim/neovim)

I want to individually thank @tpope and @junegunn for their Fugitive and FZF
plugins respectively. Largely because reading through the source code for
those projects helped kick off my excitement in
tweaking and optimizing my workflow.

Drew Neil's Vimcasts is a perpetual source of information for me as is his
book Practical Vim.

Derek Wyatt's videos also deserve some praise here.

Steve Losh's [Learn VimScript the Hard Way](https://github.com/sjl/learnvimscriptthehardway)
is a book I only recently picked up; however, it's been open sourced and
clearly
explains some of Vim's stickier points like type coercion in an interesting
and fun way. As a result, I would highly recommend it!
