" ============================================================================
    " File: xonsh.vim
    " Author: Faris Chugthai
    " Description: Xonsh ftdetecy
    " Last Modified: April 23, 2019
" ============================================================================

" Guard: {{{1
" I don't know if this is how you do this. ftdetect folder doesn't exist in the
" $VIMRUNTIME so we don't have a canonical reference. I suppose we could treat
" tpope or junegunn as one but.. eh.

" if exists('b:did_ftplugin') | finish | endif
" let b:did_ftplugin = 1

augroup xonsh_filetypedetect
    au!
    au BufNewFile,BufRead .xonshrc set filetype=xonsh
    au BufNewFile,BufRead *.xsh set filetype=xonsh
augroup END
