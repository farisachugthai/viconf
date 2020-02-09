" ============================================================================
  " File: filetype.vim
  " Author: Faris Chugthai
  " Description: Your personal ftdetect
  " Last Modified: Oct 10, 2019
" ============================================================================

if exists('b:loaded_filetype_vim') || &compatible || v:version < 700
  finish
endif
let b:loaded_filetype_vim = 1

let g:requirements#detect_filename_pattern = 'Pipfile'
let g:is_bash = 1

augroup Userftdetect
  au!
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace,*.jupyterlab-settings set filetype=json
  au BufNewFile,BufRead *.bash,*.bashrc,*.profile,*.bash_profile set filetype=bash
  au BufNewFile,BufRead *.sip set filetype=cpp
  au BufNewFile,BufRead setup.cfg set filetype=dosini
  au BufNewFile,BufRead *.xonshrc, set filetype=xonsh
  au BufNewFile,BufRead *.xsh set filetype=xonsh
  " YESSSS I used bracket expansion correctly fuck yes
  au BufNewFile,BufRead *.tmux{,.conf} set filetype=tmux
  " tmux configuration
  " just noticed that in $VIMRUNTIME/filetype.vim
  " so why don't we recognize tmux filetypes without it then?
  " OH it needs teh conf.
  " au BufNewFile,BufRead {.,}tmux*.conf		setf tmux

  au BufNewFile,BufRead *.rst.txt set filetype=rst.txt
  au BufNewFile,BufRead *.rst_t set filetype=htmljinja.htmldjango
  au BufNewFile,BufRead *.gitconfig set filetype=gitconfig
  au BufNewFile,BufRead *.rktd set filetype=lisp

augroup END
