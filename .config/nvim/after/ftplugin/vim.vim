" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: vim ftplugin
    " Last Modified: February 19, 2019
" ============================================================================
"
" Kinda surprised I've never made one of these before...
let &commentstring='" %s'
" For some reason setting the above still has my commentstrings messed up
" verbose set commentstring isn't helping but I can't make heads or tails
" of what the fuck set comments is saying so let's empty it.
setl comments="

" And we finally have :kbd:`gc` back to normal!
