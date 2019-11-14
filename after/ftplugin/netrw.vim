" ============================================================================
    " File: netrw.vim
    " Author: Faris Chugthai
    " Description: Yes netrw is a ftplugin
    " Last Modified: Oct 14, 2019
" ============================================================================

" Guards: {{{1
if exists('b:did_netrw_after_ftplugin') || &compatible || v:version < 700
    finish
endif
let b:did_netrw_after_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

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
nnoremap <buffer> <Tab>	<Plug>NetrwShrink

let g:netrw_preview = 1

" Defaults to 50%
" let g:netrw_winsize = 70
" This is the wrong way
let g:netrw_winsize = 30

" Long as hell but a bool indicating that theres special HL
let g:netrw_special_syntax    = v:true

" Mappings: {{{1
"
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

noremap <buffer> ^ <Plug>NetrwBrowseUpDir<Space>

" I have no idea why but this line isn't working and its generating an error
" that netrw buffers aren't modifiable....
" nnoremap <buffer> <F1>			:he netrw-quickhelp<cr>
" ....wtf?
nnoremap <buffer> <F1> <Cmd>help netrw-quickhelp<CR>

" Atexit: {{{1
let b:undo_ftplugin = '| unmap <buffer> ^'
let b:undo_ftplugin .= 'set stl< '

let &cpoptions = s:cpo_save
unlet s:cpo_save
