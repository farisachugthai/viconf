" ============================================================================
  " File: filetype.vim
  " Author: Faris Chugthai
  " Description: Your personal ftdetect
  " Last Modified: Oct 10, 2019
" ============================================================================

if exists("b:loaded_your_filetypes")
  finish
endif
let b:loaded_your_filetypes = 1

augroup YourFTDetect

  au!

  " requirements
  au BufNewFile,BufRead Pipfile,Pipfile.lock setf requirements

  " JSON
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace setf json
augroup END
