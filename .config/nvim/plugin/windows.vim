" ============================================================================
  " File: windows.vim
  " Author: Faris Chugthai
  " Description: Plugin with functions and commands for vim windows
  " Last Modified: May 03, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_windows_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_windows_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Here's a bunch from the nvim api. I wanna start experimenting with that and
" see how it goes

" EchoRTP: {{{1
" The nvim API is seriously fantastic.

function! g:EchoRTP()
    for directory in nvim_list_runtime_paths()
        echo directory
    endfor
endfunction

nnoremap <Leader>rt call g:EchoRTP()

command! -nargs=0 EchoRTP call g:EchoRTP()

" PreviewWord: {{{1

" Open a tag for the word under the cursor in the preview window.
" Could definitely do with a mapping

function! g:PreviewWord() abort
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

" General Mappings: {{{1

" To make navigating the location list and quickfiz easier
" Also check ./unimpaired.vim
noremap <leader>c <Cmd>cclose<CR><bar><Cmd>lclose<CR>
noremap <leader>q <Cmd>copen<CR><bar><Cmd>lopen<CR>

" Navigate windows more easily
noremap <C-h> <Cmd>wincmd h<CR>
noremap <C-j> <Cmd>wincmd j<CR>
noremap <C-k> <Cmd>wincmd k<CR>
noremap <C-l> <Cmd>wincmd l<CR>

" Resize them more easily. Finish more later. TODO
noremap <C-w>< <Cmd>wincmd 5<<CR>
noremap <C-w>> <Cmd>wincmd 5><CR>


" ALT Key Window Navigation: {{{1
" Originally this inspired primarily for terminal use but why not put it everywhere?
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l
noremap! <A-h> <C-w>h
noremap! <A-j> <C-w>j
noremap! <A-k> <C-w>k
noremap! <A-l> <C-w>l

" atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
