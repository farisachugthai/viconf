" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: Syntax highlighting for vim files
    " Last Modified: March 16, 2019
" ============================================================================


" VIM			*vim.vim*		*ft-vim-syntax*
" 			*g:vimsyn_minlines*	*g:vimsyn_maxlines*
" There is a trade-off between more accurate syntax highlighting versus screen
" updating speed.  To improve accuracy, you may wish to increase the
" g:vimsyn_minlines variable.  The g:vimsyn_maxlines variable may be used to
" improve screen updating rates (see |:syn-sync| for more on this). >

" 	g:vimsyn_minlines : used to set synchronization minlines
" 	g:vimsyn_maxlines : used to set synchronization maxlines
" <
" 	(g:vim_minlines and g:vim_maxlines are deprecated variants of
" 	these two options)

" 						*g:vimsyn_embed*
" The g:vimsyn_embed option allows users to select what, if any, types of
" embedded script highlighting they wish to have. >

"    g:vimsyn_embed == 0      : disable (don't embed any scripts)
"    g:vimsyn_embed == 'lPr'  : support embedded lua, python and ruby
" <
" This option is disabled by default.
" 						*g:vimsyn_folding*

" Some folding is now supported with syntax/vim.vim: >

"    g:vimsyn_folding == 0 or doesn't exist: no syntax-based folding
"    g:vimsyn_folding =~ 'a' : augroups
"    g:vimsyn_folding =~ 'f' : fold functions
"    g:vimsyn_folding =~ 'P' : fold python   script
" <
" 							*g:vimsyn_noerror*
" Not all error highlighting that syntax/vim.vim does may be correct; Vim script
" is a difficult language to highlight correctly.  A way to suppress error
" highlighting is to put the following line in your |vimrc|: >

" 	let g:vimsyn_noerror = 1
