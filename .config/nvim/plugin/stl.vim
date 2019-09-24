" ============================================================================
    " File: stl.vim
    " Author: Faris Chugthai
    " Description: Statusline
    " Last Modified: August 18, 2019 
" ============================================================================

" Guard: {{{1
if exists('b:did_stl_vim') || &compatible || v:version < 700
  finish
endif
let b:did_stl_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Statusline: {{{1

function! s:statusline_expr() abort
  " Define statusline groups for WebDevIcons, Fugitive and other plugins.
  " Define empty fallbacks if those plugins aren't installed. Then
  " use the builtins to fill out the information.
  if exists('*WebDevIconsGetFileTypeSymbol')
    let dicons = ' %{WebDevIconsGetFileTypeSymbol()} '
  else
    let dicons = ''
  endif

  let fug = " %{exists('g:loaded_fugitive') ? fugitive#statusline() : ''} "

  let sep = ' %= '

  let pos = ' %-12(%l : %c%V%) '

  if exists('*CSV_WCol')
    let csv = '%1*%{&ft=~"csv" ? CSV_WCol() : ""}%*'
  else
    let csv = ''
  endif

  if exists('*strftime')
    " Overtakes the whole screen when Termux zooms in
    if &columns > 80
      let tstmp = ' %{strftime("%H:%M %m/%d/%Y", getftime(expand("%:p")))}'
      " last modified timestamp
    else
      let tstmp = ''
    endif
  else
    let tstmp = ''  " ternary expressions should get on the todo list
  endif

  let cos = " %{exists('g:did_coc_loaded') ? coc#status() : ''} "

  let cog = ' %{exists("b:coc_git_status") ? "Git Status: " . b:coc_git_status : ""} '

  return '[%n] %f ' . dicons . '%m' . '%r' . ' %y ' . fug . csv . 
        \ ' %{&ff} ' . tstmp . cos . cog . sep . pos . '%*' . ' %P'

endfunction

let &statusline = <SID>statusline_expr()

let &cpoptions = s:cpo_save
unlet s:cpo_save
