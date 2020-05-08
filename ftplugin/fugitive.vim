" ============================================================================
  " File: Fugitive.vim
  " Author: Faris Chugthai
  " Description: Modifications to fugitive buffers
  " Last Modified: March 08, 2020
" ============================================================================

  " otherwise this gets sourced every fucking time you're in a git repo
if &filetype==# 'fugitive'
  finish
endif

" Noticed while reading source
setlocal foldexpr=fugitive#Foldtext()

nnoremap <buffer> q <Cmd>bd!<CR>

" Plus isn't stage stuff. Wtf
" Uhh idk if i did this right but it might need <cexpr>
nnoremap <buffer> + <Cmd>Git add --renormalize <cword><CR>

" gO is something
" 1P is pedit. Can i have it just be p?
nnoremap <buffer> p 1P

" Fat fingers are scary
if maparg('U')
  nunmap <buffer> U
endif

let b:undo_ftplugin = 'setlocal foldexpr< '
      \ . '|unlet! b:undo_ftplugin'
      \ . '|silent! <buffer> nunmap p'
      \ . '|silent! <buffer> nunmap +'
      \ . '|silent! <buffer> nunmap q'
