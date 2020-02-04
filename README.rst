========
README
========

:Author: Faris Chugthai
:Date: Jul 06, 2019

Directory Layout and Runtimepath
=================================

How are the folders in a :mod:`pynvim` neovim directory tree supposed to be
laid out?

While each directory serves a specific purpose, depending on use case, not
all need to be created and used.

The variable of importance is ``runtimepath``. The varying
directories all affect how different settings are recorded and in what order
the code is ran.

We can observe this with::

   set rtp   " or alternatively
   echo &rtp

Runtimepath
-----------

Here's a quick summary of the folders in a standard runtimepath layout.

.. glossary::

   plugin/
       Vim script files that are loaded automatically when editing any kind of
       file. Called “global plugins.”
   autoload/
       (Not to be confused with “plugin.”) Scripts in autoload contain
       functions that are loaded only when requested by other scripts.
   ftdetect/
       Scripts to detect filetypes. They can base their decision on filename
       extension, location, or internal file contents.
   ftplugin/
       Scripts that are executed when editing files with known type.
   compiler/
       Definitions of how to run various compilers or linters, and of how to
       parse their output. Can be shared between multiple ftplugins.
       Also not applied automatically, must be called with :compiler
   pack/
       Container for Vim 8 native packages, the successor to “Pathogen”
       style package management. The native packaging system does not
       require any third-party code.

Ftplugin
~~~~~~~~~~

Ftplugin files should be used to totally override the configuration
neovim has built-in for a certain filetype.

You either have to be **THAT** discontent with it, or willing to simply
copy and paste the original and then add your own modifications in.

The standard ftplugin files on a Linux system are found in the
`runtime directory </usr/share/nvim/runtime>`_ in the
`ftplugin section </usr/share/nvim/runtime/ftplugin/`_.

In lieu of doing all of that, `after/ftplugin`_ simply builds on the
configuration that comes built in the with editor.

.. note:: Guards

    This is only true if you put ftplugin guards in your configs.
    However, you absolutely should.

As a result, we won't put the usual ftplugin guard in there. However, we
should do something to ensure that buffers of a different filetype don't
source everything in `after/ftplugin`_.

For example, let's say we were in `after/ftplugin/gitcommit.vim`_.

Something like this pseudo code would be perfect.:

.. code-block:: vim

    if ft != None && ft != gitcommit | finish | endif


Then put that in everything in that dir.

Syntax
~~~~~~~

A similar way of organizing Vim's configuration files exists with the directory
that dictates syntax highlighting: `after/syntax`_. We also have a fair
number of files in `syntax`_

.. _`syntax`: ./syntax/


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


Spell Files
============

From the help docs

.. topic:: Spellfile Cleanup

    SPELLFILE CLEANUP         *spellfile-cleanup*

    The ``zw`` command turns existing entries in 'spellfile' into comment lines.
    This avoids having to write a new file every time, but results in the file
    only getting longer, never shorter.  To clean up the comment lines in all
    ".add" spell files do this:

    `:runtime spell/cleanadd.vim`

    This deletes all comment lines, except the ones that start with "##".  Use
    "##" lines to add comments that you want to keep.

    You can invoke this script as often as you like.  A variable is
    provided to skip updating files that have been changed recently.  Set
    it to the number
    of seconds that has passed since a file was changed before it will be
    cleaned. For example, to clean only files that were not changed in the last
    hour:

    `let g:spell_clean_limit = 60 * 60`

    The default is one second.


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
| :omap        |           |         | Operating-pending                        |
+--------------+-----------+---------+------------------------------------------+
| :map!        |           |         | Insert and Command-line                  |
+--------------+-----------+---------+------------------------------------------+
| :imap        |           |         | Insert                                   |
+--------------+-----------+---------+------------------------------------------+
| :lmap        |           |         | Insert, Command-line, Lang-Arg           |
+--------------+-----------+---------+------------------------------------------+
| :cmap        |           |         | Command-line                             |
+--------------+-----------+---------+------------------------------------------+
| :tmap        |           |         | Terminal                                 |
+--------------+-----------+---------+------------------------------------------+

