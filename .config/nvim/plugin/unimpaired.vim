" ============================================================================
    " File: unimpaired.vim
    " Author: Faris Chugthai
    " Description: I'm sorry @tpope
    " Last Modified: February 12, 2019
" ============================================================================

" Unimpaired:
" Note that ]c and [c are mapped by git-gutter and ALE has ]a and [a
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :cfirst<CR>
nnoremap [Q :clast<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap ]L :lfirst<CR>
nnoremap [L :llast<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]B :blast<CR>
nnoremap [B :bfirst<CR>
nnoremap ]t :tabn<CR>
nnoremap [t :tabp<CR>

" TODO: Everything but these 2 are backwards. At least as first last goes.
nnoremap [T :tfirst<CR>
nnoremap ]T :tlast<CR>
