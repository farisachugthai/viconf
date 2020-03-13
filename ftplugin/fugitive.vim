" ============================================================================
  " File: Fugitive.vim
  " Author: Faris Chugthai
  " Description: Modifications to fugitive buffers
  " Last Modified: March 08, 2020
" ============================================================================

" So they are definitively their own filetype. Huh.

if &filetype !=# 'fugitive'
  finish
endif

" Noticed while reading source
setlocal foldexpr=fugitive#Foldtext()

" Plus isn't stage stuff. Wtf
" Uhh idk if i did this right but it might need <cexpr>
nnoremap <buffer> + <Cmd>Git add --renormalize <cword><CR>

" gO is something
" 1P is pedit. Can i have it just be p?
nnoremap <buffer> p 1P

      " \ . '|nunmap p'
      " \ . '|nunmap +'

let b:undo_ftplugin = 'setlocal syntax< foldexpr< '
      \ . '|unlet! b:undo_ftplugin'

