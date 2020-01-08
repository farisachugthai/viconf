" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

" Highlighting Commands: {{{1

command! -complete=highlight HL call syncom#HL()
command! -complete=color HiC call syncom#HiC()
command! HiQF call syncom#HiQF()

command! SyntaxInfo call syncom#get_syn_info()

" Working:
command! HiTest call syncom#hitest()

" Plug Mappings: {{{1
" To attempt making this a little more modular.

nnoremap <Plug>(HL) <Cmd>call syncom#HL()<CR>
nnoremap <Plug>(HiC) <Cmd>HiC<CR>
nnoremap <Plug>HiQF <Cmd>HiQF<CR>
nnoremap <Plug>SyntaxInfo <Cmd>SyntaxInfo<CR>

if !hasmapto('<Plug>(HL)')
  nnoremap <Leader>h <Plug>(HL)
endif

" From `:he change`  line 352 tag g?g?
" Adding range means that the command defaults to current line
" Need to add a check that we're in visual mode and drop the '<,'> if not.
command! -nargs=0 -range Title execute 'normal! ' . "'<,'>s/\v<(.)(\w*)/\u\1\L\2/g"

augroup CursorLine
  autocmd!
  autocmd InsertEnter * setlocal cursorline
  autocmd InsertLeave * setlocal nocursorline
augroup end
