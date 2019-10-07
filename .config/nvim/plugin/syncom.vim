" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

" Guards: {{{1
if exists('g:loaded_syncom_plugin') || &compatible || v:version < 700
    finish
endif
let g:loaded_syncom_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

if &textwidth!=0
  setl colorcolumn=+1
else
  setl colorcolumn=80
endif

" Should we set a corresponding grepformat?
if executable('rg')
    let s:rg = 'rg'
    let &grepprg = s:rg . ' --vimgrep --no-messages --color=never --smart-case --no-messages ^'
elseif executable('rg.exe')  " fucking windows
    let s:rg = 'rg.exe'
    let &grepprg = s:rg . ' --vimgrep --no-messages --color=never --smart-case --no-messages ^'
endif

" Search Mappings: {{{1

" Dude read over :he getcharsearch(). Now ; and , search forward backward no matter what!!!
noremap <expr> ; getcharsearch().forward ? ';' : ','
noremap <expr> , getcharsearch().forward ? ',' : ';'

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

" Isn't working. But at least the error message is specific enough that you
" knew where to check.
command! SyntaxInfo call g:syncom#get_syn_info()

" Working:
command! HiTest call g:syncom#hitest()

" Plug Mappings: {{{1
" To attempt making this a little more modular.

nnoremap <Plug>(HL) call syncom#HL()
nnoremap <Plug>HiC <Cmd>HiC<CR>
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
nnoremap <silent> <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>
nnoremap <silent> <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

" Title: {{{1

" From `:he change`  line 352 tag g?g?

" Adding range means that the command defaults to current line
" Need to add a check that we're in visual mode and drop the '<,'> if not.
command! -nargs=0 -range Title execute 'normal! ' . "'<,'>s/\v<(.)(\w*)/\u\1\L\2/g"

" Toggle Search Highlighting: {{{1

set nohlsearch
augroup vimrc_incsearch_highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
