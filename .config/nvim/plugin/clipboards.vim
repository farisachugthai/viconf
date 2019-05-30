" ============================================================================
    " File: clipboards.vim
    " Author: Faris Chugthai
    " Description: The excessive complications of copy/paste in Vim
    " Last Modified: May 28, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_clipboard_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_clipboard_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Fun With Clipboards: {{{1

" I've been using vim for almost 3 years. I still don't have copy paste ironed out...
" Let's start simple

" Set Clipboard: {{{2
if has('unnamedplus')                   " Use the system clipboard.
    set clipboard+=unnamed,unnamedplus
else                                        " Accommodate Termux
    set clipboard+=unnamed
endif

set pastetoggle=<F7>

" Clipboard Provider: {{{2
" Now let's set up the clipboard provider

" First check that we're in a tmux session before trying this
if exists('$TMUX')

  " Now let's make a dictionary for copying and pasting actions. Name both
  " to hopefully make debugging easier. In `he provider-clipboard` they define
  " these commands so that they go to * and +....But what if we put them in
  " named registers? Then we can still utilize the * and + registers however
  " we want. Idk give it a try.
  " Holy hell that emits a lot of warnings and error messages don't do that
  " again.
  "
  " As an FYI, running `:echo provider#clipboard#Executable()` on Ubuntu gave
  " me xclip so that's something worth knowing
  let g:clipboard = {
      \   'name': 'TmuxCopyPasteClipboard',
      \   'copy': {
      \      '*': 'tmux load-buffer -',
      \      '+': 'tmux load-buffer -',
      \    },
      \   'paste': {
      \      '*': 'tmux save-buffer -',
      \      '+': 'tmux save-buffer -',
      \   },
      \   'cache_enabled': 1,
      \ }
else
  if exists('$DISPLAY') && executable('xclip')
    " This is how it's defined in autoload/providor/clipboard.vim
    let g:clipboard = {
      \    'name': 'xclipboard',
      \    'copy': {
      \       '*': 'xclip -quiet -i -selection primary',
      \       '+': 'xclip -quiet -i -selection clipboard',
      \    },
      \   'paste': {
      \       '*': 'xclip -o -selection primary',
      \       '+': 'xclip -o -selection clipboard',
      \   },
      \   'cache_enabled': 1,
      \ }
  endif
endif

" Double check if we need to do this but sometimes the clipboard fries when set this way
runtime! autoload/provider/clipboard.vim

" atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
