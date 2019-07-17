" JSON ftdetect

augroup YourFTDetect

  au!
  " JSON
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace	setf json
augroup END
