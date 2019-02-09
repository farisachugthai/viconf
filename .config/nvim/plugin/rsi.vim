" ============================================================================
    " File: rsi.vim
    " Author: Faris Chugthai
    " Description: A reimplementation of rsi.vim
    " Last Modified: Feb 09, 2019
" ============================================================================

" Guards: {{{1
if exists('did_rsi_vim') || &cp|| v:version < 700
    finish
endif
let did_rsi_vim = 1

let s:cpo_save = &cpo
set cpo&vim

" Readline_Basics: {{{1

" Cmdline Mappings: {{{2
" From `:he tips` and the section on Emacs keys
" start of line
cnoremap <C-A> <Home>
" back one character
cnoremap <C-B> <Left>
" delete character under cursor
cnoremap <C-D> <Del>
" end of line
" Interestingly this is already Vim's default behavior!
cnoremap <C-E> <End>
" forward one character
cnoremap <C-F> <Right>

" Page up and page down in insert mode: {{{3
" Hey look what I just found in `:he insert`
" <S-ScrollWheelDown>  move window one page down		*i_<S-ScrollWheelDown>*
" ...
" <S-ScrollWheelUp>    move window one page up		*i_<S-ScrollWheelUp>*
" Could we map things in that way too? Hm. Unfortunately I'm sure there are
" plugins or other things that depend on C-v because that defines literal
" pasting of text right?
" }}}


" page down
cnoremap <C-v> <PageDown>
" page up
cmap <A-v> <PageUp>
" Top of buffer
cmap <A\<> :norm gg
" Bottom of buffer
cmap <A\>> :norm G

cnoremap        <M-d> <S-Right><C-W>

" Insert Mode Mappings: {{{2
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>

" General Mappings: {{{2
" back one word
noremap! <A-b> <S-Left>
" forward one word
noremap! <A-f> <S-Right>

noremap!        <M-d> <C-O>dw

" delete previous word
noremap!        <M-BS> <C-W>

" History: {{{1

" recall newer command-line. {Actually C-n and C-p on Emacs}
cmap <A-n> <Down>
" recall previous (older) command-line. {But we can't lose C-n and C-p}
cmap <A-p> <Up>

" Other: {{{1

" How did I do this backwards??
" It's annoying you lose a whole command from a typo
cmap <Esc> <nop>

" However I still need the functionality
cnoremap <C-g> <Esc>

" From he cedit. Open the command window with Esc so it at least does
" something.
" Does this work?
exe "set cedit=\<Esc>"

" In case you want inspiration!
" C-k is kill from cursor to end of line
" C-u is either kill from cursor to beginning of line or an indication of a
" count with a command
" C-y is yank.

" Idk if this would only work in the command window but <C-v> and <M-v> would
" be page forward and page back. Think Vim C-f and C-b.

" Compatability Guard: {{{1
let &cpo = s:cpo_save
unlet s:cpo_save
