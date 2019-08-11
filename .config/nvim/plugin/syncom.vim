" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting and extra commands
    " Last Modified: Jul 20, 2019
" ============================================================================

" Guards: {{{1
if exists('g:did_syncom_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_syncom_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

" Admittedly I kinda know why the screen looks so small
if &textwidth!=0
  setl colorcolumn=+1
else
  setl colorcolumn=80
endif

" Commands: {{{1

" Did you know that both -complete=color and -complete=highlight are things??
command! HL call syncom#HL()
command! HiC call syncom#HiC()
" command! HiD call <SID>syncom#HiD()
command! HiQF call syncom#HiQF()

" Isn't working. But at least the error message is specific enough that you
" knew where to check.
command! SyntaxInfo call g:syncom#get_syn_info()

command! HiTest call g:syncom#hitest()

" Plug Mappings: {{{1
" To attempt making this a little more modular.

nnoremap <Plug>HL <Cmd>HL<CR>
nnoremap <Plug>HiC <Cmd>HiC<CR>
nnoremap <Plug>HiQF <Cmd>HiQF<CR>
nnoremap <Plug>SyntaxInfo <Cmd>SyntaxInfo<CR>

" TODO: when i come up with some default mappings for this, remember to
" use this idiom:
" if !exists('no_plugin_maps') && !exists('no_windows_vim_maps') | call funcs
" | endif

" NewGrep: {{{1

" 06/13/2019: Just got moved up so that the grep command down there uses the
" new grepprg
" Should we set a corresponding grepformat?
let &grepprg = 'rg --vimgrep --no-messages --color=never --smart-case --no-messages ^'

" he quickfix
command! -nargs=+ NewGrep execute 'silent grep! <args>' | copen


" Title: {{{1
" From `:he change`  line 352 tag g?g?
" Adding range means that the command defaults to current line
" Need to add a check that we're in visual mode and drop the '<,'> if not.
command! -nargs=0 -range Title <Cmd>'<,'>s/\v<(.)(\w*)/\u\1\L\2/g


" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
