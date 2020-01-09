" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: vim ftplugin
    " Last Modified: Nov 14, 2019
" ============================================================================

" From `:he syntax`
" 			*g:vimsyn_minlines*	*g:vimsyn_maxlines*
" Support embedded lua python nd ruby syntax highlighting in vim ftypes.
let g:vimsyn_minlines = 300

let g:vimsyn_maxlines = 500  " why is the default 60???

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

" Some folding is now supported with syntax/vim.vim:

   " g:vimsyn_folding == 0 or doesn't exist: no syntax-based folding
   " g:vimsyn_folding =~ 'a' : augroups
   " g:vimsyn_folding =~ 'f' : fold functions
   " g:vimsyn_folding =~ 'P' : fold python   script

let g:vimsyn_folding = 'afP'

if &filetype !=# 'vim' | finish | endif

" doesnt work
" global !p
" from _vim import command, pretty_it, pretty_xml, pretty_json
" endglobal

setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal suffixesadd=.vim
setlocal nolinebreak
setlocal wrap

setlocal foldmethod=syntax
" Didn't seem to be getting set
setlocal indentexpr=GetVimIndent()
setlocal indentkeys+==end,=else,=cat,=fina,=END,0\\,0=\"\\\

let b:undo_indent = "setlocal indentkeys< indentexpr<"
let &l:commentstring='" %s'
let &l:path = ftplugins#VimPath()

" Make 'gf' work
setlocal isfname+=#
" To allow tag lookup via CTRL-] for autoload functions, '#' must be a
" keyword character.  E.g., for netrw#Nread().
setlocal isk+=#

call ftplugins#ALE_Vim_Conf()

let b:undo_ftplugin = 'setlocal fdm< com< cms< et< sw< ts< sts< lbr< sua< wrap< isk<'
      \ . '|setlocal path< isf<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:undo_indent'