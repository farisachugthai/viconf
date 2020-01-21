" ============================================================================
    " File: netrw.vim
    " Author: Faris Chugthai
    " Description: Yes netrw is a ftplugin
    " Last Modified: Oct 14, 2019
" ============================================================================

if exists('b:loaded_your_netrw')
  finish
endif
let b:loaded_your_netrw = 1

" Options: {{{1
" Can be modified interactively using `:NetrwSettings` !!

" UI: {{{2
" Hide that weird looking banner
let g:netrw_banner = 0

" Netrw calls itself netrw in the statusline like be less weird
let g:NetrwTopLvlMenu = 'File Explorer'

" Keep the current directory the same as the browsing directory
let g:netrw_keepdir = 0

" Open windows from netrw in a preview window. Can be achieved by pressing 'P'
let g:netrw_browse_split = 2

  " *g:netrw_liststyle*		Set the default listing style:
  "                               = 0: thin listing (one file per line)
  "                               = 1: long listing (one file per line with time
				     " stamp information and file size)
				" = 2: wide listing (multiple files in columns)
				" = 3: tree style listing
let g:netrw_liststyle = 3

let g:netrw_list_hide = netrw_gitignore#Hide() . '.*\.swp$'

" TODO: Make sure to test on windows
if !has('win32')
    let g:netrw_localmkdir = 'mkdir'
    let g:netrw_localmkdiropt = '-pv '
    let g:netrw_browsex_viewer= 'xdg-open'
else
    let g:netrw_browsex_viewer= 'firefox %s'
endif

" TODO:               *netrw_filehandler*
let g:netrw_sizestyle = 'h'

" Only display errors as messages
let g:netrw_errorlvl          = 2

" setlocal statusline=%f\ %{WebDevIconsGetFileTypeSymbol()}\ %h%w%m%r\ %=%(%l,%c%V\ %Y\ %=\ %P%)
" Uh the official version is throwing too many errors so here it is.

" NetrwStatusLine: {{{2
fun! NetrwStatusLine()

" vvv NetrwStatusLine() debugging vvv
"  let g:stlmsg=""
"  if !exists("w:netrw_explore_bufnr")
"   let g:stlmsg="!X<explore_bufnr>"
"  elseif w:netrw_explore_bufnr != bufnr("%")
"   let g:stlmsg="explore_bufnr!=".bufnr("%")
"  endif
"  if !exists("w:netrw_explore_line")
"   let g:stlmsg=" !X<explore_line>"
"  elseif w:netrw_explore_line != line(".")
"   let g:stlmsg=" explore_line!={line(.)<".line(".").">"
"  endif
"  if !exists("w:netrw_explore_list")
"   let g:stlmsg=" !X<explore_list>"
"  endif
" ^^^ NetrwStatusLine() debugging ^^^

  if !exists("w:netrw_explore_bufnr") || w:netrw_explore_bufnr != bufnr("%") || !exists("w:netrw_explore_line") || w:netrw_explore_line != line(".") || !exists("w:netrw_explore_list")
   " restore user's status line
   if exists("w:netrw_explore_bufnr")|unlet w:netrw_explore_bufnr|endif
   if exists("w:netrw_explore_line") |unlet w:netrw_explore_line |endif
   return ""
  else
   return "Match ".w:netrw_explore_mtchcnt." of ".w:netrw_explore_listlen
  endif
endfun


let &l:stl = NetrwStatusLine()

" From the help
let g:netrw_bufsettings='noma nomod nobl nowrap ro rnu'

" Window Settings: {{{2
" WTH! Yes I want this.
  " *g:netrw_usetab*		if this variable exists and is non-zero, then
				" the <tab> map supporting shrinking/expanding a
				" Lexplore or netrw window will be enabled.
				" (see |netrw-c-tab|)
let g:netrw_usetab = 1

" Unfortnately though, the <tab> map means <C-Tab>. Can we also get <Tab>?

" Jump down to mappings to see more

let g:netrw_preview = 1

" Defaults to 50%
" let g:netrw_winsize = 70
" This is the wrong way
" still massive wth
let g:netrw_winsize = 30

" Long as hell but a bool indicating that theres special HL
let g:netrw_special_syntax    = v:true

" Mappings: {{{1

if &filetype !=# 'netrw'
  finish
endif

function NetrwUnmaps() abort
" wth why is this a thing.
  nunmap <buffer> a
  " dude you'll wish your problems were limited to randomly hiding shit.
  " Chec this out
  nunmap <buffer> D
  vunmap <buffer> D
  nunmap <buffer> <Del>
  vunmap <buffer> <Del>
  nunmap <buffer> <RightMouse>
  vunmap <buffer> <RightMouse>

  " So what were all those?
  " THE DEFAULT MAPPINGS TO RMDIR THE DIR YOU'RE CURRENTLY IN WHAT THE FUCK NETRW
  "Don't worry about this guy just make sure vinegar is installed
  " noremap <buffer> ^ <Plug>NetrwBrowseUpDir<Space>

  nnoremap <buffer> <F1> <Cmd>help netrw-quickhelp<CR>

  " See g:netrw_preview above
  nnoremap <buffer> <Tab>	<Plug>NetrwShrink

  " Yo how crazy is it that this isn't setup
  nnoremap <buffer><silent> q :<C-u>bd!<CR>

  " Fuck I still need history
  nnoremap <buffer> Q q:
  return 1
endfunction

" TODO: check this got done right
augroup UserNetrw
  au!
  au FileExplorer User silent call NetrwUnmaps()
augroup END
