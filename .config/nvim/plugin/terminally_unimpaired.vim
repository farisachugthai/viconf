" ============================================================================
    " File: terminally_unimpaired.vim
    " Author: Faris Chugthai
    " Description: Because noremap doesn't change terminal mappings
    " Last Modified: April 14, 2019
" ============================================================================

if exists('g:did_terminally_unimpaired_vim') || &cp || v:version < 700
    finish
endif
let g:did_terminally_unimpaired_vim = 1

" Mappings:

" IPython in a Vim terminal acts oddly. If you hit i or a it doesn't move to where
" your cursor is. It moves relative to its old positon.

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

" Move around the line
tnoremap <A-A> <Esc>A
tnoremap <A-b> <Esc>b
tnoremap <A-d> <Esc>d
tnoremap <A-f> <Esc>f

" Other window
tnoremap <C-w> <Esc><C-w>

" test that these work
" nope
tnoremap <A-a> <Esc>I
tnoremap <A-e> <Esc>$i

" Leader -- applications -- htop. Requires nvim for <Cmd> which tmk doesn't exist
" even in vim8.0+. Also requires htop which more than likely rules out Win32.

" Need to use enew in case your previous buffer setl nomodifiable
noremap <Leader>ah <Cmd>wincmd v<CR><bar><Cmd>enew<CR><bar>term://htop

" Leader -- applications -- IPython

" Let's add options to this to give the feeling of a real plugin
function! g:IPython() abort
  if !exists('g:ipy_vert') && !exists('g:ipy_horiz') && !exists('g:ipy_tab')
    let g:ipy_horiz = 1
  endif
endfunction

" do later
