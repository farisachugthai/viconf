.. _plugin-README:

=============
User Plugins
=============

:date: 05/24/2019

.. highlight:: vim

Aka the directory for blocks of Vimscript that got too long to justifiably
stay in the `init.vim <../init.vim>`_.

Below are just some notes on how to best work with these files.

Motivation
==========

If you're not sure why you would want to begin breaking up your vimrc,
I can't recommend `Tom Ryder's writing enough
<https://vimways.org/2018/from-vimrc-to-vim>`_

Common Vim Naming Conventions
=============================

Just making a short mental note that it's common convention to use
``let g:loaded_plugin_name`` when writing a guard for a plugin.

It's common convention to use ``b:did_ftplugin`` for a specific ftplugin,
and similarly named guards for the indent and syntax directories.

Particularly relevant because, for example, an rst filetype plugin doesn't
need the var to be named ``b:did_rst_ftplugin``.

The variable is buffer-local so it's implied what the
``&ft`` is and if not then you can check that ``&var`` right there.

In spite of that I'm going to keep naming the guards this way as
you regularly see more than one ftplugin in the output of `scriptnames`.

In directories where it makes sense to load more than one file, like `syntax`_,
adding var names will probably pay dividends.

.. _syntax:

Autocmd for Vim Commentary
===========================

I found this in `after/plugin/vim-commentary.vim`_ but ... why? So I want
to move it in here but I'm not actually sure where.

.. code-block:: vim

   " Should I make it only 1 keybinding? Would make interface easier
   augroup commentary
       autocmd!
       autocmd Filetype python noremap <Leader># ^<Plug>CommentaryLine
       autocmd Filetype javascript noremap <Leader>// ^<Plug>CommentaryLine
       autocmd Filetype vim noremap <Leader>" ^<Plug>CommentaryLine
   augroup END


Function Scoping
=================

If you set a guard at the beginning of a plugin file that reads something
to the effect of::

   if exists('g:did_plugin_name') || &compatible || v:version < 700
      finish
   endif
   let g:did_plugin_name = 1

As it's been set globally, we won't reload the file unless we explicitly
`source %` it.

.. caution:: You actually won't reload it in any situation.

So there's actually no need anymore to define functions as::

   function! VimFoo() abort

And it'd actually possibly be better to define it without the :kbd:`!`.
We would want an error if that go re-sourced and re-defined.


Writing Plugins on NT systems
==============================

From ``:he source_crnl``

.. code-block:: help

   Windows: Files that are read with ":source" normally have <CR><NL> <EOL>s.
   These always work.  If you are using a file with <NL> <EOL>s (for example, a
   file made on Unix), this will be recognized if 'fileformats' is not empty and
   the first line does not end in a <CR>.  This fails if the first line has
   something like ":map <F1> :help^M", where "^M" is a <CR>.  If the first line
   ends in a <CR>, but following ones don't, you will get an error message,
   because the <CR> from the first lines will be lost.

   On other systems, Vim expects ":source"ed files to end in a <NL>.  These
   always work.  If you are using a file with <CR><NL> <EOL>s (for example, a
   file made on Windows), all lines will have a trailing <CR>.  This may cause
   problems for some commands (e.g., mappings).  There is no automatic <EOL>
   detection, because it's common to start with a line that defines a mapping
   that ends in a <CR>, which will confuse the automaton.

**tl;dr** Always use ``ff=unix ffs=unix,dos`` even on NT.


Debugging FZF
==============

Here are 2 commands I'm still actively working on.::

   " Doesn't work
   command! -bang -nargs=* -complete=file_in_path FZRgFind
         \ call fzf#vim#grep(
         \ 'rg --no-heading --smart-case --no-messages ^ '
         \ . shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview({'dir': system('git rev-parse --show-toplevel 2&>/dev/null')[:-2]}, 'up:60%')
         \ : fzf#vim#with_preview({'dir': system('git rev-parse --show-toplevel 2&>/dev/null')[:-2]}, 'right:50%:hidden', '?'),
         \ <bang>0)

   " Damn still doesn't work
   command! -bang -nargs=* -complete=file_in_path FZFind
         \ call fzf#vim#grep(
         \ 'rg --no-heading --smart-case --no-messages ^ '
         \ . shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%')
         \ : fzf#vim#with_preview('right:50%:hidden', '?'),
         \ <bang>0)
   " Grep: {{{2


