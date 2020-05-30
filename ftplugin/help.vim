" ========================================================================
  " File: help.vim
  " Author: Faris Chugthai
  " Description: Help files basically don't have an ftplugin
  " Last Modified: September 10, 2019
" ========================================================================

if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/help.vim

" Options:
  setlocal iskeyword+=-
  setlocal relativenumber number
  setlocal foldcolumn=0 signcolumn=
  setlocal tabstop=8
  setlocal softtabstop=2
  setlocal shiftwidth=2
  setlocal breakindent

  setlocal wrap  " scrolling horizontally to read sucks

" Oh shit i found duplicated code.
" NOTE: I mean code duplicated in the neovim source code.
" autoload/man.vim and ftplugin/man.vim have 1 function copy pasted

" dont make this mapping silent tho
" nnoremap <buffer> gO :call <sid>show_toc()<cr>
" You can't map something to a function prefixed with <SID>? Dude
" script local namespaces are so poorly done.
  setlocal tags=~/.config/nvim/tags,$VIMRUNTIME/doc/tags,tags,**
  let &l:path = includes#VimPath()

  setlocal tags=~/.config/nvim/tags,$VIMRUNTIME/doc/tags,tags,**

" Mappings:
  " Back on track. I mess up this binding too often
  nnoremap <buffer> go gO

" Plugins:
  " I think this is probably the best way to define the buffer local fixers
  " based on the global ones.
  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
  " Align help tags to the right margin
  let b:ale_fixers += ['align_help_tags']

" Undo:
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                      \. '|setlocal fo< tw< cole< cocu< isk< rnu< nu<'
                      \. '|setlocal foldcolumn< signcolumn< wrap<'
                      \. '|silent! nunmap <buffer> go'
                      \. '|setlocal tags< path<'
                      \. '|unlet! b:undo_ftplugin'
                      \. '|unlet! b:did_ftplugin'
                      \. '|silent! nunmap <buffer> go'
                      \. '|unlet! b:ale_fixers'
