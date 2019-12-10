" ============================================================================
  " File: filetype.vim
  " Author: Faris Chugthai
  " Description: Your personal ftdetect
  " Last Modified: Oct 10, 2019
" ============================================================================

" Options: {{{1

let g:requirements#detect_filename_pattern = 'Pipfile'

let g:is_bash = 1

" Autocmds: {{{1
augroup YourFTDetect
  au!

  " *********
  " NOTE:
  " *********
  " setf only sets a filetype if it hasn't been set already

  " requirements. this is actually unnecessary if you use the var
  " g:requirements#detect_filename_pattern
  " au BufNewFile,BufRead Pipfile,Pipfile.lock setf requirements

  " JSON
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace,*.jupyterlab-settings set filetype=json

  au BufNewFile,BufRead *.bash,*.bashrc,*.profile,*.bash_profile set filetype=bash

  au BufNewFile,BufRead *.sip set filetype=cpp

  au BufNewFile,BufRead setup.cfg set filetype=dosini

  au BufNewFile,BufRead .xonshrc set filetype=xonsh
  au BufNewFile,BufRead *.xsh set filetype=xonsh

  au BufNewFile,BufRead *.tmux set filetype=tmux
  au BufNewFile,BufRead .tmux.conf set filetype=tmux
  au BufNewFile,BufRead *.rst.txt set filetype=rst.txt

augroup END

" Alright now that we did mine should we do his?
" Nope it actually sources with no problem seemingly
