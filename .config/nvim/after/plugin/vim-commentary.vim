" ============================================================================
    " File: vim-commentary.vim
    " Author: Faris Chugthai
    " Description: Configuration for tpopes vim commentary
    " Last Modified: April 22, 2019
" ============================================================================

" Should I make it only 1 keybinding? Would make interface easier
augroup commentary
    autocmd!
    autocmd Filetype python noremap <Leader># ^<Plug>CommentaryLine
    autocmd Filetype javascript noremap <Leader>// ^<Plug>CommentaryLine
    autocmd Filetype vim noremap <Leader>" ^<Plug>CommentaryLine
augroup END
