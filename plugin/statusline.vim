" ============================================================================
  " File: statusline.vim
  " Author: Faris Chugthai
  " Description: statusline warranted it's own file
  " Last Modified: March 06, 2020
" ============================================================================

scriptencoding utf8

" how the fuck was this not set.
setglobal ruler

function! s:fzf_statusline()  abort " {{{
  " Curious if this'll work
  hi! fzf1 cterm=bold,undercurl,reverse gui=bold,undercurl,reverse guifg=#7daea3 guibg=NONE ctermbg=NONE guisp=NONE font='Source Code Pro'
  hi! link fzf2 fzf1
  hi! link fzf3 fzf1
  setlocal statusline=%#fzf1#\ FZF:\ %#fzf2#fz%#fzf3#f

endfunction   " }}}

augroup FZFStatusline  " {{{
" NOTE: This has to remain the name of the augroup it's what Junegunn calls
  au!
  autocmd User FzfStatusLine call s:fzf_statusline()
  autocmd User FzfStatusline setlocal winblend=15 pumblend=10
augroup END

augroup UserStatusline
  au!
  " i think this is fucking up tagbar.
  au BufEnter * if &filetype != 'tagbar'
                  \| let &statusline = Statusline(0)
                  \| endif


  autocmd User CocStatusChange,CocDiagnosticChange
        \| if exists('*Statusline')
        \| call Statusline(1)
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

  let l:info = get(b:, 'coc_diagnostic_info', {})
  if empty(l:info) | return '' | endif
  let l:msgs = []
  if get(l:info, 'error', 0)
    call add(l:msgs, 'E' . l:info['error'])
  endif
  if get(l:info, 'warning', 0)
    call add(l:msgs, 'W' . l:info['warning'])
  endif
  return join(l:msgs, ' ') . ' ' . get(g:, 'coc_status', '')
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
      let s:tstmp = '| %{strftime("%H:%M %m-%d-%Y", getftime(expand("%:p")))} |'
      " last modified timestamp
    else
      let s:tstmp = ''
    endif
  else
    let s:tstmp = ''  " ternary expressions should get on the todo list
  endif
  let s:gutentags = '%{exists("g:gutentags_enabled") ? gutentags#statusline() : ""}'

  let g:statusline = '« [%n]: '
        \. s:VarExists('*WebDevIconsGetFileTypeSymbol', '%{WebDevIconsGetFileTypeSymbol()}')
        \. '%< %m%r %y %w»'
        \. s:VarExists('g:loaded_fugitive', '%{FugitiveStatusline()}')
        \. ' %{&ff} ' . s:tstmp
        \. s:VarExists('g:did_coc_loaded', ' %{coc#status()} ')
        \. s:VarExists('g:coc_git_status', ' %{coc_git_status} ')
        \. '◀ 😀 %.30F ▶'
        \. s:sep
        \. s:StatusDiagnostic()
        \. s:VarExists('g:ale_enabled', '«[ALE Lints]»: # %{getbufvar(bufnr(""), "ale_linted", 0)} | ')
        \. s:gutentags
        \. '«: '. s:pos . '%*' . ' %P »'

  if a:bang ==# 1
    redrawstatus!
  endif
  return g:statusline

endfunction " }}}

function! Statusline(bang, ...) abort  " {{{ Lets give a nicer clean entry point.
  return s:_Statusline(a:bang, a:000)
endfunction

command! -bang -bar -nargs=* -range=% -addr=loaded_buffers -complete=expression -complete=var ReloadStatusline call Statusline(<bang>0, <q-args>)
" }}}
