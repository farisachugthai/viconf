" i3.vim filedetect
" https://raw.githubusercontent.com/moon-musick/vim-i3-config-syntax/master/ftdetect/i3.vim

" Well shit I just realized that this isn't setup for the right directory
" That should catch both the i3 and i3status dirs and the files config and
" config.keycodes
autocmd BufNewFile,BufRead ~/.config/i3*/config* set filetype=i3
