" gutentags

" General tags stuff

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

" You never added complete tags dude!
command! -complete=tag Tags echo gettagstack(expand('%'))

if exists('&tagfunc')
  let &tagfunc = 'vim_file_chooser#TagFunc'
endif

" The actual plugin
if !has('unix')
  let g:gutentags_ctags_executable = expand('$HOME/bin/ctags')
endif

