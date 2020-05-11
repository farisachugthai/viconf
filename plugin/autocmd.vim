" ============================================================================
  " File: autocmd.vim
  " Author: Faris Chugthai
  " Description: Auto commands
  " Last Modified: February 17, 2020
" ============================================================================

let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

augroup UserHelpandPython " {{{
  au!
  autocmd FileType man,help setlocal number relativenumber
  autocmd FileType man,help  if winnr('$') > 1
        \| wincmd T
        \| endif

  " Not ready yet. BE CAREFUL and go read :he BufReadCmd and Cmd-events
  " inspired by $VIMRUNTIME/plugin/man.vim
  " autocmd BufReadCmd pydoc:// call pydoc_help#foo(matchstr(expand('<amatch>'), 'pydoc://\zs.*'))

  " Here's a solid group to test out on
  " Blocks the UI and jams shit
  " au! CursorHold .xonshrc ++nested exe "silent! psearch " . expand("<cword>")

  autocmd BufWinEnter * if &previewwindow | setlocal nonumber nornu | else | setlocal number relativenumber |  endif

augroup END
" }}}

function! s:Goyo_enter() " Goyo: {{{
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  " ... Limelight
endfunction
" }}}

function! s:Goyo_leave()   " {{{
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  " ... Limelight!
endfunction
" }}}

augroup UserPlugins " {{{
  au!
  autocmd  User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  " autocmd CursorHold * sil if exists('*CocActionAsync') | call CocActionAsync('highlight') | endif

  " " let's see if this works better
  " autocmd CursorHoldI * sil if exists('*CocActionAsync') | call CocActionAsync('showSignatureHelp') | endif
  " autocmd  User CursorHold call CocActionAsync('showSignatureHelp')
  "
  " Clear this so that p.u.m. doesn't open in the command window
  autocmd! User CmdlineEnter CompleteDone

  " autocmd! User CursorHoldI
  " todo: why did he add the exclamation mark and the nested?
  if exists('#GoyoEnter')
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
  endif

  if exists('#vim-which-key')
    autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
  endif
augroup END " }}}

augroup UserPotpourri  " {{{
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
  autocmd CmdwinEnter [/?]  startinsert
  autocmd CmdwinLeave [/?]  stopinsert

  autocmd Syntax * syntax sync fromstart linebreaks=2
  " hopefully this will only call one time
  " so far is working perfectly
  " autocmd VimEnter * call UltiSnipsConf()
  " autocmd VimEnter * call syncom#gruvbox_material()
  " autocmd VimEnter * call syncom#grepprg()
augroup END  " }}}

exec 'source ' . s:repo_root . '/autoload/syncom.vim'

call syncom#gruvbox_material()
call syncom#grepprg()
" augroup TagbarAutoCmds
"   " Dude holy christ is this annoying
"   au! CursorHold *
"   au! CursorHoldI *
" augroup END

if exists('#TagbarAutoCmds')
  au! TagbarAutoCmds *
endif

augroup UserNerdLoader  " {{{
  autocmd!
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdTree')
        \|   execute 'autocmd! UserNerdLoader'
        \| endif

augroup END " }}}

augroup UserFiletypesCompletions  " {{{
  au!
  " Show type information automatically when the cursor stops moving
  autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

  autocmd BufEnter * if &l:omnifunc ==# '' | setlocal omnifunc=syntaxcomplete#Complete | endif

  autocmd BufEnter * if &l:completefunc ==# '' | setlocal completefunc=syntaxcomplete#Complete | endif

  if exists('*SuperTabChain')
    autocmd FileType *
      \ if &omnifunc != ''
      \|  call SuperTabChain(&omnifunc, "<c-p>")
      \| else
      \|  call SuperTabChain(&completefunc, "<c-p>")
      \| endif
  endif
augroup END  " }}}

if !has('nvim') | finish | endif

augroup UserTerm " {{{
  au!
  autocmd TermOpen * setlocal statusline=%{b:term_title}

  " `set nomodified` so Nvim stops prompting you when you
  " try to close a buftype==terminal buffer. afterwards clean up the window
  autocmd TermOpen * setlocal nomodified norelativenumber foldcolumn=0 signcolumn=

  " April 14, 2019: To enter |Terminal-mode| automatically:
  " Use TermEnter instead of TermOpen
  autocmd TermEnter * startinsert

  " Jul 17, 2019: It's been like 3 months and I only recently realized
  " that I didn't mention to leave insert mode when the terminal closes...
  " Leave instead of close so if the term is still open but you switch buffers
  " you go back to normal
  autocmd TermLeave * stopinsert

  " Set up mappings
  autocmd TermOpen * call buffers#terminals()

  " Dear god this i awful looking
  " autocmd TermOpen,WinEnter * if &buftype=='terminal'
  "   \|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
  "   \|else|setlocal winhighlight=|endif

	" *TermResponse*
" TermResponse			After the response to t_RV is received from
	" 			the terminal.  The value of |v:termresponse|
	" 			can be used to do things depending on the
	" 			terminal version.  Note that this event may be
	" 			triggered halfway through another event
	" 			(especially if file I/O, a shell command, or
	" 			anything else that takes time is involved).
  au TermResponse * echomsg 'Term response was ' . v:termresponse
augroup END  " }}}

