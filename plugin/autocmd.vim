" ============================================================================
  " File: autocmd.vim
  " Author: Faris Chugthai
  " Description: Auto commands. Statusline as well.
  " Last Modified: February 17, 2020
" ============================================================================

scriptencoding utf8
setglobal ruler

let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

if !exists("$MSYSTEM")
  colo gruvbox-material
else
  colo gruvbox
endif

call syncom#grepprg()

function! s:fzf_statusline()  abort
  " Curious if this'll work
  hi! fzf1 cterm=bold,undercurl,reverse gui=bold,undercurl,reverse guifg=#7daea3 guibg=NONE ctermbg=NONE guisp=NONE font='Source Code Pro'
  hi! link fzf2 fzf1
  hi! link fzf3 fzf1
  setlocal statusline=%#fzf1#\ FZF:\ %#fzf2#fz%#fzf3#f
endfunction

function! s:VarExists(var, val) abort
  if exists(a:var)
    return a:val
  else
    return ''
  endif
endfunction

function! s:StatusDiagnostic() abort
  if !exists('g:loaded_coc') | return '' | endif

  let l:info = get(b:, 'coc_diagnostic_info', {})
  if empty(l:info) | return '' | endif
  let l:msgs = []
  if get(l:info, 'error', 0)
    call add(l:msgs, 'E' . l:info['error'])
  endif
  if get(l:info, 'warning', 0)
    call add(l:msgs, 'W' . l:info['warning'])
  endif
  return join(l:msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

function! s:_Statusline(bang, ...) range abort
  " from he 'statusline'.
  " Each status line item is of the form:
  " %-0{minwid}.{maxwid}{item}

  let s:sep = ' %= '
  let s:pos = ' %-12(%l : %c%V%) '

  if exists('*strftime')
    " Overtakes the whole screen when Termux zooms in
    " Worth noting that %< indicates where to truncate the &stl though
    if &columns > 80
      let s:tstmp = '| %{strftime("%H:%M %m-%d-%Y", getftime(expand("%:p")))} |'
      " last modified timestamp
    else
      let s:tstmp = ''
    endif
  else
    let s:tstmp = ''  " ternary expressions should get on the todo list
  endif
  let s:gutentags = '%{exists("g:gutentags_enabled") ? gutentags#statusline() : ""}'

  let g:statusline = '« [%n]: '
        \. s:VarExists('*WebDevIconsGetFileTypeSymbol', '%{WebDevIconsGetFileTypeSymbol()}')
        \. '%< %m%r %y %w»'
        \. s:VarExists('g:loaded_fugitive', '%{FugitiveStatusline()}')
        \. ' %{&ff} ' . s:tstmp
        \. s:VarExists('g:did_coc_loaded', ' %{coc#status()} ')
        \. s:VarExists('g:coc_git_status', ' %{coc_git_status} ')
        \. '◀ 😀 %.30F ▶'
        \. s:sep
        \. s:StatusDiagnostic()
        \. s:VarExists('g:ale_enabled', '«[ALE Lints]»: # %{getbufvar(bufnr(""), "ale_linted", 0)} | ')
        \. s:gutentags
        \. '«: '. s:pos . '%*' . ' %P »'

  if a:bang ==# 1
    redrawstatus!
  endif
  let &statusline = g:statusline
  return g:statusline
endfunction

function! Statusline(bang, ...) abort
  return s:_Statusline(a:bang, a:000)
endfunction

command! -bang -bar -nargs=* -range=% -addr=loaded_buffers -complete=expression -complete=var ReloadStatusline call Statusline(<bang>0, <q-args>)

augroup FZFStatusline
  " NOTE: This has to remain the name of the augroup it's what Junegunn calls
  au!
  autocmd User call s:fzf_statusline()
  autocmd User setlocal winblend=15 pumblend=10
augroup END

augroup UserStatusline
  au!
  autocmd User CocStatusChange,CocDiagnosticChange
        \| if exists('*Statusline')
        \| call Statusline(1)
        \| endif

  autocmd VimEnter * call Statusline(1)
augroup END

augroup UserFtplugin
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

  autocmd BufWritePre *.h,*.cc,*.cpp call format#ClangCheck()

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
augroup END

function! s:Goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  " ... Limelight
endfunction

function! s:Goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  " ... Limelight!
endfunction

augroup UserPlugins
  au!
  autocmd  User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  " autocmd CursorHold * sil if exists('*CocActionAsync') | call CocActionAsync('highlight') | endif

  " " let's see if this works better
  " autocmd CursorHoldI * sil if exists('*CocActionAsync') | call CocActionAsync('showSignatureHelp') | endif
  " autocmd  User CursorHold call CocActionAsync('showSignatureHelp')

  " autocmd! User CursorHoldI
  " todo: why did he add the exclamation mark and the nested?
  if exists('#GoyoEnter')
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
  endif

  if exists('#vim-which-key')
    autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
  endif

  if exists('g:loaded_vista')
    autocmd FileType vista,vista_kind nnoremap <buffer> <silent> \
  endif
augroup END

function! StripTrailingWhitespace() abort
  let l:current_line = line(".")
  let l:column = col(".")
  %s/\s\+$//e
  call cursor(l:current_line, l:column)
endfunction

augroup UserPotpourri
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
  autocmd CmdwinEnter [/?]  startinsert
  autocmd CmdwinLeave [/?]  stopinsert

  autocmd BufWrite * call StripTrailingWhitespace()

  autocmd Syntax * syntax sync fromstart linebreaks=2

  autocmd BufWinEnter * if &previewwindow | setlocal nonumber nornu | else | setlocal number relativenumber |  endif
  "
  " Clear this so that p.u.m. doesn't open in the command window
  autocmd! User CmdlineEnter CompleteDone

augroup END

if exists('#TagbarAutoCmds')
  au! TagbarAutoCmds *
endif

augroup UserNerdLoader
  autocmd!
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdTree')
        \|   execute 'autocmd! UserNerdLoader'
        \| endif
augroup END

if !has('nvim') | finish | endif

augroup UserTerm
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

  " Dear god this i awful looking
  " autocmd TermOpen,WinEnter * if &buftype=='terminal'
  "   \|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
  "   \|else|setlocal winhighlight=|endif

  " *TermResponse*
  " After the response to t_RV is received from the terminal.
  " The value of |v:termresponse| can be used to do things depending on the terminal version.
  " Note that this event may be triggered halfway through another event (especially if file I/O,
  " a shell command, or anything else that takes time is involved).
  au TermResponse * echomsg 'Term response was ' . v:termresponse
augroup END
