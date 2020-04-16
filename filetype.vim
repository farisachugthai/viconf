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


fun! s:TryDetectJinja()
  if exists("b:did_jinja_autodetect")
    return
  endif
  let b:did_jinja_autodetect=1

  let n = 1
  while n < 50 && n < line("$")
    let line = getline(n)
    if line =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>' || line =~ '{{\s*\S+[|(]'
      setlocal filetype=htmljinja
      return
    endif
    let n = n + 1
  endwhile
endfun

fun! s:ConsiderSwitchingToJinja()
  if exists("b:did_jinja_autodetect")
    return
  endif
  let b:did_jinja_autodetect=1

  let n = 1
  while n < 50 && n < line("$")
    let line = getline(n)
    " Bail on django specific tags
    if line =~ '{%\s*\(load\|autoescape \(on\|off\)\|cycle\|empty\)\>'
      return
    " Bail on django filter syntax
    elseif line =~ '\({%\|{{\).*|[a-zA-Z0-9]\+:'
      return
    endif
    let n = n + 1
  endwhile
  setlocal filetype=htmljinja
endfun

fun! s:ConsiderSwitchingToJinjaAgain()
  unlet b:did_jinja_autodetect
  call s:TryDetectJinja()
endfun


function! s:SelectHTML() abort  " {{{
  let l:n = 1
  while l:n < 50 && l:n <= line('$')
    " check for jinja
    if getline(l:n) =~? '{{.*}}\|{%-\?\s*\(end.*\|extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
      setlocal filetype=htmljinja.htmldjango
      return
    endif
    let l:n = l:n + 1
  endwhile
endfunction  " }}}

augroup Userftdetect  " {{{
  au!
  au BufNewFile,BufRead *.json,*.jsonp,*.webmanifest,*.code-workspace setfiletype json
  au BufNewFile,BufRead *.jupyterlab-settings,*.ipynb,*.code-snippets setfiletype json
  au BufNewFile,BufRead *.bash,*.bashrc,*.bash_profile setfiletype bash
  au BufNewFile,BufRead *.sh,*.profile                 setfiletype bash
  au BufNewFile,BufRead *.sip                          setfiletype cpp
  au BufNewFile,BufRead setup.cfg                      setfiletype dosini
  au BufNewFile,BufRead *.xonshrc,*.xsh                setfiletype xonsh

  " YESSSS I used bracket expansion correctly fuck yes
  au BufNewFile,BufRead *.tmux{,.conf}           setfiletype tmux
  au BufNewFile,BufRead *.rst.txt                setfiletype rst.txt
  au BufNewFile,BufRead *.rst_t                  setfiletype htmljinja.htmldjango
  au BufNewFile,BufRead *.html,*.htm,*.nunjucks,*.nunjs,*.njk  call s:SelectHTML()
  au BufNewFile,BufRead *.jinja2,*.j2,*.jinja,*.tera setfiletype htmljinja.htmldjango
  " idk if the filetypes are gonna work the way we want them to but whqtever
  au Filetype jinja                              setfiletype htmljinja.htmldjango
  au BufNewFile,BufRead *.gitconfig              setfiletype gitconfig
  au BufNewFile,BufRead *.css_t                  setfiletype css
  au BufNewFile,BufRead *.rktd                   setfiletype lisp
  " Is this correct or was this a typo?
  au BufNewFile,BufRead *.rktl                   setfiletype lisp

  " Go dep and Rust use several TOML config files that are not named with .toml.
  au BufNewFile,BufRead *.toml,Gopkg.lock,Cargo.lock,*/.cargo/config,*/.cargo/credentials,Pipfile setfiletype toml

  autocmd FileType htmldjango call s:ConsiderSwitchingToJinja()
  autocmd FileType html call s:TryDetectJinja()

  autocmd BufWritePost *.html,*.htm,*.shtml,*.stm call s:ConsiderSwitchingToJinjaAgain()
augroup END
" }}}

