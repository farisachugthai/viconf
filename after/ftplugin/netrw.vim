" ============================================================================
    " File: netrw.vim
    " Author: Faris Chugthai
    " Description: Yes netrw is a ftplugin
    " Last Modified: Oct 14, 2019
" ============================================================================

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
let g:netrw_browse_split = 4

  " *g:netrw_liststyle*		Set the default listing style:
  "                               = 0: thin listing (one file per line)
  "                               = 1: long listing (one file per line with time
				     " stamp information and file size)
				" = 2: wide listing (multiple files in columns)
				" = 3: tree style listing
let g:netrw_liststyle = 1

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

if exists('b:undid_netrw_mappings') | finish | endif
let b:undid_netrw_mappings = 1
" let's fix these fucking mappings like wth
"
function NetrwUnmaps() abort
" wth why is this a thing.
  nunmap <buffer> a
  " dudeyou'll wish your problems were limited to randomly hiding shit.
  " Chec this out
  nunmap <buffer> D
  vunmap <buffer> D
  nunmap <buffer> <Del>
  vunmap <buffer> <Del>
  nunmap <buffer> <RightMouse>
  vunmap <buffer> <RightMouse>

  " So what were all those?
  " THE DEFAULT MAPPINGS TO RMDIR THE DIR YOU'RE CURRENTLY IN WHAT THE FUCK
  " NETRW


  "Don't worry about this guy just make sure vinegar is installed
  " noremap <buffer> ^ <Plug>NetrwBrowseUpDir<Space>

  " I have no idea why but this line isn't working and its generating an error
  " that netrw buffers aren't modifiable....
  " nnoremap <buffer> <F1>			:he netrw-quickhelp<cr>
  " ....wtf?
  nnoremap <buffer> <F1> <Cmd>help netrw-quickhelp<CR>

  " See g:netrw_preview above
  nnoremap <buffer> <Tab>	<Plug>NetrwShrink
  return 1
endfunction

