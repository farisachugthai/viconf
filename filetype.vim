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


function! s:SelectHTML() abort
  let l:n = 1
  while l:n < 50 && l:n <= line('$')
    " check for jinja
    if getline(l:n) =~? '{{.*}}\|{%-\?\s*\(end.*\|extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
      setlocal filetype=htmljinja.htmldjango
      return
    endif
    let l:n = l:n + 1
  endwhile
endfunction


augroup Userftdetect
  au!
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace,*.jupyterlab-settings setfiletype json
  au BufNewFile,BufRead *.bash,*.bashrc,*.profile,*.bash_profile set filetype=bash
  au BufNewFile,BufRead *.sip setfiletype cpp
  au BufNewFile,BufRead setup.cfg setfiletype dosini
  au BufNewFile,BufRead *.xonshrc, setfiletype xonsh
  au BufNewFile,BufRead *.xsh setfiletype xonsh
  " YESSSS I used bracket expansion correctly fuck yes
  au BufNewFile,BufRead *.tmux{,.conf} setfiletype tmux
  " tmux configuration
  " just noticed that in $VIMRUNTIME/filetype.vim
  " so why don't we recognize tmux filetypes without it then?
  " OH it needs teh conf.
  au BufNewFile,BufRead {.,}tmux*.conf setfiletype tmux
  au BufNewFile,BufRead *.sh setfiletype bash
  au BufNewFile,BufRead *.rst.txt setfiletype rst.txt
  au BufNewFile,BufRead *.rst_t setfiletype htmljinja.htmldjango
  au BufNewFile,BufRead *.html,*.htm,*.nunjucks,*.nunjs,*.njk  call s:SelectHTML()
  au BufNewFile,BufRead *.jinja2,*.j2,*.jinja,*.tera setfiletype htmljinja.htmldjango
  " idk if the filetypes are gonna work the way we want them to but whqtever
  au Filetype jinja setl filetype=htmljinja.htmldjango
  au BufNewFile,BufRead *.gitconfig setfiletype gitconfig
  au BufNewFile,BufRead *.rktd setfiletype lisp

  " Go dep and Rust use several TOML config files that are not named with .toml.
  au BufNewFile,BufRead *.toml,Gopkg.lock,Cargo.lock,*/.cargo/config,*/.cargo/credentials,Pipfile setfiletype toml

augroup END
