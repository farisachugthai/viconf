" ============================================================================
    " File: man.vim
    " Author: Faris Chugthai
    " Description: pydoc and man vim hooks
    " Last Modified: Jun 13, 2019
" ============================================================================

" Guards: {{{1
if exists('g:loaded_pydoc_plugin') || &compatible
    finish
endif
let g:loaded_pydoc_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=c

" Options: {{{1

if !exists('g:pydoc_window')
  let g:pydoc_window = 1  " should this be an int or str. hm.
endif

" Functions: {{{1

" Helptabs:
" I've pretty heavily modified this one but junegunn gets the initial credit.
function! g:Helptab()
  setlocal number relativenumber
  if len(nvim_list_wins()) > 1
    wincmd T
  endif

  setlocal nomodified
  setlocal buflisted
  " Complains that we can't modify any buffer. But its a local option so yes we can
  silent setlocal nomodifiable

  noremap <buffer> q <Cmd>q<CR>
  " Check the rplugin/python3/pydoc.py file
  noremap <buffer> P <Cmd>Pydoc<CR>
endfunction

" Autocmds: {{{1

augroup mantabs
  autocmd!
  autocmd Filetype man,help call g:Helptab()
augroup END

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
command! -nargs=1 -complete=help Help call g:Helptab()

" Commands: {{{1

command! PydocThis call pydoc_help#PydocCword()

" This should be able to take the argument '-bang' and allow to open in a new
" separate window like fzf does.
command! PydocSplit call pydoc_help#SplitPydocCword()

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
