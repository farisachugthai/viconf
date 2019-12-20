" ============================================================================
    " File: unix.vim
    " Author: Faris Chugthai
    " Description: Add GNU/Linux commands, functions and mappings
    " Last Modified: Jul 13, 2019
" ============================================================================

nnoremap zE <nop>

if has('unix')
  call unix#UnixOptions()
else
  runtime autoload/msdos.vim
endif

if exists($ANDROID_DATA)
  " May 26, 2019: Just ran into my first problem from a filename with a space in the name *sigh*
  nnoremap <silent> <Leader>ts <Cmd>execute '!termux-share -a send ' . shellescape(expand("%"))<CR>
endif


" Alternative Edit Implementation: {{{1
" Completes filenames from the directories specified in the 'path' option:
command! -nargs=1 -bang -complete=customlist,unix#EditFileComplete
   	\ EF edit<bang> <args>

" Chmod: {{{1
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


" Pure Emacs: {{{1
" There are more comfortable ways of doing the following in Vim.
" I'm not going to convince you it's better. That it's cleaner.
" Unfortunately, there are  few of *their* keybindings wired in.
" May as well map them correctly.

" This seemingly trivial difference determines whether the following is run
" by fzf or the vim built-in, and they both have quite different looking
" interfaces IMO.
if exists('*fzf#wrap')
  nnoremap <M-x>      <Cmd>Commands<CR>
  nnoremap <C-x><C-b> <Cmd>Buffers<CR>
else
  nnoremap <M-x>      <Cmd>commands<CR>
  nnoremap <C-x><C-b> <Cmd>buffers<CR>
endif

nnoremap <silent> <C-x>o <Cmd>wincmd W<CR>

" Control A And Incrementing: {{{1
" Both Tmux and Readline utilize C-a. It's a useful keybinding and
" my preferred manner of going to col-0 in insert mode. Cue vim-rsi
" a la Tim Pope. Cool. It'd be kinda cool to have that in normal mode.
nnoremap C-a ^
" But now I can't increment stuff.
" I just realized today {Oct 01, 2019} that the + key in normal mode does
" nothing different than <CR>. Wtf???
nnoremap + C-a

command! -bar RangerChooser call vim_file_chooser#RangeChooser()
nnoremap <leader>r :<C-U>vim_file_chooser#RangerChooser<CR>
