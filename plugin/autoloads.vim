" ============================================================================
    " File: autoloads.vim
    " Author: Faris Chugthai
    " Description: Commands and functions defined in the autoload dir
    " Last Modified: June 26, 2019
" ============================================================================

" TODO: make bang handle either open in split or full window
command! -bar -bang Todo call todo#Todo()

" :he map line 1454. How have i never noticed this isn't a feature???
command! -bar -nargs=1 -bang -complete=file Rename f <args>|w<bang>za

" Completion:
set wildignorecase wildmode=full:list:longest,full:list
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
set wildcharm=<C-z>

" C-n and C-p now use the same input that every other C-x does combined!
" Remove includes they're pretty slow
set complete+=kspell,d,k complete-=u,i

" Create a preview window and display all possibilities but don't insert
" dude what am i doing wrong that i don't get the cool autocompletion that NORC gets??
set completeopt=menu,menuone,noselect,noinsert,preview

imap <C-]> <C-x><C-]>
imap <C-i> <C-x><C-i>
imap <C-n> <C-x><C-n>
imap <C-p> <C-x><C-p>
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
command! -bar -bang -complete=compiler -nargs=? -buffer Make make <q-args> %

if &tabstop > 4 | setlocal tabstop=4 | endif
if &shiftwidth > 4  | setlocal shiftwidth=4 | endif
setlocal expandtab smarttab softtabstop=4

" Search Mappings:
set nohlsearch
if &textwidth!=0 | setl colorcolumn=+1 | else | setl colorcolumn=80 | endif

" Dude read over :he getcharsearch(). Now ; and , search forward backward no matter what!!!
nnoremap <expr> ; getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'

" These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" If you highlight something in Visual mode, you should be able to use '#' and
" '*' to search for it.
xnoremap * y/<C-R>"<CR>/<CR>gvzz
xnoremap # y?<C-R>"<CR>gvzz

if has('unix')
  if exists(':Marks')
    " Hey why not make it fuzzy if we can
    nnoremap ' <Cmd>Marks<CR>
  else
    " Literally ` does the same thing as ' but ` remembers column.
    nnoremap ' `
  endif
else
    nnoremap ' `
endif
