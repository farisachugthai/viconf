.. viconf documentation master file, created by
   sphinx-quickstart on Fri May 22 12:35:25 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to viconf's documentation!
==================================

:date: |today|

.. highlight:: vim

.. moduleauthor:: Faris Chugthai


Imagine you're a Vim user. You're well above the simple beginner
stages. You've finished Vim Tutor a handful of times. You're read a
reasonably large chunk of the User Guide. You want to advance to the next
level and begin taking advantage of the runtimepath. Breaking up your
monolithic vimrc file is a phenomenal idea, as the folders in a user's
``~/.config/nvim`` or ``~/.vim`` are of supreme importance to startup.

**By the way, if nothing I just said makes sense to you, go read ``:help 'runtimepath'``.**

**Yes I mean now. I'll still be here when you're done.**

Directory Layout and Runtimepath
=================================
How are the folders in a neovim directory tree supposed to be
laid out?

While each directory serves a specific purpose, depending on use case, not
all need to be created and used.

The variable of importance is ``runtimepath``. The varying
directories all affect how different settings are recorded and in what order
the code is ran.

We can observe this with::

   set rtp   " or alternatively
   echo &rtp

.. _rtp:

Runtimepath
-----------
Here's a quick summary of the folders in a standard runtimepath layout.

.. glossary::

   plugin
      Vim script files that are loaded automatically when editing any kind of
      file. Called "global plugins."

   autoload
      (Not to be confused with "plugin.") Scripts in autoload contain
      functions that are loaded only when requested by other scripts.

   ftdetect
      Scripts to detect filetypes. They can base their decision on filename
      extension, location, or internal file contents.

   ftplugin
      Scripts that are executed when editing files with known type.

   compiler
      Definitions of how to run various compilers or linters, and of how to
      parse their output. Can be shared between multiple ftplugins.
      Also not applied automatically, must be called with :compiler

   pack
      Container for Vim 8 native packages, the successor to "Pathogen"
      style package management. The native packaging system does not
      require any third-party code.


.. seealso::
   :file:`ftplugin/README.rst`


So where are my files?
----------------------
This produces the weirdest behavior.
In order to find where files are, one can use a series of functions Vim
provides for stating the OS. However a fair number of them have clunky
syntax and produce surprising behavior.::

   let s:this_dir = fnameescape(fnamemodify(resolve('$MYVIMRC'), ':p:h'))
   echomsg s:this_dir

That resolves to your current working directory. I couldn't begin to tell you
why it does that.::

   let s:this_dir = fnameescape(fnamemodify(expand('$MYVIMRC'), ':p:h'))
   echomsg s:this_dir
   " use this 2 lines for debugging or just in a different spot if you want
   let s:something = fnamemodify(expand('<sfile>'), ':p:h')
   echomsg s:something

These 2 actually echo the same location!
*Assuming that you put those 2 in your vimrc.*

The rest of this document largely deals with setting up a comfortable
editing environment for any type of plain text file regardless of platform.


Better defaults for resizing windows
====================================
I've been using Vim for 5 years. And at this point I've forgotten most of the
bindings for resizing windows. They're all difficult to remember, arbitrarily
chosen, and uncomfortable.

For example.:

   - :kbd:`CTRL-W <`	   decrease current window width N columns
   - :kbd:`CTRL-W >`	   increase current window width N columns

That seems sensible right? But imagine you have a buffer with 2 windows
split right down the middle.
Your cursor is on the right side. You want to make it larger.

Doesn't it seem like :kbd:`CTRL-W <` should do the trick?

**The default bindings make dumb assumptions like assuming your cursor is always
in the top left.**

But today I noticed something else.

*They're really incomplete.*

There is no default binding to resize your currently focused window to make it
as small as possible. Put another way.:

**Vim doesn't have a default binding to minimize a window.**

Default bindings for this type of thing are so commonplace that I simply
opted to steal the ones from `tmux <https://github.com/tmux/tmux>`_.:

   C-Up, C-Down
   C-Left, C-Right
      Resize the current pane in steps of one cell.
   M-Up, M-Down
   M-Left, M-Right
      Resize the current pane in steps of five cells.

Instead of using :kbd:`C-a` or :kbd:`C-b` as a prefix like tmux does, let's
use the native Vim window prefix :kbd:`C-w`.

So let's set it up!:

   XXX


Working with Plugins
=====================
Vim-Plug is a highly recommended plugin manager, and the one that I myself use.
Written by Junegunn Choi (also the author of FZF), vim-plug creates a
simple way of interacting with plugins.

