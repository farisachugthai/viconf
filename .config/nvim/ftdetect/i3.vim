" i3 ftdetect
" https://raw.githubusercontent.com/moon-musick/vim-i3-config-syntax/master/ftdetect/i3.vim

augroup i3
    autocmd!
    autocmd BufNewFile,BufRead ~/.config/i3* set filetype=i3
augroup end
