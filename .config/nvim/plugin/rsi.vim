" ============================================================================
    " File: rsi.vim
    " Author: Faris Chugthai
    " Description: A reimplementation of rsi.vim
    " Last Modified: Jan 29, 2019
" ============================================================================

if exists('did_rsi_vim') || &cp|| v:version < 700
    finish
endif
let did_rsi_vim = 1

" Readline_Basics:{{{1

" start of line
cnoremap <C-A> <Home>
" back one character
cnoremap <C-B> <Left>
" delete character under cursor
cnoremap <C-D> <Del>
" end of line
cnoremap <C-E> <End>
" forward one character
cnoremap <C-F> <Right>

" back one word
cmap <A-b> <S-Left>
" forward one word
cmap <A-f> <S-Right>

" page down
cnoremap <C-v> <PageDown>
" page up
cmap <A-v> <PageUp>
" Top of buffer
cmap <A\<> :norm gg
" Bottom of buffer
cmap <A\>> :norm G

" History: {{{1

" recall newer command-line. {Actually C-n and C-p on Emacs}
cmap <A-n> <Down>
" recall previous (older) command-line. {But we can't lose C-n and C-p}
cmap <A-p> <Up>

" Other: {{{1

" How did I do this backwards??
" It's annoying you lose a whole command from a typo
cnoremap <Esc> <nop>
" However I still need the functionality
cnoremap <C-g> <Esc>

" From he cedit. Open the command window with F1 because it being bound to
" help is SO annoying.
execute 'set cedit=<F1>'

" In case you want inspiration!
" <A-BS> is delete previous word
" C-k is kill from cursor to end of line

" Already default Vim behavior!
" C-u is either kill from cursor to beginning of line or an indication of a
" count with a command

" C-y is yank.

" Idk if this would only work in the command window but <C-v> and <M-v> would
" be page forward and page back. Think Vim C-f and C-b.