There are a few things to note about this. One being that the commands map and
noremap do not apply to insert or command line mode. As a result, mappings that
would typically conflict with inserted text can easily be used.

My `mapleader` is currently set to :kbd:`Space`. If I were to map :kbd:`Space r e`
in insert mode, then any time I typed a word like 'return', the mapping would fire.

However, ``noremap`` doesn't touch insert mode.

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

Autocompletion
===============

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

FZF in Insert Mode
~~~~~~~~~~~~~~~~~~~

For a good portion of these, I've written mappings that correspond to
their respective FZF functions. In addition I've added shorter variations
by dropping the redundant :kbd:`C-x`.

For example, :kbd:`C-f` only in insert mode invokes FZF.

That code can be found `here.`_


Different Shells
================

Inexplicably, nvim started a terminal buffer using *powershell* with no prompting!
:envvar:`SHELL` was set to pwsh and it automatically set things up correctly!::

   set shell=powershell
   set shellcmdflag-=c
   set shellredir=>
   set shellpipe=| tee
   set shellquote=

And seemingly nothing else. I think most of those are the bash defaults too!

Jumps
======

Are something I never utilize frequently enough.:

                                                        *CTRL-O*
CTRL-O                  Go to [count] Older cursor position in jump list
                        (not a motion command).

<Tab>           or                                      *CTRL-I* *<Tab>*
CTRL-I                  Go to [count] newer cursor position in jump list
                        (not a motion command).


That's legitimately wonderful to know!

Now I just need to work that in, and make a few utility mappings for the
quickfix window.

Folds
-----

.. admonition::  foldclose=all  " close folds automatically when you move out of them

Jesus Christ is this setting annoying. Don't set it!


Includes and the Path
---------------------

Setting the path the way that you want is hard; however, I seem to have found
a method for doing so that works. Should be functional on both windows and linux,
for any python installation and regardless of whether python was installed from
a package manager or Anaconda.

In addition, it still works quickly as recursive includes can get out of
control very quickly.

.. code-block:: vim

   function py#PythonPath() abort  " {{{1

   " Note: the path option is to find directories so it's usually unnecesssary
   " to glob if you have the /usr/lib/python dir in hand.
   " let s:orig_path = &path

   " The current path and the buffer's dir. Also recursively search downwards
   let s:path = '.,,**,'

   if !empty('g:python3_host_prog')

      if has('unix')
         let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h:h')
         " max out at 3 dir deep
         " don't go 3 dir in includes start going REALLY slowly
         let s:site_pack = s:root_dir . '/lib/python3.7/site-packages/**'

         let s:path = s:path . s:site_pack
         let s:path = ',' . s:root_dir . '/lib/python3.7/*' . s:path . ','
         let s:path =  ',' . s:root_dir . '/lib/python3.7/**/*' . s:path . ','

      " sunovabitch conda doesn't put stuff in the same spot
      else
         let s:root_dir = fnamemodify(g:python3_host_prog, ':p:h')

         let s:site_pack = s:root_dir . '/lib/site-packages/**2/'
         let s:path = s:path . s:site_pack

         " This option requires that the **# either is at the end of the path or
         " ends with a '/'
         " let s:path =  ',' . s:root_dir . '/lib/**1/' . s:path . ','
         " make this last. its the standard lib and we prepend it to the path so
         " it should be first in the option AKA last in the function
         let s:path = s:root_dir . '/lib' . s:path
      endif

   " else
      " Todo i guess. lol sigh
      " return s:orig_path

   endif

   return s:path
   " if this still doesn't work keep wailing at python_serves_python

   endfunction


Asynchronous Buffers
====================

.. admonition:: Be careful when working with ``jobstart``.

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
thing on the :abbr:`pum` which is terrible when you're just trying
to insert whitespace.::

   inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"))


Fixing Coc auto-completion in the cmdwindow
-------------------------------------------
The `pum` would open after using :kbd:`q;`. It would then raise an error on
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

.. todo:: Annotate the rest


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
.. _`after/ftplugin/gitcommit.vim`: ./after/ftplugin/gitcommit.vim
.. _`after/ftplugin/`: ./after/ftplugin/
.. _`after/syntax/`: ./after/syntax/
