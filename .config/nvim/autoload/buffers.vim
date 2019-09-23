
" ============================================================================
  " File: buffers.vim
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with buffers.
  " Last Modified: July 22, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_buffers_vim') || &compatible || v:version < 700
  finish
endif
let g:did_buffers_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

function! buffers#EchoRTP()  " {{{1

  for directory in nvim_list_runtime_paths()   
    echo directory
  endfor

endfunction


function! buffers#PreviewWord() abort  " {{{1

" Open a tag for the word under the cursor in the preview window.
" TODO: Could definitely do with a mapping

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


function! buffers#terminals() abort  " {{{1

  " If running a terminal in Vim, go into Normal mode with Esc
  tnoremap <Esc> <C-\><C-n>

  " From he term. Alt-R is better because this causes us to lose C-r in every
  " command we run from nvim
  tnoremap <expr> <A-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

  " From :he terminal
  tnoremap <A-h> <C-\><C-N><C-w>h
  tnoremap <A-j> <C-\><C-N><C-w>j
  tnoremap <A-k> <C-\><C-N><C-w>k
  tnoremap <A-l> <C-\><C-N><C-w>l
  inoremap <A-h> <C-\><C-N><C-w>h
  inoremap <A-j> <C-\><C-N><C-w>j
  inoremap <A-k> <C-\><C-N><C-w>k
  inoremap <A-l> <C-\><C-N><C-w>l

  " Move around the line
  tnoremap <A-A> <Esc>A
  tnoremap <A-b> <Esc>b
  tnoremap <A-d> <Esc>d
  tnoremap <A-f> <Esc>f

  " Other window
  tnoremap <C-w>w <C-><C-N><C-w>w
endfunction


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
