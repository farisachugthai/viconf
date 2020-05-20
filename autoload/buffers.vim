" ============================================================================
  " File: buffers.vim
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with buffers.
  " Last Modified: Feb 22, 2020
" ============================================================================

function! buffers#EchoRTP() abort
  " Huh son of a bitch. I actually figured out an easier way to do this
  " let's do a check that this function exists then and do it the non-nvim way
  " otherwise
  if exists('*nvim_list_runtime_paths')
    for l:directory in nvim_list_runtime_paths()
      echomsg l:directory
    endfor
  else
    for l:i in split(&runtimepath, ',') | echomsg l:i | endfor
  endif
endfunction

function! buffers#PreviewWord() abort
  " Open a tag for the word under the cursor in the preview window.
  " TODO: Could definitely do with a mapping

  " From :he cursorhold-example
  if &previewwindow     " don't do this in the preview window
    return
  endif
  let l:w = expand('<cword>')   " get the word under cursor
  if l:w =~? '\a'               " if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P            " jump to preview window
    if &previewwindow           " if we really get there...
      match none                " delete existing highlight
      wincmd p                  " back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    " lets add a write operation so that that doesnt end up raising
    if &autowrite && &modified | write | endif

    try
       execute 'ptag ' . l:w
    catch
      return
    endtry

    silent! wincmd P      " jump to preview window
    if &previewwindow   " if we really get there...
      if has('folding')
        silent! .foldopen    " don't want a closed fold
      endif
      call search('$', 'b')    " to end of previous line

      let l:w = substitute(l:w, '\\', '\\\\', '')

      call search('\<\V' . l:w . '\>')  " position cursor on match

      " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=green guibg=green

      exe 'match previewWord "\%' . line('.') . 'l\%' . col('.') . 'c\k*"'
      wincmd p      " back to old window
    endif
  endif
endfunction

function! buffers#terminals() abort
  " If running a terminal in Vim, go into Normal mode with Esc
  tnoremap <Esc> <C-\><C-n>

  " From he term. Alt-R is better because this causes us to lose C-r in every
  " command we run from nvim
  tnoremap <expr> <A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'

  " From :he terminal
  tnoremap <M-h> <C-\><C-N><C-w>h
  tnoremap <M-j> <C-\><C-N><C-w>j
  tnoremap <M-k> <C-\><C-N><C-w>k
  tnoremap <M-l> <C-\><C-N><C-w>l

  " Move around the line
  tnoremap <M-A> <Esc>A
  tnoremap <M-b> <Esc>b
  tnoremap <M-d> <Esc>d
  tnoremap <M-f> <Esc>f

  " Other window
  tnoremap <C-w>w <C-\><C-N><C-w>w

  tnoremap <F4> <Cmd>Snippets<CR>
  tnoremap <F6> <Cmd>UltiSnipsEdit<CR>

  " It's so annoying that buffers need confirmation to kill. Let's dedicate a
  " key but one that we know windows hasn't stolen yet.
  tnoremap <D-z> <Cmd>bd!<CR>
endfunction
