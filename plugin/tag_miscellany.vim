" ============================================================================
  " File: tag_miscellany.vim
  " Author: Faris A Chugthai
  " Description: Utility settings for tags
  " Last Modified: 02/10/2020
" ============================================================================

" See Also: ../autoload/buffers.vim

" See Also:  ./buffers.vim for more things similar to this
" There's a good buffers#PreviewWord that shows some stuff i'm sure you wanna do

if exists('g:did_tag_miscellany') | finish | endif
let g:did_tag_miscellany = 1

" Mnemonic: goto like mosts other g commands and \ is the key we're left free
nnoremap <g-\> [I:let nr = input("Choose an include: ")<Bar>exe "normal! " . nr ."[\t"<CR>

setglobal tags=tags,**/tags
setglobal tagcase=smart showfulltag

" You never added complete tags dude!
command! -complete=tag -bar Tagstack echo gettagstack(expand('%'))
command! -complete=tag -bar Tagfiles echo tagfiles()

command! -complete=tag -bar -bang FZTags call fzf#run(fzf#wrap('tags', {'source': 'gettagstack(expand("%"))', 'sink': 'e', 'options': g:fzf_options}, <bang>0))

if exists('&tagfunc')
  let &g:tagfunc = 'TagFunc'
endif

nnoremap ]g <Cmd>stjump!<CR>
xnoremap ]g <Cmd>stjump!<CR>

" Thank you index.txt!
" From: 2.2 Window commands						*CTRL-W*
" |CTRL-W_g_CTRL-]| CTRL-W g CTRL-]
" split window and do |:tjump| to tag under cursor
nnoremap <Leader>w] <C-w>g<C-]>
nnoremap ]w <C-w>g<C-]>

nnoremap <Leader>wc <Cmd>wincmd c<CR>
nnoremap <Leader>wo <Cmd>wincmd o<CR>

" Open a tag for the word under the cursor in the preview window.
command! -complete=tag PreviewTag call buffers#PreviewWord()

nnoremap ]t <Cmd>PreviewTag<CR>

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

if !exists('g:plugs') | finish | endif

" Could check for loaded_gutentags = 1 but idk if we're loading before him or
" not
let g:gutentags_ctags_exclude = [
      \ '.pyc',
      \ '.eggs',
      \ '.egg-info',
      \ '_static',
      \ '__pycache__',
      \ 'elpy',
      \ 'elpa',
      \ '.ipynb_checkpoints',
      \ '.idea',
      \ 'node_modules',
      \ '_build',
      \ 'build',
      \ '.git',
      \ 'log',
      \ 'tmp',
      \ 'dist',
      \ '.tox',
      \ '.venv',
      \ ]
