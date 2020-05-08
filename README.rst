========
README
========

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

Runtimepath
-----------

Here's a quick summary of the folders in a standard runtimepath layout.

.. glossary::

   plugin
       Vim script files that are loaded automatically when editing any kind of
       file. Called “global plugins.”
   autoload
       (Not to be confused with “plugin.”) Scripts in autoload contain
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

So where are my files?
----------------------

This produces the weirdest behavior.
In order to find where files are, one can use a series of functions Vim
provides for stating the OS. However a fair number of them have clunky
syntax and produce surprising behavior.::

   " let s:this_dir = fnameescape(fnamemodify(resolve('$MYVIMRC'), ':p:h'))
   " echomsg s:this_dir

That resolves to your current working directory. I couldn't begin to tell you
why it does that.::

   let s:this_dir = fnameescape(fnamemodify(expand('$MYVIMRC'), ':p:h'))
   echomsg s:this_dir
   " use this 2 lines for debugging or just in a different spot if you want
   let s:something = fnamemodify(expand('<sfile>'), ':p:h')
   echomsg s:something

These 2 actually echo the same location!
*assuming that you put those 2 in your vimrc.*

The rest of this document largely deals with setting up a comfortable
editing environment for any type of plain text file regardless of platform.


Better defaults for resizing Windows
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



.. _autocompletion:

Autocompletion
---------------

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

This function POURS output into the current buffer.
Keep in mind that this happens asynchronously so button-mashing :kbd:`Ctrl-c`
won't get you anywhere! Make sure you're switched to a scratch buffer.

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


Fixing Coc auto-completion in the cmd-window
--------------------------------------------
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

Change ``&backupext`` and ``&directory`` to things you want.


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