Working with tags
==================

In the opposite vein of unimpaired (as unimpaired uses keybindings of the
flavor :kbd:`]` :kbd:`[a-z]`), I just found the keybinding :kbd:`g]`!

It's phenomenally useful but because of unimpaired I'm inclined to remember it
as ]g instead of g].

However that's not hard to fix!::

   nnoremap ]g g]
   nnoremap ]g g]

Then I began reviewing tagsrch.txt. And wow.::

                                                           *g]*
   g]			Like CTRL-], but use ":tselect" instead of ":tag".

                                                           *v_g]*
   {Visual}g]		Same as "g]", but use the highlighted text as the
                           " identifier.

                                                           *:tj* *:tjump*
   :tj[ump][!] [name]	Like ":tselect", but jump to the tag directly when
                           there is only one match.

                                                           *:stj* *:stjump*
   :stj[ump][!] [name]	Does ":tjump[!] [name]" and splits the window for the
                           selected tag.

                                                           *g_CTRL-]*
   g CTRL-]		Like CTRL-], but use ":tjump" instead of ":tag".

So let's do better than g]!::

   nnoremap ]g <Cmd>stjump!<CR>
   xnoremap ]g <Cmd>stjump!<CR>
   " Don't forget
   ptag!

.. note::
   The <Cmd> pseudo-mapping is only available on Neovim.


Mappings
=========

Here's a few different ways to map a function to a key.

   " TODO: Not really working. Kinda hard to get it to behave how I'd like.
   vnoremap <C-\> :<C-u>call UltiSnips#ListSnippets()<CR>
   And another!
   vnoremap <C-\> <Cmd>call UltiSnips#ListSnippets()<CR>
   And another
   vnoremap <expr> <C-\> UltiSnips#list_snippets()



ALE --- Asynchronous Lint Engine
================================

A plugin that lints buffers as well as, as of late, supports the LSP protocol.

quickfix vs. locationlist
--------------------------
By default ale uses location lists.

Location lists are tied to the window they were created for, not the
entire session as the quickfix list is. Because commands like ``:lwindow``
and ``:lopen`` are window specific, you only see linting information for your
current buffer to populate the list.

If ALE were to use the quickfix, you would see linting information for
every buffer you have open simultaneously, which would be a nightmare.

More importantly, you don't want every buffer to wipe your quickfix list
while you're in the middle of actually recompiling something
simply to view a few linter errors.

Node
-----

Shockingly, this simple if/else was the difference between :file:`ale.vim`
loading in 0.4 msecs and ~15.::

   if !has('unix')
     if isdirectory('C:/Program Files/nodejs/node.exe')
       let g:ale_windows_node_executable_path = 'C:/Program Files/nodejs/node.exe'
     elseif executable(exepath('node.exe'))
       let g:ale_windows_node_executable_path = exepath('node.exe')
     endif
   endif

Searching
=========


Here's a helpful tidbit from the help pages.:

   g*			Like "*", but don't put "\<" and "\>" around the word. 
                        This makes the search also find matches that are not a
			whole word.

							*g#*
   g#			Like "#", but don't put "\<" and "\>" around the word.
   			This makes the search also find matches that are not a
			whole word.

::

   nnoremap * g*
   nnoremap # g#


Using ``*`` and ``#`` to search in Visual Mode
==============================================

It's bugged me for a while that :kbd:`*` and :kbd:`#` don't search when
you have text selected in visual mode.
I found a little section in the help that inspired the perfect way to fix that.:

   Note that the ":vmap" command can be used to specifically map keys in Visual
   mode.  For example, if you would like the "/" command not to extend the Visual
   area, but instead take the highlighted text and search for that::

      :vmap / y/<C-R>"<CR>

   (In the <> notation ``<>``, when typing it you should type it literally; you
   need to remove the 'B' flag from '&cpoptions'.)

So I implemented that as::

   xnoremap * y/<C-R>"<CR>/<CR>gvzz
   xnoremap # y?<C-R>"<CR>gvzz

