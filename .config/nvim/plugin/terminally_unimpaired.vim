" ============================================================================
    " File: terminally_unimpaired.vim
    " Author: Faris Chugthai
    " Description: noremap doesn't change terminal mappings
    " Last Modified: April 14, 2019
" ============================================================================

" Mappings:

" IPython in a Vim terminal acts oddly. If you hit i or a it doesn't move to where
" your cursor is. It moves relative to its old positon.
" TODO: Add more readline mappings for terminal.

" If running a terminal in Vim, go into Normal mode with Esc
tnoremap <Esc> <C-\><C-n>
" From he term. Alt-R is better because this causes us to lose C-r in every
" command we run from nvim
tnoremap <expr> <A-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
" From :he terminal
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

tnoremap <A-A> <Esc>A
tnoremap <A-b> <Esc>b
tnoremap <A-d> <Esc>d
tnoremap <A-f> <Esc>f

" test that these work
" nope
tnoremap <A-a> <Esc>I
tnoremap <A-e> <Esc>$i
