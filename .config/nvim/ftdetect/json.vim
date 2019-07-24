" ============================================================================
  " File: json.vim
  " Author: Faris Chugthai
  " Description: JSON ftdetect
  " Last Modified: July 24, 2019
" ============================================================================

augroup YourFTDetect

  au!
  " JSON
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace	setf json
" Ftdetect for json to add .code-workspace

augroup YourFtDetect