Beyond the basic commands you can read about in his README, vim-plug has
an API that exports the command ``plug``. This command utilizes vimscript to
return a dictionary with all of your currently loaded plugins.

This dict maintains the order that the plugins were loaded into the buffer and
can be accessed with

.. code-block:: vim

   echo keys(plugs)

This feature proves phenomenally useful in a handful of situations.

For example, one may want to check whether a ftplugin was lazily loaded or
loaded at all.

Echoing the plugins that Vim-Plug has loaded at startup time can also be
an easy way to diagnose performance issues with Vim.

As a product of its utility, I wrote a command to quickly call the dictionary.::

   command! Plugins -nargs=0 echo keys(plugs)

In addition, one could be in the situation where they may have
different configuration files on different devices, and would like to
check whether a plugin was installed. It's also good for debugging and
seeing in what order a plugin loads.

Git Subtree
-----------
Updating vim-plug.

.. code-block:: bash

   git subtree pull --squash --prefix=vim-plug https://github.com/junegunn/vim-plug.git master


Mappings
=========
Mappings initially sounds like a simple enough idea as it's generally commonplace
in other editors.:

    Map :kbd:`Ctrl` + :kbd:`Shift` + :kbd:`F1` to some arbitrary macro

Is conventionally how this works. In Vim there are 7 different mapping modes
that exist.

+--------------+-----------+---------+------------------------------------------+
| Map Overview |           |         |                                          |
+--------------+-----------+---------+------------------------------------------+
| Commands     | Modes     |         |                                          |
+--------------+-----------+---------+------------------------------------------+
| :map         | :noremap  | :unmap  | Normal, Visual, Select, Operator-pending |
+--------------+-----------+---------+------------------------------------------+
| :nmap        | :nnoremap | :nunmap | Normal                                   |
+--------------+-----------+---------+------------------------------------------+
| :vmap        | :vnoremap | :vunmap | Visual and Select                        |
+--------------+-----------+---------+------------------------------------------+
| :smap        | :snoremap | :sunmap | Select                                   |
+--------------+-----------+---------+------------------------------------------+
| :xmap        | :xnoremap | :xunmap | Visual                                   |
+--------------+-----------+---------+------------------------------------------+
| :omap        | :onoremap | :ounmap | Operating-pending                        |
+--------------+-----------+---------+------------------------------------------+
| :map!        | :noremap! | :unmap! | Insert and Command-line                  |
+--------------+-----------+---------+------------------------------------------+
| :imap        | :inoremap | :iunmap | Insert                                   |
+--------------+-----------+---------+------------------------------------------+
| :lmap        | :lnoremap | :lunmap | Insert, Command-line, Lang-Arg           |
+--------------+-----------+---------+------------------------------------------+
| :cmap        | :cnoremap | :cunmap | Command-line                             |
+--------------+-----------+---------+------------------------------------------+
| :tmap        | :tnoremap | :tunmap | Terminal                                 |
+--------------+-----------+---------+------------------------------------------+

There are a few things to note about this. One being that the commands map and
noremap do not apply to insert or command line mode. As a result, mappings that
would typically conflict with inserted text can easily be used.

My `mapleader` is currently set to :kbd:`Space`. If I were to map :kbd:`Space r e`
in insert mode, then any time I typed a word like 'return', the mapping would fire.

However, even the *relatively* permissive ``:noremap`` command doesn't touch
insert mode, command line mode or terminal mode!

So how does one ensure that they have a mapping in every mode?

Unfortunately, *to my knowledge* there's no way to do this in one command.
In fact, **it currently takes 3.**

.. code-block:: vim

   map <F2> <Cmd>NERDTreeToggle
   map! <F2> <Cmd>NERDTreeToggle
   tmap <F2> <Cmd>NERDTreeToggle

Nowhere near the most elegant solution; unfortunately, it seems to be the only
one.

However, using the ``<Cmd>`` keyword prevents us from having to prepend ``<C-o>``
from all of our normal mode mappings and ``<C-u>`` for the visual and select mode
mappings.

It actually never fires a ``CmdlineEnter`` event which also preserves our
command history.

Ensure that mappings use the ``<Cmd>`` idiom in place of :kbd:`<C-o>` for insert
mode or :kbd:`<C-u>` for visual mode.

.. topic:: Map cmd

    :map-cmd
                            *<Cmd>* *:map-cmd*
    The <Cmd> pseudokey may be used to define a 'command mapping', which executes
    the command directly (without changing modes, etc.).  Where you might use
    :...<CR>" in the {lhs} of a mapping, you can instead use '<Cmd>...<CR>'.

    ...

    Unlike <expr> mappings, there are no special restrictions on the <Cmd>
    command: it is executed as if an (unrestricted) ``autocmd`` was invoked or an
    async event event was processed.


