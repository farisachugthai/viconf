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
" let g:loaded_pydoc_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

if !exists('g:pydoc_window')
  let g:pydoc_window = 1  " should this be an int or str. hm.
endif


" Autocmds: {{{1

if &filetype==man || &filetype==help
  augroup mantabs
    autocmd Filetype * call pydoc_help#Helptab()
  augroup END
endif

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
command! -nargs=1 -complete=help Help call pydoc_help#Helptab()

" Commands: {{{1

if has('python') || has('python3')

  command! -nargs=0 -range PydocThis call pydoc_help#PydocCword()

  " This should be able to take the argument '-bang' and allow to open in a new
  " separate window like fzf does.
  command! -nargs=0 PydocSplit call pydoc_help#SplitPydocCword()
endif

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
