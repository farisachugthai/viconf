" ============================================================================
    " File: man.vim
    " Author: Faris Chugthai
    " Description: Man.vim filetype mods
    " Last Modified: March 17, 2019
" ============================================================================

" Helptabs:
function! s:helptab()
    " This needs to be conditional on there being 2 windows.
    try
        wincmd T
    catch
    endtry

    setlocal number
    setlocal relativenumber

    nnoremap <buffer> q :q<cr>
    " need to make an else for if ft isn't help then open a help page with the
    " first argument
endfunction

augroup mantabs
    autocmd!
    " Would this mean only call this part when we enter a new buffer but not
    " the first time we enter nvim?
    " Unfortunately no.
    " autocmd VimEnter finish
    autocmd Filetype man,help call s:helptab()
    " should we do both?
    " autocmd BufEnter buftype ==# 'help' call s:helptab()

augroup END
