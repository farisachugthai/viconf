" The output of Gstatus is its own filetype

nnoremap F <Cmd>Gfetch<CR>

nnoremap <buffer> q <Cmd>bd!<CR>
silent! setlocal nomodified  noswapfile nomodifiable readonly

" Noticed while reading source
setlocal foldexpr=fugitive#Foldtext()

nnoremap <buffer> q <Cmd>bd!<CR>

" Plus isn't stage stuff. Wtf
" Uhh idk if i did this right but it might need <cexpr>
nnoremap <buffer> + <Cmd>Git add --renormalize <cword><CR>

" gO is something
" 1P is pedit. Can i have it just be p?
" p and P are taken tho
" nnoremap <buffer> p 1P

" Fat fingers are scary
silent! nunmap <buffer> U

let b:undo_ftplugin = '|setlocal ma< swf< mod< ro< foldexpr<'
      \. '|silent! <buffer> nunmap p'
      \. '|silent! <buffer> nunmap +'
      \. '|silent! <buffer> nunmap q'
      \. '|silent! <buffer> nunmap F'
