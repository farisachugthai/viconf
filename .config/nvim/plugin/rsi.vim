" ============================================================================
    " File: rsi.vim
    " Author: Faris Chugthai
    " Description: A reimplementation of rsi.vim
    " Last Modified: December 08, 2018
" ============================================================================

if exists('did_rsi_vim') || &cp|| v:version < 700
    finish
endif
let did_rsi_vim = 1

" RSI: {{{1
"
" Readline_Basics:{{{2
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

" History:{{{2
" recall newer command-line. {Actually C-n and C-p on Emacs}
cmap <A-n> <Down>
" recall previous (older) command-line. {But we can't lose C-n and C-p}
cmap <A-p> <Up>

" Other:{{{2
" How did I do this backwards??
" It's annoying you lose a whole command from a typo
cnoremap <Esc> <nop>
" However I still need the functionality
cnoremap <C-g> <Esc>

" In case you want inspiration!
" <A-BS> is delete previous word
" C-k is kill from cursor to end of line
" C-u is either kill from cursor to beginning of line or an indication of a
" count with a command
" C-y is yank.