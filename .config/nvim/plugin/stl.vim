

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

  let cos = ' %{coc#status()} '

  return '[%n] %f '. dicons . '%m' . '%r' . ' %y ' . fug . csv . ' ' . ' %{&ff} ' . tstmp . cos . sep . pos . '%*' . ' %P'

endfunction

let &statusline = <SID>statusline_expr()
