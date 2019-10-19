" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: vim ftplugin
    " Last Modified: May 09, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_after_vim_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_after_vim_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal suffixesadd+=.vim
setlocal nolinebreak
setlocal wrap

" TODO: Probably needs to be a function. Should checj if we already added
" this and don't do it more than once
" let &path = &path . ',' . stdpath('data') . '/plugged/*/*/*.vim'
let &commentstring='" %s'

" So that you can cleanly jump around inside of autoloaded func names
setlocal iskeyword-=#

" Syntax Highlighting: {{{1

" From `:he syntax`
" 			*g:vimsyn_minlines*	*g:vimsyn_maxlines*
" Support embedded lua python nd ruby syntax highlighting in vim ftypes.
let g:vimsyn_minlines = 300

let g:vimsyn_maxlines = 500  " why is the default 60???

" Embedding: {{{2
" Allows users to specify the type of embedded script highlighting
" they want:  (perl/python/ruby/tcl support)
"   g:vimsyn_embed == 0   : don't embed any scripts
"   g:vimsyn_embed =~# 'l' : embed lua
"   g:vimsyn_embed =~# 'm' : embed mzscheme
"   g:vimsyn_embed =~# 'p' : embed perl
"   g:vimsyn_embed =~# 'P' : embed python
"   g:vimsyn_embed =~# 'r' : embed ruby
"   g:vimsyn_embed =~# 't' : embed tcl
let g:vimsyn_embed = 'P'

" Turn off errors because 50% of them are wrong.
let g:vimsyn_noerror = 1

" *g:vimsyn_folding* {{{2

" Some folding is now supported with syntax/vim.vim:

   " g:vimsyn_folding == 0 or doesn't exist: no syntax-based folding
   " g:vimsyn_folding =~ 'a' : augroups
   " g:vimsyn_folding =~ 'f' : fold functions
   " g:vimsyn_folding =~ 'P' : fold python   script

let g:vimsyn_folding = 'afP'


" ALE: {{{1

" Don't drop the quotes because if the var isn't defined it'll raise errors
if !empty('g:loaded_ale')
  call ftplugins#ALE_Vim_Conf()
endif

" Atexit: {{{1
let b:undo_ftplugin = 'set com< cms< et< sw< ts< sts< lbr< sua< wrap< isk<'

let &cpoptions = s:cpo_save
unlet s:cpo_save
