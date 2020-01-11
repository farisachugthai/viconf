" ============================================================================
    " File: fugitive.vim
    " Author: Faris Chugthai
    " Description: Fugitive configuration
    " Last Modified: Dec 05, 2019
" ============================================================================

function! Fugitive_mappings() abort
  nnoremap <Leader>gb   <Cmd>Gblame<CR>
  nnoremap <Leader>gc   <Cmd>Gcommit<CR>
  nnoremap <Leader>gd   <Cmd>Gdiffsplit!<CR>
  cabbrev Gd Gdiffsplit!<Space>
  nnoremap <Leader>gds  <Cmd>Gdiffsplit! --staged<CR>
  cabbrev gds2 Git diff --stat --staged
  nnoremap <Leader>gds2 <Cmd>Git diffsplit! --stat --staged<CR>
  nnoremap <Leader>ge   <Cmd>Gedit<Space>
  nnoremap <Leader>gf   <Cmd>Gfetch<CR>
  cabbrev gL 0Glog --pretty=oneline --graph --decorate --abbrev --all --branches
  nnoremap <Leader>gL   <Cmd>0Glog --pretty=oneline --graph --decorate --abbrev --all --branches<CR>
  nnoremap <Leader>gm   <Cmd>Gmerge<CR>
  " Make the mapping longer but clear as to whether gp would pull or push
  nnoremap <Leader>gp  <Cmd>Gpull<CR>
  nnoremap <Leader>gP  <Cmd>Gpush<CR>
  nnoremap <Leader>gq   <Cmd>Gwq<CR>
  nnoremap <Leader>gQ   <Cmd>Gwq!<CR>
  nnoremap <Leader>gR   <Cmd>Gread<Space>
  nnoremap <Leader>gs   <Cmd>Gstatus<CR>
  nnoremap <Leader>gst  <Cmd>Git diffsplit! --stat<CR>
  nnoremap <Leader>gw   <Cmd>Gwrite<CR>
  nnoremap <Leader>gW   <Cmd>Gwrite!<CR>
endfunction

if exists('g:loaded_fugitive')
  call Fugitive_mappings()
endif
