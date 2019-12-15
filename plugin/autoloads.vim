" ============================================================================
    " File: autoloads.vim
    " Author: Faris Chugthai
    " Description: Commands and functions defined in the autoload dir
    " Last Modified: June 26, 2019
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions-=C

" silence the errors from nvim -u NORC by defining this var in the first plugin file loaded
if !exists('plugs') | let plugs = {} | endif

" Commands: {{{1
command! Todo call todo#Todo()

" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=1 -bang -complete=file Rename f <args>|w<bang>za

" Gotta be honest this doesn't have much to do with anything but oh well.
"
" Autocompletion: {{{1
set wildignorecase wildmode=full:list:longest,full:list
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
" C-n and C-p now use the same input that every other C-x does combined!
" Remove includes they're pretty slow
set wildcharm=<C-z>
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

" G Commands: {{{1

xnoremap < <gv
xnoremap > >gv
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
" nnoremap J gJ
" This is only only a good idea if your line are mostly lined up with the left
" handside. Absolutely awful if you're working with code that's 9+ chars to
" the right

" Tags: {{{1
"
" Seeing as how I randomly decided this file would be the one that holds
" autocompletion info, why not add tags too?
" See Also: ../autoload/buffers.vim
" There's a good buffers#PreviewWord that shows some stuff i'm sure you wanna do

setglobal tags=tags,**/tags
setglobal tagcase=smart showfulltag

" So I just realized that I have almost no mappings or settings
" for the: paths, includes, defines, the clist or llist, tagstack or preview
" window. All of these things are really intertwined so i might start fleshing
" it out here!

" Just realized this isn't mapped either
nnoremap <C-}> [I:let nr = input("Choose an include: ")<Bar>exe "normal! " . nr ."[\t"<CR>

command! Tags echo gettagstack(expand('%'))

" Tagfunc: {{{2

" Lol literally what is this option?
" well fuck. just errored on nvim4
function! TagFunc(pattern, flags, info)
  function! CompareFilenames(item1, item2)
    let f1 = a:item1['filename']
    let f2 = a:item2['filename']
    return f1 >=# f2 ?
    \ -1 : f1 <=# f2 ? 1 : 0
  endfunction

  let result = taglist(a:pattern)
  call sort(result, "CompareFilenames")

  return result
endfunc

if exists('&tagfunc')
  set tagfunc=TagFunc
endif

" Compiling: {{{1

" just cuz. plus isn't the complete compiler option kinda cool?
command! -complete=compiler -nargs=? -buffer Make make <q-args> %

" Remotes: {{{1
" lol this got really random didn't it?

if has('unix')
  " Termux
  if exists($ANDROID_DATA)
    call find_files#termux_remote()
  " Ubuntu like or WSL
  else
    call find_files#ubuntu_remote()
  endif

  if exists($TMUX)
    let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': 'tmux load-buffer -',
          \      '*': 'tmux load-buffer -',
          \    },
          \   'paste': {
          \      '+': 'tmux save-buffer -',
          \      '*': 'tmux save-buffer -',
          \   },
          \   'cache_enabled': 1,
          \ }
  endif

else  " windows not wsl
  call find_files#msdos_remote()
endif


" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
