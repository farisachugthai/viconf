" ============================================================================
    " File: autoloads.vim
    " Author: Faris Chugthai
    " Description: Commands and functions defined in the autoload dir
    " Last Modified: June 26, 2019
" ============================================================================

" silence the errors from nvim -u NORC by defining this var in the first plugin file loaded
if !exists('plugs') | let plugs = {} | endif

command! Todo call todo#Todo()

" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>za

" Gotta be honest this doesn't have much to do with anything but oh well.

set wildignorecase wildmode=full:list:longest,full:list
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
set wildcharm=<C-z>

" C-n and C-p now use the same input that every other C-x does combined!
" Remove includes they're pretty slow
set complete+=kspell,d,k complete-=u,i

" Create a preview window and display all possibilities but don't insert
" dude what am i doing wrong that i don't get the cool autocompletion that NORC gets??
set completeopt=menu,menuone,noselect,noinsert

imap <C-]> <C-x><C-]>
" vim-rsi got this one
" imap <C-d> <C-x><C-d>
imap <C-i> <C-x><C-i>
imap <C-n> <C-x><C-n>
imap <C-p> <C-x><C-p>

" Can't do C-v or C-o they're too important

xnoremap < <gv
xnoremap > >gv
" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
noremap <Up> gk
noremap <Down> gj
" I mess this up constantly thinking that gI does what gi does
inoremap gI gi

" just cuz. plus isn't the complete compiler option kinda cool?
command! -complete=compiler -nargs=? -buffer Make make <q-args> %

if &tabstop > 4 | setlocal tabstop=4 | endif
if &shiftwidth > 4  | setlocal shiftwidth=4 | endif
setlocal expandtab smarttab softtabstop=4

" Search: {{{
set nohlsearch
if &textwidth!=0
  setl colorcolumn=+1
else
  setl colorcolumn=80
endif

" let &grepprg = syncom#grepprg(<q-args>)
" note you can't do this. no args to options
call syncom#grepprg()

" Dude read over :he getcharsearch(). Now ; and , search forward backward no matter what!!!
nnoremap <expr> ; getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Dude i didn't know this. This is dope
							" *gstar*
" g*			Like "*", but don't put "\<" and "\>" around the word.
			" This makes the search also find matches that are not a
			" whole word.

							" *g#*
" g#			Like "#", but don't put "\<" and "\>" around the word.
			" This makes the search also find matches that are not a
			" whole word.

nnoremap * g*
nnoremap # g#
