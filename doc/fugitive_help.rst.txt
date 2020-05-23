========================
Extra Fugitive Help Docs
========================

.. module:: vim_fugitive.autoload.fugitive
   :synopsis: Fugitive help.

The lost fugitive help docs.

Fugitive is an absolutely amazing plugin for Vim, and the more that I learn
about Vimscript, the more I'm left in absolute awe of what `tpope`_
accomplished with it.

However, to a shocking extent the documentation is incredibly incomplete.

Did you know that there's an ``User`` autocmd that fugitive comes with?
You can pretty heavily configure the way that Fugitive works, but judging
by it's


API Documentation
=================

Options
-------

.. option:: fugitive_columns

Yes there are options that you can set in advance.::

   function! s:OpenExec(cmd, mods, env, args, ...) abort
     let options = a:0 ? a:1 : {'dir': s:Dir()}
     let temp = tempname()
     let columns = get(g:, 'fugitive_columns', 80)
     ...
   endfunction

Seemingly the most reasonable thing to do as a result is something to
the effect of.::

   let g:fugitive_columns = &columns      " set to fullscreen
   let g:fugitive_columns = &columns / 2  " 50/50 split


Functions
---------

.. function:: BufReadStatus() abort

   Hulking 300 line function that calls a different function to set up
   mappings, sets up 50 of the buffer local mappings in ``:Gstatus``, sets
   the ``git`` buffer's filetype and many other things that we now take
   for granted thanks to `tpope`_.

I wanted to add a default argument to every instance of ``git write`` as
on my Windows devices I've noticed things working more smoothly if it's
always run as ``git write --renormalize``.

So let's start digging!

.. function:: WriteCommand(line1, line2, range, bang, mods, arg, args) abort

   The function that implements the commands ``:Gw`` and ``:Gwrite``.
   Unfortunately takes no options or has any configurable options it considers.

.. function:: s:ChompError(...) abort

   One of the functions that *directly* shells out and calls the git executable.

I wanted to have something like this work.::

  " Update the Gwrite commands to A) have them work correctly on windows and B) allow user customization
  if !exists('g:fugitive_write_args')
    let g:fugitive_write_args = ''
  endif

  " How tpope implements ``:Gwrite``. I mean Jesus Christ just look at that!
  exe 'command! -bar -bang -nargs=* -complete=customlist,fugitive#EditComplete Gw     exe fugitive#WriteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])'
  exe 'command! -bar -bang -nargs=* -complete=customlist,fugitive#EditComplete Gwrite exe fugitive#WriteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])'
  exe 'command! -bar -bang -nargs=* -complete=customlist,fugitive#EditComplete Gwq    exe fugitive#WqCommand(   <line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])'

.. _tpope: https://github.com/tpope
