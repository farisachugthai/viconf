" ============================================================================
    " File: terminally_unimpaired.vim
    " Author: Faris Chugthai
    " Description: Configuring the terminal
    " Last Modified: Sep 13, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_terminally_unimpaired_vim') || &compatible || v:version < 700
    finish
endif
let g:did_terminally_unimpaired_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C


if executable('htop')  " {{{1
  " Leader -- applications -- htop. Requires nvim for <Cmd> which tmk doesn't exist
  " even in vim8.0+. Also requires htop which more than likely rules out Win32.

  " Need to use enew in case your previous buffer setl nomodifiable
  noremap <Leader>ah <Cmd>wincmd v<CR><bar><Cmd>enew<CR><bar>term://htop
endif

" Vim doesn't have this autocmd event
if !has('nvim')
  finish
endif 

augroup TermGroup
  " Statusline in the terminal: {{{1
  autocmd TermOpen * setlocal statusline=%{b:term_title}

  " `set nomodified` so Nvim stops prompting you when you
  " try to close a buftype==terminal buffer. afterwards clean up the window
  autocmd TermOpen * setlocal nomodified norelativenumber foldcolumn=0 signcolumn=

  " April 14, 2019
  " To enter |Terminal-mode| automatically:
  autocmd TermOpen * startinsert

  " Jul 17, 2019: It's been like 3 months and I only recently realized
  " that I didn't mention to leave insert mode when the terminal closes...
  autocmd TermClose * stopinsert
augroup END


" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
