" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: vim ftplugin
    " Last Modified: Nov 14, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif
" We source $VIMRUNTIME later don't do this
" let b:did_ftplugin = 1

let g:vimsyn_minlines = 300
let g:vimsyn_maxlines = 500  " why is the default 60???
let g:vimsyn_noerror = 1  " Turn off errors because 50% of them are wrong.

syntax sync fromstart
source $VIMRUNTIME/ftplugin/vim.vim
setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=8
setlocal softtabstop=2
setlocal suffixesadd=.vim
setlocal nolinebreak
setlocal nowrap wrapmargin=1
setlocal isfname+=#  " Make 'gf' work
" To allow tag lookup via CTRL-] for autoload functions, '#' must be a
" keyword character.  E.g., for netrw#Nread().
setlocal isk+=#

setlocal foldmethod=indent  " Didn't seem to be getting set
setlocal indentexpr=GetVimIndent()
setlocal indentkeys+==end,=else,=cat,=fina,=END,0\\,0=\"\\\
let b:undo_indent = "setlocal indentkeys< indentexpr<"

let &l:commentstring='" %s'
let &l:path = ftplugins#VimPath()

call ftplugins#ALE_Vim_Conf()

let b:undo_ftplugin = 'setlocal fdm< com< cms< et< sw< ts< sts< lbr< sua< wrap< isk<'
      \ . '|setlocal path< isf<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:undo_indent'
