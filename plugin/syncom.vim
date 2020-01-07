" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

" Highlighting Commands: {{{1

" Did you know that both -complete=color and -complete=highlight are things??
" These commands all just describe the color and highlighting group under your
" cursor.
command! HL call syncom#HL()
command! HiC call syncom#HiC()
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

" QuickFix Window: {{{1

" From `:he quickfix`
command! -nargs=+ NewGrep execute 'silent grep! <args>' | copen

" But now I need way more mappings

nnoremap <silent> <Leader>l <Cmd>botright lwindow<CR>
" These need to catch E776 no location list
nnoremap <silent> <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>
nnoremap <silent> <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

" Title: {{{1

" From `:he change`  line 352 tag g?g?

" Adding range means that the command defaults to current line
" Need to add a check that we're in visual mode and drop the '<,'> if not.
command! -nargs=0 -range Title execute 'normal! ' . "'<,'>s/\v<(.)(\w*)/\u\1\L\2/g"

augroup CursorLine
  autocmd!
  autocmd InsertEnter * setlocal cursorline
  autocmd InsertLeave * setlocal nocursorline
augroup end
