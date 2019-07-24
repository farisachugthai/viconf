
" ============================================================================
  " File: buffers.vim
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with buffers.
  " Last Modified: July 22, 2019
" ============================================================================

" Splitlist the rtp and echo: {{{1
function! buffers#EchoRTP()
    for directory in nvim_list_runtime_paths()
        echo directory
    endfor
endfunction

" PreviewWord:

" Open a tag for the word under the cursor in the preview window.
" TODO: Could definitely do with a mapping

function! buffers#PreviewWord() abort
" From :he cursorhold-example
  if &previewwindow			" don't do this in the preview window
    return
  endif
  let w = expand('<cword>')		" get the word under cursor
  if w =~? '\a'			" if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P			" jump to preview window
    if &previewwindow			" if we really get there...
      match none			" delete existing highlight
      wincmd p			" back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
       execute 'ptag ' . w
    catch
      return
    endtry

    silent! wincmd P			" jump to preview window
    if &previewwindow		" if we really get there...
	 if has('folding')
	   silent! .foldopen		" don't want a closed fold
	 endif
	 call search('$', 'b')		" to end of previous line
	 let w = substitute(w, '\\', '\\\\', '')
	 call search('\<\V' . w . '\>')	" position cursor on match
	 " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=green guibg=green
	 exe 'match previewWord "\%' . line('.') . 'l\%' . col('.') . 'c\k*"'
      wincmd p			" back to old window
    endif
  endif
endfunction
