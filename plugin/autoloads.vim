" ============================================================================
  " File: autoloads.vim
  " Author: Faris Chugthai
  " Description: Commands and functions defined in the autoload dir
  " *Though increasingly this file is just random junk
  " Last Modified: June 26, 2019
" ============================================================================

if exists('g:did_autoloads') || &compatible || v:version < 700
  finish
endif
let g:did_autoloads = 1


" Completion: {{{
setglobal wildignorecase wildmode=full:list:longest,full:list
setglobal wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
setglobal wildcharm=<C-z>

" C-n and C-p now use the same input that every other C-x does combined!
" Remove includes they're pretty slow
setglobal complete+=kspell,d,k complete-=u,i

" Create a preview window and display all possibilities but don't insert
" dude what am i doing wrong that i don't get the cool autocompletion that NORC gets??
setglobal completeopt=menu,menuone,noselect,noinsert,preview

                                                " *i_CTRL-]*
" CTRL-]                Trigger abbreviation, without inserting a character.
" So I guess we shouldnt do this anymore either
" imap <C-]> <C-x><C-]>
" }}}

" Navigation: {{{
xnoremap < <gv
xnoremap > >gv

" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
noremap <Up> gk
noremap <Down> gj

" I mess this up constantly thinking that gI does what gi does
inoremap gI gi
" }}}

" Finding Files: {{{

nnoremap ,e :e **/*<C-z><S-Tab>

nnoremap ,f :find **/*<C-z><S-Tab>
" Completes filenames from the directories specified in the 'path' option:
command! -nargs=* -bang -bar -complete=customlist,unix#EditFileComplete
        \ Edit edit<bang> <q-args>

" I admit feeling peer pressured to add this but
" -range=N    A count (default N) which is specified in the line
"             number position (like |:split|); allows for zero line
"             number.
command! -nargs=* -bang -bar -complete=file -complete=customlist,unix#EditFileComplete
        \ Split <q-mods>split<bang> <q-args>

command! -nargs=* -bang -bar -complete=file -complete=customlist,unix#EditFileComplete -range=0
        \ SplitHere <q-mods>split<bang> <q-args>

" Frustratingly this works but doesn't open the fucking file?
command! -nargs=* -range=% -addr=buffers -bang -bar -complete=file_in_path Find <q-mods>find<bang> <q-args>

" Well this is nice to know about. You can specify what a range refers to.
" -addr=loaded_buffers
command! -nargs=* -bang -bar -complete=buffer -range=% -addr=buffers
      \ BuffEdit <q-mods>buffer<bang> <q-args>

command! -nargs=* -bang -bar -complete=buffer -range=% -addr=buffers
      \ BuffsEdit <q-mods>buffers<bang> <q-args>

" }}}

" Miscellaneous: {{{
command! -bar -bang -complete=compiler -nargs=* Make
      \ if <args>
      \ for f in expand(<q-args>, 0, 1) |
      \ exe '<mods> make<bang>' . f |
      \ endfor
      \ else
      \ exe '<mods> make<bang>' . expand('%')

command! -bar -bang -complete=compiler -nargs=* -range=% -addr=buffers MakeBuffers
      \ if <args>
      \ for f in expand(<q-args>, 0, 1) |
      \ exe '<mods> make<bang>' . f |
      \ endfor
      \ else
      \ exe '<mods> make<bang>' . expand('%')

if &tabstop > 4 | setglobal tabstop=4 | endif
if &shiftwidth > 4  | setglobal shiftwidth=4 | endif
setglobal expandtab smarttab softtabstop=4

nnoremap Q @q
xnoremap <BS> d
nnoremap <Leader>sp <Cmd>setlocal spell!<CR>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

command! -bar -nargs=1 -complete=history RerunLastX call histget(<args>, 1)

" TODO: make bang handle either open in split or full window
command! -bar Todo call todo#Todo()

" :he map line 1454. How have i never noticed this isn't a feature???
command! -bar -nargs=? -bang -complete=buffer Rename file <q-args>|w<bang>za

" These 2 commands are for parsing the output of scriptnames though a command
" like :TBrowseScriptnames would probably be easier to work with:
command! -nargs=? -bar SNames call vimscript#Scriptnames(<f-args>)
command! -nargs=0 -bar SNamesDict echo vimscript#ScriptnamesDict()

" Useful if you wanna see all available funcs provided by nvim
command! -bang -nargs=0 NvimAPI
      \ new<bang> | put =map(filter(api_info().functions,
      \ '!has_key(v:val,''deprecated_since'')'),
      \ 'v:val.name')

" Easier mkdir and cross platform!
command! -complete=dir -nargs=1 Mkdir call mkdir(shellescape(<args>), 'p', '0700')
" }}}

" Search Mappings: {{{
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
xnoremap * y/<C-R>"<CR>
xnoremap # y?<C-R>"<CR>

" here's a great idea from justinmk:
" mark searches before you start
nnoremap / ms/
" let's extend justin's idea with ours!
" get rid of the gv it's super confusing
xnoremap / msy/<C-R>"<CR>

" }}}

" FZF Marks: {{{
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

" }}}

" {{{
" From `:he change`  line 352 tag g?g?
" Adding range means that the command defaults to current line
" Need to add a check that we're in visual mode and drop the '<,'> if not.
command! -nargs=0 -bar -range TitleCase execute 'normal! ' . "'<,'>s/\v<(.)(\w*)/\u\1\L\2/g"
" }}}
"
" Vim: set fdm=marker:
