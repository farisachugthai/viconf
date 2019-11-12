" ============================================================================
    " File: autoloads.vim
    " Author: Faris Chugthai
    " Description: Commands and functions defined in the autoload dir
    " Last Modified: June 26, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_autoloads_vim') || &compatible || v:version < 700
    finish
endif
let g:did_autoloads_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Unrelated functionality but silence the errors from nvim -u NORC by defining
" this var in the first plugin file loaded
if !exists('plugs')
  let plugs = {}
endif

" Commands: {{{1
command! Todo call todo#Todo()

" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>za

" Gotta be honest this doesn't have much to do with anything but oh well.
"
" Autocompletion: {{{1

imap <C-]> <C-x><C-]>
" vim-rsi got this one
" imap <C-d> <C-x><C-d>
imap <C-i> <C-x><C-i>
imap <C-n> <C-x><C-n>
imap <C-p> <C-x><C-p>

" Can't do C-v or C-o they're too important

" G Commands: {{{1

vnoremap < <gv
vnoremap > >gv
" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
noremap <Up> gk
noremap <Down> gj
" I mess this up constantly thinking that gI does what gi does
inoremap gI gi

" Nov 12, 2019:
" Holy actual shit. I can't believe I didn't know about this and now it's the
" only way i want to join lines.
nnoremap J gJ

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
