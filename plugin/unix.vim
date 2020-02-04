" ============================================================================
    " File: unix.vim
    " Author: Faris Chugthai
    " Description: Add GNU/Linux commands, functions and mappings
    " Last Modified: Dec 16, 2019
" ============================================================================

if exists('g:did_unix') || &compatible || v:version < 700
  finish
endif
let g:did_unix = 1

nnoremap zE <nop>

let s:root_dir = fnameescape(fnamemodify(expand('$MYVIMRC'), ':p:h:h'))

if has('unix')
  call unix#UnixOptions()
else
  " exec 'source ' . s:root_dir . '\autoload\msdos.vim'
  call msdos#set_shell_cmd()
endif

if exists($ANDROID_DATA)
  " May 26, 2019: Just ran into my first problem from a filename with a space in the name *sigh*
  nnoremap <silent> <Leader>ts <Cmd>execute '!termux-share -a send ' . shellescape(expand("%"))<CR>
endif

"	:S	Escape special characters for use with a shell command (see
"		|shellescape()|). Must be the last one. Examples:
"           :!dir <cfile>:S
"           :call system('chmod +w -- ' . expand('%:S'))
" From :he filename-modifiers in the cmdline page.
command! -nargs=1 -complete=file Chmod call system('chmod +x ' . expand('%:S'))

" More From The Bottom Of Help Map: {{{1
command! -nargs=+ -complete=file MyEdit
    \ for f in expand(<q-args>, 0, 1) |
    \ exe '<mods> split ' . f |
    \ endfor

command! -nargs=+ -complete=file Sedit call unix#SpecialEdit(<q-args>, <q-mods>)

" There are more comfortable ways of doing the following in Vim.
" I'm not going to convince you it's better. That it's cleaner.
" Unfortunately, there are  few of *their* keybindings wired in.
" May as well map them correctly.

" This seemingly trivial difference determines whether the following is run
" by fzf or the vim built-in, and they both have quite different looking
" interfaces IMO.
if exists('*fzf#wrap')
  nnoremap <M-x>                      <Cmd>FufCommands<CR>
  nnoremap <C-x><C-b>                 :<C-u>FufBuffers
  nnoremap <C-x><C-f>                 :<C-u>FufFiles
else
  nnoremap <M-x>                      <Cmd>verbose command<CR>
  nnoremap <C-x><C-b>                 <Cmd>buffers<CR>
  nnoremap <C-x><C-f>                 :<C-u>find ~/**
endif


function! AddVileBinding(key, handler)
  " Map a key 3 times for normal mode, insert and command.
  exec 'nnoremap ' . a:key a:handler
  exec 'inoremap ' . a:key a:handler
  exec 'cnoremap ' . a:key a:handler

endfunction
" oh
call AddVileBinding('<C-x>o', '<Cmd>wincmd W<CR>')
" zero
call AddVileBinding('<C-x>0', '<Cmd>wincmd c<CR>')

call AddVileBinding('<C-x>1', '<Cmd>wincmd o<CR>')

" Both Tmux and Readline utilize C-a. It's a useful keybinding and
" my preferred manner of going to col-0 in insert mode. Cue vim-rsi
" a la Tim Pope. Cool. It'd be kinda cool to have that in normal mode.
nnoremap C-a ^
" But now I can't increment stuff.
" I just realized today {Oct 01, 2019} that the + key in normal mode does
" nothing different than <CR>. Wtf???
nnoremap + C-a

" As a nod to the inspiration I also want it in insert-mode
call AddVileBinding('<C-x><C-r>', '<Cmd>source $MYVIMRC<CR>echomsg "Reread $MYVIMRC"<CR>')

" Swap the mark and point
xnoremap <C-x><C-x> o
