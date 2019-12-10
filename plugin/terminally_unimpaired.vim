" ============================================================================
    " File: terminally_unimpaired.vim
    " Author: Faris Chugthai
    " Description: Configuring the terminal
    " Last Modified: Sep 13, 2019
" ============================================================================

if executable('htop')  " {{{1
  " Leader -- applications -- htop. Requires nvim for <Cmd> which tmk doesn't exist
  " even in vim8.0+. Also requires htop which more than likely rules out Win32.

  " Need to use enew in case your previous buffer setl nomodifiable
  noremap <Leader>ah <Cmd>wincmd v<CR><bar><Cmd>enew<CR><bar>term://htop
endif

" Autocompletion on the cmdline: {{{1
set wildcharm=<C-z>  " {{{1
nnoremap ,e :e **/*<C-z><S-Tab>

set path-=/usr/include
nnoremap ,f :find **/*<C-z><S-Tab>

if exists($ANDROID_DATA)
  " May 26, 2019: Just ran into my first problem from a filename with a space in the name *sigh*
  nnoremap <silent> <Leader>ts <Cmd>execute '!termux-share -a send ' . shellescape(expand("%"))<CR>
endif

" MSDOS terminal accomodations: {{{1

" Options: {{{2

if !has('unix')
  if exists('+shellslash')   " don't drop the +!
    set shellslash
  endif

  " I'm running pwsh but honestly the support is too sloppy.

  " In usr_41 it's mentioned that files formatted with dos formatting won't
  " run vim scripts correctly so holy shit that might explain a hell of a lot
  " Comment this out because we now define ffs as only unix in $MYVIMRC
  " set fileformats=unix,dos

  " 'slash' and 'unix' are useful on Windows when sharing view files
  " with Unix.  The Unix version of Vim cannot source dos format scripts,
  " but the Windows version of Vim can source unix format scripts.
  set sessionoptions+=unix,slash viewoptions+=unix,slash

  " ConEmu is complaining but it stops if we do this
  if !empty($TERM) | unlet $TERM | endif

  " So this HAS to be a bad idea; however, all 3 DirChanged autocommands emit
  " errors and that's a little insane
  " Oct 22, 2019: Somehow I've observed literally 0 problems with this and the
  " error is still emitted when the dir changes soooo
  set eventignore=DirChanged

  " Set the shell: {{{2
  command! Cmd call msdos#Cmd()

  command! PowerShell call msdos#PowerShell()

  command! PwshHelp call msdos#pwsh_help(shellescape(<f-args>))
endif


if !has('nvim') | finish | endif  " {{{1

augroup TermGroup

  " Fuck you know what I just noticed?
  au!
  " Dude I never ran a bare au! to clear mappings out jeez
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

  " Set up mappings
  autocmd TermOpen * call buffers#terminals()

augroup END
