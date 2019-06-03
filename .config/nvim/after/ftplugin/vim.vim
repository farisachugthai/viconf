" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: vim ftplugin
    " Last Modified: May 09, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_vim_after_ftplugin') || &compatible || v:version < 700
  finish
endi
let g:did_vim_after_ftplugin = 1

" Options: {{{1
"
setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal suffixesadd=*.vim
setlocal nolinebreak

let &commentstring='" %s'

" This is the absolute worst way to implement this
" setlocal comments="


" Syntax Highlighting: {{{1
" Let's add a little meat in here shall we?

" From he syntax
" VIM			*vim.vim*		*ft-vim-syntax*
" 			*g:vimsyn_minlines*	*g:vimsyn_maxlines*
" Support embedded lua python nd ruby syntax highlighting in vim ftypes.
" No idea what your other options are.
" GOT IT!

" Allows users to specify the type of embedded script highlighting
" they want:  (perl/python/ruby/tcl support)
"   g:vimsyn_embed == 0   : don't embed any scripts
"   g:vimsyn_embed =~# 'l' : embed lua
"   g:vimsyn_embed =~# 'm' : embed mzscheme
"   g:vimsyn_embed =~# 'p' : embed perl
"   g:vimsyn_embed =~# 'P' : embed python
"   g:vimsyn_embed =~# 'r' : embed ruby
"   g:vimsyn_embed =~# 't' : embed tcl
let g:vimsyn_embed = 'lmtPr'
" perl removed because its slow and also fuck perl

" Turn off errors because 50% of them are wrong.
let g:vimsyn_noerror = 1

						" *g:vimsyn_folding*

" Some folding is now supported with syntax/vim.vim:

   " g:vimsyn_folding == 0 or doesn't exist: no syntax-based folding
   " g:vimsyn_folding =~ 'a' : augroups
   " g:vimsyn_folding =~ 'f' : fold functions
   " g:vimsyn_folding =~ 'P' : fold python   script

let g:vimsyn_folding = 'afP'

let g:vimsyn_maxlines = 500  " why is the default 60???

let b:undo_ftplugin = 'set com< cms< et< sw< ts< sts< linebreak<'