'xmap' because visual map, in a really unintuitive move, includes select-mode.
*If you're unfamiliar, select-mode is basically visual-mode with overwrite.*
I don't want this mapping to include anything but visual mode so xmap.

Then yank into the clipboard and begin a search with :kbd:`/`.
<C-R> or Control-r inserts text literally while in insert-mode, while on the
command line and while searching. <C-R>" inserts clipboard text!
<CR> to start the search.

The extra :kbd:`/` and :kbd:`<CR>` are because a forward slash and a <CR>
repeat the last search, *and oddly this mapping doesn't working without it.*

``gv`` reselects the last text you had highlighted in visual mode. And ``zz``
re-centers the cursor!

Using shells besides cmd or bash
================================

In usr_41 it's mentioned that files formatted with dos formatting won't
run vim scripts correctly so holy shit that might explain a hell of a lot
Comment this out because we now define ``&ff`` as only unix in $MYVIMRC.::

   set fileformats=unix,dos

Related to inter-op on Windows.:

   'slash' and 'unix' are useful on Windows when sharing view files
   with Unix.  The Unix version of Vim cannot source dos format scripts,
   but the Windows version of Vim can source unix format scripts.

Supertab
========

Supertab is a great plugin to build on insert-mode completion.

I realized none of this was necessary.

From :file:`./supertab.vim`.

.. code-block:: vim

   if !exists('g:loaded_supertab') | finish | endif

   " Culmination Of The Help Docs:

   " Pretty much a copy paste of the last section of the help docs except
   " I added the autocmd to it's own augroup.

   " 40% of the way in he sets up the context for you.

   " Might give this a try
   let g:SuperTabDefaultCompletionType = '<C-x><C-u>'

Stopped using this as the completefunc option wasn't set.
Supertab appears to provide a litany of functions for use;
however, so this might be revisited.

For example, one could do.::

   set completefunc=SuperTabCodeComplete

Note: once the buffer has been initialized, changing the value of this setting
will not change the default complete type used. If you want to change the
default completion type for the current buffer after it has been set, perhaps
in an ftplugin, you'll need to call *SuperTabSetDefaultCompletionType* like so,
supplying the completion type you wish to switch to::

   let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
   let g:SuperTabContextDiscoverDiscovery =
           \ ['&completefunc:<c-x><c-u>', '&omnifunc:<c-x><c-o>']


This configuration will result in a completion flow like so::

   "   if text before the cursor looks like a file path:
   "     use file completion
   "   elif text before the cursor looks like an attempt to access a member
   "   (method, field, etc):
   "     use user completion
   "       where user completion is currently set to supertab's
   "       completion chaining, resulting in:
   "         if omni completion has results:
   "           use omni completion
   "         else:
   "           use keyword completion
   "   else:
   "     use keyword completion


Fugitive
=========

I put all of my mappings into a function. Now I'm trying to figure out how to
call that functional in a conditional way. Function calls are expensive in Vim,
*and honestly even defining enough is pretty bad* so we don't want it called
on every new BufEnter.

.. todo:: How do we call UserFugitiveMappings in a way that still behaves as expected.

I think we gotta set up an autocmd that fires on ``DirChanged``.

Oddly fugitive doesn't do that at all! Check the output of ``:augroup fugitive``
*which btw you should do with*
``autocmd fugitive`` not ``augroup``.

There's a autocommand::

   fugitive  BufNewFile
       \*         call FugitiveDetect(expand('<amatch>:p'))

That does the same thing that I did in this function::

   function! ProjectRoot() abort
     " Like how would this not be really useful all the time?
     return FugitiveExtractGitDir(fnamemodify(expand('%'), ':p:h'))
   endfunction

User Defined Commands
=======================

Feb 25, 2020:
Can be too difficult to write; however, they're pretty great when done
correctly.

- `:Find` with no arg opens this file

- `:Find!` does as well
  
- `:Find <TAB><TAB>` begins cycling files

- `:Find README.md` opens the first README.md in the path

- `:2Find README.md` opens the 2nd README.md in the path

- completes as expected

User defined find.::

   command! -nargs=* -range=% -addr=buffers -count -bang -bar -complete=file_in_path Find :<count><mods>find<bang> <args>

