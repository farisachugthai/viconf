" See Also: ../autoload/buffers.vim
" There's a good buffers#PreviewWord that shows some stuff i'm sure you wanna do
" See Also:  ./buffers.vim for more things similar to this

if !has('unix')
  let g:gutentags_ctags_executable = expand('$HOME/bin/ctags')
endif

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


" Forgot i had this function autoloaded
" Open a tag for the word under the cursor in the preview window.
" TODO: Could definitely do with a mapping

command! -complete=tag PreviewTag call buffers#PreviewWord()

" Probably needs a better mapping but whatever
nnoremap <Leader>t] <Cmd>PreviewTag<CR>

" And now we have stufff about tags

function! TagFunc(pattern, flags, info) abort
" Lol literally what is this option?
" well fuck. just errored on nvim4
  function! CompareFilenames(item1, item2) abort
    let f1 = a:item1['filename']
    let f2 = a:item2['filename']
    return f1 >=# f2 ?
    \ -1 : f1 <=# f2 ? 1 : 0
  endfunction

  let result = taglist(a:pattern)
  call sort(result, 'CompareFilenames')

  return result
endfunction
