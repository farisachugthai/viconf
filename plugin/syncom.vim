" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

if exists('g:did_syncom') || &compatible || v:version < 700
  finish
endif
let g:did_syncom = 1

" Make shift-insert work like in Xterm: {{{
noremap <S-Insert> <MiddleMouse>
noremap! <S-Insert> <MiddleMouse>
tnoremap <S-Insert> <MiddleMouse>
" }}}

" Highlighting Commands: {{{
command! HL call syncom#HL()
command! HiC call syncom#HiC()
command! HiQF call syncom#HiQF()
command! SyntaxInfo call syncom#get_syn_info()

" Working:
command! HiTest call syncom#hitest()
" }}}

" Plug Mappings: {{{
nnoremap <Plug>(HL) <Cmd>call syncom#HL()<CR>
nnoremap <Plug>(HiC) <Cmd>HiC<CR>
nnoremap <Plug>(HiQF) <Cmd>HiQF<CR>
nnoremap <Plug>(SyntaxInfo) <Cmd>SyntaxInfo<CR>

if !hasmapto('<Plug>(HL)')
  nnoremap <Leader>h <Plug>(HL)
endif  " }}}

" Use the down arrow when the pums open: {{{
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>
inoremap <Up> <C-R>=pumvisible() ? "\<lt>C-P>" : "\<lt>Up>"<CR>

" }}}

augroup UserColors  " {{{
  autocmd!
  autocmd VimEnter * colorscheme gruvbox-material
augroup end  " }}}

