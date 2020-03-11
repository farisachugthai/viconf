" ============================================================================
  " File: autocmd.vim
  " Author: Faris Chugthai
  " Description: Auto commands
  " Last Modified: February 17, 2020
" ============================================================================

" if exists('g:loaded_autocmd') || &compatible || v:version < 700
"   finish
" endif
" let g:loaded_autocmd = 1

let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

augroup UserHelpandPython " {{{
  au!
  autocmd FileType man,help setlocal number relativenumber
  autocmd FileType man,help  if winnr('$') > 1
        \| wincmd T
        \| endif

  autocmd FileType python exec 'source ' . s:repo_root . '/ftplugin/python.vim'
  autocmd FileType python,xonsh let &l:path = py#PythonPath()
  autocmd FileType python,xonsh call py#ALE_Python_Conf()

  " Not ready yet. BE CAREFUL and go read :he BufReadCmd and Cmd-events
  " inspired by $VIMRUNTIME/plugin/man.vim
  " autocmd BufReadCmd pydoc:// call pydoc_help#foo(matchstr(expand('<amatch>'), 'pydoc://\zs.*'))

  if exists('*SuperTabChain')
    autocmd FileType *
      \ if &omnifunc != ''
      \|  call SuperTabChain(&omnifunc, "<c-p>")
      \| else
      \|  call SuperTabChain(&completefunc, "<c-p>")
      \| endif
  endif


augroup END
" }}}

" TODO: {{{
" Also worth noting func buffers#PreviewWord
" :[range]ps[earch][!] [count] [/]pattern[/]
" 		Works like |:ijump| but shows the found match in the preview
" 		window.  The preview window is opened like with |:ptag|.  The
" 		current window and cursor position isn't changed.  Useful
" 		example: >
" 			:psearch popen
" <		Like with the |:ptag| command, you can use this to
" 		automatically show information about the word under the
" 		cursor.  This is less clever than using |:ptag|, but you don't
" 		need a tags file and it will also find matches in system
" 		include files.  Example: >
"   :au! CursorHold *.[ch] ++nested exe "silent! psearch " . expand("<cword>")
"
"   Ah that's a fucking amazing idea!  }}}

augroup UserCoc " {{{
  au!
  autocmd  User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd  User CursorHold call CocActionAsync('showSignatureHelp')
  " Clear this so that p.u.m. doesn't open in the command window
  autocmd! User CmdlineEnter CompleteDone

augroup END

" }}}

if !has('nvim') | finish | endif

augroup UserTerm " {{{
  au!
  autocmd TermOpen * setlocal statusline=%{b:term_title}

  " `set nomodified` so Nvim stops prompting you when you
  " try to close a buftype==terminal buffer. afterwards clean up the window
  autocmd TermOpen * setlocal nomodified norelativenumber foldcolumn=0 signcolumn=

  " April 14, 2019: To enter |Terminal-mode| automatically:
  autocmd TermOpen * startinsert

  " Jul 17, 2019: It's been like 3 months and I only recently realized
  " that I didn't mention to leave insert mode when the terminal closes...
  autocmd TermClose * stopinsert

  " Set up mappings
  autocmd TermOpen * call buffers#terminals()

  " Dear god this i awful looking
  " autocmd TermOpen,WinEnter * if &buftype=='terminal'
  "   \|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
  "   \|else|setlocal winhighlight=|endif

augroup END

augroup UserStl
  autocmd!
  au CmdwinEnter [/?]  startinsert
augroup END
" }}}

