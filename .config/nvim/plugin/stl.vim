" ============================================================================
    " File: stl.vim
    " Author: Faris Chugthai
    " Description: Statusline
    " Last Modified: Oct 20, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_stl_vim') || &compatible || v:version < 700
  finish
endif
let b:did_stl_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Statusline: {{{1

function! StatusDiagnostic() abort

  if !exists('g:loaded_coc') | return '' | endif

  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

function! Statusline_expr() abort
  " Define statusline groups for WebDevIcons, Fugitive and other plugins.
  " Define empty fallbacks if those plugins aren't installed. Then
  " use the builtins to fill out the information.
  if exists('*WebDevIconsGetFileTypeSymbol')
    let dicons = '%{WebDevIconsGetFileTypeSymbol()}'
  else
    let dicons = ''
  endif
  let fug = " %{exists('g:loaded_fugitive') ? fugitive#statusline() : ''} "
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '

  if exists('*CSV_WCol')
    " Doing it the exact way he specifies in the help docs means you don't get
    " tsv support
    if &filetype == 'tsv' || &filetype == 'csv'
      let csv = '%1*%{CSV_WCol()}%*'
    else
      let csv = ''
    endif
  else
    let csv = ''
  endif

  if exists('*strftime')
    " Overtakes the whole screen when Termux zooms in
    if &columns > 80
      let tstmp = ' %{strftime("%H:%M %m-%d-%Y", getftime(expand("%:p")))}'
      " last modified timestamp
    else
      let tstmp = ''
    endif
  else
    let tstmp = ''  " ternary expressions should get on the todo list
  endif

  " from he 'statusline'.
  " Each status line item is of the form:
  " %-0{minwid}.{maxwid}{item}
  let cos = " %{exists('g:did_coc_loaded') ? coc#status() : ''} "

  let cog = ' %{exists("coc_git_status") ? coc_git_status : ""} '

  " shit g:ale_enabled == 0 returns True
  let ale_stl = '%{exists("g:ale_enabled") ? "[ALE]" : ""}'


  return '[%n] ' . dicons . '%m' . '%r' . ' %y '
        \. fug . csv
        \. ' %{&ff} ' . tstmp
        \. cos . cog
        \. StatusDiagnostic()
        \. ' %f'
        \. sep
        \. ale_stl
        \. pos . '%*' . ' %P'


endfunction

augroup YourStatusline
  au!
  au BufEnter * let &statusline = Statusline_expr()
augroup END

command! ReloadStatusline call Statusline_expr()

let &cpoptions = s:cpo_save
unlet s:cpo_save
