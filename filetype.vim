" ============================================================================
  " File: filetype.vim
  " Author: Faris Chugthai
  " Description: Your personal ftdetect
  " Last Modified: Oct 10, 2019
" ============================================================================

let g:requirements#detect_filename_pattern = 'Pipfile'
let g:is_bash = 1

augroup YourFTDetect
  au!
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace,*.jupyterlab-settings set filetype=json
  au BufNewFile,BufRead *.bash,*.bashrc,*.profile,*.bash_profile set filetype=bash
  au BufNewFile,BufRead *.sip set filetype=cpp
  au BufNewFile,BufRead setup.cfg set filetype=dosini
  au BufNewFile,BufRead *.xonshrc, set filetype=xonsh
  au BufNewFile,BufRead *.xsh set filetype=xonsh
  au BufNewFile,BufRead *.tmux set filetype=tmux
  au BufNewFile,BufRead *.tmux.conf set filetype=tmux
  au BufNewFile,BufRead *.rst.txt set filetype=rst.txt
  au BufNewFile,BufRead *.rst_t set filetype=htmljinja
  au BufNewFile,BufRead *.gitconfig set filetype=gitconfig
augroup END
