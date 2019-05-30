" ============================================================================
    " File: unimpaired.vim
    " Author: Faris Chugthai
    " Description: I'm sorry @tpope
    " Last Modified: February 12, 2019
" ============================================================================

" Guards: {{{1

" Note that ]c and [c are mapped by git-gutter and ALE has ]a and [a
if exists('g:loaded_unimpaired_plugin') || &compatible || v:version < 700
    finish
endif
let g:loaded_unimpaired_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Unimpaired: {{{1

" Map quickfix list, buffers, windows and tabs to *[ and *]
noremap ]q <Cmd>cnext<CR>
noremap [q <Cmd>cprev<CR>
noremap ]Q <Cmd>clast<CR>
noremap [Q <Cmd>cfirst<CR>
noremap ]l <Cmd>lnext<CR>
noremap [l <Cmd>lprev<CR>
noremap ]L <Cmd>llast<CR>
noremap [L <Cmd>lfirst<CR>
noremap ]b <Cmd>bnext<CR>
noremap [b <Cmd>bprev<CR>
noremap ]B <Cmd>blast<CR>
noremap [B <Cmd>bfirst<CR>
noremap ]t <Cmd>tabn<CR>
noremap [t <Cmd>tabp<CR>
noremap ]T <Cmd>tablast<CR>
noremap [T <Cmd>tabfirst<CR>


" Navigate Buffers More Easily: {{{1

noremap <Leader>bb <Cmd>buffers<CR>
noremap <Leader>bd <Cmd>bdelete<CR>
noremap <Leader>bn <Cmd>bnext<CR>
noremap <Leader>bp <Cmd>bprev<CR>
noremap <Leader>bf <Cmd>bfirst<CR>
noremap <Leader>bl <Cmd>blast<CR>
noremap <Leader>bY <Cmd>"+%y<CR>
noremap <Leader>bP <Cmd>"+P<CR>
" Sunovabitch bonly isn't a command?? Why is
" noremap <Leader>bo <Cmd>bonly<CR>

" Navigate tabs more easily. First check we have more than 1 tho.
if len(nvim_list_tabpages()) > 1
    noremap  <A-Right>  <Cmd>tabnext<CR>
    noremap  <A-Left>   <Cmd>tabprev<CR>
    noremap! <A-Right>  <Cmd>tabnext<CR>
    noremap! <A-Left>   <Cmd>tabprev<CR>
elseif len(nvim_list_wins()) > 1
    noremap  <A-Right>  <Cmd>wincmd l<CR>
    noremap  <A-Left>   <Cmd>wincmd h<CR>
    noremap! <A-Right>  <Cmd>wincmd l<CR>
    noremap! <A-Left>   <Cmd>wincmd h<CR>
endif

nnoremap <Leader>tn <Cmd>tabnext<CR>
nnoremap <Leader>tp <Cmd>tabprev<CR>
nnoremap <Leader>tq <Cmd>tabclose<CR>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <Leader>te <Cmd>tabedit <c-r>=expand("%:p:h")<CR>

" It should also be easier to edit the config. Bind similarly to tmux
nnoremap <Leader>ed <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

noremap <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>
" Don't forget to add in mappings when in insert/cmd mode
noremap! <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

" Now reload it
noremap <Leader>re <Cmd>so $MYVIMRC<CR><Cmd>echo 'Vimrc reloaded!'<CR>

" atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
