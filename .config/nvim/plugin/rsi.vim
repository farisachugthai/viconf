" ============================================================================
    " File: rsi.vim
    " Author: Faris Chugthai
    " Description: A reimplementation of rsi.vim
    " Last Modified: May 30, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_rsi_vim_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_rsi_vim_plugin = 1

" Readline_Basics:{{{1

" Admonition: The below doesn't work the way youd assume.
" cnoremap <Tab> <C-a>
" This still ends up recursively binding where Tab inputs every completion
" suggestion it can so it brings up completion suggestions, then the C-a to
" Home binding brings it to the beginning of the line after inserting.
" Shits retarded.

" Command Line: {{{2
" Admittedly it would be weird to set the 2nd one since that's all this does
" but whatever.
if exists('no_plugin_maps') || exists('no_rsi_maps')
  finish
endif

" start of line
cnoremap <C-a> <Home>
" back one character
cnoremap <C-b> <Left>
" delete character under cursor
cnoremap <C-d> <Del>
" end of line. I think Vim's default behavior
cnoremap <C-e> <End>
" forward one character
cnoremap <C-f> <Right>

" back one word
cmap <A-b> <S-Left>
" forward one word
cmap <A-f> <S-Right>

" page down
cnoremap <C-v> <PageDown>
" page up
cmap <A-v> <PageUp>

cnoremap        <M-d> <S-Right><C-W>

" Insert Mode And Command: {{{2

noremap! <C-a> <C-o>^
noremap!        <M-d> <C-O>dw
noremap!        <M-BS> <C-W>
noremap!        <M-f> <S-Right>
noremap!        <M-n> <Down>
noremap!        <M-p> <Up>


" History: {{{1

" recall newer command-line. {Actually C-n and C-p on Emacs}
cnoremap <A-n> <Down>
" recall previous (older) command-line. {But we can't lose C-n and C-p}
cnoremap <A-p> <Up>

" Other: {{{1

" It's annoying you lose a whole command from a typo
cnoremap <Esc> <nop>
" However I still need the functionality
cnoremap <C-g> <Esc>

" From he cedit. Open the command window with F1 because it being bound to
" help is SO annoying.
execute 'set cedit=<F1>'

" In the same line of thinking:
" Avoid accidental hits of <F1> while aiming for <Esc>
noremap! <F1> <Esc>


" In case you want inspiration!: {{{2
" <A-BS> is delete previous word
" C-k is kill from cursor to end of line
" C-y is yank.
" Idk if this would only work in the command window but <C-v> and <M-v> would
" be page forward and page back. Think Vim C-f and C-b.

" Already default Vim behavior!: {{{2
" C-u is either kill from cursor to beginning of line or an indication of a
" count with a command
" C-w is backwards delete word so that's 2.
" C-j and C-m for accept and enter new line make 4!

" Pure Emacs: {{{1
" There are more comfortable ways of doing the following in Vim.
" I'm not going to convince you it's better. That it's cleaner.
" Unfortunately, there are  few of *their* keybindings wired in.
" May as well map them correctly.

" Alt-x: {{{2
" This seemingly trivial difference determines whether the following is run
" by fzf or the vim built-in, and they both have quite different looking
" interfaces IMO.
if exists('*fzf#wrap')
  noremap <M-x>      <Cmd>Commands<CR>
  noremap <C-x><C-b> <Cmd>Buffers<CR>
else
  noremap <M-x> <Cmd>commands<CR>
  noremap <C-x><C-b> <Cmd>buffers<CR>
endif

noremap <silent> <C-x>o <Cmd>wincmd W<CR>
