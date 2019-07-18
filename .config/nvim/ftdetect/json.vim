" Ftdetect for json to add .code-workspace

augroup YourFtDetect

  au!
  " JSON
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace	setf json
augroup END
