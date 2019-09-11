" ============================================================================
  " File: windows.vim
  " Author: Faris Chugthai
  " Description: Plugin with functions and commands for vim windows
  " Last Modified: Jul 19, 2019
" ============================================================================

" Guard:
if exists('g:did_windows_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_windows_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" EchoRTP: {{{1
" The nvim API is seriously fantastic.

nnoremap <Leader>rt call buffers#EchoRTP()

command! -nargs=0 EchoRTP echo buffers#EchoRTP()

" General Mappings: {{{1
" This is specifically for ftplugins but why not add a check here regardless?
" <						*no_plugin_maps*
" 4. Disable defining mappings for all filetypes by setting a variable: >
" 	:let no_plugin_maps = 1

function! Buf_Window_Mapping() abort
  " To make navigating the location list and quickfiz easier
  " Also check ./unimpaired.vim
  " Sep 05, 2019: This doesnt need to be 2 commands!! cwindow does both!
  noremap <leader>c <Cmd>cwindow<CR><bar><Cmd>lwindow<CR>
  " noremap <leader>q <Cmd>copen<CR><bar><Cmd>lopen<CR>

  " Navigate windows more easily
  noremap <C-h> <Cmd>wincmd h<CR>
  noremap <C-j> <Cmd>wincmd j<CR>
  noremap <C-k> <Cmd>wincmd k<CR>
  noremap <C-l> <Cmd>wincmd l<CR>

  " Resize them more easily. Finish more later. TODO
  nnoremap <C-w>< <Cmd>5wincmd < <CR>
  nnoremap <C-w>> <Cmd>5wincmd > <CR>
  nnoremap <C-w>+ <Cmd>5wincmd + <CR>
  nnoremap <C-w>- <Cmd>5wincmd - <CR>
endfunction

" Command Line: {{{1
" It's annoying you lose a whole command from a typo
cnoremap <Esc> <nop>
" However I still need the functionality
cnoremap <C-g> <Esc>

" From he cedit. Open the command window with F1 because it being bound to
" help is SO annoying.
execute 'set cedit=<F1>'

" In the same line of thinking:
" Avoid accidental hits of <F1> while aiming for <Esc>
noremap! <F1> <Esc>

" ALT Key Window Navigation: {{{1
function! Alt_Key_Navigation() abort
  " Originally this inspired primarily for terminal use but why not put it everywhere?
  noremap  <A-h> <C-w>h
  noremap  <A-j> <C-w>j
  noremap  <A-k> <C-w>k
  noremap  <A-l> <C-w>l
  noremap! <A-h> <C-w>h
  noremap! <A-j> <C-w>j
  noremap! <A-k> <C-w>k
  noremap! <A-l> <C-w>l
endfunction


" Navigate Buffers More Easily: {{{1

function! SpaceBuffers() abort
  noremap <Leader>bb <Cmd>buffers<CR>
  noremap <Leader>bd <Cmd>bdelete<CR>
  noremap <Leader>bn <Cmd>bnext<CR>
  noremap <Leader>bp <Cmd>bprev<CR>
  noremap <Leader>bf <Cmd>bfirst<CR>
  noremap <Leader>bl <Cmd>blast<CR>
  noremap <Leader>bY <Cmd>"+%y<CR>
  noremap <Leader>bP <Cmd>"+P<CR>
  " Sunovabitch bonly isn't a command?? Why is
  " noremap <Leader>bo <Cmd>bonly<CR>
endfunction

" Navigate Tabs More Easily: {{{1

function! TabMaps() abort
  " First check we have more than 1 tho.
  if len(nvim_list_tabpages()) > 1
      noremap  <A-Right>  <Cmd>tabnext<CR>
      noremap  <A-Left>   <Cmd>tabprev<CR>
      noremap! <A-Right>  <Cmd>tabnext<CR>
      noremap! <A-Left>   <Cmd>tabprev<CR>
  elseif len(nvim_list_wins()) > 1
      noremap  <A-Right>  <Cmd>wincmd l<CR>
      noremap  <A-Left>   <Cmd>wincmd h<CR>
      noremap! <A-Right>  <Cmd>wincmd l<CR>
      noremap! <A-Left>   <Cmd>wincmd h<CR>
  endif

  nnoremap <Leader>tn <Cmd>tabnext<CR>
  nnoremap <Leader>tp <Cmd>tabprev<CR>
  nnoremap <Leader>tq <Cmd>tabclose<CR>

  " Opens a new tab with the current buffer's path
  " Super useful when editing files in the same directory
  nnoremap <Leader>te <Cmd>tabedit <c-r>=expand("%:p:h")<CR>

  " It should also be easier to edit the config. Bind similarly to tmux
  nnoremap <Leader>ed <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

  noremap <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>
  " Don't forget to add in mappings when in insert/cmd mode
  noremap! <F9> <Cmd>tabe ~/projects/viconf/.config/nvim/init.vim<CR>

  " Now reload it
  noremap <Leader>re <Cmd>so $MYVIMRC<CR><Cmd>echo 'Vimrc reloaded!'<CR>

endfunction

" Navigate Windows More Easily: {{{1
function! SpaceWindows()
  noremap <Leader>ws <Cmd>wincmd s<CR>
  noremap <Leader>wv <Cmd>wincmd v<CR>
  noremap <Leader>ww <Cmd>wincmd w<CR>
  " Split and edit file under the cursor
  noremap <Leader>wf <Cmd>wincmd f<CR>
  " Split and open the word under the cursor as a tag
  noremap <Leader>w] <Cmd>wincmd ]<CR>
  noremap <Leader>wc <Cmd>wincmd c<CR>
  noremap <Leader>wo <Cmd>wincmd o<CR>
endfunction

" Unimpaired Mappings: {{{1

function! UnImpairedWindows() abort
  " Map quickfix list, buffers, windows and tabs to *[ and *]
  noremap ]q <Cmd>cnext<CR>
  noremap [q <Cmd>cprev<CR>
  noremap ]Q <Cmd>clast<CR>
  noremap [Q <Cmd>cfirst<CR>
  noremap ]l <Cmd>lnext<CR>
  noremap [l <Cmd>lprev<CR>
  noremap ]L <Cmd>llast<CR>
  noremap [L <Cmd>lfirst<CR>
  noremap ]b <Cmd>bnext<CR>
  noremap [b <Cmd>bprev<CR>
  noremap ]B <Cmd>blast<CR>
  noremap [B <Cmd>bfirst<CR>
  noremap ]t <Cmd>tabn<CR>
  noremap [t <Cmd>tabp<CR>
  noremap ]T <Cmd>tablast<CR>
  noremap [T <Cmd>tabfirst<CR>
endfunction

" Call Functions: {{{1

if !exists('no_plugin_maps') && !exists('no_windows_vim_maps')
  call Buf_Window_Mapping()
  call Alt_Key_Navigation()
  call SpaceBuffers()
  call TabMaps()
  call UnImpairedWindows()
  call SpaceWindows()
endif

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
