" ============================================================================
  " File: statusline.vim
  " Author: Faris Chugthai
  " Description: statusline warranted it's own file
  " Last Modified: March 06, 2020
" ============================================================================

function! s:fzf_statusline()  " {{{

  " Override statusline as you like
  hi! fzf1 cterm=bold,underline,reverse gui=bold,underline,reverse guifg=#7daea3
  hi! link fzf2 fzf1
  hi! link fzf3 fzf1
  setlocal statusline=%#fzf1#\ FZF:\ %#fzf2#fz%#fzf3#f

endfunction   " }}}

augroup FZFStatusline  " {{{
" NOTE: This has to remain the name of the augroup it's what Junegunn calls
  au!
  autocmd! User FzfStatusLine call <SID>fzf_statusline()
  au BufEnter * let &statusline = Statusline(0)
  autocmd User CocStatusChange,CocDiagnosticChange
        \| if exists('*Statusline')
        \| call Statusline_expr(0)
        \| endif

augroup END  " }}}

function! s:VarExists(var, val) abort    " {{{

  if exists(a:var)
    return a:val
  else
    return ''
  endif
endfunction  " }}}

function! s:StatusDiagnostic() abort  " {{{
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
endfunction  " }}}

function! s:_Statusline(bang, ...) range abort  " {{{

  " from he 'statusline'.
  " Each status line item is of the form:
  " %-0{minwid}.{maxwid}{item}

  let s:sep = ' %= '
  let s:pos = ' %-12(%l : %c%V%) '

  if exists('*strftime')
    " Overtakes the whole screen when Termux zooms in
    " Worth noting that %< indicates where to truncate the &stl though
    if &columns > 80
      let s:tstmp = ' %{strftime("%H:%M %m-%d-%Y", getftime(expand("%:p")))}  '
      " last modified timestamp
    else
      let s:tstmp = ''
    endif
  else
    let s:tstmp = ''  " ternary expressions should get on the todo list
  endif
  let s:gutentags = '%{exists("g:gutentags_enabled") ? gutentags#statusline() : ""}'

  " lines 2, 4, 6, 7
  let g:statusline = '[%n] '
        \. s:VarExists('*WebDevIconsGetFileTypeSymbol', '%{WebDevIconsGetFileTypeSymbol()}')
        \. '%< %m%r %y %w '
        \. s:VarExists('g:loaded_fugitive', '%{FugitiveStatusline()}')
        \. ' %{&ff} ' . s:tstmp
        \. s:VarExists('g:did_coc_loaded', ' %{coc#status()} ')
        \. s:VarExists('g:coc_git_status', ' %{coc_git_status} ')
        \. ' %f '
        \. s:sep
        \. s:StatusDiagnostic()
        \. s:VarExists('g:ale_enabled', '[ALE Lints]: %{getbufvar(bufnr(""), "ale_linted", 0)}')
        \. s:gutentags
        \. s:pos . '%*' . ' %P'

  if a:bang ==# 1
    let &stl = g:statusline
    redrawstatus!
  endif
  return g:statusline

endfunction " }}}

function! Statusline(bang, ...) abort  " {{{ Lets give a nicer clean entry point.
  return s:_Statusline(a:bang, a:000)
endfunction

command! -bang -bar -nargs=* -range=% -addr=loaded_buffers -complete=expression -complete=var ReloadStatusline call Statusline(<bang>0, <q-args>)
" }}}