To date I haven't had any problems with replacing all instances of :kbd:`:`
with ``<Cmd>``, and it makes Nvim behave in a slightly more manageable way.


Autocompletion And WildMode
===========================
Whew! Just spent a whole lot of time setting up autocompletion from scratch.
Let's first start with ex-mode completion.::

   set wildmode=full:list:longest,full:list

So what does this lugubrious setting provide?

Broken up with a comma, this indicates that your first use of
``wildchar``, or :kbd:`Tab`, will autocomplete the longest single completion. If
multiple match, show them but only fill until the longest common string.
This is nice because you won't have to delete extra characters that get
inputted by setting only the ``full`` or ``list`` options.

Then if you hit ``wildchar`` a second time, drop the longest option. If i hit
tab twice in a row, I want you to start auto-populating the command line

.. _insert-mode-completion:

Insert Mode Completion
----------------------
Because I can never remember these.

7. Insert mode completion                               *ins-completion*

In Insert and Replace mode, there are several commands to complete part of a
keyword or line that has been typed.  This is useful if you are using
complicated keywords (e.g., function names with capitals and underscores).

These commands are not available when the `+insert_expand` feature was
disabled at compile time.

Completion can be done for:

+-----------------------------------------------+------------+
| 1. Whole lines                                | <C-x><C-l> |
+-----------------------------------------------+------------+
| 2. Keywords in the current file               | <C-x><C-n> |
+-----------------------------------------------+------------+
| 3. Keywords in `dictionary`                   | <C-x><C-k> |
+-----------------------------------------------+------------+
| 4. Keywords in `thesaurus`                    | <C-x><C-t> |
+-----------------------------------------------+------------+
| 5. Keywords in the current and included files | <C-x><C-i> |
+-----------------------------------------------+------------+
| 6. Tags                                       | <C-x><C-]> |
+-----------------------------------------------+------------+
| 7. File names                                 | <C-x><C-f> |
+-----------------------------------------------+------------+
| 8. Definitions or macros                      | <C-x><C-d> |
+-----------------------------------------------+------------+
| 9. Vim Command Line                           | <C-x><C-v> |
+-----------------------------------------------+------------+
| 10. User defined completion                   | <C-x><C-u> |
+-----------------------------------------------+------------+
| 11. Omnicompletion (Filetype specific)        | <C-x><C-o> |
+-----------------------------------------------+------------+
| 12. Spelling Suggestions                      | <C-x>s     |
+-----------------------------------------------+------------+

.. _fzf:

FZF in Insert Mode
===================
For a good portion of these, I've written mappings that correspond to
their respective FZF functions. In addition I've added shorter variations
by dropping the redundant :kbd:`C-x`.

For example, :kbd:`C-f` only in insert mode invokes FZF.

That code can be found `here.`_


Different Shells
----------------
Inexplicably, nvim started a terminal buffer using *powershell* with no prompting!
:envvar:`SHELL` was set to pwsh and it automatically set things up correctly!::

   set shell=powershell
   set shellcmdflag-=c
   set shellredir=>
   set shellpipe=| tee
   set shellquote=

And seemingly nothing else. I think most of those are the bash defaults too!


Asynchronous Buffers
====================

.. admonition::
   Be careful when working with ``:jobstart``.

This function POURS output into the current buf so make sure you're
switched to a scratch buffer.

However... **THIS WORKS**::

   call jobstart('pydoc ' . expand('<cexpr>'), {'on_stdout':{j,d,e->append(line('.'),d)}})

.. function:: jobstart

   <cexpr> is replaced with the word under the cursor, including more to form a
   C expression. E.g., when the cursor is on "arg" of "ptr->arg" then the result
   is "ptr->arg"; when the cursor is on "]" of "list[idx]" then the result is
   "list[idx]".  This is used for ``v:beval_text``.


Coc Nvim
========
.. glossary::

   pum
      Pop up menu

A useful command on the ex line. Prefix with ``:py3``.:

.. code-block:: python3

   from pprint import pprint; pprint(vim.eval('coc#list#get_chars()'))

Don't use the below mapping because CR auto-selects the first
thing on the :abbr:`pum (popup-menu)` which is terrible when you're just trying
to insert whitespace.::

   inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"))


