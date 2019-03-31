" ============================================================================
    " File: fugitive.vim
    " Author: Faris Chugthai
    " Description: Fugitive configuration
    " Last Modified: March 30, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'vim-fugitive')
    finish
endif

if exists('g:did_fugitive_conf') || &compatible || v:version < 700
    finish
endif
let g:did_fugitive_conf = 1

" Mappings: {{{1
nnoremap <silent> <Leader>gb   <Cmd>Gblame<CR>
nnoremap <silent> <Leader>gc   <Cmd>Gcommit<CR>
nnoremap <silent> <Leader>gd   <Cmd>Gdiff<CR>
nnoremap <silent> <Leader>gds  <Cmd>Gdiff --staged<CR>
nnoremap <silent> <Leader>gds2 <Cmd>Git diff --stat --staged<CR>
nnoremap <silent> <Leader>ge   <Cmd>Gedit<Space>
nnoremap <silent> <Leader>gf   <Cmd>Gfetch<CR>
nnoremap <silent> <Leader>gL   <Cmd>0Glog --pretty=oneline --graph --decorate --abbrev --all --branches<CR>
nnoremap <silent> <Leader>gm   <Cmd>Gmerge<CR>
" Make the mapping longer but clear as to whether gp would pull or push
nnoremap <silent> <Leader>gpl  <Cmd>Gpull<CR>
nnoremap <silent> <Leader>gps  <Cmd>Gpush<CR>
nnoremap <silent> <Leader>gq   <Cmd>Gwq<CR>
nnoremap <silent> <Leader>gQ   <Cmd>Gwq!<CR>
nnoremap <silent> <Leader>gR   :Gread<Space>
noremap <silent> <Leader>gs   <Cmd>Gstatus<CR>
nnoremap <silent> <Leader>gst  <Cmd>Git diff --stat<CR>
nnoremap <silent> <Leader>gw   <Cmd>Gwrite<CR>
nnoremap <silent> <Leader>gW   <Cmd>Gwrite!<CR>
