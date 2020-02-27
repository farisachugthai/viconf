" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: vim ftplugin
    " Last Modified: Nov 14, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" Just found this guy. Make indents the same regardless of my indentation or
" the default 8 space tabstop.
if &l:shiftwidth ==# 2
  let g:vim_indent_cont = shiftwidth() * 8
elseif &l:shiftwidth ==# 8
  let g:vim_indent_cont = shiftwidth() * 2
endif


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
setlocal wrap
setlocal foldmethod=marker
setlocal foldlevel=0

" This man can do no wrong omg
" if exists('*scriptease#complete')
"   let &l:completefunc = scriptease#complete()
" endif

setlocal indentexpr=GetVimIndent()
setlocal indentkeys+==end,=else,=cat,=fina,=END,0\\,0=\"\\\
let b:undo_indent = "setlocal indentkeys< indentexpr<"

let &l:commentstring='" %s'
let &l:path = ftplugins#VimPath()

call ftplugins#ALE_Vim_Conf()

" the original ftplugin also sets b:undo_ftplugin = to call VimFtpluginUndo
let b:undo_ftplugin = 'setlocal et< sw< ts< sts< lbr< sua< wrap< fdl< fdm< cms< path< isf< isk<'
      \ . '|setlocal path< isf<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:undo_indent'
      \ . '|unlet! b:did_ftplugin'
      \ . '|call VimFtpluginUndo()'


