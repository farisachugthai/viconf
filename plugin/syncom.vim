" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

" Grepprg:
call syncom#grepprg()

" Highlighting Commands: {{{1
command! HL call syncom#HL()
command! HiC call syncom#HiC()
command! HiQF call syncom#HiQF()
command! SyntaxInfo call syncom#get_syn_info()

" Working:
command! HiTest call syncom#hitest()

" Plug Mappings: {{{1
nnoremap <Plug>(HL) <Cmd>call syncom#HL()<CR>
nnoremap <Plug>(HiC) <Cmd>HiC<CR>
nnoremap <Plug>(HiQF) <Cmd>HiQF<CR>
nnoremap <Plug>(SyntaxInfo) <Cmd>SyntaxInfo<CR>

if !hasmapto('<Plug>(HL)')
  nnoremap <Leader>h <Plug>(HL)
endif

" Title: {{{1
" From `:he change`  line 352 tag g?g?
" Adding range means that the command defaults to current line
" Need to add a check that we're in visual mode and drop the '<,'> if not.
command! -nargs=0 -range Title execute 'normal! ' . "'<,'>s/\v<(.)(\w*)/\u\1\L\2/g"

augroup UserCursorLine
  autocmd!
  autocmd InsertEnter * setlocal cursorline
  autocmd InsertLeave * setlocal nocursorline
  autocmd VimEnter * colorscheme gruvbox-material
augroup end
