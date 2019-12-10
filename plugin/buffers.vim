" ============================================================================
  " File: buffers.vim
  " Author: Faris Chugthai
  " Description: Plugin with functions and commands for vim buffers and windows
  " Last Modified: Oct 20, 2019
" ============================================================================

" EchoRTP: {{{1
" The nvim API is seriously fantastic.

nnoremap <Leader>rt call buffers#EchoRTP()
command! -nargs=0 EchoRTP echo buffers#EchoRTP()

function! Buf_Window_Mapping() abort  " {{{1
  " Navigate windows more easily
  nnoremap <C-h> <Cmd>wincmd h<CR>
  nnoremap <C-j> <Cmd>wincmd j<CR>
  nnoremap <C-k> <Cmd>wincmd k<CR>
  nnoremap <C-l> <Cmd>wincmd l<CR>
  " Move windows a little faster the command bythemselves don't do anything
  nnoremap <C-w>< 5<C-w><
  nnoremap <C-w>> 5<C-w>>
  nnoremap <C-w>+ 5<C-w>+
  nnoremap <C-w>- 5<C-w>-
  " Also don't make me hit the shift key
  nnoremap <C-w>, 5<C-w><
  nnoremap <C-w>. 5<C-w>>
endfunction

function! QuickfixMappings() abort

  " To make navigating the location list and quickfix easier
  " Also check ./unimpaired.vim
  " Sep 05, 2019: This doesnt need to be 2 commands!! cwindow does both!
  " Oct 18, 2019: I just ran into llist and lwindow showing different things
  " and lwindow didn't show the location list i had at the time so switching again
  " November llist throws an error if no location. *sigh*
  noremap <Leader>cc <Cmd>cwindow<CR><bar>
  " Leader l is currently botright lwindow
  nnoremap <Leader>lc <Cmd>lwindow<CR>
  nnoremap <Leader>cl <Cmd>clist!<CR>
  nnoremap <Leader>ll <Cmd>llist!<CR>
  nnoremap <leader>co <Cmd>copen<CR>
  nnoremap <Leader>lo <Cmd>lopen<CR>

endfunction

" Command Line: {{{1
" It's annoying you lose a whole command from a typo
cnoremap <Esc> <nop>
" However I still need the functionality
cnoremap <C-g> <Esc>
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
  " we might be in vim
  if !exists('*nvim_list_tabpages') | return | endif

  " First check we have more than 1 tab.
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

endfunction

" Navigate Buffers More Easily: {{{1
function! SpaceBuffers() abort
  noremap <Leader>bb <Cmd>buffers<CR>
  noremap <Leader>bd <Cmd>bdelete<CR>
  noremap <Leader>bn <Cmd>bnext<CR>
  noremap <Leader>bp <Cmd>bprev<CR>
  noremap <Leader>bf <Cmd>bfirst<CR>
  noremap <Leader>bl <Cmd>blast<CR>
	" aka yank the whole buffer
  noremap <Leader>bY <Cmd>"+%y<CR>
	" and then paste it
  noremap <Leader>bP <Cmd>"+P<CR>
  " Sunovabitch bonly isn't a command?? Why is
  " noremap <Leader>bo <Cmd>bonly<CR>
endfunction

function! TabMaps() abort  " {{{1
  nnoremap <Leader>tn <Cmd>tabnext<CR>
  nnoremap <Leader>tp <Cmd>tabprev<CR>
  nnoremap <Leader>tq <Cmd>tabclose<CR>
  nnoremap <Leader>tc <Cmd>tabclose<CR>
  nnoremap <Leader>T  <Cmd>tabs<CR>
  nnoremap <Leader>te <Cmd>tabedit<CR>
	" ngl pretty surprised that that cword didn't need an expand()
	nnoremap <Leader>t# <Cmd>tabedit <cword><CR>
	" Need to decide between many options
	" nnoremap <Leader>tg <Cmd>tabedit
	" poop can't do this
	" nnoremap <Leader>tn <Cmd>tabnew<CR>
	nnoremap <Leader>tf <Cmd>tabfirst<CR>
	nnoremap <Leader>tl <Cmd>tablast<CR>

  noremap <F9> <Cmd>tabe ~/projects/viconf/init.vim<CR>
  " Don't forget to add in mappings when in insert/cmd mode
  noremap! <F9> <Cmd>tabe ~/projects/viconf/init.vim<CR>
  tnoremap <F9> <Cmd>tabe ~/projects/viconf/init.vim<CR>

endfunction

" Navigate Windows More Easily: {{{1
function! SpaceWindows() abort
  noremap <Leader>ws <Cmd>wincmd s<CR>
  noremap <Leader>wv <Cmd>wincmd v<CR>
  noremap <Leader>ww <Cmd>wincmd w<CR>
  " Split and edit file under the cursor
  noremap <Leader>wf <Cmd>wincmd f<CR>
  " Split and open the word under the cursor as a tag
  " noremap <Leader>w] <Cmd>wincmd ]<CR>

  " Thank you index.txt! From:
  " 2.2 Window commands						*CTRL-W*
  " |CTRL-W_g_CTRL-]| CTRL-W g CTRL-]  split window and do |:tjump| to tag
  " under cursor
  noremap <Leader>w] <C-w>g<C-]>
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
  call QuickfixMappings()
endif