" Dude how is netrw so fucking slow.
" Btw here are all avilable maps
" n  <Tab>       *@<Plug>NetrwShrink
" n  <C-L>        @<Plug>NetrwRefresh
" n  <CR>         @<Plug>NetrwLocalBrowseCheck
" n  <C-R>        @<Plug>NetrwServerEdit
" x  !            @.!
" n  !            @.!
" n  %            @<Plug>NetrwOpenFile
" n  -            @<Plug>VinegarUp
" x  .           *@<Esc>: <C-R>=<SNR>57_escaped(line("'<"), line("'>"))<CR><Home>
" n  .           *@:<C-U> <C-R>=<SNR>57_escaped(line('.'), line('.') - 1 + v:count1)<CR><Home>
" n  @            @peekaboo#peek(v:count1, '@', 0)
" n  C            @<Plug>NetrwSetChgwin
" n  I           *@:<C-U>call <SNR>130_NetrwBannerCtrl(1)<CR>
" n  O           *@:<C-U>call <SNR>130_NetrwObtain(1)<CR>
" n  P           *@:<C-U>call <SNR>130_NetrwPrevWinOpen(1)<CR>
" v  R           *@:call <SNR>130_NetrwLocalRename("C:/Users/faris/AppData/Local")<CR>
" n  R           *@:call <SNR>130_NetrwLocalRename("C:/Users/faris/AppData/Local")<CR>
" n  S           *@:<C-U>call <SNR>130_NetSortSequence(1)<CR>
" n  Th          *@:<C-U>call <SNR>130_NetrwSetTgt(1,'h',v:count)<CR>
" n  Tb          *@:<C-U>call <SNR>130_NetrwSetTgt(1,'b',v:count1)<CR>
" n  U           *@:<C-U>call <SNR>130_NetrwBookHistHandler(5,expand("%"))<CR>
" n  X           *@:<C-U>call <SNR>130_NetrwLocalExecute(expand("<cword>"))"<CR>
" n  cd           @<Plug>NetrwLcd
" n  cB           @<Plug>NetrwBadd_cB
" n  cb           @<Plug>NetrwBadd_cb
" n  d           *@:call <SNR>130_NetrwMakeDir("")<CR>
" n  gp          *@:<C-U>call <SNR>130_NetrwChgPerm(1,b:netrw_curdir)<CR>
" n  gn          *@:<C-U>call netrw#SetTreetop(0,<SNR>130_NetrwGetWord())<CR>
" n  gh          *@:<C-U>call <SNR>130_NetrwHidden(1)<CR>
" n  gf          *@:<C-U>call <SNR>130_NetrwForceFile(1,<SNR>130_NetrwGetWord())<CR>
" n  gd          *@:<C-U>call <SNR>130_NetrwForceChgDir(1,<SNR>130_NetrwGetWord())<CR>
" n  gb           @<Plug>NetrwBookHistHandler_gb
" n  i           *@:<C-U>call <SNR>130_NetrwListStyle(1)<CR>
" n  mz          *@:<C-U>call <SNR>130_NetrwMarkFileCompress(1)<CR>
" n  mX          *@:<C-U>call <SNR>130_NetrwMarkFileExe(1,1)<CR>
" n  mx          *@:<C-U>call <SNR>130_NetrwMarkFileExe(1,0)<CR>
" n  mv          *@:<C-U>call <SNR>130_NetrwMarkFileVimCmd(1)<CR>
" n  mu          *@:<C-U>call <SNR>130_NetrwUnMarkFile(1)<CR>
" n  mt          *@:<C-U>call <SNR>130_NetrwMarkFileTgt(1)<CR>
" n  mT          *@:<C-U>call <SNR>130_NetrwMarkFileTag(1)<CR>
" n  ms          *@:<C-U>call <SNR>130_NetrwMarkFileSource(1)<CR>
" n  mr          *@:<C-U>call <SNR>130_NetrwMarkFileRegexp(1)<CR>
" n  mp          *@:<C-U>call <SNR>130_NetrwMarkFilePrint(1)<CR>
" n  mm          *@:<C-U>call <SNR>130_NetrwMarkFileMove(1)<CR>
" n  mh          *@:<C-U>call <SNR>130_NetrwMarkHideSfx(1)<CR>
" n  mg          *@:<C-U>call <SNR>130_NetrwMarkFileGrep(1)<CR>
" n  mF          *@:<C-U>call <SNR>130_NetrwUnmarkList(bufnr("%"),b:netrw_curdir)<CR>
" n  mf          *@:<C-U>call <SNR>130_NetrwMarkFile(1,<SNR>130_NetrwGetWord())<CR>
" n  me          *@:<C-U>call <SNR>130_NetrwMarkFileEdit(1)<CR>
" n  md          *@:<C-U>call <SNR>130_NetrwMarkFileDiff(1)<CR>
" n  mc          *@:<C-U>call <SNR>130_NetrwMarkFileCopy(1)<CR>
" n  mB          *@:<C-U>call <SNR>130_NetrwBookHistHandler(6,b:netrw_curdir)<CR>
" n  mb          *@:<C-U>call <SNR>130_NetrwBookHistHandler(0,b:netrw_curdir)<CR>
" n  mA          *@:<C-U>call <SNR>130_NetrwMarkFileArgList(1,1)<CR>
" n  ma          *@:<C-U>call <SNR>130_NetrwMarkFileArgList(1,0)<CR>
" n  o           *@:call <SNR>130_NetrwSplit(3)<CR>
" n  p           *@:<C-U>call <SNR>130_NetrwPreview(<SNR>130_NetrwBrowseChgDir(1,<SNR>130_NetrwGetWord(),1))<CR>
" n  qL          *@:<C-U>call <SNR>130_NetrwMarkFileQFEL(1,getloclist(v:count))<CR>
" n  qF          *@:<C-U>call <SNR>130_NetrwMarkFileQFEL(1,getqflist())<CR>
" n  qf          *@:<C-U>call <SNR>130_NetrwFileInfo(1,<SNR>130_NetrwGetWord())<CR>
" n  qb          *@:<C-U>call <SNR>130_NetrwBookHistHandler(2,b:netrw_curdir)<CR>
" n  r           *@:<C-U>let g:netrw_sort_direction= (g:netrw_sort_direction =~# 'n')? 'r' : 'n'|exe "norm! 0"|call <SNR>130_NetrwRefresh(1,<SNR>130_NetrwBrowseChgDir(1,'./'))<CR>
" n  s           *@:call <SNR>130_NetrwSortStyle(1)<CR>
" n  t           *@:call <SNR>130_NetrwSplit(4)<CR>
" n  u           *@:<C-U>call <SNR>130_NetrwBookHistHandler(4,expand("%"))<CR>
" n  v           *@:call <SNR>130_NetrwSplit(5)<CR>
" n  x           *@:<C-U>call netrw#BrowseX(<SNR>130_NetrwBrowseChgDir(1,<SNR>130_NetrwGetWord(),0),0)"<CR>
" n  y.          *@:<C-U>call setreg(v:register, join(<SNR>57_absolutes(line('.'), line('.') - 1 + v:count1), "\n")."\n")<CR>
" n  ~           *@:edit ~/<CR>
" n  <F1>        *@<Cmd>help netrw-quickhelp<CR>
" n  <Plug>Netrw2Leftmouse  @-
" n  <Plug>NetrwSLeftdrag *@<LeftMouse>:call <SNR>130_NetrwSLeftdrag(1)<CR>
" n  <Plug>NetrwSLeftmouse *@<LeftMouse>:call <SNR>130_NetrwSLeftmouse(1)<CR>
" n  <Plug>NetrwMiddlemouse *@<LeftMouse>:call <SNR>130_NetrwPrevWinOpen(1)<CR>
" n  <Plug>NetrwCLeftmouse *@<LeftMouse>:call <SNR>130_NetrwCLeftmouse(1)<CR>
" n  <Plug>NetrwLeftmouse *@<LeftMouse>:call <SNR>130_NetrwLeftmouse(1)<CR>
" n  <2-LeftMouse>  @<Plug>Netrw2Leftmouse
" n  <S-LeftDrag>  @<Plug>NetrwSLeftdrag
" n  <S-LeftMouse>  @<Plug>NetrwSLeftmouse
" n  <MiddleMouse>  @<Plug>NetrwMiddlemouse
" n  <C-LeftMouse>  @<Plug>NetrwCLeftmouse
" n  <LeftMouse>  @<Plug>NetrwLeftmouse
" n  <Plug>NetrwTreeSqueeze *@:call <SNR>130_TreeSqueezeDir(1)<CR>
" n  <S-CR>       @<Plug>NetrwTreeSqueeze
" n  <S-Up>      *@:Pexplore<CR>
" n  <S-Down>    *@:Nexplore<CR>

