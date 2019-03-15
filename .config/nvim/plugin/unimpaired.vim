" ============================================================================
    " File: unimpaired.vim
    " Author: Faris Chugthai
    " Description: I'm sorry @tpope
    " Last Modified: February 12, 2019
" ============================================================================

" Unimpaired:
" Note that ]c and [c are mapped by git-gutter and ALE has ]a and [a
if exists('g:loaded_unimpaired') || &cp || v:version < 700
    finish
endif
let g:loaded_unimpaired = 1

let s:cpo_save = &cpo
set cpo&vim

nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap ]L :llast<CR>
nnoremap [L :lfirst<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]B :blast<CR>
nnoremap [B :bfirst<CR>
nnoremap ]t :tabn<CR>
nnoremap [t :tabp<CR>
nnoremap ]T :tlast<CR>
nnoremap [T :tfirst<CR>

let &cpo = s:cpo_save
unlet s:cpo_save