Fixing Coc auto-completion in the cmdwindow
-------------------------------------------
The :abbr:`pum (popup-menu)` would open after using :kbd:`q;`. It would then raise an error on
the ``CompleteDone`` event as it isn't allowed in the command window.::

   autocmd! User CmdlineEnter CompleteDone

Fixed things up perfectly.

.. todo::
   Why is this raising an error.

.. code-block:: vim

   " Example from docs
   call coc#config('coc.preferences', {
        \ 'timeout': 1000,
        \})
   call coc#config('languageserver', {
        \ 'ccls': {
        \   "command": "ccls",
        \   "trace.server": "verbose",
        \   "filetypes": ["c", "cpp", "objc", "objcpp"]
        \ }
        \})

   " This is throwing errors. What am i doing wrong?
   if !has('unix')
     call coc#config('python.condaPath', {
           \ 'C:/tools/vs/2019/Community/Common7/IDE/Extensions/Microsoft/Python/Miniconda/Miniconda3-x64/Scripts/conda'
           \ })
   " else todo
   endif


Beginners Intro
===============
To say Vim has a lot of options, associated files and directories is an
understatement. But these can be broken down piece by piece to be more
easily digestible.

First I'll go over setting basic options.


Options
=========
The first and most obvious file is the :file:`init.vim`. We can setup
the base options like so:

+--------------------------+----------------+
| Options                  |                |
+--------------------------+----------------+
| .. code-block:: vim      |                |
+--------------------------+----------------+
|    :let OPTION_NAME = 1  | Enable option  |
+--------------------------+----------------+
|    :let OPTION_NAME = 0  | Disable option |
+--------------------------+----------------+
| Continuation of settings |                |
+--------------------------+----------------+


let vs. set
------------
How do we utilize ``let`` for a built-in vim variables?

.. code-block:: vim

    let &grepprg = 'ag --nogroup --nocolor --column --vimgrep $*'

By prepending :kbd:`&` to the variable, Vim knows we're modifying the value of
a variable it recognizes and not defining our own. The single quotes are
still required; however I find this more manageable than adding a `\\``
before every single space.


``&virtualedit``
------------------
.. code-block:: vim

   set virtualedit=all

It allows you to move the cursor anywhere in the window.
If you enter characters or insert a visual block, Vim will add whatever
spaces are required to the left of the inserted characters to keep
them in place. Virtual edit mode makes it simple to edit tabular data.
Turn it off with ``:set virtualedit=.``


Diffopts
---------
My current ``&diffopt``.::

   " Filler lines to keep text synced, 0 lines of context on diffs,
   " don't diff hidden files,default foldcolumn is 2, case insensitive
   set diffopt=filler,context:0,hiddenoff,foldcolumn:2,icase,indent-heuristic,horizontal
   if has('patch-8.1.0360') | set diffopt+=internal,algorithm:patience | endif

.. todo::
   Annotate the rest


Creating Backups
================
The defaults are generally pretty good::

   setglobal writebackup        " protect against crash-during-write
   setglobal nobackup           " but do not persist backup after successful write

Change &backupext and &directory to things you want.


Environment Variables
=====================
Do not ever redefine :envvar:`$VIMRUNTIME`! This variable is used by both Neovim and
Vim; however, both define the var differently.

If this is set in a startup file like `.bash_profile` or `.bashrc`, it will
create compatibility issues between the two.

Nvim defines :envvar:`$VIMRUNTIME` as /usr/share/nvim/runtime/, in
comparison to Vim's /usr/share/vim/runtime/ definition. Therefore, defining `$VIMRUNTIME`
as /usr/share/vim/runtime/ in a startup file will cause unexpected behavior
in Neovim's startup.


Extraneous Environment Variables
--------------------------------
The below is an env var set as a convenient bridge between Ubuntu and Termux
As a result it messes things up if not set, but there's no reason to halt
everything. Feel free to discard if you copy/paste my vimrc.

Added: 05/18/19: Just found out Windows has an envvar ``%SystemRoot%``::

   if !exists('$_ROOT') && !empty(g:termux)
     let $_ROOT = expand('$PREFIX')
   elseif !exists('$_ROOT') && !empty(g:ubuntu)
     let $_ROOT = '/usr'
   elseif !exists('$_ROOT') && !empty(g:windows)
     " Or should I use ALLUSERSPROFILE
     let $_ROOT = expand('$SystemRoot')
   endif


.. _`here.`: after/plugin/fzf.vim
.. _`after/ftplugin/`: ./after/ftplugin/

Table of Contents
------------------
.. toctree::
   :maxdepth: 3

   fugitive_help.rst
   plugin.rst
   ftplugin.rst
   colors.rst
   python.rst



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