" n  <Plug>NetrwRefresh *@<C-L>:call <SNR>130_NetrwRefresh(1,<SNR>130_NetrwBrowseChgDir(1,(w:netrw_liststyle == 3)? w:netrw_treetop : './'))<CR>
" n  <Plug>NetrwHideEdit *@:call <SNR>130_NetrwHideEdit(1)<CR>
" n  <Plug>NetrwBookHistHandler_gb *@:<C-U>call <SNR>130_NetrwBookHistHandler(1,b:netrw_curdir)<CR>
" n  <Plug>NetrwMakeDir *@:<C-U>call <SNR>130_NetrwMakeDir("")<CR>
" n  <Plug>NetrwServerEdit *@:<C-U>call <SNR>130_NetrwServerEdit(3,<SNR>130_NetrwGetWord())<CR>
" n  <Plug>NetrwLocalBrowseCheck *@:<C-U>call netrw#LocalBrowseCheck(<SNR>130_NetrwBrowseChgDir(1,<SNR>130_NetrwGetWord()))<CR>
" n  <Plug>NetrwSetChgwin *@:<C-U>call <SNR>130_NetrwSetChgwin()<CR>
" n  <Plug>NetrwLcd *@:<C-U>call <SNR>130_NetrwLcd(b:netrw_curdir)<CR>
" n  <Plug>NetrwBadd_cB *@:<C-U>call <SNR>130_NetrwBadd(1,1)<CR>
" n  <Plug>NetrwBadd_cb *@:<C-U>call <SNR>130_NetrwBadd(1,0)<CR>
" n  <Plug>NetrwOpenFile *@:<C-U>call <SNR>130_NetrwOpenFile(1)<CR>
" n  <Plug>NetrwBrowseUpDir *@:<C-U>call <SNR>130_NetrwBrowseUpDir(1)<CR>
" n  <Plug>NetrwHide_a *@:<C-U>call <SNR>130_NetrwHide(1)<CR>

" Atexit: {{{1
" let b:undo_ftplugin = 'set stl< '
