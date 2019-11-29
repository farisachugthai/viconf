# README

![Screenshot](./images/startup_init.jpg)

While still a work-in-progress, this repository houses a collection of
initialization files, plugin modifications and syntax highlighting Vim
scripts that I use to run Neovim on Linux, Windows 10, and
[Termux](https://www.github.com/termux/termuxapp) on Android.

😎😎😎😎

## How it works

As much of this [init.vim](.config/nvim/init.vim) is set up so that it
will start up as quickly as possible while still maintaining a plethora 
of features.

This is achieved by [auto-loading](.config/nvim/autoload) as many functions as
possible, and determining a few non-portable settings in a relatively quick
and consistent manner.

### Set up

The initialization file has largely been refactored out of existence.

The use (and inevitable abuse) of the `runtimepath` or `&rtp` variable
allows for more logical namespaces to be utilized, and typically debugging
has proven easier with almost all functionality broken up into
the respective (.config/nvim/plugin), (.config/nvim/after/plugin),
and (.config/nvim/autoload) directories.

The only remaining assumption as a result of the restructuring is:

- [vim-plug](https://www.github.com/junegunn/vim-plug) is the plugin manager
  that you'd like to use.

Largely this is being refactored; however, its been slow as manually
checking for the presence of every plugin is a pain point.

The [init.vim](./.config/nvim/init.vim) will immediately check that the
plug.vim file is there, and it will automatically download it if not.

If that proves too much effort, I `git sub-tree add`ed vim-plug to this
repo as well.

## Requirements

By and large I do assume that anyone using this code is using a very new copy
of Neovim. Generally I make as many checks as possible to ensure backwards
compatibility...except for when I don't.

### Updating to a newer version

Unfortunately the newest version of neovim in the Ubuntu 18.04 repositories
is 0.2.2, which didn't ship with the `stdpath()` function along with many other niceties.

Luckily upgrading is typically as simple as running:

    sudo add-apt-repository ppa:neovim-ppa/unstable

On ubuntu or:

    choco install neovim --pre

On Windows.


#### Use of the `stdpath()`

**Warning:**

In version 0.3.1 Neovim created a function `stdpath()` that will
return the value of the user's configuration directory regardless
of platform or OS. It's a phenomenal function and greatly simplifies a huge
number of complicated tasks; however, I frequently don't check if that
function exists before use.

## Start up time

The configuration for the plugins used by Neovim are currently being refactored
out of the [init.vim](./.config/nvim/init.vim) and moved into the directory
[after/plugin](./.config/nvim/after/plugin)

By factoring these files out of the init.vim, it becomes easier to
check that Vim-Plug actually loaded the plugin. If the plugin 
was not loaded, the configuration file runs `finish` immediately.

This allows for extensive modification to the way that Neovim handles files and
allows for startup time to remain the realm of 200 milliseconds.

## Features

As a result of my modifications, this setup currently has:

### Remote Providers

- 4 different remote providers that Neovim can communicate with via RPC.
  - node.js, ruby, and python hosts are communicated with to offload work.
  - In addition, a Tmux server is connected to and used as a clipboard!

### Man pages

- [Improved syntax highlighting](./.config/nvim/syntax/man.vim) for man pages
  over the defaults provided by either Neovim or Vim.
  - This was accomplished by merging together the highlighting groups of
    both Neovim and Vim, and then adding around 20 links to color groups.

### Colorscheme Improvements

- The [Gruvbox](https://github.com/morhetz/gruvbox.vim) colorscheme has been
  integrated into the repository and currently stands at over [double the
  original length](./.config/nvim/colors/gruvbox.vim) with no appreciable
  change in startup time.

  This has been accomplished by falling back to Nvim's builtin functions for
  highlighting certain syntax groups.

### Tmux integration

[Tmux](https://github.com/tmux/tmux/wiki) configuration files live at
[tmuxline.vim](./.config/nvim/after/plugin/tmuxline.vim).

  - Keybindings for both Nvim and tmux correspond so that jumping from a Nvim
    window to a Tmux pane uses the same keys.
  - The configuration for Tmux is displayed at [dotfiles](https://www.github.com/farisachugthai/dotfiles).
### Other

- [Personally configured](./.config/nvim/after/ftplugin/) filetype plugins and
  added [filetype detection](./.config/nvim/ftdetect).

- Lightly configured embedded terminal.
  [20+ convenience mappings](.config/nvim/plugin/terminally_unimpaired.vim)
  are provided to ease navigation between Nvim windows and the embedded terminal.

- Spell-checking with dictionaries that have been personally compiled and reviewed.
  - For the full list of words check
    [en.utf-8.add](./.config/nvim/spell/en.utf-8.add)

- Multiple colorschemes that support xterm-256 or 24 bit terminals including
  Solarized, Jellybeans, Gruvbox and Monokai.
  - An explanation of how to work with colorschemes is given at the
    [README](./.config/nvim/colors/README.rst)

## Usage

### Basics Keymappings

Keycode                       | Mode     | [Command]Description
:-                            | :-       | :-
<kbd>h</kbd>                  | Norm     | Move cursor one char left
<kbd>j</kbd>                  | Norm     | Move cursor one char down
<kbd>k</kbd>                  | Norm     | Move cursor one char up
<kbd>l</kbd>                  | Norm     | Move cursor one char right
<kbd>w</kbd>                  | Norm     | Move cursor to the beginning of the next word
<kbd>b</kbd>                  | Norm     | Move cursor to the beginning of the previous word
<kbd>M</kbd>                  | Norm     | Move cursor to vertical center
<kbd>gg</kbd>                 | Norm     | Move to the first line
<kbd>G</kbd>                  | Norm     | Move to the last line
<kbd>:</kbd><kbd>w</kbd>      | Cmd      | Save the current buffer
<kbd>:</kbd><kbd>q</kbd>      | Cmd      | Close the buffer without saving

### Remappings

Further explanations for how nvim is configured can be found in my personal
[Neovim README](./.config/nvim/README.rst).

### Diffs

Command | Keycode
:-|:-
Next change | <kbd>]c</kbd>
Previous change |  <kbd>\[c</kbd>
Diff obtain {Grab differing lines from other buffer} | <kbd>do</kbd>
Diff put {Put differing lines in other buffer} | <kbd>dp</kbd>
Open fold directly under cursor | <kbd>zo</kbd>
Close fold directly under cursor | <kbd>zc</kbd>
Update diff and syntax highlighting in windows | `:diffupdate`
Toggle diff under cursor | <kbd>za</kbd>

## Plugins Used

Currently, lazily loaded modification files exist for:

- [coc.nvim](./.config/nvim/after/plugin/coc.vim)
- [airline.vim](./.config/nvim/after/plugin/airline.vim)
- [deoplete.vim](./.config/nvim/after/plugin/deoplete.vim)
- [fzf.vim](./.config/nvim/after/plugin/fzf.vim)
- [lang_client.vim](./.config/nvim/after/plugin/lang_client.vim)
- [lightline.vim](./.config/nvim/after/plugin/lightline.vim)
- [nerdtree.vim](./.config/nvim/after/plugin/nerdtree.vim)
- [riv.vim](./.config/nvim/after/plugin/riv.vim)
- [startify.vim](./.config/nvim/after/plugin/startify.vim)
- [ultisnips.vim](./.config/nvim/after/plugin/ultisnips.vim)

In addition, configurations exist for:

- [coc.nvim](https://www.github.com/neoclide/coc.nvim).

  - Automatic autocompletion for any filetype Vim supports via

  - This plugin depends on node.js and Yarn being installed.

- Snippet integration/expansion for 24 different filetypes.

  - Well over [1000 snippets](./.config/nvim/UltiSnips) are included.

  - Nvim's Python integration is utilized to expand some snippets.

    - Over [20 functions](./.config/nvim/pythonx/snippets_helper.py) are imported and used throughout the varying snippet files.

- [Fugitive](https://www.github.com/tpope/vim-fugitive).

  - Git integration with aliases via Tim Pope's plugin.

- [NERDTree](https://www.github.com/scrooloose/nerdTree)

### NERDTree

NERDTree is a file explorer plugin that provides "project drawer"
functionality to your vim editing.  You can learn more about it with
`:help NERDTree`.

### Coc

This is an outstandingly useful plugin and one that now has close to 1000 lines
dedicated to it in this repository alone.

Settings can be easily set up using the
[coc-settings.json](./.config/nvim/coc-settings.json) file, which will probably
prove to be much easier for most than learning VimScript.

In addition to connecting Vim to any LSP servers it can, it also *amusingly*
adds emoji support with packages like `coc-emoji`.

🎺!

### Filetype Plugins

This repository contains:

- Real time interactive displays for reStructured Text files.

  - The plugin [Riv.vim](https://www.github.com/gu-fan/riv.vim) allows one to
  run `docutils` on a buffer and then preview it in a browser.

- Asynchronous linters thanks to the Asynchronous Lint Engine or
  [ALE](https://www.github.com/w0rp/ale).

  - Support for specific filetype dependent linters including ReStructured Text
  are configured in my
  [dotfiles](https://www.github.com/farisachugthai/dotfiles) repo.

  - Specifically Flake8, pydocstyle, the python-language-server and others.

#### Filetype Detection

- Can't say I ever noticed this before but here's an interesting section from
  `$VIMRUNTIME/filetype.vim`.

```vim

" Pipenv Pipfiles
au BufNewFile,BufRead Pipfile			setf config
au BufNewFile,BufRead Pipfile.lock		setf json

```

TIL that Pipfiles are officially recognized by the filetype detector in Nvim!

#### Loading a personal filetype file

**Note:**

```vim

if exists("myfiletypefile") && filereadable(expand(myfiletypefile))
  execute "source " . myfiletypefile
endif

```

Would setting ``&myfiletypefile`` to the file at
./.config/nvim/ftdetect/filetype.vim be redundant? 

### Sources for all plugins

Here's a current list of all my plugins, a summary of their usage, and notes
on my personal customization.

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

## Settings

### set vs let

`set` allows one to set useful configurations and is easier to read than
some corresponding `let` statements, but it only allows one to
define a variable to one literal value.

The set keyword in vim is best used when setting an option to a well defined
string or a boolean of some sort.

`let` allows for scoping variables, and as Vim has an incredibly unintuitive
system for coercing types, this will frequently come in handy.

In addition, `let` is best used when an expression requires evaluating a 
external value, such as an environment variable of some sort.

### Options of note

```vim
" Keep statusline overflow to simply empty spaces no matter if higlighting
" is on or off. use some unicode for cooler lines and use periods not --- for
" deleted diff lines. It makes diff buffers very visually noisy.
let &g:fillchars = "stl:' ',stlnc:' ',vert:\u250b,fold:\u00b7,diff:'.'"
```

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
is a book I only recently picked up; however, it's been open sourced and clearly
explains some of Vim's stickier points like type coercion in an interesting
and fun way. As a result, I would highly recommend it!
