" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

" Options: {{{1

set nohlsearch
if &textwidth!=0
  setl colorcolumn=+1
else
  setl colorcolumn=80
endif

let &grepprg = syncom#grepprg()

" Search Mappings: {{{1

" Dude read over :he getcharsearch(). Now ; and , search forward backward no matter what!!!
nnoremap <expr> ; getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Highlighting Commands: {{{1

" Did you know that both -complete=color and -complete=highlight are things??
command! HL call syncom#HL()
command! HiC call syncom#HiC()
" command! HiD call <SID>syncom#HiD()
command! HiQF call syncom#HiQF()

command! SyntaxInfo call syncom#get_syn_info()

" Working:
command! HiTest call syncom#hitest()

" Plug Mappings: {{{1
" To attempt making this a little more modular.

nnoremap <Plug>(HL) call syncom#HL()
nnoremap <Plug>(HiC) <Cmd>HiC<CR>
nnoremap <Plug>HiQF <Cmd>HiQF<CR>
nnoremap <Plug>SyntaxInfo <Cmd>SyntaxInfo<CR>

if !hasmapto('<Plug>HL')
  nnoremap <Leader>h <Plug>HL()
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
