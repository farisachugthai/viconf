" ============================================================================
  " File: Fugitive.vim
  " Author: Faris Chugthai
  " Description: Modifications to fugitive buffers
  " Last Modified: March 08, 2020
" ============================================================================

" does he not define it as a ffplugin im so confused
" heres a few autocmds
  "autocmd FileType fugitive
  "      \ if len(FugitiveGitDir()) |
  "      \   call fugitive#MapCfile('fugitive#StatusCfile()') |
  "      \ endif

  "autocmd BufReadCmd    fugitive://*//*             exe fugitive#BufReadCmd() |
  "      \ if &path =~# '^\.\%(,\|$\)' |
  "      \   let &l:path = substitute(&path, '^\.,\=', '', '') |
  "      \ endif
  "autocmd BufWriteCmd   fugitive://*//[0-3]/*       exe fugitive#BufWriteCmd()
  "autocmd FileReadCmd   fugitive://*//*             exe fugitive#FileReadCmd()
  "autocmd FileWriteCmd  fugitive://*//[0-3]/*       exe fugitive#FileWriteCmd()
  "if exists('##SourceCmd')
  "  autocmd SourceCmd     fugitive://*//*    nested exe fugitive#SourceCmd()
  "endif

" Noticed while reading source
setlocal foldexpr=fugitive#Foldtext()

nnoremap q <Cmd>bd!<CR>

" Plus isn't stage stuff. Wtf
" Uhh idk if i did this right but it might need <cexpr>
nnoremap <buffer> + <Cmd>Git add --renormalize <cword><CR>

" gO is something
" 1P is pedit. Can i have it just be p?
nnoremap <buffer> p 1P

" Fat fingers are scary
nunmap <buffer> U

let b:undo_ftplugin = 'setlocal foldexpr< '
      \ . '|unlet! b:undo_ftplugin'
      \ . '|silent! <buffer> nunmap p'
      \ . '|silent! <buffer> nunmap +'
      \ . '|silent! <buffer> nunmap q'

