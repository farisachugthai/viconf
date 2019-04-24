" ============================================================================
    " File: xonsh.vim
    " Author: Faris Chugthai
    " Description: Xonsh ftdetecy
    " Last Modified: April 23, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

augroup xonsh_filetypedetect
    au!
    au BufNewFile,BufRead .xonshrc set filetype=xonsh
    au BufNewFile,BufRead *.xsh set filetype=xonsh
augroup END
