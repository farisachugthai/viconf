" ============================================================================
    " File: terminally_unimpaired.vim
    " Author: Faris Chugthai
    " Description: Configuring the terminal
    " Last Modified: Sep 13, 2019
" ============================================================================

if executable('htop')
  " Leader -- applications -- htop. Requires nvim for <Cmd> which tmk doesn't exist
  " even in vim8.0+. Also requires htop which more than likely rules out Win32.

  " Need to use enew in case your previous buffer setl nomodifiable
  nnoremap <Leader>ah <Cmd>wincmd v<CR><bar><Cmd>enew<CR><bar>term://htop
endif

set wildcharm=<C-z>
nnoremap ,e :e **/*<C-z><S-Tab>

set path-=/usr/include
nnoremap ,f :find **/*<C-z><S-Tab>

if !empty($ANDROID_DATA)
  " May 26, 2019: Just ran into my first problem from a filename with a space in the name *sigh*
  command! TermuxSend :<C-u>execute '!termux-share -a send ' . shellescape(expand('%'))<CR>
  nnoremap <Leader>ts :<C-u>TermuxSend<CR>
endif

if !has('unix')
  if exists('+shellslash')   " don't drop the +!
    set shellslash
  endif
  set sessionoptions+=unix,slash viewoptions+=unix,slash

  " So this HAS to be a bad idea; however, all 3 DirChanged autocommands emit
  " errors and that's a little insane
  " Oct 22, 2019: Somehow I've observed literally 0 problems with this and the
  " error is still emitted when the dir changes soooo
  set eventignore=DirChanged

  command! SetCmd call msdos#set_shell_cmd()
  call msdos#set_shell_cmd()

  command! -nargs=? CmdInvoke call msdos#invoke_cmd(<q-args>)
  command! -nargs=? -complete=shellcmd Cmd call msdos#CmdTerm(<q-args>)
  command! PowerShell call msdos#PowerShell()

  command! -nargs=? PwshHelp call msdos#pwsh_help(shellescape(<f-args>))
endif

if !has('nvim') | finish | endif

augroup UserTerm
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

augroup END
