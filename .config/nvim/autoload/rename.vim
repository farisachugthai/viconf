" ============================================================================
    " File: rename.vim
    " Author: Faris Chugthai
    " Description: A description of the file below
    " Last Modified: July 08, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_rename_vim') || &compatible || v:version < 700
  finish
endif
let g:did_rename_vim = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Rename: {{{1

" Setup Functions: {{{2

function! rename#fullpathname() abort

  let s:buf = fnamemodify(expand('%'), ':p')
  return s:buf

endfunction

function! rename#dropbox() abort

  let s:Dropbox = expand('~/Dropbox')
  return s:Dropbox
endfunction

if has('python3')
    function! rename#DefPython() abort
    python << EOF
        if vim.eval('rename#fullpathname()').startswith(vim.eval('rename#dropbox()')):
            pass  # I have no idea what I was originally trying to do fuck
EOF
    endfunction
    " call DefPython()
endif


" Commands: {{{1

" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>za

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
