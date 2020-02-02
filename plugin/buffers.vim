" ============================================================================
  " File: buffers.vim
  " Author: Faris Chugthai
  " Description: Plugin with functions and commands for vim buffers and windows
  " Last Modified: Oct 20, 2019
" ============================================================================

if exists('g:did_buffers') || &compatible || v:version < 700
  finish
endif
let g:did_buffers = 1


" The nvim API is seriously fantastic.
nnoremap <Leader>rt call buffers#EchoRTP()
command! -nargs=0 EchoRTP echo buffers#EchoRTP()

command! -complete=dir -bar -bang -nargs=* NewGrep execute 'silent grep! <args>' | copen<bang>

function! Window_Mappings() abort  " {{{1
  " Navigate windows more easily
  " We cant use these though because ultisnips took c-j and c-k fuck
  " nnoremap <C-h> <Cmd>wincmd h<CR>
  " This displays as <NL> when you run `:map` but it behaves like C-j. Oh well.
  " nnoremap <C-j> <Cmd>wincmd j<CR>
  " nnoremap <C-k> <Cmd>wincmd k<CR>
  " nnoremap <C-l> <Cmd>wincmd l<CR>
  " Move windows a little faster the command bythemselves don't do anything
  nnoremap <C-w>< 5<C-w><
  nnoremap <C-w>> 5<C-w>>
  nnoremap <C-w>+ 5<C-w>+
  nnoremap <C-w>- 5<C-w>-
  " Also don't make me hit the shift key
  nnoremap <C-w>, 5<C-w><
  nnoremap <C-w>. 5<C-w>>

  " Navigate Windows More Easily:
  nnoremap <Leader>ws <Cmd>wincmd s<CR>
  nnoremap <Leader>wv <Cmd>wincmd v<CR>
  nnoremap <Leader>ww <Cmd>wincmd w<CR>
  " Split and edit file under the cursor
  nnoremap <Leader>wf <Cmd>wincmd f<CR>
endfunction

function! Quickfix_Mappings() abort
  " To make navigating the location list and quickfix easier
  " Also check ./unimpaired.vim
  " Sep 05, 2019: This doesnt need to be 2 commands!! cwindow does both!
  " Oct 18, 2019: I just ran into llist and lwindow showing different things
  " and lwindow didn't show the location list i had at the time so switching again
  " November llist throws an error if no location. *sigh*
  nnoremap <Leader>qc <Cmd>cwindow<CR>

  " These need to catch E776 no location list
  nnoremap <silent> <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>
  nnoremap <silent> <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

  " Normally the quickfix window is at the bottom of the screen.  If there are
  " vertical splits, it's at the bottom of the rightmost column of windows.  To
  " make it always occupy the full width:
  nnoremap <Leader>l <Cmd>botright lwindow<CR>
  nnoremap <Leader>lw <Cmd>lwindow<CR>
  nnoremap <Leader>ll <Cmd>llist!<CR>
  nnoremap <Leader>lo <Cmd>lopen<CR>

  nnoremap <Leader>qw <Cmd>botright cwindow<CR>
  nnoremap <Leader>ql <Cmd>botright clist!<CR>
  nnoremap <leader>qo <Cmd>botright copen<CR>

  nnoremap <Leader>C <Cmd>make %<CR>

  " Unimpaired Mappings:
  " Map quickfix list, buffers, windows and tabs to *[ and *]
  " Note: A bunch more in ./tag_miscellany.vim
  nnoremap ]q <Cmd>cnext<CR>
  nnoremap [q <Cmd>cprev<CR>
  nnoremap ]Q <Cmd>clast<CR>
  nnoremap [Q <Cmd>cfirst<CR>
  nnoremap ]l <Cmd>lnext<CR>
  nnoremap [l <Cmd>lprev<CR>
  nnoremap ]L <Cmd>llast<CR>
  nnoremap [L <Cmd>lfirst<CR>

  " Unrelated but cmdline
  " It's annoying you lose a whole command from a typo
  cnoremap <Esc> <nop>
  " However I still need the functionality
  cnoremap <C-g> <Esc>
  " Avoid accidental hits of <F1> while aiming for <Esc>
  noremap! <F1> <Esc>
endfunction

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

function! Buffer_Mappings() abort
  " Navigate Buffers More Easily:
  nnoremap <Leader>bb <Cmd>buffers<CR>
  nnoremap <Leader>bd <Cmd>bdelete<CR>
  nnoremap <Leader>bn <Cmd>bnext<CR>
  nnoremap <Leader>bp <Cmd>bprev<CR>
  nnoremap <Leader>bf <Cmd>bfirst<CR>
  nnoremap <Leader>bl <Cmd>blast<CR>
	" aka yank the whole buffer
  nnoremap <Leader>bY <Cmd>"+%y<CR>
	" and then paste it
  nnoremap <Leader>bP <Cmd>"+P<CR>
  " Sunovabitch bonly isn't a command?? Why is
  " noremap <Leader>bo <Cmd>bonly<CR>

  nnoremap ]b <Cmd>bnext<CR>
  nnoremap [b <Cmd>bprev<CR>
  nnoremap ]B <Cmd>blast<CR>
  nnoremap [B <Cmd>bfirst<CR>
endfunction

function! Tab_Mappings() abort  " {{{1
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

  nnoremap ]t <Cmd>tabn<CR>
  nnoremap [t <Cmd>tabp<CR>
  nnoremap ]T <Cmd>tablast<CR>
  nnoremap [T <Cmd>tabfirst<CR>
endfunction

" Call Functions:
if !exists('no_plugin_maps') && !exists('no_windows_vim_maps')
  call Window_Mappings()
  call Alt_Key_Navigation()
  call Buffer_Mappings()
  call Tab_Mappings()
  call Quickfix_Mappings()
endif
