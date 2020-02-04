" ============================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019
" ============================================================================


setlocal formatoptions+=tcroql textwidth=78
" Just saying... I have this set globally too. W/e.
setlocal cole=2 cocu=nc
setlocal iskeyword+=-


" Oh shit i found duplicated code.
" NOTE: I mean code duplicated in the neovim source code.
" autoload/man.vim and ftplugin/man.vim have 1 function copy pasted

" Back on track. I mess up this binding too often
nnoremap <buffer> go gO

" I think this is probably the best way to define the buffer local fixers
" based on the global ones.
let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
" Align help tags to the right margin
let b:ale_fixers += ['align_help_tags']


let b:undo_ftplugin = "setlocal fo< tw< cole< cocu< "
                    \ . '|unlet! b:undo_ftplugin'
                    \ . '|unlet! b:did_ftplugin'
