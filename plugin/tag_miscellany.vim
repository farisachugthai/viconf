" See Also: ../autoload/buffers.vim
" There's a good buffers#PreviewWord that shows some stuff i'm sure you wanna do
" See Also:  ./buffers.vim for more things similar to this

nnoremap <C-}> [I:let nr = input("Choose an include: ")<Bar>exe "normal! " . nr ."[\t"<CR>

setglobal tags=tags,**/tags
setglobal tagcase=smart showfulltag

" You never added complete tags dude!
command! -complete=tag Tags echo gettagstack(expand('%'))

if exists('&tagfunc')
  let &tagfunc = 'vim_file_chooser#TagFunc'
endif

nnoremap ]g <Cmd>stjump!<CR>
xnoremap ]g <Cmd>stjump!<CR>

" Split and open the word under the cursor as a tag
" noremap <Leader>w] <Cmd>wincmd ]<CR>

" Thank you index.txt! From:
" 2.2 Window commands						*CTRL-W*
" |CTRL-W_g_CTRL-]| CTRL-W g CTRL-]  split window and do |:tjump| to tag
" under cursor
nnoremap <Leader>w] <C-w>g<C-]>
nnoremap ]w <C-w>g<C-]>

nnoremap <Leader>wc <Cmd>wincmd c<CR>
nnoremap <Leader>wo <Cmd>wincmd o<CR>
