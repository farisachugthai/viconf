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
command! EchoRTP echo buffers#EchoRTP()

" From `:he quickfix`
command! -complete=dir -bang -nargs=* NewGrep execute 'silent grep! <q-args>' | copen<bang>

function! Window_Mappings() abort  " {{{
  " Navigate windows more easily
  " This displays as <NL> when you run `:map` but it behaves like C-j. Oh well.
  nnoremap <C-j> <Cmd>wincmd j<CR>
  nnoremap <C-k> <Cmd>wincmd k<CR>
  nnoremap <C-l> <Cmd>wincmd l<CR>
  nnoremap <C-j> <Cmd>wincmd j<CR>
  nnoremap <C-l> <Cmd>wincmd l<CR>
  " Resize windows a little faster
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
endfunction  " }}}

function! Quickfix_Mappings() abort  " {{{

  " TODO: These need to catch E776 no location list
  nnoremap <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>
  nnoremap <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

  " Normally the quickfix window is at the bottom of the screen.  If there are
  " vertical splits, it's at the bottom of the rightmost column of windows.  To
  " make it always occupy the full width:
  " use botright.
  nnoremap <Leader>l <Cmd>botright lhistory<CR>
  nnoremap <Leader>lw <Cmd>botright lwindow<CR>
  nnoremap <Leader>ll <Cmd>botright llist!<CR>
  nnoremap <Leader>lo <Cmd>lopen<CR>
  nnoremap <Leader>lf <Cmd>lwindow<CR>

  " Wanna note how long Ive been using Vim and still i onlyjust found out
  " about the chistory and lhistory commands like wth
  nnoremap <Leader>q <Cmd>botright chistory<CR>
  nnoremap <Leader>qw <Cmd>botright cwindow<CR>
  nnoremap <Leader>ql <Cmd>botright clist!<CR>
  nnoremap <leader>qo <Cmd>botright copen<CR>
  nnoremap <Leader>qf <Cmd>cwindow<CR>

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
endfunction  " }}}

function! AltKeyNavigation() abort  " {{{
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
endfunction  " }}}

function! Buffer_Mappings() abort  " {{{
  
  " Navigate Buffers More Easily:
  " Also note I wrote a Buffers command that utilizes fzf.
  nnoremap <Leader>bb <Cmd>Buffers<CR>

  nnoremap <Leader>bd <Cmd>bdelete<CR>
  " like quit
  nnoremap <Leader>bq <Cmd>bdelete!<CR>
  " like eXit
  nnoremap <Leader>bx <Cmd>bwipeout<CR>
  nnoremap <Leader>bu <Cmd>bunload<CR>

  nnoremap <Leader>bn <Cmd>bnext<CR>
  nnoremap <Leader>bp <Cmd>bprev<CR>
  nnoremap <Leader>b0 <Cmd>bfirst<CR>
  nnoremap <Leader>b$ <Cmd>blast<CR>
  " aka yank the whole buffer
  nnoremap <Leader>by <Cmd>"+%y<CR>
  " and then paste it
  nnoremap <Leader>bp <Cmd>"+gp<CR>
  " Sunovabitch bonly isn't a command?? Why is
  " noremap <Leader>bo <Cmd>bonly<CR>

  nnoremap <Leader>bs <Cmd>sbuffer<CR>
  nnoremap <Leader>bv <Cmd>vs<CR>
  nnoremap ]b <Cmd>bnext<CR>
  nnoremap [b <Cmd>bprev<CR>
  nnoremap ]B <Cmd>blast<CR>
  nnoremap [B <Cmd>bfirst<CR>
endfunction  " }}}

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
  call AltKeyNavigation()
  call Buffer_Mappings()
  call Tab_Mappings()
  call Quickfix_Mappings()
endif
