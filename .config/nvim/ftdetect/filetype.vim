" ============================================================================
  " File: filetype.vim
  " Author: Faris Chugthai
  " Description: Your personal ftdetect
  " Last Modified: Oct 10, 2019
" ============================================================================

" Guards: {{{1
if exists("b:loaded_your_filetypes")
  finish
endif
let b:loaded_your_filetypes = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

" Idk if i did this right
let g:requirements#detect_filename_pattern = 'Pipfile[.lock]?'

" Autocmds: {{{1
augroup YourFTDetect
  au!

  " requirements. this is actually unnecessary if you use the var
  " g:requirements#detect_filename_pattern
  " au BufNewFile,BufRead Pipfile,Pipfile.lock setf requirements

  " JSON
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace setf json
augroup END

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
